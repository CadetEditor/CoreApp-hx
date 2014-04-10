  // =================================================================================================    //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.util.swfclassexplorer.data;

class MultiName extends AbcQName
{public var nsset : Array<Dynamic>;public function new(nsset : Array<Dynamic>, localName : String)
    {super(localName);this.nsset = nsset;
    }
}