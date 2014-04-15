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

import core.app.util.Dictionary;
import nme.utils.Dictionary;

class ArrayUtil
{
	public static function shuffle(array : Array<Dynamic>, iterations : Int) : Void
	{
		for (i in 0...iterations) {
			array = array.sort(shuffleFunc);
        }
    }
	
	private static function shuffleFunc(itemA : Dynamic, itemB : Dynamic) : Bool
	{
		return Math.random() < 0.5;
    }
	
	public static function filterByType(array : Array<Dynamic>, type : Class<Dynamic>) : Array<Dynamic>
	{
		var obj : Dynamic = {
            type : type
        };
		
		return array.filter(function(item : Dynamic, index : Int, arr : Array<Dynamic>) : Bool
		{
			return Std.is(item, type);        
		}, 
		obj);
    }
	
	public static function filterByTypes(array : Array<Dynamic>, types : Array<Dynamic>) : Array<Dynamic>
	{
		var obj : Dynamic = {
            types : types
        };
		
		return array.filter(function(item : Dynamic, index : Int, arr : Array<Dynamic>) : Bool
		{
			for (type in types) {
				if (Std.is(item, type) == false) return false;
            }
			return true;
         }, 
		 obj);
    }
	
	public static function removeDuplicates(array : Array<Dynamic>) : Void
	{
		var table : Dictionary = new Dictionary();
		for (i in 0...array.length) {
			var item : Dynamic = array[i];
			if (Reflect.field(table, Std.string(item))) {
				array.splice(i, 1);
				i--;
            } else {
				Reflect.setField(table, Std.string(item), true);
            }
        }
    }
	
	public static function containsInstanceOf(array : Array<Dynamic>, type : Class<Dynamic>) : Bool
	{
		for (item in array) {
			if (Std.is(item, type)) return true;
        }
		
		return false;
    }
	
	public static function getInstanceOf(array : Array<Dynamic>, type : Class<Dynamic>) : Dynamic
	{
		for (item in array) {
			if (Std.is(item, type)) return item;
        }
		
		return null;
    }  
	
	/**
	 * Compares the 2 input arrays for likeness and returns true if they match, false if they don't. 
	 * @param arrayA
	 * @param arrayB
	 * @param matchOrder Set this flag to true to check if both arrays not only contain the same items, but they are in the same order too.
	 * @return 
	 */  
	public static function compare(arrayA : Array<Dynamic>, arrayB : Array<Dynamic>, matchOrder : Bool = false) : Bool
	{
		if (arrayA.length != arrayB.length) return false;
		var L : Int = arrayA.length;
		
		for (i in 0...L) {
			var item : Dynamic = arrayA[i];
			if (Lambda.indexOf(arrayB, item) == -1) return false;
			if (matchOrder) {
				if (item != arrayB[i]) return false;
            }
        }
		
		return true;
    }

    public function new()
    {
    }
}