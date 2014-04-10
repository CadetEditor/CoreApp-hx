// =================================================================================================  //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.validators;

import core.app.validators.EventDispatcher;
import core.app.validators.IValidator;
import core.app.validators.ValidatorEvent;
import nme.events.EventDispatcher;import core.app.core.validators.IValidator;import core.app.events.ValidatorEvent;@:meta(Event(name="stateChanged",type="core.app.events.ValidatorEvent"))
class AbstractValidator extends EventDispatcher implements IValidator
{
    public var state(get, never) : Bool;
private var _state : Bool = false;private var firstSet : Bool = false;public function new()
    {
        super();
    }public function dispose() : Void{
    }private function get_State() : Bool{return _state;
    }private function setState(value : Bool) : Void{if (value == _state && !firstSet)             return;firstSet = true;_state = value;dispatchEvent(new ValidatorEvent(ValidatorEvent.STATE_CHANGED, _state));
    }
}