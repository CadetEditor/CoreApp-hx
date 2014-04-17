// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.managers;

/*
import core.app.managers.Event;
import core.app.managers.EventDispatcher;
import core.app.managers.IExternalResource;
import core.app.managers.IFactoryResource;
import core.app.managers.IFileSystemProvider;
import core.app.managers.IResource;
import core.app.managers.ResourceManagerEvent;
import core.app.managers.URI;
*/
import flash.errors.Error;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import core.app.core.managers.filesystemproviders.IFileSystemProvider;
import core.app.entities.URI;
import core.app.events.ResourceManagerEvent;
import core.app.resources.IExternalResource;
import core.app.resources.IFactoryResource;
import core.app.resources.IResource;
//import core.app.util.IntrospectionUtil;

@:meta(Event(type="core.app.events.ResourceManagerEvent",name="resourceAdded"))
class ResourceManager extends EventDispatcher
{
	private var fileSystemProvider : IFileSystemProvider;
	private var resourceTable : Dynamic;
	private var allResources : Array<IResource>;
	private var factoryInstanceTable : Dictionary;
	private var bindingsByResourceID : Dynamic;
	private var bindingsByHost : Dictionary;
	public function new(fileSystemProvider : IFileSystemProvider = null)
    {
        super();
		this.fileSystemProvider = fileSystemProvider;
		resourceTable = { };
		allResources = new Array<IResource>();
		factoryInstanceTable = new Dictionary(true);
		bindingsByResourceID = { };
		bindingsByHost = new Dictionary(true);
    }
	
	public function dispose() : Void
	{
		fileSystemProvider = null;
		resourceTable = null;
		allResources = null;
		factoryInstanceTable = null;
		bindingsByResourceID = null;
		bindingsByHost = null;
    }
	
	public function addResource(resource : IResource) : Void
	{
		resourceTable[resource.getID()] = resource;
		if (Std.is(resource, IExternalResource)) {
			cast((resource), IExternalResource).setFileSystemProvider(fileSystemProvider);
        }
        else if (Std.is(resource, IFactoryResource)) {  
			// TODO JP Do we really need to be able to get a factory back from a resource?    
			//factoryInstanceTable[IFactoryResource(resource).getInstance()] = resource;  
        }
		allResources.push(resource);
		var bindingsForThisResourceID : Array<ResourceBinding> = bindingsByResourceID[resource.getID()];
		if (bindingsForThisResourceID != null) {
			for (binding in bindingsForThisResourceID) {
				if (Std.is(resource, IExternalResource)) {
					var externalResource : IExternalResource = cast((resource), IExternalResource);
					if (externalResource.getIsLoaded()) {
						binding.host[binding.property] = externalResource.getInstance();
						return;
                    }
					if (externalResource.getIsLoading() == false) {
						externalResource.addEventListener(Event.COMPLETE, loadResourceCompleteHandler);
						externalResource.load();
                    }
                }
                else if (Std.is(resource, IFactoryResource)) {
					binding.host[binding.property] = cast((resource), IFactoryResource).getInstance();
                }
            }
        }
		dispatchEvent(new ResourceManagerEvent(ResourceManagerEvent.RESOURCE_ADDED, resource));
    }
	
	public function removeResource(resource : IResource, removeBindings : Bool = true) : Void
	{
		var index : Int = Lambda.indexOf(allResources, resource);
		if (index == -1) {
			throw (new Error("Resource has not been added"));
			return;
        }
		if (Std.is(resource, IFactoryResource)) {
			// TODO delete not supported
			//delete factoryInstanceTable[IFactoryResource(resource).getInstance()];
        }
		
		resourceTable[resource.getID()] = null;
		allResources.splice(index, 1);
		var bindingsForThisResourceID : Array<ResourceBinding> = bindingsByResourceID[resource.getID()];
		var binding : ResourceBinding;
		if (removeBindings) {
			while (bindingsForThisResourceID.length > 0) {
				binding = bindingsForThisResourceID[0];unbindResource(binding.host, binding.property);
            }
        }
        else {  
			// Simply null any properties bound to this resource. Binding remains.  
			for (binding in bindingsForThisResourceID) {
				binding.host[binding.property] = null;
            }
        }
		if (Std.is(resource, IExternalResource)) {
			cast((resource), IExternalResource).unload();
        }
    }
	
	public function getResourcesByURI(uri : URI) : Array<IResource> {
		var output : Array<IResource> = new Array<IResource>();
		for (resource in allResources) {
			if (Std.is(resource, IExternalResource)) {
				var resourceURI : URI = cast((resource), IExternalResource).getUri();
				var projectAssetsPath : String = uri.path;  
				//TODO: currently only works for nesting one level deep 
				//WHY GET PARENT..?    
				//var resourceAssetsPath:String = resourceURI.getParentURI().path;  
				var resourceAssetsPath : String = resourceURI.path;
				if (projectAssetsPath == resourceAssetsPath) {
					output.push(resource);
                }  
				//trace("projectAssetsPath "+projectAssetsPath+" resourceAssetsPath "+resourceAssetsPath);  
            }
        }
		return output;
    }
	
	public function getAllResources() : Array<IResource>
	{
		return allResources;
    }
	
	public function getResourceByID(id : String) : IResource
	{
		return Reflect.field(resourceTable, id);
    }
	
