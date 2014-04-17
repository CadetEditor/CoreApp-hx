/*
The MIT License

Copyright (c) 2008 Flassari.is

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/  

package core.app.util.swfclassexplorer;

//import core.app.util.swfclassexplorer.Traits;
import flash.utils.ByteArray;
import core.app.util.swfclassexplorer.data.Traits; 

/**
* Inspects a swf for any classes tagged for export.
*/  
class SwfClassExplorer
{  
/**
* Returns an Array of class names found in the supplied ByteArray.
* @param	bytes	The ByteArray of the AS3 swf to look in.
* @return	Returns an Array of class names found.
*/  
	public static function getClassNames(swfBytes : ByteArray) : Array<String>
	{
		var ret : Array<String> = new Array<String>();
		for (abcTag/* AS3HX WARNING could not determine type for var: abcTag exp: ECall(EField(EIdent(AbcExtractor),getAbcTags),[EIdent(swfBytes)]) type: null */ in AbcExtractor.getAbcTags(swfBytes)) {
			for (trait/* AS3HX WARNING could not determine type for var: trait exp: EField(EIdent(abcTag),instances) type: null */ in abcTag.instances) {
				ret.push(Std.string(trait).replace(":", "."));
			}
		}
		return ret;
    } 
	
	/**
	 * Returns an Array of Traits instances found in the supplied ByteArray.
	 * @param	bytes	The ByteArray of the AS3 swf to look in.
	 * @return	Returns an Array of traits instances found.
	 */  
	
	public static function getTraits(swfBytes : ByteArray) : Array<Dynamic>
	{
		return AbcExtractor.getAbcTags(swfBytes);
    }

    public function new()
    {
    }
}