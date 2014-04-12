// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com    
// All rights reserved.  package core.app.operations;

import core.app.core.operations.IUndoableOperation;class AddToVectorOperation implements IUndoableOperation
{
    public var label(get, never) : String;
private var item : Dynamic;private var vector : Dynamic;  //Vector  private var index : Int;private var host : Dynamic;private var propertyName : String;public function new(item : Dynamic, vector : Dynamic, index : Int = -1, host : Dynamic = null, propertyName : String = null)
    {this.item = item;this.vector = vector;this.index = index;this.host = host;this.propertyName = propertyName;
    }public function execute() : Void{if (index == -1) {vector.push(item);
        }
        else {vector.splice(index, 0, item);
        }if (host != null && propertyName != null) {Reflect.setField(host, propertyName, vector);
        }
    }public function undo() : Void{var index : Int = vector.indexOf(item);vector.splice(index, 1);if (host != null && propertyName != null) {Reflect.setField(host, propertyName, vector);
        }
    }private function get_Label() : String{return "Add item to vector";
    }
}