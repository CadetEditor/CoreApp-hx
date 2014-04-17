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

class StringUtil
{  
	/**
	 *  Removes all whitespace characters from the beginning and end
	 *  of the specified string.
	 *
	 *  @param str The String whose whitespace should be trimmed. 
	 *
	 *  @return Updated String where whitespace was removed from the 
	 *  beginning and end. 
	 */  
	
	public static function trim(str : String) : String
	{
		if (str == null) return "";
		var startIndex : Int = 0;
		while (isWhitespace(str.charAt(startIndex)))++startIndex;
		var endIndex : Int = str.length - 1;
		while (isWhitespace(str.charAt(endIndex)))--endIndex;
		if (endIndex >= startIndex) 
			return str.substring(startIndex, endIndex + 1);
        else 
			return "";
    }
	
	public static function replaceAll(str : String, pattern : String, replaceString : String) : String
	{
		while (str.indexOf(pattern) != -1) {
			str = StringTools.replace(str, pattern, replaceString);
        }
		
		return str;
    }  
	
	/**
	 *  Returns <code>true</code> if the specified string is
	 *  a single space, tab, carriage return, newline, or formfeed character.
	 *
	 *  @param str The String that is is being queried. 
	 *
	 *  @return <code>true</code> if the specified string is
	 *  a single space, tab, carriage return, newline, or formfeed character.
	 */  
	
	public static function isWhitespace(character : String) : Bool
	{
        switch (character) {
			// replaced \f with \x0C
			// https://groups.google.com/forum/#!msg/haxelang/HDQchW_fy0E/dyvaomgt1dAJ
			case " ", "\t", "\r", "\n" , "\x0C":
				return true;
			default:
				return false;
        }
    }

    public function new()
    {
    }
}