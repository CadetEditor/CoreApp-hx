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

import core.app.managers.filesystemproviders.local.IReadFileOperation;
import core.app.managers.filesystemproviders.local.ProgressEvent;
import nme.events.ErrorEvent;import nme.events.Event;import nme.events.IOErrorEvent;import nme.events.ProgressEvent;import nme.filesystem.File;import nme.filesystem.FileMode;import nme.filesystem.FileStream;import nme.utils.ByteArray;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.IReadFileOperation;import core.app.entities.URI;import core.app.events.FileSystemErrorCodes;import core.app.events.OperationProgressEvent;import core.app.util.AsynchronousUtil;class ReadFileOperation extends LocalFileSystemProviderOperation implements IReadFileOperation
{
    public var bytes(get, never) : ByteArray;
private var fileStream : FileStream;private var _bytes : ByteArray;@:allow(core.app.managers.filesystemproviders.local)
    private function new(rootDirectory : File, uri : URI, fileSystemProvider : IFileSystemProvider)
    {super(rootDirectory, uri, fileSystemProvider);
    }private function dispose() : Void{if (fileStream != null) {fileStream.removeEventListener(ProgressEvent.PROGRESS, readProgressHandler);fileStream.removeEventListener(Event.COMPLETE, readCompleteHandler);fileStream.removeEventListener(IOErrorEvent.IO_ERROR, readErrorHandler);fileStream.close();fileStream = null;
        }
    }override public function execute() : Void{  //var file:File = new File( uriToFilePath(uri) );  var filePath : String = FileSystemUtil.uriToFilePath(_uri, _rootDirectory);var file : File = new File(filePath);if (file.exists) {fileStream = new FileStream();fileStream.addEventListener(ProgressEvent.PROGRESS, readProgressHandler);fileStream.addEventListener(Event.COMPLETE, readCompleteHandler);fileStream.addEventListener(IOErrorEvent.IO_ERROR, readErrorHandler);fileStream.openAsync(file, FileMode.READ);
        }
        // Error - file does not exist
        else {AsynchronousUtil.dispatchLater(this, new ErrorEvent(ErrorEvent.ERROR, false, false, "Local ReadFileOperation Error: File Not Found \"" + filePath + "\"", FileSystemErrorCodes.FILE_DOES_NOT_EXIST));
        }
    }private function readErrorHandler(event : IOErrorEvent) : Void{AsynchronousUtil.dispatchLater(this, new ErrorEvent(ErrorEvent.ERROR, false, false, "", FileSystemErrorCodes.FILE_DOES_NOT_EXIST));dispose();
    }private function readProgressHandler(event : ProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, event.bytesLoaded / event.bytesTotal));
    }private function readCompleteHandler(event : Event) : Void{_bytes = new ByteArray();fileStream.readBytes(bytes, 0, fileStream.bytesAvailable);dispatchEvent(new Event(Event.COMPLETE));dispose();
    }override private function get_Label() : String{return "Read File : " + _uri.path;
    }private function get_Bytes() : ByteArray{return _bytes;
    }
}