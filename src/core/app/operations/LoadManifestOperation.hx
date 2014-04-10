  // =================================================================================================    //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.operations;

import core.app.operations.Manifest;
import core.app.operations.ProgressEvent;
import core.app.operations.URLLoader;
import core.app.operations.URLRequest;
import nme.errors.Error;
import nme.events.ErrorEvent;import nme.events.Event;import nme.events.EventDispatcher;import nme.events.IOErrorEvent;import nme.events.ProgressEvent;import nme.events.SecurityErrorEvent;import nme.net.URLLoader;import nme.net.URLLoaderDataFormat;import nme.net.URLRequest;import core.app.core.operations.IOperation;import core.app.core.serialization.Manifest;import core.app.events.OperationProgressEvent;class LoadManifestOperation extends EventDispatcher implements IOperation
{
    public var label(get, never) : String;
private var url : String;private var manifest : Manifest;public function new(url : String, manifest : Manifest)
    {
        super();this.url = url;this.manifest = manifest;
    }public function execute() : Void{var request : URLRequest = new URLRequest(url);var loader : URLLoader = new URLLoader();loader.dataFormat = URLLoaderDataFormat.TEXT;loader.addEventListener(Event.COMPLETE, onLoadComplete);loader.addEventListener(ProgressEvent.PROGRESS, onProgress);loader.addEventListener(IOErrorEvent.IO_ERROR, onError);loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);loader.load(request);
    }private function onProgress(event : ProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, event.bytesLoaded / event.bytesTotal));
    }private function onError(event : ErrorEvent) : Void{dispatchEvent(new ErrorEvent("Failed to load manifest file at : " + url));
    }private function onLoadComplete(event : Event) : Void{var loader : URLLoader = cast((event.target), URLLoader);try{var xml : FastXML = cast((loader.data), XML);manifest.parse(xml);
        }        catch (e : Error){dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "An error occured while parsing manifest XML : " + e.message));
        }dispatchEvent(new Event(Event.COMPLETE));
    }private function get_Label() : String{return "Load Manifest : " + url;
    }
}