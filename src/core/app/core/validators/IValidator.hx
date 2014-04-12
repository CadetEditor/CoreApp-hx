// =================================================================================================  
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.core.validators;

import core.app.core.validators.IEventDispatcher;
import nme.events.IEventDispatcher;@:meta(Event(type="core.app.events.ValidatorEvent",name="stateChanged"))
interface IValidator extends IEventDispatcher
{
    var state(get, never) : Bool;
function dispose() : Void;
}