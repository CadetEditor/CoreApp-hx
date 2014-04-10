package core.app.core.managers.filesystemproviders;

import core.app.entities.URI;interface ILocalFileSystemProvider extends IFileSystemProvider
{
    var rootDirectoryURI(get, never) : URI;    var defaultDirectoryURI(get, never) : URI;

}