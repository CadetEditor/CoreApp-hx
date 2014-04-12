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

import core.app.util.swfclassexplorer.data.QName;
class ParameterizedQName extends AbcQName
{private var parameters : Array<Dynamic>;public function new(name : AbcQName, parameters : Array<Dynamic>)
    {super(name.localName);this.parameters = parameters;
    }override public function toString() : String{if (parameters.length == 0)             return Std.string(super) + " []";var s : String = Std.string(super) + " [";for (name in parameters)s += Std.string(name) + ", ";return s.substr(0, s.length - 2) + "]";
    }
}