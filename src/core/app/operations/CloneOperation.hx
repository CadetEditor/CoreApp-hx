  // =================================================================================================    //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.operations;

import core.app.operations.Deserializer;
import core.app.operations.Event;
import core.app.operations.EventDispatcher;
import core.app.operations.IAsynchronousOperation;
import core.app.operations.ISerializationPlugin;
import core.app.operations.OperationProgressEvent;
import core.app.operations.SerializeProgressEvent;
import core.app.operations.Serializer;
import nme.events.Event;import nme.events.EventDispatcher;import core.app.core.operations.IAsynchronousOperation;import core.app.core.serialization.Deserializer;import core.app.core.serialization.ISerializationPlugin;import core.app.core.serialization.Serializer;import core.app.events.OperationProgressEvent;import core.app.events.SerializeProgressEvent;@:meta(Event(type="core.app.events.OperationProgressEvent",name="progress"))
@:meta(Event(type="flash.events.Event",name="complete"))
@:meta(Event(type="flash.events.ErrorEvent",name="error"))
  /**
	 * This Operation wraps up a call to the bones.core.serialization.Serializer.cloneAsync() method.
	 * The Serializer dispatches its own progress and complete events, which this Operation re-dispatches
	 * as OperationEvent's. 
	 * @author Jonathan
	 * 
	 */  class CloneOperation extends EventDispatcher implements IAsynchronousOperation
{
    public var label(get, never) : String;
private var serializer : Serializer;private var deserializer : Deserializer;private var result : Dynamic;private var item : Dynamic;public function new(item : Dynamic, plugins : Array<ISerializationPlugin> = null)
    {
        super();this.item = item;serializer = new Serializer();serializer.addEventListener(Event.COMPLETE, serializeCompleteHandler);serializer.addEventListener(SerializeProgressEvent.PROGRESS, serializeProgressHandler);deserializer = new Deserializer();deserializer.addEventListener(Event.COMPLETE, deserializeCompleteHandler);deserializer.addEventListener(SerializeProgressEvent.PROGRESS, deserializeProgressHandler);if (plugins != null) {for (plugin in plugins){serializer.addPlugin(plugin);deserializer.addPlugin(plugin);
            }
        }
    }public function execute() : Void{serializer.serializeAsync(item);
    }private function serializeCompleteHandler(event : Event) : Void{deserializer.deserializeAsync(serializer.getResult());
    }private function deserializeCompleteHandler(event : Event) : Void{result = deserializer.getResult();dispose();dispatchEvent(new Event(Event.COMPLETE));
    }private function serializeProgressHandler(event : SerializeProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, (event.numItems / event.totalItems) * 0.2));
    }private function deserializeProgressHandler(event : SerializeProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, 0.2 + (event.numItems / event.totalItems) * 0.8));
    }private function dispose() : Void{serializer.removeEventListener(Event.COMPLETE, serializeCompleteHandler);serializer.removeEventListener(SerializeProgressEvent.PROGRESS, serializeProgressHandler);deserializer.removeEventListener(Event.COMPLETE, deserializeCompleteHandler);deserializer.removeEventListener(SerializeProgressEvent.PROGRESS, deserializeProgressHandler);
    }public function getResult() : Dynamic{return result;
    }private function get_Label() : String{return "Clone";
    }
}