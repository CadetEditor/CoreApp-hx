// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.events;

import core.app.events.IFileSystemProvider;
import core.app.events.IFileSystemProviderOperation;
import nme.events.Event;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.IFileSystemProviderOperation;class FileSystemProviderEvent extends Event
{
    public var fileSystemProvider(get, never) : IFileSystemProvider;
    public var operation(get, never) : IFileSystemProviderOperation;
public static inline var OPERATION_BEGIN : String = "operationBegin";private var _fileSystemProvider : IFileSystemProvider;private var _operation : IFileSystemProviderOperation;public function new(type : String, fileSystemProvider : IFileSystemProvider, operation : IFileSystemProviderOperation)
    {super(type);_fileSystemProvider = fileSystemProvider;_operation = operation;
    }override public function clone() : Event{return new FileSystemProviderEvent(type, _fileSystemProvider, _operation);
    }private function get_FileSystemProvider() : IFileSystemProvider{return _fileSystemProvider;
    }private function get_Operation() : IFileSystemProviderOperation{return _operation;
    }
}