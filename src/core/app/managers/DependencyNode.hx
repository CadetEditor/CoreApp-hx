// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.managers;

class DependencyNode
{
	@:meta(Serializable())
	public var object : Dynamic;  
	// List of objects that depend on this object  
	@:meta(Serializable())
	public var dependants : Array<Dynamic>;  
	// List of objects that this object depends on  
	@:meta(Serializable())
	public var dependencies : Array<Dynamic>;
	public function new(object : Dynamic = null)
    {
		this.object = object; 
		dependants = new Array<Dynamic>();
		dependencies = new Array<Dynamic>();
    }
}