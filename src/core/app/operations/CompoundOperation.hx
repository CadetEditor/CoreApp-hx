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

import core.app.operations.ErrorEvent;
import core.app.operations.IOperation;
import core.app.operations.PropertyChangeEvent;
import nme.events.ErrorEvent;
import nme.events.Event;
import nme.events.EventDispatcher;
import core.events.PropertyChangeEvent;
import core.app.core.operations.IAsynchronousOperation;
import core.app.core.operations.IOperation;
import core.app.events.OperationProgressEvent;
import core.app.util.AsynchronousUtil;

@:meta(Event(type="core.app.events.OperationProgressEvent",name="progress"))
@:meta(Event(type="flash.events.Event",name="complete"))
@:meta(Event(type="flash.events.ErrorEvent",name="error"))
/**
* This Operation allows multiple Operations to be treated as one. This operation will 'execute()' its
* children Operations in order - and calculates the overall progress based upon how many operations
* have completed.
* 
* As a CompoundOperation is itself an Operation, you could have CompoundOperations within CompoundOperations.
* @author Jonathan
* 
*/  
  
class CompoundOperation extends EventDispatcher implements IAsynchronousOperation
{
    private var currentIndex(get, never) : Int;
    public var label(get, set) : String;
	public var operations : Array<Dynamic>;
	private var _label : String = "Compound Operation";
	private var _customLabelSet : Bool = false;
	private var currentOperation : IOperation;
	
	public function new()
    {
        super();
		operations = [];
    }
	
	private function get_CurrentIndex() : Int
	{
		return Lambda.indexOf(operations, currentOperation);
    }
	
	public function addOperation(operation : IOperation) : Void
	{
		operations.push(operation);
    }
	
	public function execute() : Void
	{
		if (operations.length == 0) {
			AsynchronousUtil.dispatchLater(this, new Event(Event.COMPLETE));
			return;
        }
		update();
    }
	
	private function update() : Void
	{
		if (currentIndex == (operations.length - 1) || operations.length == 0) {
			dispatchEvent(new Event(Event.COMPLETE));
			return;
        }
		
		currentOperation = operations[currentIndex + 1];
		if (Std.is(currentOperation, IAsynchronousOperation)) {
			cast((currentOperation), IAsynchronousOperation).addEventListener(Event.COMPLETE, operationCompleteHandler);
			cast((currentOperation), IAsynchronousOperation).addEventListener(OperationProgressEvent.PROGRESS, operationProgressHandler);
			cast((currentOperation), IAsynchronousOperation).addEventListener(ErrorEvent.ERROR, operationErrorHandler);updateLabel();  
			//trace("Compound Operation. Executing child operation : " + currentOperation.label);  
			currentOperation.execute();
        }
        else {  
			//trace("Compound Operation. Executing child operation : " + currentOperation.label);  
			currentOperation.execute();update();
        }
    }
	
	private function operationErrorHandler(event : ErrorEvent) : Void
	{
		dispatchEvent(event);
    }
	
	private function operationProgressHandler(event : OperationProgressEvent) : Void
	{
		updateLabel();
		var progressPerOperation : Float = 1 / operations.length;
		var index : Int = Lambda.indexOf(operations, event.target);
		var progress : Float = (index * progressPerOperation) + (event.progress * progressPerOperation);
		dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, progress));
    }
	
	private function operationCompleteHandler(event : Event) : Void
	{
		var operation : IAsynchronousOperation = cast((event.target), IAsynchronousOperation);
		operation.removeEventListener(Event.COMPLETE, operationCompleteHandler);
		operation.removeEventListener(OperationProgressEvent.PROGRESS, operationProgressHandler);
		operation.removeEventListener(ErrorEvent.ERROR, operationErrorHandler);  
		//trace("Undoable Compound Operation. Child operation complete : " + operation.label);  
		update();
    }
	
	private function updateLabel() : Void
	{
		if (_customLabelSet) return;
		var oldValue : String = _label;
		if (oldValue != currentOperation.label) {
			_label = currentOperation.label;dispatchEvent(new PropertyChangeEvent("propertyChange_label", null, _label));
        }
    }
	
	private function set_Label(value : String) : String
	{
		_label = value;
		_customLabelSet = true;
		dispatchEvent(new PropertyChangeEvent("propertyChange_label", null, _label));
        return value;
    }
	
	private function get_Label() : String
	{
		return _label;
    }
}