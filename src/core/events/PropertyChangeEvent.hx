// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.events;

import nme.errors.Error;
import nme.events.Event;class PropertyChangeEvent extends Event
{
    public var propertyName(get, never) : String;
    public var oldValue(get, never) : Dynamic;
    public var newValue(get, never) : Dynamic;
private var _propertyName : String;private var _oldValue : Dynamic;private var _newValue : Dynamic;public function new(type : String, oldValue : Dynamic, newValue : Dynamic)
    {super(type, false, false);if (type.indexOf("propertyChange_") == -1) {throw (new Error("Invalid event type for PropertyChangeEvent. Must be of the form 'propertyChange_<propertyName>' "));return;
        }_propertyName = type.substring(15);_oldValue = oldValue;_newValue = newValue;
    }override public function clone() : Event{return new PropertyChangeEvent(type, _oldValue, _newValue);
    }private function get_PropertyName() : String{return _propertyName;
    }private function get_OldValue() : Dynamic{return _oldValue;
    }private function get_NewValue() : Dynamic{return _newValue;
    }
}