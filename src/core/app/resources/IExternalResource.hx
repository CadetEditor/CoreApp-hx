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

import core.app.resources.IEventDispatcher;
import nme.events.IEventDispatcher;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.entities.URI;interface IExternalResource extends IFactoryResource extends IEventDispatcher
{
function getIsLoaded() : Bool;function getIsLoading() : Bool;function setFileSystemProvider(value : IFileSystemProvider) : Void;function getUri() : URI;function load() : Void;function unload() : Void;
}