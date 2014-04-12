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

import nme.events.ErrorEvent;import nme.events.Event;import nme.events.EventDispatcher;import core.app.core.operations.IAsynchronousOperation;import core.app.core.operations.IUndoableOperation;import core.app.events.OperationProgressEvent;  /**

	 * This Operation allows multiple IUndoableOperations to be treated as one. This operation will 'execute()' its

	 * children Operations in order - and calculates the overall progress based upon how many operations

	 * have completed.

	 * 

	 * It is also capable of providing the same behaviour in reverse, when undo() is called.

	 * 

	 * As a UndoableCompoundOperation is itself an Operation, you could have UndoableCompoundOperation within UndoableCompoundOperation.

	 * @author Jonathan

	 * 

	 */  class UndoableCompoundOperation extends EventDispatcher implements IAsynchronousOperation implements IUndoableOperation
{
    private var currentIndex(get, never) : Int;
    public var label(get, set) : String;
public var operations : Array<Dynamic>;private var currentOperation : IUndoableOperation;private var _description : String = "Compound Operation";private var direction : Int = 1;public function new()
    {
        super();operations = [];
    }private function get_CurrentIndex() : Int{return Lambda.indexOf(operations, currentOperation);
    }public function addOperation(operation : IUndoableOperation) : Void{if (Lambda.indexOf(operations, operation) != -1)             return;operations.push(operation);
    }public function execute() : Void{direction = 1;update();
    }public function undo() : Void{direction = -1;update();
    }private function update() : Void{if (direction == 1) {if (currentIndex == operations.length - 1 || operations.length == 0) {dispatchEvent(new Event(Event.COMPLETE));return;
            }currentOperation = operations[currentIndex + 1];if (Std.is(currentOperation, IAsynchronousOperation)) {cast((currentOperation), IAsynchronousOperation).addEventListener(Event.COMPLETE, operationCompleteHandler);cast((currentOperation), IAsynchronousOperation).addEventListener(ErrorEvent.ERROR, operationErrorHandler);cast((currentOperation), IAsynchronousOperation).addEventListener(OperationProgressEvent.PROGRESS, operationProgressHandler);  //trace("Undoable Compound Operation. Executing child operation : " + currentOperation.label);  currentOperation.execute();
            }
            else {  //trace("Undoable Compound Operation. Executing child operation : " + currentOperation.label);  currentOperation.execute();update();
            }
        }
        else {if (currentIndex == -1) {dispatchEvent(new Event(Event.COMPLETE));return;
            }if (Std.is(currentOperation, IAsynchronousOperation)) {var asynchronousOperation : IAsynchronousOperation = cast((currentOperation), IAsynchronousOperation);asynchronousOperation.addEventListener(Event.COMPLETE, operationCompleteHandler);currentOperation = currentIndex == (0) ? null : operations[currentIndex - 1];  //trace("Undoable Compound Operation. Undoing child operation : " + asynchronousOperation.label);  cast((asynchronousOperation), IUndoableOperation).undo();
            }
            else {  //trace("Undoable Compound Operation. Undoing child operation : " + currentOperation.label);  currentOperation.undo();currentOperation = currentIndex == (0) ? null : operations[currentIndex - 1];update();
            }
        }
    }private function operationErrorHandler(event : ErrorEvent) : Void{dispatchEvent(event);
    }private function operationProgressHandler(event : OperationProgressEvent) : Void{var progressPerOperation : Float = 1 / operations.length;var index : Int = Lambda.indexOf(operations, event.target);var progress : Float = (index * progressPerOperation) + (event.progress * progressPerOperation);dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, progress));
    }private function operationCompleteHandler(event : Event) : Void{var operation : IAsynchronousOperation = cast((event.target), IAsynchronousOperation);operation.removeEventListener(Event.COMPLETE, operationCompleteHandler);operation.removeEventListener(ErrorEvent.ERROR, operationErrorHandler);operation.removeEventListener(OperationProgressEvent.PROGRESS, operationProgressHandler);  //trace("Undoable Compound Operation. Child operation complete : " + operation.label);  update();
    }private function set_Label(value : String) : String{_description = value;
        return value;
    }private function get_Label() : String{return _description;
    }
}