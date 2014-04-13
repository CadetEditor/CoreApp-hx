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

import core.app.managers.filesystemproviders.local.IDeleteFileOperation;
import core.app.managers.filesystemproviders.local.LocalFileSystemProviderOperation;
import nme.events.ErrorEvent;
import nme.events.Event;
import nme.filesystem.File;
import core.app.core.managers.filesystemproviders.IFileSystemProvider;
import core.app.core.managers.filesystemproviders.operations.IDeleteFileOperation;
import core.app.entities.URI;
import core.app.events.FileSystemErrorCodes;
import core.app.util.AsynchronousUtil;

class DeleteFileOperation extends LocalFileSystemProviderOperation implements IDeleteFileOperation
{
	@:allow(core.app.managers.filesystemproviders.local)    
	private function new(rootDirectory : File, uri : URI, fileSystemProvider : IFileSystemProvider)
    {
		super(rootDirectory, uri, fileSystemProvider);
    }
	
	override public function execute() : Void
	{  
		//var file:File = new File( uriToFilePath(uri) );  
		var file : File = new File(FileSystemUtil.uriToFilePath(_uri, _rootDirectory));
		if (file.exists == false) { 
			AsynchronousUtil.dispatchLater(this, new ErrorEvent(ErrorEvent.ERROR, false, false, "", FileSystemErrorCodes.DELETE_FILE_ERROR));
			return;
        }
		if (file.isDirectory) {
			file.deleteDirectory(true);
        }
        else {
			file.deleteFile();
        }
		
		AsynchronousUtil.dispatchLater(this, new Event(Event.COMPLETE));
    }
	
	override private function get_Label() : String {
		return "Delete File : " + _uri.path;
    }
}