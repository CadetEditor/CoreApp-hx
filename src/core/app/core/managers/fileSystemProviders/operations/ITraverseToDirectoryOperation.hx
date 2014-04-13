// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package core.app.core.managers.filesystemproviders.operations;

import core.app.entities.URI;
interface ITraverseToDirectoryOperation extends IFileSystemProviderOperation
{
    var contents(get, never) : Array<Dynamic>;    
	var finalURI(get, never) : URI;
}