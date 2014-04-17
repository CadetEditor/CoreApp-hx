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
import core.app.resources.ByteArray;
import core.app.resources.Event;
import core.app.resources.EventDispatcher;
import core.app.resources.IExternalResource;
import core.app.resources.IFileSystemProvider;
import core.app.resources.IReadFileOperation;
import core.app.resources.URI;
*/
import flash.errors.Error;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.ByteArray;
import core.app.core.managers.filesystemproviders.IFileSystemProvider;
import core.app.core.managers.filesystemproviders.operations.IReadFileOperation;
import core.app.entities.URI;

class AbstractExternalResource extends EventDispatcher implements IExternalResource
{
	private var id : String;
	private var _uri : URI;
	private var fileSystemProvider : IFileSystemProvider;
	private var isLoaded : Bool = false;
	private var isLoading : Bool = false;
	private var type : Class<Dynamic>;
	
	public function new(id : String, uri : URI)
    {
        super();
		this.id = id;
		_uri = uri;
    }
	
	public function getLabel() : String
	{
		return "External Resource";
    }
	
	public function load() : Void
	{
		if (_uri == null) {
			throw (new Error("No uri specified on ExternalResource"));
			return;
        }
		
		if (fileSystemProvider == null) {
			throw (new Error("No fileSystemProvider specified on ExternalResource"));
			return;
        }
		
		if (isLoading) return;
		
		if (isLoaded) {
			dispatchEvent(new Event(Event.COMPLETE));
			return;
        }
		
		isLoading = true;
		isLoaded = false;
		var operation : IReadFileOperation = fileSystemProvider.readFile(_uri);
		operation.addEventListener(Event.COMPLETE, readFileCompleteHandler);
		operation.execute();
    }
	
	public function unload() : Void
	{
		isLoaded = false;
		isLoading = false;
    }
	
	private function readFileCompleteHandler(event : Event) : Void
	{  
		// Ignore callback if we've been unloaded during load.  
		if (isLoading == false) return;
		var operation : IReadFileOperation = cast((event.target), IReadFileOperation);
		parseBytes(operation.bytes);
    }
	
	private function parseBytes(bytes : ByteArray) : Void
	{
		throw (new Error("Subclass must override this method."));
    }  
	
	// Implement IFactoryResource  
	public function getInstance() : Dynamic 
	{
		throw (new Error("Subclass must override this method."));
    }
	
	public function getUri() : URI
	{
		return _uri;
    }
	
	public function setFileSystemProvider(value : IFileSystemProvider) : Void
	{
		fileSystemProvider = value;
    }
	
	public function getIsLoaded() : Bool
	{
		return isLoaded;
    }
	
	public function getIsLoading() : Bool
	{
		return isLoading;
    }
	
	public function getID() : String
	{
		return id;
    }
	
	public function getInstanceType() : Class<Dynamic>
	{
		return type;
    }
}