// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.managers.filesystemproviders.url;

import core.app.managers.filesystemproviders.url.IGetDirectoryContentsOperation;
import core.app.managers.filesystemproviders.url.ProgressEvent;
import core.app.managers.filesystemproviders.url.URLFileSystemProvider;
import core.app.managers.filesystemproviders.url.URLLoader;
import core.app.managers.filesystemproviders.url.URLRequest;
import nme.errors.Error;
import nme.events.ErrorEvent;import nme.events.Event;import nme.events.EventDispatcher;import nme.events.IOErrorEvent;import nme.events.ProgressEvent;import nme.events.SecurityErrorEvent;import nme.net.URLLoader;import nme.net.URLLoaderDataFormat;import nme.net.URLRequest;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.IGetDirectoryContentsOperation;import core.app.entities.URI;import core.app.events.OperationProgressEvent;class GetDirectoryContentsOperation extends EventDispatcher implements IGetDirectoryContentsOperation
{
    public var label(get, never) : String;
    public var uri(get, never) : URI;
    public var fileSystemProvider(get, never) : IFileSystemProvider;
    public var contents(get, never) : Array<URI>;
private var _uri : URI;private var _fileSystemProvider : URLFileSystemProvider;private var _baseURL : String;private var _contents : Array<URI>;private var _defaultContentsXMLURL : String = "_contents.xml";@:allow(core.app.managers.filesystemproviders.url)
    private function new(uri : URI, fileSystemProvider : URLFileSystemProvider, baseURL : String)
    {
        super();_uri = uri;_fileSystemProvider = fileSystemProvider;_baseURL = baseURL;
    }public function execute() : Void{var loader : URLLoader = new URLLoader();  // Remove the FileSystemProvider's id from the start of the path;  var localURI : URI = _uri.subpath(1);var url : String = _baseURL + localURI.path;if (url.charAt(url.length - 1) != "/") {url = url + "/";
        }var request : URLRequest = new URLRequest(url + _defaultContentsXMLURL);request.contentType = URLLoaderDataFormat.TEXT;loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);loader.addEventListener(Event.COMPLETE, loadCompleteHandler);loader.load(request);
    }private function errorHandler(event : ErrorEvent) : Void{  // Failed to find contents.xml, assume directory is empty.  _contents = new Array<URI>();dispatchEvent(new Event(Event.COMPLETE));
    }private function progressHandler(event : ProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, event.bytesLoaded / event.bytesTotal));
    }private function loadCompleteHandler(event : Event) : Void{var loader : URLLoader = cast((event.target), URLLoader);var contentsXML : FastXML;try{contentsXML = cast((loader.data), XML);
        }        catch (e : Error){_contents = new Array<URI>();dispatchEvent(new Event(Event.COMPLETE));return;
        }_contents = new Array<URI>();for (i in 0...contentsXML.node.children.innerData().length()){var child : FastXML = contentsXML.nodes.children()[i];if (child.node.name.innerData() == "file") {_contents.push(new URI(_uri.path + Std.string(child.node.text.innerData())));
            }
            else if (child.node.name.innerData() == "folder") {_contents.push(new URI(_uri.path + Std.string(child.node.text.innerData() + "/")));
            }
        }dispatchEvent(new Event(Event.COMPLETE));
    }private function get_Label() : String{return "Get Directory Contents : " + _uri.path;
    }private function get_Uri() : URI{return _uri;
    }private function get_FileSystemProvider() : IFileSystemProvider{return fileSystemProvider;
    }private function get_Contents() : Array<URI>{return _contents;
    }
}