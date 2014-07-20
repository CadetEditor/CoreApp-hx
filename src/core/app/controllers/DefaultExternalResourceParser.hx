// =================================================================================================  
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package core.app.controllers;

/*
import core.app.controllers.ErrorEvent;
import core.app.controllers.Event;
import core.app.controllers.ExternalBitmapDataResource;
import core.app.controllers.ExternalMP3Resource;
import core.app.controllers.ExternalXMLResource;
import core.app.controllers.FactoryResource;
import core.app.controllers.IExternalResource;
import core.app.controllers.IExternalResourceParser;
import core.app.controllers.IFileSystemProvider;
import core.app.controllers.IReadFileOperation;
import core.app.controllers.IResource;
import core.app.controllers.Loader;
import core.app.controllers.LoaderContext;
import core.app.controllers.LoaderInfo;
import core.app.controllers.ResourceManager;
import core.app.controllers.URI;
*/
import flash.errors.Error;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.ByteArray;
import core.app.core.managers.filesystemproviders.IFileSystemProvider;
import core.app.core.managers.filesystemproviders.operations.IReadFileOperation;
import core.app.entities.URI;
import core.app.managers.ResourceManager;
import core.app.resources.ExternalBitmapDataResource;
import core.app.resources.ExternalMP3Resource;
import core.app.resources.ExternalXMLResource;
import core.app.resources.FactoryResource;
import core.app.resources.IExternalResource;
import core.app.resources.IResource;
//import core.app.util.IntrospectionUtil;
import core.app.util.swfclassexplorer.SwfClassExplorer;

class DefaultExternalResourceParser implements IExternalResourceParser
{
	private var uri : URI;
	private var resourceManager : ResourceManager;
	private var loader : Loader;
	private var swfResources : Array<Dynamic>;
	private var bytes : ByteArray;
		
	public function new()
    {
		swfResources = [];
    }
	
	public function parse(uri : URI, assetsURI : URI, resourceManager : ResourceManager, fileSystemProvider : IFileSystemProvider) : Array<Dynamic>
	{
		this.uri = uri;
		this.resourceManager = resourceManager;
		var extension : String = uri.getExtension(true);  
		//var resourceID:String = uri.getFilename(true);    
		//var resourceID:String = uri.path;  
		var resourceID : String = uri.path;
		if (resourceID.indexOf(assetsURI.path) != -1) {
			resourceID = StringTools.replace(resourceID, assetsURI.path, "");
        }
		
		var resource : IExternalResource;

        switch (extension)
        {
			case "png", "jpg":
				resource = new ExternalBitmapDataResource(resourceID, uri);
				resourceManager.addResource(resource);
				return [resource];
			
			case "swf":
				var readFileOperation : IReadFileOperation = fileSystemProvider.readFile(uri);
				readFileOperation.addEventListener(ErrorEvent.ERROR, readSWFFileErrorHandler);
				readFileOperation.addEventListener(Event.COMPLETE, readSWFFileCompleteHandler);
				readFileOperation.execute();
				swfResources = [];
				return swfResources;
			
			case "xml":
				resource = new ExternalXMLResource(resourceID, uri);
				resourceManager.addResource(resource);
				return [resource];
			
			case "mp3":
				resource = new ExternalMP3Resource(resourceID, uri);
				resourceManager.addResource(resource);
				return [resource];
        }
		
		return null;
    }
	
	private function readSWFFileErrorHandler(event : ErrorEvent) : Void
	{
		var readFileOperation : IReadFileOperation = cast((event.target), IReadFileOperation);
		throw (new Error("Error while reading SWF file in asset directory : " + readFileOperation.uri.path));
    }
	
	private function readSWFFileCompleteHandler(event : Event) : Void
	{
		var readFileOperation : IReadFileOperation = cast((event.target), IReadFileOperation);
		var loader : Loader = new Loader();
		bytes = readFileOperation.bytes;
		var context : LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
		
		//TODO: needs to be resolved
		//if (context.exists("allowCodeImport")) {
			//Reflect.setField(context, "allowCodeImport", true);
        //}
		
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadSWFCompleteHandler);
		loader.loadBytes(readFileOperation.bytes, context);
    }
	
	//TODO: needs to be resolved
	private function loadSWFCompleteHandler(event : Event) : Void
	{
		var loaderInfo : LoaderInfo = cast((event.target), LoaderInfo);
		var resourceIDPrefix : String = uri.getFilename(false) + "/"; 
		bytes.position = 0;
		var classPaths : Array<String> = SwfClassExplorer.getClassNames(bytes);
		for (classPath in classPaths) {
			//TODO: needs to be resolved
			var type : Class<Dynamic> = null;// cast((loaderInfo.applicationDomain.getDefinition(classPath)), Class);
			var resourceID : String = resourceIDPrefix + classPath;
			var resource : IResource;
		/*	
			if (IntrospectionUtil.doesTypeExtend(type, DisplayObject)) {
				resource = new FactoryResource(type, classPath);
            }
            else if (IntrospectionUtil.doesTypeExtend(type, BitmapData)) {
				resource = new FactoryResource(type, classPath, null, [0, 0]);
            }
			
			if (resource != null) {
				swfResources.push(resource);resourceManager.addResource(resource);
            }
			*/
        }
    }
}