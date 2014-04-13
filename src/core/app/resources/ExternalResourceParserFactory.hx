// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//   
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.resources;

import core.app.resources.FactoryResource;

class ExternalResourceParserFactory extends FactoryResource
{
    public var supportedExtensions(get, never) : Array<Dynamic>;
	private var _supportedExtensions : Array<Dynamic>;
	
	public function new(type : Class<Dynamic>, label : String, supportedExtensions : Array<Dynamic>)
    {
		super(type, label);
		_supportedExtensions = supportedExtensions;
		
		for (i in 0..._supportedExtensions.length) {
			_supportedExtensions[i] = _supportedExtensions[i].toLowerCase();
        }
    }
	
	private function get_SupportedExtensions() : Array<Dynamic> {
		return _supportedExtensions.substring();
    }
}