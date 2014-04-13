// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.operations;

import core.data.ArrayCollection;
import core.app.core.operations.IUndoableOperation;

class RemoveItemOperation implements IUndoableOperation
{
    public var label(get, never) : String;
	private var item : Dynamic;
	private var list : ArrayCollection;
	private var index : Int;
	
	public function new(item : Dynamic, list : ArrayCollection)
    {
		this.item = item;
		this.list = list;
    }
	
	public function execute() : Void
	{
		index = list.getItemIndex(item);
		list.removeItemAt(index);
    }
	
	public function undo() : Void
	{
		if (index >= list.length) {
			list.addItem(item);
        } else {
			list.addItemAt(item, index);
        }
    }
	
	private function get_Label() : String
	{
		return "Remove item";
    }
}