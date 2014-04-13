// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.core.operations;

import core.app.core.operations.IOperation;

interface IUndoableOperation extends IOperation
{
	function undo() : Void;
}