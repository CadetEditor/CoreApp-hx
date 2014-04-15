// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.entities;

import core.data.ArrayCollection;
import core.events.ArrayCollectionEvent;
//import core.app.entities.EventDispatcher;
//import nme.errors.Error;
//import nme.events.EventDispatcher;
import flash.events.EventDispatcher;
import core.data.ArrayCollection;
import core.events.ArrayCollectionChangeKind;
import core.events.ArrayCollectionEvent;

@:meta(Event(type="core.events.ArrayCollectionEvent",name="change"))
class TreeNode extends EventDispatcher
{
    public var children(get, never) : ArrayCollection;
    public var data(get, set) : Dynamic;
    public var label(get, set) : String;
	private var _children : ArrayCollection;
	private var _data : Dynamic;
	private var _label : String;
	public var parent : TreeNode;
	public function new()
    {
        super();
		_children = new ArrayCollection();
		_children.addEventListener(ArrayCollectionEvent.CHANGE, collectionChangeHandler);
    }
	private function collectionChangeHandler(event : ArrayCollectionEvent) : Void
	{
		if (event.kind == ArrayCollectionChangeKind.ADD) {
			event.item.parent = this;
			event.item.addEventListener(ArrayCollectionEvent.CHANGE, childCollectionChangedHandler);
        }
        else if (event.kind == ArrayCollectionChangeKind.REMOVE) {
			event.item.parent = null;
			event.item.removeEventListener(ArrayCollectionEvent.CHANGE, childCollectionChangedHandler);
        }
        else if (event.kind == ArrayCollectionChangeKind.RESET) {
			throw (new Error("TreeItem cannot handle the 'removeAll()' operation on it's children"));
			return;
        }
		
		dispatchEvent(event);
    }
	
	private function childCollectionChangedHandler(event : ArrayCollectionEvent) : Void
	{
		dispatchEvent(event);
    }
	
	private function get_Children() : ArrayCollection
	{
		return _children;
    }
	
	private function set_Data(value : Dynamic) : Dynamic
	{
		_data = value;
        return value;
    }
	
	private function get_Data() : Dynamic
	{
		return _data;
    }
	
	private function set_Label(value : String) : String
	{
		_label = value;
        return value;
    }
	
	private function get_Label() : String
	{
		return _label;
    }
	
	public function getChildren(recursive : Bool = true) : Array<Dynamic>
	{
		var array : Array<Dynamic> = [];
		for (i in 0..._children.length) {
			var child : TreeNode = _children[i]; array.push(child);
			if (recursive) {
				array = array.concat(child.getChildren(true));
            }
        }
		
		return array;
    }
	
	public function getChildWithLabel(value : String, recursive : Bool = false) : TreeNode
	{
		for (i in 0..._children.length) {
			var child : TreeNode = _children[i];
			if (child.label == value) return child;
			if (recursive) {
				var result : TreeNode = child.getChildWithLabel(value, true);
				if (result != null) return result;
            }
        }
		return null;
    }
	
	public function getChildWithData(value : Dynamic, recursive : Bool = false) : TreeNode
	{
		for (i in 0..._children.length) {
			var child : TreeNode = _children[i];
			if (child.data == value) return child;
			if (recursive) {
				var result : TreeNode = child.getChildWithData(value, true);
				if (result != null) return result;
            }
        }
		return null;
    }
}