package core.app.resources;
/*
import core.app.resources.AbcBuilder;
import core.app.resources.AbcFile;
import core.app.resources.AbcSerializer;
import core.app.resources.IAbcBuilder;
import core.app.resources.IClassBuilder;
import core.app.resources.IPackageBuilder;
import core.app.resources.LoaderContext;
import core.app.resources.SWF;
import core.app.resources.SWFData;
import core.app.resources.Sound;
import core.app.resources.SoundClass;
import core.app.resources.TagEnd;
import core.app.resources.TagFileAttributes;
import core.app.resources.TagShowFrame;
import core.app.resources.TagSymbolClass;
import com.codeazur.as3swf.SWF;
import com.codeazur.as3swf.SWFData;
import com.codeazur.as3swf.data.SWFSymbol;
import com.codeazur.as3swf.tags.TagDefineSound;
import com.codeazur.as3swf.tags.TagDoABC;
import com.codeazur.as3swf.tags.TagEnd;
import com.codeazur.as3swf.tags.TagFileAttributes;
import com.codeazur.as3swf.tags.TagShowFrame;
import com.codeazur.as3swf.tags.TagSymbolClass;
*/
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.media.Sound;
import flash.system.LoaderContext;
import flash.utils.ByteArray;
import core.app.entities.URI;
/*
import org.as3commons.bytecode.abc.AbcFile;
import org.as3commons.bytecode.emit.IAbcBuilder;
import org.as3commons.bytecode.emit.IClassBuilder;
import org.as3commons.bytecode.emit.IPackageBuilder;
import org.as3commons.bytecode.emit.impl.AbcBuilder;
import org.as3commons.bytecode.io.AbcSerializer;
*/

class ExternalMP3Resource extends AbstractExternalResource
{
	private static inline var PACKAGENAME : String = "tmp";
	private static inline var CLASSNAME : String = "SoundClass";
	private static var QNAME : String = PACKAGENAME + "." + CLASSNAME;
	private var sound : Sound;
	
	public function new(id : String, uri : URI)
    {
		super(id, uri);
		type = Sound;
    }
	
	override public function unload() : Void
	{
		if (isLoaded) {
			sound = null;
        }
		super.unload();
    }
	
	override private function parseBytes(bytes : ByteArray) : Void
	{  
		// Wrap the MP3 with a SWF  
		var swf : ByteArray = createSWFFromMP3(bytes);  
		// Load the SWF with Loader::loadBytes()  
		var context : LoaderContext = new LoaderContext();
		context.allowCodeImport = true;
		var loader : Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
		loader.loadBytes(swf, context);
    }
	
	private function initHandler(e : Event) : Void{  
		// Get the sound class definition  
		var SoundClass : Class<Dynamic> = Type.getClass(cast((e.currentTarget), LoaderInfo).applicationDomain.getDefinition(QNAME));  
		// Instantiate the sound class  
		sound = try cast(Type.createInstance(SoundClass, []), Sound) catch(e:Dynamic) null;  
		// Play the sound    
		//sound.play();  
		isLoading = false;
		isLoaded = true;
		dispatchEvent(new Event(Event.COMPLETE));
    }  
	
	// https://gist.github.com/218226  
	private function createSWFFromMP3(mp3 : ByteArray) : ByteArray{  
		// Create an empty SWF    
		// Defaults to v10, 550x400px, 50fps, one frame (works fine for us)  
		var swf : SWF = new SWF();  
		// Add FileAttributes tag    
		// Defaults: as3 true, all other flags false (works fine for us)  
		swf.tags.push(new TagFileAttributes());  
		// Add DefineSound tag    
		// The ID is 1, all other parameters are automatically    
		// determined from the mp3 itself.  
		swf.tags.push(TagDefineSound.createWithMP3(1, mp3));  
		// Create and add DoABC tag    
		// Contains the AS3 byte code for the class definition for the embedded sound:    
		// package tmp {    
		//    public dynamic class SoundClass extends flash.media.Sound {    
		//    }    
		// }  
		var abcBuilder : IAbcBuilder = new AbcBuilder();
		var packageBuilder : IPackageBuilder = abcBuilder.definePackage(PACKAGENAME);
		var classBuilder : IClassBuilder = packageBuilder.defineClass(CLASSNAME, "flash.media.Sound");
		var abcFile : AbcFile = abcBuilder.build();
		var abcSerializer : AbcSerializer = new AbcSerializer();
		var abcBytes : ByteArray = abcSerializer.serializeAbcFile(abcFile);swf.tags.push(TagDoABC.create(abcBytes));  
		// Add SymbolClass tag    
		// Binds the sound class definition to the embedded sound  
		var symbolClass : TagSymbolClass = new TagSymbolClass();
		symbolClass.symbols.push(SWFSymbol.create(1, QNAME));
		swf.tags.push(symbolClass);  
		// Add ShowFrame tag  
		swf.tags.push(new TagShowFrame());  
		// Add End tag  
		swf.tags.push(new TagEnd());  
		// Publish the SWF  
		var swfData : SWFData = new SWFData();
		swf.publish(swfData);
		
		return swfData;
    }
	
	override public function getInstance() : Dynamic
	{
		return sound;
    }
}