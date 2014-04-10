// =================================================================================================  //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.managers.filesystemproviders.url;

import core.app.managers.filesystemproviders.url.ErrorEvent;
import core.app.managers.filesystemproviders.url.Event;
import core.app.managers.filesystemproviders.url.EventDispatcher;
import core.app.managers.filesystemproviders.url.GetDirectoryContentsOperation;
import core.app.managers.filesystemproviders.url.IDoesFileExistOperation;
import core.app.managers.filesystemproviders.url.IFileSystemProvider;
import core.app.managers.filesystemproviders.url.OperationProgressEvent;
import core.app.managers.filesystemproviders.url.URI;
import core.app.managers.filesystemproviders.url.URLFileSystemProvider;
import nme.events.ErrorEvent;import nme.events.Event;import nme.events.EventDispatcher;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.IDoesFileExistOperation;import core.app.entities.URI;import core.app.events.FileSystemErrorCodes;import core.app.events.OperationProgressEvent;class DoesFileExistOperation extends EventDispatcher implements IDoesFileExistOperation
{
    public var label(get, never) : String;
    public var fileExists(get, never) : Bool;
    public var uri(get, never) : URI;
    public var fileSystemProvider(get, never) : IFileSystemProvider;
private var _uri : URI;private var _fileSystemProvider : URLFileSystemProvider;private var _baseURL : String;private var _fileExists : Bool = false;@:allow(core.app.managers.filesystemproviders.url)
    private function new(uri : URI, fileSystemProvider : URLFileSystemProvider, baseURL : String)
    {
        super();_uri = uri;_fileSystemProvider = fileSystemProvider;_baseURL = baseURL;
    }public function execute() : Void{  // Remove the FileSystemProvider's id from the start of the path;  var localURI : URI = _uri.subpath(1);var parent : URI = new URI();parent.copyURI(localURI);  //parent.chdir("../");  parent = parent.getParentURI();var getDirectoryContents : GetDirectoryContentsOperation = new GetDirectoryContentsOperation(parent, _fileSystemProvider, _baseURL);getDirectoryContents.addEventListener(OperationProgressEvent.PROGRESS, progressHandler);getDirectoryContents.addEventListener(ErrorEvent.ERROR, errorHandler);getDirectoryContents.addEventListener(Event.COMPLETE, getDirectoryContentsCompleteHandler);getDirectoryContents.execute();
    }private function errorHandler(event : ErrorEvent) : Void{dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, event.text, FileSystemErrorCodes.DOES_FILE_EXIST_ERROR));
    }private function progressHandler(event : OperationProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, event.progress));
    }private function getDirectoryContentsCompleteHandler(event : Event) : Void{var getDirectoryContents : GetDirectoryContentsOperation = cast((event.target), GetDirectoryContentsOperation);  // Remove the FileSystemProvider's id from the start of the path;  var uriToFind : URI = _uri.subpath(1);_fileExists = false;for (uriInFolder/* AS3HX WARNING could not determine type for var: uriInFolder exp: EField(EIdent(getDirectoryContents),contents) type: null */ in getDirectoryContents.contents){if (uriInFolder.path == uriToFind.path) {_fileExists = true;break;
            }
        }dispatchEvent(new Event(Event.COMPLETE));
    }private function get_Label() : String{return "Does file exist : " + _uri.path;
    }private function get_FileExists() : Bool{return _fileExists;
    }private function get_Uri() : URI{return _uri;
    }private function get_FileSystemProvider() : IFileSystemProvider{return fileSystemProvider;
    }
}