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

import core.app.managers.filesystemproviders.local.IDoesFileExistOperation;
import core.app.managers.filesystemproviders.local.LocalFileSystemProviderOperation;
import nme.events.Event;import nme.filesystem.File;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.IDoesFileExistOperation;import core.app.entities.URI;import core.app.util.AsynchronousUtil;class DoesFileExistOperation extends LocalFileSystemProviderOperation implements IDoesFileExistOperation
{
    public var fileExists(get, never) : Bool;
private var _fileExists : Bool;@:allow(core.app.managers.filesystemproviders.local)
    private function new(rootDirectory : File, uri : URI, fileSystemProvider : IFileSystemProvider)
    {super(rootDirectory, uri, fileSystemProvider);
    }override public function execute() : Void{  //var file:File = new File( uriToFilePath(uri) );  var file : File = new File(FileSystemUtil.uriToFilePath(_uri, _rootDirectory));_fileExists = file.exists;AsynchronousUtil.dispatchLater(this, new Event(Event.COMPLETE));
    }override private function get_Label() : String{return "Does File Exist : " + _uri.path;
    }private function get_FileExists() : Bool{return _fileExists;
    }
}