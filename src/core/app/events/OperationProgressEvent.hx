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

import nme.events.Event;class OperationProgressEvent extends Event
{
    public var progress(get, never) : Float;
public static inline var PROGRESS : String = "progress";private var _progress : Float;public function new(type : String, progress : Float)
    {super(type);_progress = progress;
    }override public function clone() : Event{return new OperationProgressEvent(type, progress);
    }private function get_Progress() : Float{return _progress;
    }
}