// =================================================================================================  //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.operations;

import core.app.operations.ArrayCollection;
import core.app.operations.IUndoableOperation;
import core.data.ArrayCollection;import core.app.core.operations.IUndoableOperation;  /**
	 * This Operation wraps up a call to an IList's addItem() method. You can optionally specify an index for the item to be added at,
	 * if not specified it defaults to -1, which symbolises simply adding it to the end of the array.
	 * @author Jonathan
	 * 
	 */  class AddItemOperation implements IUndoableOperation
{
    public var label(get, never) : String;
private var item : Dynamic;private var list : ArrayCollection;private var index : Int;public function new(item : Dynamic, list : ArrayCollection, index : Int = -1)
    {this.item = item;this.list = list;this.index = index;
    }public function execute() : Void{if (index == -1 || index >= list.length) {list.addItem(item);
        }
        else {list.addItemAt(item, index);
        }
    }public function undo() : Void{list.removeItemAt(list.getItemIndex(item));
    }private function get_Label() : String{return "Add item";
    }
}