  // =================================================================================================    //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.util.swfclassexplorer.data;

class RecordHeader
{public var tagCode : Int;public var tagLength : Int;public function new(tag : Int, length : Int)
    {tagCode = tag;tagLength = length;
    }
}