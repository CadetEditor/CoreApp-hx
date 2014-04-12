// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com    
// All rights reserved.  package core.app.operations;

import nme.events.Event;import nme.events.EventDispatcher;import core.app.core.operations.IAsynchronousOperation;import core.app.core.serialization.ISerializationPlugin;import core.app.core.serialization.Serializer;import core.app.events.OperationProgressEvent;import core.app.events.SerializeProgressEvent;@:meta(Event(type="core.app.events.OperationProgressEvent",name="progress"))
@:meta(Event(type="flash.events.Event",name="complete"))
class SerializeOperation extends EventDispatcher implements IAsynchronousOperation
{
    public var label(get, never) : String;
private var item : Dynamic;private var plugins : Array<ISerializationPlugin>;private var result : FastXML;public function new(item : Dynamic, plugins : Array<ISerializationPlugin> = null)
    {
        super();this.item = item;this.plugins = plugins;
    }public function getResult() : FastXML{return result;
    }public function execute() : Void{var serializer : Serializer = new Serializer();if (plugins != null) {for (plugin in plugins){serializer.addPlugin(plugin);
            }
        }serializer.addEventListener(SerializeProgressEvent.PROGRESS, serializeProgressHandler);serializer.addEventListener(Event.COMPLETE, serializeCompleteHandler);serializer.serializeAsync(item);
    }private function serializeProgressHandler(event : SerializeProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, event.numItems / event.totalItems));
    }private function serializeCompleteHandler(event : Event) : Void{var serializer : Serializer = cast((event.target), Serializer);serializer.removeEventListener(SerializeProgressEvent.PROGRESS, serializeProgressHandler);serializer.removeEventListener(Event.COMPLETE, serializeCompleteHandler);result = serializer.getResult();dispatchEvent(new Event(Event.COMPLETE));
    }private function get_Label() : String{return null;
    }
}