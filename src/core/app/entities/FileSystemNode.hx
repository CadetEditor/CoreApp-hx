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

import core.app.entities.TreeNode;
import core.app.entities.URI;
class FileSystemNode extends TreeNode
{
    public var path(get, set) : String;
    public var filename(get, never) : String;
    public var extension(get, never) : String;
    public var uri(get, never) : URI;
    public var isPopulated(get, set) : Bool;
	private var _path : String;
	private var _isPopulated : Bool;
	
	public function new()
    {
        super();
    }
	
	override private function set_data(value : Dynamic) : Dynamic
	{
		try { 
			path = cast(value, String);
		} catch (e:Dynamic) {
			path = null;
		}
        return value;
    }
	
	override private function get_data() : Dynamic {
		return path;
    }
	
	private function set_path(value : String) : String
	{
		_path = value;
        return value;
    }
	
	private function get_path() : String
	{
		return _path;
    }
	
	private function get_filename() : String
	{
		return uri.getFilename();
    }
	
	private function get_extension() : String
	{
		return uri.getExtension(true);
    }
	
	private function get_uri() : URI
	{
		return new URI(_path);
    }
	
	private function set_isPopulated(value : Bool) : Bool
	{
		_isPopulated = value;
        return value;
    }
	
	private function get_isPopulated() : Bool
	{
		return _isPopulated;
    }
	
	public function getChildWithPath(value : String, recursive : Bool = false) : FileSystemNode
	{
		return try cast(getChildWithData(value, recursive), FileSystemNode) catch(e:Dynamic) null;
    }
}