// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.operations;

import core.app.operations.IFileSystemProvider;
import core.app.operations.IReadFileOperation;
import core.app.operations.URI;
import nme.events.Event;import nme.events.EventDispatcher;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.IReadFileOperation;import core.app.core.operations.IAsynchronousOperation;import core.app.core.serialization.ISerializationPlugin;import core.app.entities.URI;import core.app.events.OperationProgressEvent;@:meta(Event(type="core.app.events.OperationProgressEvent",name="progress"))
@:meta(Event(type="flash.events.Event",name="complete"))
@:meta(Event(type="flash.events.ErrorEvent",name="error"))
class ReadFileAndDeserializeOperation extends EventDispatcher implements IAsynchronousOperation
{
    public var label(get, never) : String;
private var readFileOperation : IReadFileOperation;private var deserializeOperation : DeserializeOperation;private var result : Dynamic;private var uri : URI;private var fileSystemProvider : IFileSystemProvider;private var plugins : Array<ISerializationPlugin>;public function new(uri : URI, fileSystemProvider : IFileSystemProvider, plugins : Array<ISerializationPlugin> = null)
    {
        super();this.uri = uri;this.fileSystemProvider = fileSystemProvider;this.plugins = plugins;
    }public function execute() : Void{readFileOperation = fileSystemProvider.readFile(uri);readFileOperation.addEventListener(OperationProgressEvent.PROGRESS, readFileProgressHandler);readFileOperation.addEventListener(Event.COMPLETE, readFileCompleteHandler);readFileOperation.execute();
    }private function readFileProgressHandler(event : OperationProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, event.progress * 0.2));
    }private function readFileCompleteHandler(event : Event) : Void{if (readFileOperation.bytes.length == 0) {result = null;dispatchEvent(new Event(Event.COMPLETE));return;
        }var xml : FastXML = cast((readFileOperation.bytes.readUTFBytes(readFileOperation.bytes.length)), XML);deserializeOperation = new DeserializeOperation(xml, plugins);deserializeOperation.addEventListener(Event.COMPLETE, deserializeCompleteHandler);deserializeOperation.addEventListener(OperationProgressEvent.PROGRESS, deserializeProgressHandler);deserializeOperation.execute();
    }private function deserializeProgressHandler(event : OperationProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, 0.2 + event.progress * 0.8));
    }private function deserializeCompleteHandler(event : Event) : Void{result = deserializeOperation.getResult();dispatchEvent(new Event(Event.COMPLETE));
    }private function get_Label() : String{return "Read file and deserialize : " + uri.getFilename();
    }public function getResult() : Dynamic{return result;
    }public function getURI() : URI{return readFileOperation.uri;
    }
}