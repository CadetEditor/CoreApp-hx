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

class AbcQName
{public var localName : String;public var uri : String = "";public function new(localName : String, uri : AbcNamespace = null)
    {this.localName = localName;if (uri != null)             this.uri = uri.uri;
    }public function toString() : String{return ((uri != null && uri.length > 0)) ? uri + ":" + localName : localName;
    }
}