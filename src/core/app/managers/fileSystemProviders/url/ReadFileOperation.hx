  // =================================================================================================    //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.managers.filesystemproviders.url;

import core.app.managers.filesystemproviders.url.ByteArray;
import core.app.managers.filesystemproviders.url.IReadFileOperation;
import core.app.managers.filesystemproviders.url.URLFileSystemProvider;
import nme.events.ErrorEvent;import nme.events.Event;import nme.events.EventDispatcher;import nme.events.IOErrorEvent;import nme.events.ProgressEvent;import nme.events.SecurityErrorEvent;import nme.net.URLLoader;import nme.net.URLLoaderDataFormat;import nme.net.URLRequest;import nme.utils.ByteArray;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.IReadFileOperation;import core.app.entities.URI;import core.app.events.FileSystemErrorCodes;import core.app.events.OperationProgressEvent;import core.app.util.StringUtil;class ReadFileOperation extends EventDispatcher implements IReadFileOperation
{
    public var label(get, never) : String;
    public var bytes(get, never) : ByteArray;
    public var uri(get, never) : URI;
    public var fileSystemProvider(get, never) : IFileSystemProvider;
private var _uri : URI;private var _fileSystemProvider : URLFileSystemProvider;private var _bytes : ByteArray;private var _baseURL : String;@:allow(core.app.managers.filesystemproviders.url)
    private function new(uri : URI, fileSystemProvider : URLFileSystemProvider, baseURL : String)
    {
        super();_uri = uri;_fileSystemProvider = fileSystemProvider;_baseURL = baseURL;
    }public function execute() : Void{var loader : URLLoader = new URLLoader();  // Remove the FileSystemProvider's id from the start of the path;  var localURI : URI = _uri.subpath(1);var request : URLRequest = new URLRequest(_baseURL + localURI.path);request.contentType = URLLoaderDataFormat.BINARY;loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);loader.addEventListener(Event.COMPLETE, loadCompleteHandler);loader.dataFormat = URLLoaderDataFormat.BINARY;loader.load(request);
    }private function errorHandler(event : ErrorEvent) : Void{dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, event.text, FileSystemErrorCodes.READ_FILE_ERROR));
    }private function progressHandler(event : ProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, event.bytesLoaded / event.bytesTotal));
    }private function loadCompleteHandler(event : Event) : Void{var loader : URLLoader = cast((event.target), URLLoader);_bytes = cast((loader.data), ByteArray);dispatchEvent(new Event(Event.COMPLETE));
    }private function get_Label() : String{return "Read File : " + _uri.path;
    }private function get_Bytes() : ByteArray{return _bytes;
    }private function get_Uri() : URI{return _uri;
    }private function get_FileSystemProvider() : IFileSystemProvider{return fileSystemProvider;
    }
}