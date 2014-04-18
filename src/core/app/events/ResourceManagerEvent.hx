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

import flash.events.Event;
import core.app.resources.IResource;

class ResourceManagerEvent extends Event
{
    public var resource(get, never) : IResource;
	public static inline var RESOURCE_ADDED : String = "resourceAdded";
	private var _resource : IResource;
	
	public function new(type : String, resource : IResource)
    {
		super(type);_resource = resource;
    }
	
	override public function clone() : Event {
		return new ResourceManagerEvent(type, _resource);
    }
	
	private function get_resource() : IResource {
		return _resource;
    }
}