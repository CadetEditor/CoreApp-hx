// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.managers.filesystemproviders.local;

import nme.filesystem.File;
import core.app.entities.URI;
import core.app.util.StringUtil;

class FileSystemUtil
{
	public function new()
    {
    }
	
	public static function uriToFilePath(uri : URI, rootDirectory : File) : String
	{
		var localURI : URI = uri.subpath(1);
		if (localURI.path == "" || localURI.path == "/") return rootDirectory.nativePath;		
		// If the root directory path is already present in the localURI, don't add it again at the end.		
		var localPath : String = localURI.path; var rootPath : String = rootDirectory.url;
		rootPath = rootPath.replace("file://", "");
		var index : Int = localPath.indexOf(rootPath);
		if (index != -1) return localPath;
		if (localPath.charAt(0) == "/") localPath = localPath.substr(1);
		return rootDirectory.nativePath + "/" + localPath;
    }
	
	public static function fileToURI(file : File, rootDirectory : File, fileSystemProviderID : String) : URI
	{
		var uriPath : String = file.nativePath.replace(rootDirectory.nativePath, "");
		if (uriPath.charAt(0) == "\\") uriPath = uriPath.substr(1);
		if (uriPath.charAt(0) == "/")  uriPath = uriPath.substr(1);
		uriPath = StringTools.replaceAll(uriPath, "\\", "/");
		if (file.isDirectory) uriPath += "/";
		var resultPath : String = fileSystemProviderID + "/"; // Prepend FileSystemProvider's id to uri  
		if (uriPath != "/") resultPath += uriPath;
		return new URI(resultPath);
    }
}