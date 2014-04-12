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

import core.app.managers.filesystemproviders.local.ByteArray;
import core.app.managers.filesystemproviders.local.EventDispatcher;
import core.app.managers.filesystemproviders.local.FileSystemProviderEvent;
import core.app.managers.filesystemproviders.local.IFileSystemProviderOperation;
import core.app.managers.filesystemproviders.local.ILocalFileSystemProvider;
import core.app.managers.filesystemproviders.local.IReadFileOperation;
import core.app.managers.filesystemproviders.local.ITraverseAllDirectoriesOperation;
import core.app.managers.filesystemproviders.local.ITraverseToDirectoryOperation;
import core.app.managers.filesystemproviders.local.IWriteFileOperation;
import core.app.managers.filesystemproviders.local.ReadFileOperation;
import core.app.managers.filesystemproviders.local.TraverseAllDirectoriesOperation;
import core.app.managers.filesystemproviders.local.TraverseToDirectoryOperation;
import core.app.managers.filesystemproviders.local.WriteFileOperation;
import nme.events.*;import nme.filesystem.*;import nme.utils.ByteArray;import core.app.core.managers.filesystemproviders.ILocalFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.*;import core.app.entities.URI;import core.app.events.FileSystemProviderEvent;import core.app.events.OperationProgressEvent;@:meta(Event(type="core.app.events.FileSystemProviderEvent",name="operationBegin"))
class LocalFileSystemProvider extends EventDispatcher implements ILocalFileSystemProvider
{
    public var id(get, never) : String;
    public var label(get, never) : String;
    public var rootDirectoryURI(get, never) : URI;
    public var defaultDirectoryURI(get, never) : URI;
private var _id : String;private var _label : String;private var _rootDirectory : File;private var _defaultDirectory : File;public function new(id : String, label : String, rootDirectory : File, defaultDirectory : File)
    {
        super();_id = id;_label = label;_rootDirectory = rootDirectory;_defaultDirectory = defaultDirectory;if (_defaultDirectory.exists == false) {_defaultDirectory.createDirectory();
        }
    }private function initOperation(operation : IFileSystemProviderOperation) : Void{operation.addEventListener(ErrorEvent.ERROR, passThroughHandler);operation.addEventListener(OperationProgressEvent.PROGRESS, passThroughHandler);operation.addEventListener(Event.COMPLETE, passThroughHandler);dispatchEvent(new FileSystemProviderEvent(FileSystemProviderEvent.OPERATION_BEGIN, this, operation));
    }private function passThroughHandler(event : Event) : Void{dispatchEvent(event);
    }public function readFile(uri : URI) : IReadFileOperation{var operation : ReadFileOperation = new ReadFileOperation(_rootDirectory, uri, this);initOperation(operation);return operation;
    }public function writeFile(uri : URI, bytes : ByteArray) : IWriteFileOperation{var operation : WriteFileOperation = new WriteFileOperation(_rootDirectory, uri, bytes, this);initOperation(operation);return operation;
    }public function createDirectory(uri : URI) : ICreateDirectoryOperation{var operation : CreateDirectoryOperation = new CreateDirectoryOperation(_rootDirectory, uri, this);initOperation(operation);return operation;
    }public function getDirectoryContents(uri : URI) : IGetDirectoryContentsOperation{var operation : GetDirectoryContentsOperation = new GetDirectoryContentsOperation(_rootDirectory, uri, this);initOperation(operation);return operation;
    }public function deleteFile(uri : URI) : IDeleteFileOperation{var operation : DeleteFileOperation = new DeleteFileOperation(_rootDirectory, uri, this);initOperation(operation);return operation;
    }public function doesFileExist(uri : URI) : IDoesFileExistOperation{var operation : DoesFileExistOperation = new DoesFileExistOperation(_rootDirectory, uri, this);initOperation(operation);return operation;
    }public function traverseToDirectory(uri : URI) : ITraverseToDirectoryOperation{var operation : TraverseToDirectoryOperation = new TraverseToDirectoryOperation(_rootDirectory, uri, this);initOperation(operation);return operation;
    }public function traverseAllDirectories(uri : URI) : ITraverseAllDirectoriesOperation{var operation : TraverseAllDirectoriesOperation = new TraverseAllDirectoriesOperation(_rootDirectory, uri, this);initOperation(operation);return operation;
    }private function get_Id() : String{return _id;
    }private function get_Label() : String{return _label;
    }private function get_RootDirectoryURI() : URI{return new URI(_rootDirectory.url);
    }private function get_DefaultDirectoryURI() : URI{return new URI(_defaultDirectory.url);
    }
}