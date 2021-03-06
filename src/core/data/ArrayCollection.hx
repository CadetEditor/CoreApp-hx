// =================================================================================================  
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.data;

import core.events.ArrayCollectionEvent;
//import core.data.Event;
//import core.data.EventDispatcher;
//import core.data.IEventDispatcher;
//import core.data.Proxy;
//import nme.errors.Error;
//import nme.events.Event;
//import nme.events.EventDispatcher;
//import nme.events.IEventDispatcher;
//import nme.utils.Proxy;
import core.events.ArrayCollectionChangeKind;
import core.events.ArrayCollectionEvent;
import flash.utils.Proxy;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.errors.Error;

@:meta(Event(type = "core.events.ArrayCollectionEvent", name = "change"))
class ArrayCollection extends Proxy implements IEventDispatcher implements ArrayAccess<Dynamic>
{
    public var source(get, set) : Array<Dynamic>;
    public var length(get, never) : Int;
	private var array : Array<Dynamic>;
	private var dispatcher : EventDispatcher;
	
	public function new(source : Array<Dynamic> = null)
    {
        super();
		array = source == (null) ? [] : source;
		dispatcher = new EventDispatcher(this);
    }  
	
	////////////////////////////////////////////////    
	// Public methods    
	////////////////////////////////////////////////  
	
	
	
	public function addItemAt(item : Dynamic, index : Int) : Void
	{
		if (index < 0 || index > array.length) throw (new Error("Index out of bounds : " + index));			
		array.splice(index, 0);
		dispatcher.dispatchEvent(new ArrayCollectionEvent(ArrayCollectionEvent.CHANGE, ArrayCollectionChangeKind.ADD, index, item));
    }
	
	public function removeItemAt(index : Int) : Void
	{
		if (index < 0 || index > array.length) throw (new Error("Index out of bounds : " + index));
		
		var item : Dynamic = array[index]; 
		array.splice(index, 1);
		dispatcher.dispatchEvent(new ArrayCollectionEvent(ArrayCollectionEvent.CHANGE, ArrayCollectionChangeKind.REMOVE, index, item));
    }
	
	public function getItemIndex(item : Dynamic) : Int 
	{
		return Lambda.indexOf(array, item);
    }
	
	public function getItemAt(index : Int) : Dynamic 
	{
		return array[index];
    }
	
	public function removeItem(item : Dynamic) : Void
	{
		var index : Int = Lambda.indexOf(array, item); 
		if (index == -1) {
			throw (new Error("Item does not exist."));
			return;
		}
		removeItemAt(index);
    }
	
	public function addItem(value : Dynamic) : Void
	{
		//array.push(value);
		this[array.length] = value;
    }
	
	public function contains(item : Dynamic) : Bool
	{
		return Lambda.indexOf(source, item) != -1;
    }  
	
	////////////////////////////////////////////////    
	// Getters/Setters    
	////////////////////////////////////////////////  
	
	private function set_source(value : Array<Dynamic>) : Array<Dynamic>
	{
		var oldValue : Array<Dynamic> = array; 
		array = value;
		dispatcher.dispatchEvent(new ArrayCollectionEvent(ArrayCollectionEvent.CHANGE, ArrayCollectionChangeKind.RESET, 0, oldValue));
        return value;
    }
	
	private function get_source() : Array<Dynamic>
	{
		return array.slice(0); // todo: test
    }
	
	override function getProperty(name : Dynamic) : Dynamic
	{
		return array[name];
    }
	
	override function setProperty(name : Dynamic, value : Dynamic) : Void
	{
		var index : Int = Std.parseInt(name);
		if (Math.isNaN(index)) throw (new Error("Invalid index : " + name));
		if (index < 0 || index > array.length) throw (new Error("Index out of bounds : " + index));
		
		var changeKind : Int;
		
		if (index == array.length) {
			if (value == null) {
				//array.length--; todo: ok to comment out?
				changeKind = ArrayCollectionChangeKind.REMOVE;
            }
            else {
				changeKind = ArrayCollectionChangeKind.ADD;
				array[array.length] = value;
            }
        } else {
			changeKind = ArrayCollectionChangeKind.REPLACE;
			array[index] = value;
        }
		
		dispatcher.dispatchEvent(new ArrayCollectionEvent(ArrayCollectionEvent.CHANGE, changeKind, index, value));
    }
	
	override function nextNameIndex(index : Int) : Int
	{
		return index < length ? index + 1 : 0;
    }
	
	override function nextName(index : Int) : String
	{
		return Std.string((index - 1));
    }
	
	override function nextValue(index : Int) : Dynamic
	{
		return getItemAt(index - 1);
    }
	
	private function get_length() : Int
	{
		return array.length;
    }
	
	public function toString() : String
	{
		return Std.string(array);
    }  
	
	////////////////////////////////////////////////    
	// Implement IEventDispatcher    
	////////////////////////////////////////////////  
	
	// note: replaced listener : Function with : Dynamic
	public function addEventListener(type : String, listener : Dynamic, useCapture : Bool = false, priority : Int = 0, useWeakReference : Bool = false) : Void
	{
		dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }
	
	public function dispatchEvent(event : Event) : Bool
	{
		return dispatcher.dispatchEvent(event);
    }
	
	public function hasEventListener(type : String) : Bool
	{
		return dispatcher.hasEventListener(type);
    }
	
	// note: replaced listener : Function with : Dynamic
	public function removeEventListener(type : String, listener : Dynamic, useCapture : Bool = false) : Void
	{
		dispatcher.removeEventListener(type, listener, useCapture);
    }
	
	public function willTrigger(type : String) : Bool
	{
		return dispatcher.willTrigger(type);
    }
}