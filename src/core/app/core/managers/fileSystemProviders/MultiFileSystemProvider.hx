  // =================================================================================================    //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.core.managers.filesystemproviders;

import core.app.core.managers.filesystemproviders.Dictionary;
import core.app.core.managers.filesystemproviders.ErrorEvent;
import core.app.core.managers.filesystemproviders.Event;
import core.app.core.managers.filesystemproviders.EventDispatcher;
import core.app.core.managers.filesystemproviders.FileSystemProviderEvent;
import core.app.core.managers.filesystemproviders.IFileSystemProviderOperation;
import nme.errors.Error;
import nme.events.ErrorEvent;import nme.events.Event;import nme.events.EventDispatcher;import nme.utils.ByteArray;import nme.utils.Dictionary;import core.app.core.managers.filesystemproviders.operations.ICreateDirectoryOperation;import core.app.core.managers.filesystemproviders.operations.IDeleteFileOperation;import core.app.core.managers.filesystemproviders.operations.IDoesFileExistOperation;import core.app.core.managers.filesystemproviders.operations.IFileSystemProviderOperation;import core.app.core.managers.filesystemproviders.operations.IGetDirectoryContentsOperation;import core.app.core.managers.filesystemproviders.operations.IReadFileOperation;import core.app.core.managers.filesystemproviders.operations.ITraverseAllDirectoriesOperation;import core.app.core.managers.filesystemproviders.operations.ITraverseToDirectoryOperation;import core.app.core.managers.filesystemproviders.operations.IWriteFileOperation;import core.app.entities.FileSystemNode;import core.app.entities.URI;import core.app.events.FileSystemProviderEvent;class MultiFileSystemProvider extends EventDispatcher implements IMultiFileSystemProvider
{
    public var fileSystem(get, never) : FileSystemNode;
    public var id(get, never) : String;
    public var label(get, never) : String;
private var providers : Dynamic;private var idTable : Dictionary;private var _fileSystem : FileSystemNode;public function new()
    {
        super();providers = { };idTable = new Dictionary();_fileSystem = new FileSystemNode();_fileSystem.path = "/";_fileSystem.isPopulated = true;
    }public function registerFileSystemProvider(provider : IFileSystemProvider, addToFileSystem : Bool = true) : Void{providers[provider.id] = provider;Reflect.setField(idTable, Std.string(provider), provider.id);provider.addEventListener(FileSystemProviderEvent.OPERATION_BEGIN, operationBeginHandler);if (!addToFileSystem)             return;var node : FileSystemNode = new FileSystemNode();node.path = provider.id + "/";node.label = provider.label;_fileSystem.children.addItem(node);
    }private function get_FileSystem() : FileSystemNode{return _fileSystem;
    }public function getFileSystemProviderForURI(uri : URI) : IFileSystemProvider{return getProviderForURI(uri);
    }public function createDirectory(uri : URI) : ICreateDirectoryOperation{var provider : IFileSystemProvider = getProviderForURI(uri);var operation : ICreateDirectoryOperation = provider.createDirectory(uri);operation.addEventListener(ErrorEvent.ERROR, errorHandler, false, 0, true);return operation;
    }public function deleteFile(uri : URI) : IDeleteFileOperation{var provider : IFileSystemProvider = getProviderForURI(uri);var operation : IDeleteFileOperation = provider.deleteFile(uri);operation.addEventListener(ErrorEvent.ERROR, errorHandler, false, 0, true);return operation;
    }public function doesFileExist(uri : URI) : IDoesFileExistOperation{var provider : IFileSystemProvider = getProviderForURI(uri);var operation : IDoesFileExistOperation = provider.doesFileExist(uri);operation.addEventListener(ErrorEvent.ERROR, errorHandler, false, 0, true);return operation;
    }public function getDirectoryContents(uri : URI) : IGetDirectoryContentsOperation{var provider : IFileSystemProvider = getProviderForURI(uri);var operation : IGetDirectoryContentsOperation = provider.getDirectoryContents(uri);operation.addEventListener(ErrorEvent.ERROR, errorHandler, false, 0, true);return operation;
    }public function readFile(uri : URI) : IReadFileOperation{var provider : IFileSystemProvider = getProviderForURI(uri);var operation : IReadFileOperation = provider.readFile(uri);operation.addEventListener(ErrorEvent.ERROR, errorHandler, false, 0, true);return operation;
    }public function traverseToDirectory(uri : URI) : ITraverseToDirectoryOperation{var provider : IFileSystemProvider = getProviderForURI(uri);var operation : ITraverseToDirectoryOperation = provider.traverseToDirectory(uri);operation.addEventListener(ErrorEvent.ERROR, errorHandler, false, 0, true);return operation;
    }public function traverseAllDirectories(uri : URI) : ITraverseAllDirectoriesOperation{var provider : IFileSystemProvider = getProviderForURI(uri);var operation : ITraverseAllDirectoriesOperation = provider.traverseAllDirectories(uri);operation.addEventListener(ErrorEvent.ERROR, errorHandler, false, 0, true);return operation;
    }public function writeFile(uri : URI, data : ByteArray) : IWriteFileOperation{var provider : IFileSystemProvider = getProviderForURI(uri);var operation : IWriteFileOperation = provider.writeFile(uri, data);operation.addEventListener(ErrorEvent.ERROR, errorHandler, false, 0, true);return operation;
    }private function getProviderForURI(uri : URI) : IFileSystemProvider{var split : Array<Dynamic> = uri.path.split("/");var providerID : String = split[0];var provider : IFileSystemProvider = Reflect.field(providers, providerID);if (provider == null) {throw (new Error("Cannot map uri to provider. " + uri.path));
        }return Reflect.field(providers, providerID);
    }  //Why listen into the MultiFileSystemProvider rather than the Operation for errors?  private function errorHandler(event : ErrorEvent) : Void{  //dispatchEvent( event );  
    }private function get_Id() : String{return "";
    }private function get_Label() : String{return "";
    }  // Methods for manipulating the model  private function repopulateDirectory(uri : URI, contents : Array<URI>) : Void{var fileSystemNode : FileSystemNode = try cast(_fileSystem.getChildWithData(uri.path, true), FileSystemNode) catch(e:Dynamic) null;if (fileSystemNode == null)             return;var childrenToRemove : Array<Dynamic> = [];var childrenToAdd : Array<Dynamic> = [];var childNode : FileSystemNode;var i : Int;var childURI : URI;for (fileSystemNode.children.length){childNode = fileSystemNode.children[i];var remove : Bool = true;for (childURI in contents){if (childNode.path == childURI.path) {remove = false;
                }
            }if (remove) {childrenToRemove.push(childNode);
            }
        }for (contents.length){childURI = contents[i];var add : Bool = true;for (childNode/* AS3HX WARNING could not determine type for var: childNode exp: EField(EIdent(fileSystemNode),children) type: null */ in fileSystemNode.children){if (childNode.path == childURI.path) {add = false;
                }
            }if (add) {childrenToAdd.push(childURI);
            }
        }for (childrenToRemove.length){fileSystemNode.children.removeItem(childrenToRemove[i]);
        }for (childrenToAdd.length){addFile(childrenToAdd[i]);
        }fileSystemNode.isPopulated = true;
    }private function addFile(uri : URI) : Void{var node : FileSystemNode = try cast(_fileSystem.getChildWithData(uri.path, true), FileSystemNode) catch(e:Dynamic) null;if (node != null)             return;var parentURI : URI = new URI();parentURI.copyURI(uri);(parentURI.isDirectory()) ? parentURI.chdir("../") : parentURI.chdir("./");var parentNode : FileSystemNode = try cast(_fileSystem.getChildWithData(parentURI.path, true), FileSystemNode) catch(e:Dynamic) null;if (parentNode == null)             return;node = new FileSystemNode();node.path = uri.path;parentNode.children.addItem(node);
    }private function removeFile(uri : URI) : Void{var node : FileSystemNode = try cast(_fileSystem.getChildWithData(uri.path, true), FileSystemNode) catch(e:Dynamic) null;if (node == null)             return;var parentURI : URI = new URI();parentURI.copyURI(uri);(parentURI.isDirectory()) ? parentURI.chdir("../") : parentURI.chdir("./");var parentNode : FileSystemNode = try cast(_fileSystem.getChildWithData(parentURI.path, true), FileSystemNode) catch(e:Dynamic) null;if (parentNode == null)             return;parentNode.children.removeItem(node);
    }  /*-- Handlers ------------------------------------------------*/  private function operationBeginHandler(event : FileSystemProviderEvent) : Void{dispatchEvent(event);event.operation.addEventListener(Event.COMPLETE, operationCompleteHandler);
    }private function operationCompleteHandler(event : Event) : Void{var operation : IFileSystemProviderOperation = cast((event.target), IFileSystemProviderOperation);if (Std.is(event.target, ICreateDirectoryOperation)) {createDirectoryComplete(operation);
        }
        else if (Std.is(event.target, IDeleteFileOperation)) {deleteComplete(operation);
        }
        else if (Std.is(event.target, IDoesFileExistOperation)) {  //doesFileExistComplete( operation );  
        }
        else if (Std.is(event.target, IGetDirectoryContentsOperation)) {getDirectoryContentsComplete(operation);
        }
        else if (Std.is(event.target, ITraverseToDirectoryOperation)) {traverseToDirectoryComplete(operation);
        }
        else if (Std.is(event.target, ITraverseAllDirectoriesOperation)) {traverseAllDirectoriesComplete(operation);
        }
        else if (Std.is(event.target, IWriteFileOperation)) {writeFileComplete(operation);
        }
    }private function createDirectoryComplete(operation : IFileSystemProviderOperation) : Void{addFile(operation.uri);
    }private function deleteComplete(operation : IFileSystemProviderOperation) : Void{removeFile(operation.uri);
    }private function doesFileExistComplete(operation : IFileSystemProviderOperation) : Void{addFile(operation.uri);
    }private function writeFileComplete(operation : IFileSystemProviderOperation) : Void{addFile(operation.uri);
    }private function getDirectoryContentsComplete(operation : IFileSystemProviderOperation) : Void{var getDirectoryContentsOperation : IGetDirectoryContentsOperation = cast((operation), IGetDirectoryContentsOperation);repopulateDirectory(operation.uri, getDirectoryContentsOperation.contents);
    }private function traverseToDirectoryComplete(operation : IFileSystemProviderOperation) : Void{var traverseToDirectoryOperation : ITraverseToDirectoryOperation = cast((operation), ITraverseToDirectoryOperation);var allContents : Array<Dynamic> = traverseToDirectoryOperation.contents;for (i in 0...allContents.length){var uri : URI = allContents[i].uri;var contents : Array<URI> = allContents[i].contents;repopulateDirectory(uri, contents);
        }
    }private function traverseAllDirectoriesComplete(operation : IFileSystemProviderOperation) : Void{var traverseOperation : ITraverseAllDirectoriesOperation = cast((operation), ITraverseAllDirectoriesOperation);var allContents : Array<Dynamic> = traverseOperation.contents;for (i in 0...allContents.length){var uri : URI = allContents[i].uri;var contents : Array<URI> = allContents[i].contents;repopulateDirectory(uri, contents);
        }
    }
}