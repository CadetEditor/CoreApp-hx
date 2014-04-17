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

/*
import core.app.resources.BitmapData;
import core.app.resources.Loader;
import core.app.resources.Matrix;
*/
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.geom.Matrix;
import flash.utils.ByteArray;
import core.app.entities.URI;

class ExternalBitmapDataResource extends AbstractExternalResource
{
    public var icon(get, never) : BitmapData;
	private var loader : Loader;
	private var bitmapData : BitmapData;
	private var iconBitmapData : BitmapData;
	
	public function new(id : String, uri : URI)
    {
		super(id, uri); 
		type = BitmapData;
		iconBitmapData = new BitmapData(26, 26, false, 0xFF00FF);
    }
	
	override public function unload() : Void
	{
		if (isLoaded) {
			loader.unload();
			bitmapData.dispose();
        }
		super.unload();
    }
	
	override private function parseBytes(bytes : ByteArray) : Void
	{
		loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
		loader.loadBytes(bytes);
    }
	
	private function loadCompleteHandler(event : Event) : Void
	{
		bitmapData = cast((loader.content), Bitmap).bitmapData;
		var m : Matrix = new Matrix();
		m.scale(iconBitmapData.width / bitmapData.width, iconBitmapData.height / bitmapData.height);
		iconBitmapData.draw(bitmapData, m);
		isLoading = false; isLoaded = true;
		dispatchEvent(new Event(Event.COMPLETE));
    }
	
	override public function getInstance() : Dynamic
	{
		return bitmapData;
    }
	
	private function get_Icon() : BitmapData
	{
		load();
		return iconBitmapData;
    }
}