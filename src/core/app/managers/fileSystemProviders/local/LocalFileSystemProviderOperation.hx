  // =================================================================================================    //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.managers.filesystemproviders.local;

import core.app.managers.filesystemproviders.local.EventDispatcher;
import core.app.managers.filesystemproviders.local.IFileSystemProviderOperation;
import nme.events.EventDispatcher;import nme.filesystem.File;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.IFileSystemProviderOperation;import core.app.entities.URI;import core.app.util.StringUtil;class LocalFileSystemProviderOperation extends EventDispatcher implements IFileSystemProviderOperation
{
    public var label(get, never) : String;
    public var uri(get, never) : URI;
    public var fileSystemProvider(get, never) : IFileSystemProvider;
private var _rootDirectory : File;private var _uri : URI;private var _fileSystemProvider : IFileSystemProvider;@:allow(core.app.managers.filesystemproviders.local)
    private function new(rootDirectory : File, uri : URI, fileSystemProvider : IFileSystemProvider)
    {
        super();_rootDirectory = rootDirectory;_uri = uri;_fileSystemProvider = fileSystemProvider;
    }public function execute() : Void{
    }private function get_Label() : String{return null;
    }private function get_Uri() : URI{return _uri;
    }private function get_FileSystemProvider() : IFileSystemProvider{return _fileSystemProvider;
    }
}