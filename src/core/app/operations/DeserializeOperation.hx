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

import nme.events.ErrorEvent;
import nme.events.Event;
import nme.events.EventDispatcher;
import core.app.core.operations.IAsynchronousOperation;
import core.app.core.serialization.Deserializer;
import core.app.core.serialization.ISerializationPlugin;
import core.app.events.OperationProgressEvent;
import core.app.events.SerializeProgressEvent;

@:meta(Event(type="core.app.events.OperationProgressEvent",name="progress"))
@:meta(Event(type="flash.events.Event",name="complete"))
@:meta(Event(type="flash.events.ErrorEvent",name="error"))
class DeserializeOperation extends EventDispatcher implements IAsynchronousOperation
{
    public var label(get, never) : String;
	public var xml : FastXML;
	private var result : Dynamic;
	private var plugins : Array<ISerializationPlugin>;
	
	public function new(xml : FastXML, plugins : Array<ISerializationPlugin> = null)
    {
        super();this.xml = xml;this.plugins = plugins;
    }
	
	public function getResult() : Dynamic
	{
		return result;
    }
	
	public function execute() : Void
	{
		var deserializer : Deserializer = new Deserializer();
		if (plugins != null) {
			for (plugin in plugins) {
				deserializer.addPlugin(plugin);
            }
        }
		deserializer.addEventListener(SerializeProgressEvent.PROGRESS, deserializeProgressHandler); 
		deserializer.addEventListener(Event.COMPLETE, deserializeCompleteHandler);
		deserializer.addEventListener(ErrorEvent.ERROR, deserializeErrorHandler);
		deserializer.deserializeAsync(xml);
    }
	
	private function deserializeProgressHandler(event : SerializeProgressEvent) : Void
	{
		dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, event.numItems / event.totalItems));
    }
	
	private function deserializeCompleteHandler(event : Event) : Void
	{
		var deserializer : Deserializer = cast((event.target), Deserializer);
		deserializer.removeEventListener(SerializeProgressEvent.PROGRESS, deserializeProgressHandler);
		deserializer.removeEventListener(Event.COMPLETE, deserializeCompleteHandler);
		deserializer.removeEventListener(ErrorEvent.ERROR, deserializeErrorHandler);
		result = deserializer.getResult();
		dispatchEvent(new Event(Event.COMPLETE));
    }
	
	private function deserializeErrorHandler(event : ErrorEvent) : Void
	{
		dispatchEvent(event);
    }
	
	private function get_Label() : String
	{
		return null;
    }
}