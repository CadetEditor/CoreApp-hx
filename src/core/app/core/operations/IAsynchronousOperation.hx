// =================================================================================================  //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.core.operations;

import core.app.core.operations.IEventDispatcher;
import core.app.core.operations.IOperation;
import nme.events.IEventDispatcher;import core.app.core.operations.IOperation;@:meta(Event(type="core.app.events.OperationProgressEvent",name="progress"))
@:meta(Event(type="flash.events.Event",name="complete"))
@:meta(Event(type="flash.events.ErrorEvent",name="error"))
  /**
	 * This interface extends the basic IOperation interface. Whereas an IOperation will be
	 * treated as synchronous, any operation implementing this will be treated asynchronously.
	 * @author Jonathan
	 * 
	 */  interface IAsynchronousOperation extends IOperation extends IEventDispatcher
{

}