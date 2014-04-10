  // =================================================================================================    //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.events;

import nme.events.Event;class ValidatorEvent extends Event
{
    public var state(get, never) : Bool;
public static inline var STATE_CHANGED : String = "stateChanged";private var _state : Bool;public function new(type : String, state : Bool)
    {super(type);_state = state;
    }override public function clone() : Event{return new ValidatorEvent(type, _state);
    }private function get_State() : Bool{return _state;
    }
}