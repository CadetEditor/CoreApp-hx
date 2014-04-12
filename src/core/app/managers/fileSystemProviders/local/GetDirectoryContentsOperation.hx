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

import core.app.managers.filesystemproviders.local.FileListEvent;
import core.app.managers.filesystemproviders.local.IGetDirectoryContentsOperation;
import core.app.managers.filesystemproviders.local.IOErrorEvent;
import core.app.managers.filesystemproviders.local.LocalFileSystemProviderOperation;
import nme.events.ErrorEvent;import nme.events.Event;import nme.events.FileListEvent;import nme.events.IOErrorEvent;import nme.filesystem.File;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.IGetDirectoryContentsOperation;import core.app.entities.URI;import core.app.events.FileSystemErrorCodes;import core.app.util.AsynchronousUtil;class GetDirectoryContentsOperation extends LocalFileSystemProviderOperation implements IGetDirectoryContentsOperation
{
    public var contents(get, never) : Array<URI>;
private var _contents : Array<URI>;@:allow(core.app.managers.filesystemproviders.local)
    private function new(rootDirectory : File, uri : URI, fileSystemProvider : IFileSystemProvider)
    {super(rootDirectory, uri, fileSystemProvider);
    }override public function execute() : Void{  //var filePath:String = uriToFilePath(uri);    //var file:File = new File( filePath );  var file : File = new File(FileSystemUtil.uriToFilePath(_uri, _rootDirectory));if (file.exists == false) {AsynchronousUtil.dispatchLater(this, new ErrorEvent(ErrorEvent.ERROR, false, false, "", FileSystemErrorCodes.GET_DIRECTORY_CONTENTS_ERROR));return;
        }file.addEventListener(IOErrorEvent.IO_ERROR, getDirectoryContentsResponseHandler);file.addEventListener(FileListEvent.DIRECTORY_LISTING, getDirectoryContentsResponseHandler);file.getDirectoryListingAsync();
    }private function getDirectoryContentsErrorHandler(event : IOErrorEvent) : Void{dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "", FileSystemErrorCodes.GET_DIRECTORY_CONTENTS_ERROR));
    }private function getDirectoryContentsResponseHandler(event : FileListEvent) : Void{var file : File = cast((event.target), File);_contents = new Array<URI>();for (i in 0...event.files.length){  //_contents[i] = fileToURI( event.files[i] );  _contents[i] = FileSystemUtil.fileToURI(event.files[i], _rootDirectory, _fileSystemProvider.id);
        }dispatchEvent(new Event(Event.COMPLETE));
    }private function get_Contents() : Array<URI>{return _contents;
    }override private function get_Label() : String{return "Get Directory Contents : " + _uri.path;
    }
}