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

import core.app.core.operations.IUndoableOperation;  /**

	 * This Operation sets the value of a single property on a single object. It remembers the value

	 * it is replacing, allowing the operation to be undone.

	 * @author Jonathan

	 * 

	 */  class ChangePropertyOperation implements IUndoableOperation
{
    public var label(get, set) : String;
private var object : Dynamic;private var propertyName : String;private var newValue : Dynamic;private var oldValue : Dynamic;private var _label : String = "Change Property";public function new(object : Dynamic, propertyName : String, newValue : Dynamic, oldValue : Dynamic = null)
    {this.object = object;this.propertyName = propertyName;this.newValue = newValue;if (oldValue != null) {this.oldValue = oldValue;
        }
        else {this.oldValue = Reflect.field(object, propertyName);
        }
    }public function execute() : Void{Reflect.setField(object, propertyName, newValue);
    }public function undo() : Void{Reflect.setField(object, propertyName, oldValue);
    }private function set_Label(value : String) : String{_label = value;
        return value;
    }private function get_Label() : String{return _label;
    }
}