	public function getResourcesOfType(type : Class<Dynamic>) : Array<IResource>
	{
		var output : Array<IResource> = new Array<IResource>();
		for (resource in allResources) {
			if (IntrospectionUtil.isRelatedTo(resource, type)) {
				output.push(resource);
            }
        }
		return output;
    }
	
	public function getFactoriesForType(type : Class<Dynamic>) : Array<IFactoryResource>
	{
		var output : Array<IFactoryResource> = new Array<IFactoryResource>();
		for (resource in allResources) {
			var resourceFactory : IFactoryResource = try cast(resource, IFactoryResource) catch (e:Dynamic) null;
			if (resourceFactory == null) continue;
			if (IntrospectionUtil.isRelatedTo(resourceFactory.getInstanceType(), type)) {
				output.push(resourceFactory);
            }
        }
		return output;
    }  
	
	/////////////////////////////////////////    
	// Binding functions    
	/////////////////////////////////////////  
	
	public function bindResource(resourceID : String, host : Dynamic, property : String) : Void
	{
		var resource : IResource = getResourceByID(resourceID);
		if (resource != null && Std.is(resource, IFactoryResource) == false) {
			throw (new Error("Resource with this ID is not an IFactoryResource"));
			return;
        }
		
		unbindResource(host, property); 
		var resourceBinding : ResourceBinding = new ResourceBinding(resourceID, host, property);
		var bindingsForThisResourceID : Array<ResourceBinding> = Reflect.field(bindingsByResourceID, resourceID);
		if (bindingsForThisResourceID == null) {
			bindingsForThisResourceID = Reflect.setField(bindingsByResourceID, resourceID, new Array<ResourceBinding>());
        }
		bindingsForThisResourceID.push(resourceBinding);
		var bindingsForThisHost : Array<ResourceBinding> = Reflect.field(bindingsByHost, Std.string(host));
		if (bindingsForThisHost == null) {
			bindingsForThisHost = Reflect.setField(bindingsByHost, Std.string(host), new Array<ResourceBinding>());
        }		
		bindingsForThisHost.push(resourceBinding);
		resourceBinding.bindingsForThisHost = bindingsForThisHost; 
		resourceBinding.bindingsForThisResourceID = bindingsForThisResourceID;
		if (resource == null) {
			Reflect.setField(host, property, null);
			return;
        }
		if (Std.is(resource, IExternalResource)) {
			var externalResource : IExternalResource = cast((resource), IExternalResource);
			if (externalResource.getIsLoaded()) {
				Reflect.setField(host, property, externalResource.getInstance());
				return;
            }
			if (externalResource.getIsLoading() == false) {
				externalResource.addEventListener(Event.COMPLETE, loadResourceCompleteHandler);
				externalResource.load();
            }
        }
        else if (Std.is(resource, IFactoryResource)) {
			Reflect.setField(host, property, cast((resource), IFactoryResource).getInstance());
        }
    }
	
	public function unbindResource(host : Dynamic, property : String) : Void
	{
		var bindingsForThisHost : Array<ResourceBinding> = Reflect.field(bindingsByHost, Std.string(host));
		if (bindingsForThisHost == null) return;
		var binding : ResourceBinding;
		for (i in 0...bindingsForThisHost.length) {
			var currentBinding : ResourceBinding = bindingsForThisHost[i];
			if (currentBinding.property == property) {
				binding = currentBinding;
				break;
            }
        }
		if (binding == null) return;
		binding.bindingsForThisHost.splice(binding.bindingsForThisHost.indexOf(binding), 1);
		if (binding.bindingsForThisHost.length == 0) {
			// TODO delete not supported
			//delete bindingsByHost[host];
        }
		binding.bindingsForThisResourceID.splice(binding.bindingsForThisResourceID.indexOf(binding), 1);
		if (binding.bindingsForThisResourceID.length == 0) {
			bindingsByResourceID[binding.resourceID] = null;
        }
		Reflect.setField(host, property, null);
    }
	
	public function getResourceIDForBinding(host : Dynamic, property : String) : String
	{
		var bindingsForThisHost : Array<ResourceBinding> = Reflect.field(bindingsByHost, Std.string(host));
		if (bindingsForThisHost == null) return null;
		for (binding in bindingsForThisHost) { 
			if (binding.property == property) {
				return binding.resourceID;
            }
        }
		return null;
    }
	
	public function getFactoryForInstance(instance : Dynamic) : IFactoryResource
	{
		return Reflect.field(factoryInstanceTable, Std.string(instance));
    }  
	
	///////////////////////////////////////////////////    
	// Private    
	///////////////////////////////////////////////////  
	private function loadResourceCompleteHandler(event : Event) : Void
	{
		var externalResource : IExternalResource = cast((event.target), IExternalResource);
		factoryInstanceTable[externalResource.getInstance()] = externalResource;
		var resourceBindings : Array<ResourceBinding> = bindingsByResourceID[externalResource.getID()];
		for (resourceBinding in resourceBindings) {
			resourceBinding.host[resourceBinding.property] = externalResource.getInstance();
        }
    }
}

class ResourceBinding
{
	public var resourceID : String;
	public var host : Dynamic;
	public var property : String;
	public var bindingsForThisResourceID : Array<ResourceBinding>;
	public var bindingsForThisHost : Array<ResourceBinding>;
	
	@:allow(core.app.managers)
    private function new(resourceID : String, host : Dynamic, property : String)
    {
		this.resourceID = resourceID;
		this.host = host;
		this.property = property;
    }
}