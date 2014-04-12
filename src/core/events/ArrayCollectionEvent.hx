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

import core.events.Event;
import nme.events.Event;class ArrayCollectionEvent extends Event
{
    public var kind(get, never) : Int;
    public var index(get, never) : Int;
    public var item(get, never) : Dynamic;
public static var CHANGE : String = "change";private var _kind : Int;private var _index : Int;private var _item : Dynamic;public function new(type : String, changeKind : Int, index : Int = 0, item : Dynamic = null)
    {super(type, false, false);_kind = changeKind;_index = index;_item = item;
    }override public function clone() : Event{return new ArrayCollectionEvent(type, _kind, _index, _item);
    }private function get_Kind() : Int{return _kind;
    }private function get_Index() : Int{return _index;
    }private function get_Item() : Dynamic{return _item;
    }
}