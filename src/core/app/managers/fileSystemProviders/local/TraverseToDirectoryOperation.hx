// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.managers.filesystemproviders.local;

import core.app.managers.filesystemproviders.local.FileSystemNode;
import core.app.managers.filesystemproviders.local.ITraverseToDirectoryOperation;
import nme.events.ErrorEvent;import nme.events.Event;import nme.filesystem.File;import core.app.CoreApp;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.ITraverseToDirectoryOperation;import core.app.entities.FileSystemNode;import core.app.entities.URI;import core.app.events.OperationProgressEvent;import core.app.operations.CompoundOperation;class TraverseToDirectoryOperation extends CompoundOperation implements ITraverseToDirectoryOperation
{
    public var contents(get, never) : Array<Dynamic>;
    public var uri(get, never) : URI;
    public var finalURI(get, never) : URI;
    public var fileSystemProvider(get, never) : IFileSystemProvider;
private var _rootDirectory : File;private var _uri : URI;private var _finalURI : URI;private var _fileSystemProvider : IFileSystemProvider;private var directories : Array<Dynamic>;private var _contents : Array<Dynamic>;public function new(rootDirectory : File, uri : URI, fileSystemProvider : IFileSystemProvider)
    {
        super();_rootDirectory = rootDirectory;_uri = uri;_finalURI = uri;_fileSystemProvider = fileSystemProvider;var fileSystem : FileSystemNode = CoreApp.fileSystemProvider.fileSystem;var rootDirURI : URI = FileSystemUtil.fileToURI(_rootDirectory, _rootDirectory, _fileSystemProvider.id);_contents = [];directories = [];directories.push(_uri);var directoryURI : URI = _uri.getParentURI();while (directoryURI.path != rootDirURI.path){node = fileSystem.getChildWithPath(directoryURI.path, true);if (!(node && node.isPopulated)) {directories.push(directoryURI);
            }directoryURI = directoryURI.getParentURI();
        }  // add rootDir  directoryURI = rootDirURI;var node : FileSystemNode = fileSystem.getChildWithPath(directoryURI.path, true);if (!(node && node.isPopulated)) {directories.push(directoryURI);
        }  //trace("directories "+directories);  directories.reverse();for (i in 0...directories.length){directoryURI = directories[i];var operation : GetDirectoryContentsOperation = new GetDirectoryContentsOperation(_rootDirectory, directoryURI, _fileSystemProvider);operation.addEventListener(ErrorEvent.ERROR, getDirectoryErrorHandler);addOperation(operation);
        }
    }private function getDirectoryErrorHandler(event : Event) : Void{operations.splice(currentIndex + 1, operations.length);var operation : GetDirectoryContentsOperation = cast((event.target), GetDirectoryContentsOperation);operation.removeEventListener(Event.COMPLETE, operationCompleteHandler);operation.removeEventListener(OperationProgressEvent.PROGRESS, operationProgressHandler);operation.removeEventListener(ErrorEvent.ERROR, operationErrorHandler);  //trace("Undoable Compound Operation. Child operation complete : " + operation.label);    // The current operation is made to be the last so the CompoundOperation can quit,    // so take the second to last operation as the final valid URI  if (operations.length > 1) {operation = operations[operations.length - 2];_finalURI = operation.uri;
        }update();
    }override private function operationCompleteHandler(event : Event) : Void{if (Std.is(event.target, GetDirectoryContentsOperation)) {var operation : GetDirectoryContentsOperation = cast((event.target), GetDirectoryContentsOperation);_contents.push({
                        uri : operation.uri,
                        contents : operation.contents,

                    });
        }super.operationCompleteHandler(event);
    }private function get_Contents() : Array<Dynamic>{return _contents;
    }private function get_Uri() : URI{return _uri;
    }private function get_FinalURI() : URI{return _finalURI;
    }private function get_FileSystemProvider() : IFileSystemProvider{return _fileSystemProvider;
    }
}