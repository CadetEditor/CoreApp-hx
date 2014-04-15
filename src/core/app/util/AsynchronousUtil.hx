// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.util;

import core.app.util.Event;
import core.app.util.EventDispatcher;
import core.app.util.Timer;
import core.app.util.TimerEvent;
import nme.events.Event;
import nme.events.EventDispatcher;
import nme.events.TimerEvent;
import nme.utils.Timer;

class AsynchronousUtil
{
	private static var dispatchLaterList : Array<Dynamic>;
	private static var callLaterList : Array<Dynamic>;
	private static var dispatchLaterTimer : Timer;  
	/**
	 * Utility function for dispatching an event on the next (10ms later) code cycle. This is useful for delegate models where
	 * a function needs to dispatch an event on a delegate before it has returned it to the caller. In this situation
	 * the caller hansn't yet had chance to listen in to any events. Using this utility the callee can delay dispatching until
	 * the caller has added it's listeners.
	 * @param eventDispatcher
	 * @param event
	 * 
	 */  
	
	public static function dispatchLater(eventDispatcher : EventDispatcher, event : Event) : Void
	{
		if (dispatchLaterList == null) {
			dispatchLaterList = [];
        }
		
		dispatchLaterList.push({
			eventDispatcher : eventDispatcher,
			event : event
		});
				
		if (dispatchLaterTimer == null) {
			dispatchLaterTimer = new Timer(10, 1);
			dispatchLaterTimer.addEventListener(TimerEvent.TIMER_COMPLETE, dispatchLaterHandler);
			dispatchLaterTimer.start();
        }
    }
	
	private static function dispatchLaterHandler(event : TimerEvent) : Void
	{
		dispatchLaterTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, dispatchLaterHandler);
		dispatchLaterTimer = null;
	
		if (dispatchLaterList == null) dispatchLaterList = [];
		var localList : Array<Dynamic> = dispatchLaterList.substring();
		dispatchLaterList = [];
		
		for (i in 0...localList.length) {
			var obj : Dynamic = localList[i];
			obj.eventDispatcher.dispatchEvent(obj.event);
        }
		
		if (callLaterList == null) callLaterList = [];
		
		localList = callLaterList.substring();
		callLaterList = [];
		
		for (j in 0...localList.length) {
			obj = localList[j];
			var method : Function = obj.method;
			method.apply(null, obj.params);
        }
    }
	
	public static function callLater(method : Function, params : Array<Dynamic> = null) : Void
	{
		if (params == null) params = [];
		
		if (callLaterList == null) {
			callLaterList = [];
        }
		
		callLaterList.push({
			method : method,
			params : params
		});
				
		if (dispatchLaterTimer == null) {
			dispatchLaterTimer = new Timer(10, 1);
			dispatchLaterTimer.addEventListener(TimerEvent.TIMER_COMPLETE, dispatchLaterHandler);
			dispatchLaterTimer.start();
        }
    }

    public function new()
    {
    }
}