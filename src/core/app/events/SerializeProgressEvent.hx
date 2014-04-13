// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.events;

import nme.events.Event;  

/**
 * ...
 * @author Jon
 */  

class SerializeProgressEvent extends Event
{
	public static inline var PROGRESS : String = "progress";
	public var numItems : Int;
	public var totalItems : Int;
	
	public function new(type : String)
    {
		super(type, false, false);
    }
	
	override public function clone() : Event {
		var event : SerializeProgressEvent = new SerializeProgressEvent(SerializeProgressEvent.PROGRESS);
		event.numItems = numItems; 
		event.totalItems = totalItems;
		return event;
    }
}