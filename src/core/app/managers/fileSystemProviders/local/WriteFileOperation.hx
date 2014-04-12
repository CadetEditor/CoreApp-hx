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

import core.app.managers.filesystemproviders.local.IWriteFileOperation;
import core.app.managers.filesystemproviders.local.OutputProgressEvent;
import nme.events.ErrorEvent;import nme.events.Event;import nme.events.IOErrorEvent;import nme.events.OutputProgressEvent;import nme.filesystem.File;import nme.filesystem.FileMode;import nme.filesystem.FileStream;import nme.utils.ByteArray;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.IWriteFileOperation;import core.app.entities.URI;import core.app.events.FileSystemErrorCodes;import core.app.events.OperationProgressEvent;import core.app.util.AsynchronousUtil;class WriteFileOperation extends LocalFileSystemProviderOperation implements IWriteFileOperation
{
    public var bytes(get, never) : ByteArray;
private var fileStream : FileStream;private var _bytes : ByteArray;@:allow(core.app.managers.filesystemproviders.local)
    private function new(rootDirectory : File, uri : URI, bytes : ByteArray, fileSystemProvider : IFileSystemProvider)
    {super(rootDirectory, uri, fileSystemProvider);_bytes = bytes;
    }private function dispose() : Void{if (fileStream != null) {fileStream.close();fileStream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, writeProgressHandler);fileStream.removeEventListener(IOErrorEvent.IO_ERROR, writeErrorHandler);fileStream = null;
        }
    }override public function execute() : Void{  //var file:File = new File( uriToFilePath(_uri) );  var file : File = new File(FileSystemUtil.uriToFilePath(_uri, _rootDirectory));fileStream = new FileStream();  //if ( _bytes.length == 0 )    //{    //	AsynchronousUtil.dispatchLater( this, new ErrorEvent( ErrorEvent.ERROR, false, false, "", FileSystemErrorCodes.WRITE_FILE_ERROR ) );    //	return;    //}    //else    //{  fileStream.openAsync(file, FileMode.WRITE);if (_bytes.length == 0) {AsynchronousUtil.dispatchLater(this, new Event(Event.COMPLETE));dispose();
        }
        else {fileStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, writeProgressHandler);fileStream.addEventListener(IOErrorEvent.IO_ERROR, writeErrorHandler);fileStream.writeBytes(_bytes, 0, _bytes.length);
        }  //}  
    }private function writeErrorHandler(event : IOErrorEvent) : Void{dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "", FileSystemErrorCodes.WRITE_FILE_ERROR));dispose();
    }private function writeProgressHandler(event : OutputProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, event.bytesTotal / event.bytesPending));if (event.bytesPending == 0) {dispatchEvent(new Event(Event.COMPLETE));dispose();
        }
    }override private function get_Label() : String{return "Write file : " + _uri.path;
    }private function get_Bytes() : ByteArray{return _bytes;
    }
}