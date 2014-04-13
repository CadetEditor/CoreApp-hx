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

import core.app.events.Event;
import nme.events.Event;

class CollectionValidatorEvent extends Event
{
    public var validItems(get, never) : Array<Dynamic>;
	public static inline var VALID_ITEMS_CHANGED : String = "validItemsChanged";
	private var _validItems : Array<Dynamic>;
	public function new(type : String, validItems : Array<Dynamic>)
    {
		super(type);
		_validItems = validItems;
    }
	override public function clone() : Event{return new CollectionValidatorEvent(type, _validItems);
    }
	private function get_ValidItems() : Array<Dynamic> {
		return _validItems;
    }
}