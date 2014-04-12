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

import core.app.core.managers.filesystemproviders.operations.IAsynchronousOperation;
import core.app.core.managers.filesystemproviders.operations.IFileSystemProvider;
import core.app.core.managers.filesystemproviders.operations.URI;
import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.operations.IAsynchronousOperation;import core.app.entities.URI;@:meta(Event(type="coreApp.apps.events.FileSystemErrorEvent",name="error"))
@:meta(Event(type="flash.events.Event",name="complete"))
@:meta(Event(type="core.app.events.OperationProgressEvent",name="progress"))
interface IFileSystemProviderOperation extends IAsynchronousOperation
{
    var uri(get, never) : URI;    var fileSystemProvider(get, never) : IFileSystemProvider;

}