// =================================================================================================  //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.core.managers.filesystemproviders;

import core.app.core.managers.filesystemproviders.ByteArray;
import core.app.core.managers.filesystemproviders.ICreateDirectoryOperation;
import core.app.core.managers.filesystemproviders.IDeleteFileOperation;
import core.app.core.managers.filesystemproviders.IDoesFileExistOperation;
import core.app.core.managers.filesystemproviders.IEventDispatcher;
import core.app.core.managers.filesystemproviders.IGetDirectoryContentsOperation;
import core.app.core.managers.filesystemproviders.IReadFileOperation;
import core.app.core.managers.filesystemproviders.ITraverseAllDirectoriesOperation;
import core.app.core.managers.filesystemproviders.ITraverseToDirectoryOperation;
import core.app.core.managers.filesystemproviders.IWriteFileOperation;
import core.app.core.managers.filesystemproviders.URI;
import nme.events.IEventDispatcher;import nme.utils.ByteArray;import core.app.core.managers.filesystemproviders.operations.ICreateDirectoryOperation;import core.app.core.managers.filesystemproviders.operations.IDeleteFileOperation;import core.app.core.managers.filesystemproviders.operations.IDoesFileExistOperation;import core.app.core.managers.filesystemproviders.operations.IGetDirectoryContentsOperation;import core.app.core.managers.filesystemproviders.operations.IReadFileOperation;import core.app.core.managers.filesystemproviders.operations.ITraverseAllDirectoriesOperation;import core.app.core.managers.filesystemproviders.operations.ITraverseToDirectoryOperation;import core.app.core.managers.filesystemproviders.operations.IWriteFileOperation;import core.app.entities.URI;@:meta(Event(type="core.app.events.FileSystemProviderEvent",name="operationBegin"))
interface IFileSystemProvider extends IEventDispatcher
{
    var id(get, never) : String;    var label(get, never) : String;
function createDirectory(uri : URI) : ICreateDirectoryOperation;function deleteFile(uri : URI) : IDeleteFileOperation;function doesFileExist(uri : URI) : IDoesFileExistOperation;function getDirectoryContents(uri : URI) : IGetDirectoryContentsOperation;function readFile(uri : URI) : IReadFileOperation;function traverseToDirectory(uri : URI) : ITraverseToDirectoryOperation;function traverseAllDirectories(uri : URI) : ITraverseAllDirectoriesOperation;function writeFile(uri : URI, data : ByteArray) : IWriteFileOperation;
}