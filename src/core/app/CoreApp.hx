// =================================================================================================  //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app;

import core.app.Dictionary;
import core.app.IMultiFileSystemProvider;
import core.app.MultiFileSystemProvider;
import core.app.ResourceManager;
import nme.utils.Dictionary;import core.app.core.managers.filesystemproviders.IMultiFileSystemProvider;import core.app.core.managers.filesystemproviders.MultiFileSystemProvider;import core.app.managers.ResourceManager;class CoreApp
{
    public static var fileSystemProvider(get, never) : IMultiFileSystemProvider;
    public static var resourceManager(get, never) : ResourceManager;
    public static var externalResourceFolderName(get, set) : String;
    public static var externalResourceControllers(get, never) : Dictionary;
    public static var initialised(get, never) : Bool;
private static var _initialised : Bool;private static var _fileSystemProvider : IMultiFileSystemProvider;private static var _resourceManager : ResourceManager;private static var _externalResourceFolderName : String = "assets/";private static var _externalResourceControllers : Dictionary;  // Getters for the managers and providers  private static function get_FileSystemProvider() : IMultiFileSystemProvider{return _fileSystemProvider;
    }private static function get_ResourceManager() : ResourceManager{return _resourceManager;
    }private static function get_ExternalResourceFolderName() : String{return _externalResourceFolderName;
    }private static function set_ExternalResourceFolderName(value : String) : String{_externalResourceFolderName = value;
        return value;
    }private static function get_ExternalResourceControllers() : Dictionary{return _externalResourceControllers;
    }private static function get_Initialised() : Bool{return _initialised;
    }public static function init() : Void{_fileSystemProvider = new MultiFileSystemProvider();_resourceManager = new ResourceManager(_fileSystemProvider);_externalResourceControllers = new Dictionary();_initialised = true;
    }

    public function new()
    {
    }
}