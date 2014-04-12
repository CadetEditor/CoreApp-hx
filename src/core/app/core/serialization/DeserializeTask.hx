// =================================================================================================  
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.core.serialization;

class DeserializeTask
{public var xml : FastXML;public var type : Class<Dynamic>;public var parentTask : DeserializeTask;public var instance : Dynamic;public var name : String;public var id : String;public var next : DeserializeTask;public var deserializeFunc : Function;public function new()
    {
    }
}