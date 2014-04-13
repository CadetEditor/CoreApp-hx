// =================================================================================================  
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.datastructures;

import core.app.datastructures.Dictionary;
import nme.utils.Dictionary;
import core.app.util.IntrospectionUtil;

class ObjectPool
{
	private static var maxSize : Int = 100;
	private static var table : Dictionary = new Dictionary();
	private static var nodes : Array<Dynamic> = [];
	private static var numNodes : Int = 0;
	public static function clear() : Void {
		table = new Dictionary();
    }  
	
	/**

	 * Grabs a instance of the supplied type from the pool and returns it.

	 * If an existing instance cannot be found, then it simply returns a new instance.

	 * 

	 * IMPORTANT: Bear in mind that instances returned from this method aren't 'fresh'. For example,

	 * if a flasg.geom.Point instance was returned to the pool via returnInstance() - it's x and y

	 * properties are probably not their default zero, unlike they would be if created from scratch.

	 * @param type

	 * @return

	 */  
	public static function getInstance(type : Class<Dynamic>) : Dynamic
	{
		var node : ObjNode = Reflect.field(table, Std.string(type));
		if (node == null) {
			return Type.createInstance(type, []);
        }
		var L : Int = node.length;
		var temp : ObjNode = Reflect.setField(table, Std.string(type), node.next);
		node.next = null;
		if (temp != null) {
			temp.length = L - 1;
        }
		var instance : Dynamic = node.data;
		node.data = null; 
		nodes[numNodes++] = node;
		return instance;
    }
	
	public static function getInstances(type : Class<Dynamic>, count : Int) : Array<Dynamic> {
		var instances : Array<Dynamic> = [];
		for (i in 0...count) {
			instances[i] = getInstance(type);
        }
		return instances;
    }  
	
	/**

	 * Returns and instance to the pool, ready to be returned via getInstance() in the future.

	 * IMPORTANT: Make sure any instances returned via this method are completely disposed of.

	 * ie, don't leave any of their properties pointing to other instances.

	 * @param instance

	 * 

	 */  

	public static function returnInstance(instance : Dynamic, type : Class<Dynamic> = null) : Void
	{
		if (type == null) type = IntrospectionUtil.getType(instance);
		var node : ObjNode = Reflect.field(table, Std.string(type));
		if (node == null) { 
			Reflect.setField(table, Std.string(type), node = getNode());
			node.length = 1;node.data = instance;
        }
        else {
			if (node.length > maxSize) return;
			var newNode : ObjNode = getNode();
			newNode.data = instance;
			newNode.next = node;
			newNode.length = node.length + 1;
			Reflect.setField(table, Std.string(type), newNode);
        }
    }
	
	public static function returnInstances(instances : Array<Dynamic>, allSameType : Bool = false) : Void
	{
		if (instances.length == 0) return;
		if (allSameType) {
			var type : Class<Dynamic> = IntrospectionUtil.getType(instances[0]);
        }
		
		for (instance in instances) {
			returnInstance(instance, type);
        }
    }
	
	private static function getNode() : ObjNode {
		if (numNodes == 0) {
			return new ObjNode();
        }
		return nodes[--numNodes];
    }

    public function new()
    {
    }
}

class ObjNode
{
	public var next : ObjNode;
	public var data : Dynamic;
	public var length : Int = 0;

    @:allow(core.app.datastructures)
    private function new()
    {
    }
}