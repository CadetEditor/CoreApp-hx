// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.util.swfclassexplorer.data;

class Traits
{
	public var name : AbcQName;
	public var baseName : AbcQName;
	public var flags : Int;
	public var interfaces : Array<Dynamic>;
	
	public function toString() : String {
		return Std.string(name);
    }

    public function new()
    {
    }
}