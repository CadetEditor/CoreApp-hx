package core.app.util;

import core.app.util.ISerializationPlugin;
import core.app.util.ResourceSerializerPlugin;
import core.app.util.SerializeOperation;
import nme.events.Event;import nme.events.EventDispatcher;import core.app.CoreApp;import core.app.core.serialization.ISerializationPlugin;import core.app.core.serialization.ResourceSerializerPlugin;import core.app.operations.SerializeOperation;class SerializationUtil
{private static var _eventDispatcher : EventDispatcher;private static var _result : FastXML;public function new()
    {
    }public static function serialize(obj : Dynamic) : EventDispatcher{if (!CoreApp.initialised) {CoreApp.init();
        }if (_eventDispatcher == null) {_eventDispatcher = new EventDispatcher();
        }var plugins : Array<ISerializationPlugin> = new Array<ISerializationPlugin>();plugins.push(new ResourceSerializerPlugin(CoreApp.resourceManager));var serializeOperation : SerializeOperation = new SerializeOperation(obj, plugins);serializeOperation.addEventListener(Event.COMPLETE, serializeCompleteHandler);  //			serializeOperation.addEventListener(OperationProgressEvent.PROGRESS, progressHandler);    //			serializeOperation.addEventListener(ErrorEvent.ERROR, errorHandler);  serializeOperation.execute();return _eventDispatcher;
    }private static function serializeCompleteHandler(event : Event) : Void{var serializeOperation : SerializeOperation = cast((event.target), SerializeOperation);_result = serializeOperation.getResult();_eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
    }public static function getResult() : FastXML{return _result;
    }
}