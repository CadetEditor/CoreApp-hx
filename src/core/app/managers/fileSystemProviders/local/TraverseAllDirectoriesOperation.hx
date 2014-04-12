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

import core.app.managers.filesystemproviders.local.CompoundOperation;
import core.app.managers.filesystemproviders.local.ITraverseAllDirectoriesOperation;
import nme.events.Event;import nme.filesystem.File;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.ITraverseAllDirectoriesOperation;import core.app.entities.URI;import core.app.operations.CompoundOperation;class TraverseAllDirectoriesOperation extends CompoundOperation implements ITraverseAllDirectoriesOperation
{
    public var contents(get, never) : Array<Dynamic>;
    public var uri(get, never) : URI;
    public var fileSystemProvider(get, never) : IFileSystemProvider;
private var _rootDirectory : File;private var _uri : URI;private var _fileSystemProvider : IFileSystemProvider;  //private var directories				:Array;  private var _contents : Array<Dynamic>;public function new(rootDirectory : File, uri : URI, fileSystemProvider : IFileSystemProvider)
    {
        super();_rootDirectory = rootDirectory;_uri = uri;_fileSystemProvider = fileSystemProvider;_contents = [];var operation : GetDirectoryContentsOperation = new GetDirectoryContentsOperation(_rootDirectory, uri, _fileSystemProvider);addOperation(operation);
    }override private function operationCompleteHandler(event : Event) : Void{if (Std.is(event.target, GetDirectoryContentsOperation)) {var operation : GetDirectoryContentsOperation = cast((event.target), GetDirectoryContentsOperation);_contents.push({
                        uri : operation.uri,
                        contents : operation.contents,

                    });for (i in 0...operation.contents.length){var uri : URI = operation.contents[i];if (uri.isDirectory()) {var newOperation : GetDirectoryContentsOperation = new GetDirectoryContentsOperation(_rootDirectory, uri, _fileSystemProvider);addOperation(newOperation);
                }
            }
        }super.operationCompleteHandler(event);
    }private function get_Contents() : Array<Dynamic>{return _contents;
    }private function get_Uri() : URI{return _uri;
    }private function get_FileSystemProvider() : IFileSystemProvider{return _fileSystemProvider;
    }
}