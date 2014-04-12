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

import core.app.managers.filesystemproviders.local.ErrorEvent;
import core.app.managers.filesystemproviders.local.Event;
import core.app.managers.filesystemproviders.local.File;
import core.app.managers.filesystemproviders.local.FileStream;
import core.app.managers.filesystemproviders.local.ICreateDirectoryOperation;
import core.app.managers.filesystemproviders.local.IFileSystemProvider;
import core.app.managers.filesystemproviders.local.LocalFileSystemProviderOperation;
import core.app.managers.filesystemproviders.local.URI;
import nme.events.ErrorEvent;import nme.events.Event;import nme.filesystem.File;import nme.filesystem.FileStream;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.ICreateDirectoryOperation;import core.app.entities.URI;import core.app.events.FileSystemErrorCodes;import core.app.util.AsynchronousUtil;class CreateDirectoryOperation extends LocalFileSystemProviderOperation implements ICreateDirectoryOperation
{private var fileStream : FileStream;@:allow(core.app.managers.filesystemproviders.local)
    private function new(rootDirectory : File, uri : URI, fileSystemProvider : IFileSystemProvider)
    {super(rootDirectory, uri, fileSystemProvider);
    }override public function execute() : Void{if (_uri.isDirectory() == false) {AsynchronousUtil.dispatchLater(this, new ErrorEvent(ErrorEvent.ERROR, false, false, "", FileSystemErrorCodes.CREATE_DIRECTORY_ERROR));return;
        }  //var file:File = new File( uriToFilePath(_uri) );  var file : File = new File(FileSystemUtil.uriToFilePath(_uri, _rootDirectory));file.createDirectory();AsynchronousUtil.dispatchLater(this, new Event(Event.COMPLETE));
    }override private function get_Label() : String{return "Create Directory : " + _uri.path;
    }
}