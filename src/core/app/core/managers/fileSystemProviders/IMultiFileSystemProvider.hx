// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.core.managers.filesystemproviders;

import core.app.core.managers.filesystemproviders.FileSystemNode;
import core.app.entities.FileSystemNode;import core.app.entities.URI;interface IMultiFileSystemProvider extends IFileSystemProvider
{
    var fileSystem(get, never) : FileSystemNode;
function registerFileSystemProvider(provider : IFileSystemProvider, visible : Bool = true) : Void;function getFileSystemProviderForURI(uri : URI) : IFileSystemProvider;
}