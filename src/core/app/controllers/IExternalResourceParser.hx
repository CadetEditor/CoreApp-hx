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

import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.entities.URI;import core.app.managers.ResourceManager;interface IExternalResourceParser
{
// Should create a resource for the input uri, and take care of adding it to the resource manager.  
// It should return an array that contains (or will contain) all resources assocaited with this uri.  
function parse(uri : URI, assetsURI : URI, resourceManager : ResourceManager, fileSystemProvider : IFileSystemProvider) : Array<Dynamic>;
}