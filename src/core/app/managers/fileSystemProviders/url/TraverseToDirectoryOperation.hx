  // =================================================================================================    //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================    //TODO: implement getDirectoryErrorHandler() as per local FSP  package core.app.managers.filesystemproviders.url;

import core.app.managers.filesystemproviders.url.FileSystemNode;
import core.app.managers.filesystemproviders.url.ITraverseToDirectoryOperation;
import core.app.managers.filesystemproviders.url.URLFileSystemProvider;
import nme.events.Event;import core.app.CoreApp;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.ITraverseToDirectoryOperation;import core.app.entities.FileSystemNode;import core.app.entities.URI;import core.app.operations.CompoundOperation;class TraverseToDirectoryOperation extends CompoundOperation implements ITraverseToDirectoryOperation
{
    public var contents(get, never) : Array<Dynamic>;
    public var uri(get, never) : URI;
    public var finalURI(get, never) : URI;
    public var fileSystemProvider(get, never) : IFileSystemProvider;
private var _uri : URI;private var _finalURI : URI;private var _fileSystemProvider : URLFileSystemProvider;private var _baseURL : String;private var _fileExists : Bool = false;private var directories : Array<Dynamic>;private var _contents : Array<Dynamic>;public function new(uri : URI, fileSystemProvider : URLFileSystemProvider, baseURL : String)
    {
        super();_uri = uri;_finalURI = uri;_fileSystemProvider = fileSystemProvider;_baseURL = baseURL;var fileSystem : FileSystemNode = CoreApp.fileSystemProvider.fileSystem;var rootDirURI : URI = new URI("cadet.url/");_contents = [];directories = [];directories.push(_uri);var directoryURI : URI = _uri.getParentURI();while (directoryURI.path != rootDirURI.path){node = fileSystem.getChildWithPath(directoryURI.path, true);if (!(node && node.isPopulated)) {directories.push(directoryURI);
            }directoryURI = directoryURI.getParentURI();
        }  // add rootDir  directoryURI = rootDirURI;var node : FileSystemNode = fileSystem.getChildWithPath(directoryURI.path, true);if (!(node && node.isPopulated)) {directories.push(directoryURI);
        }  //trace("directories "+directories);  directories.reverse();for (i in 0...directories.length){directoryURI = directories[i];var operation : GetDirectoryContentsOperation = new GetDirectoryContentsOperation(directoryURI, _fileSystemProvider, _baseURL);addOperation(operation);
        }
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