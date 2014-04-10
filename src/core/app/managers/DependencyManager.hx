// =================================================================================================  //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.managers;

import core.app.managers.ArrayCollection;
import core.app.managers.ArrayCollectionEvent;
import core.app.managers.DependencyNode;
import core.app.managers.Dictionary;
import nme.errors.Error;
import nme.utils.Dictionary;import core.data.ArrayCollection;import core.events.ArrayCollectionChangeKind;import core.events.ArrayCollectionEvent;class DependencyManager
{
    public var dependencyNodes(get, set) : ArrayCollection;
private var dependencyNodesTable : Dictionary;private var _dependencyNodes : ArrayCollection;public function new()
    {dependencyNodes = new ArrayCollection();
    }@:meta(Serializable())
private function set_DependencyNodes(value : ArrayCollection) : ArrayCollection{dependencyNodesTable = new Dictionary(true);if (_dependencyNodes != null) {_dependencyNodes.removeEventListener(ArrayCollectionEvent.CHANGE, dependencyNodesChangeHandler);
        }_dependencyNodes = value;if (_dependencyNodes != null) {_dependencyNodes.addEventListener(ArrayCollectionEvent.CHANGE, dependencyNodesChangeHandler);for (i in 0..._dependencyNodes.length){var node : DependencyNode = cast((_dependencyNodes.getItemAt(i)), DependencyNode);dependencyNodesTable[node.object] = node;
            }
        }
        return value;
    }private function get_DependencyNodes() : ArrayCollection{return _dependencyNodes;
    }private function dependencyNodesChangeHandler(event : ArrayCollectionEvent) : Void{var node : DependencyNode;if (event.kind == ArrayCollectionChangeKind.ADD) {dependencyNodesTable[event.item.object] = node;
        }
        else if (event.kind == ArrayCollectionChangeKind.REMOVE) {;
        }
    }public function addDependency(dependant : Dynamic, dependency : Dynamic) : Void{if (dependant == dependency) {throw (new Error("Dependant and dependency are the same object"));
        }var newDependencyNode : DependencyNode;var dependantNode : DependencyNode = Reflect.field(dependencyNodesTable, Std.string(dependant));if (dependantNode == null) {newDependencyNode = new DependencyNode(dependant);dependantNode = Reflect.setField(dependencyNodesTable, Std.string(dependant), newDependencyNode);_dependencyNodes.addItem(newDependencyNode);
        }var dependencyNode : DependencyNode = Reflect.field(dependencyNodesTable, Std.string(dependency));if (dependencyNode == null) {newDependencyNode = new DependencyNode(dependency);dependencyNode = Reflect.setField(dependencyNodesTable, Std.string(dependency), newDependencyNode);_dependencyNodes.addItem(newDependencyNode);
        }if (hasDependant(dependantNode, dependency)) {throw (new Error("Adding dependency would create a circular dependency"));return;
        }if (dependantNode.dependencies.indexOf(dependencyNode) == -1) {dependantNode.dependencies.push(dependencyNode);
        }if (dependencyNode.dependants.indexOf(dependantNode) == -1) {dependencyNode.dependants.push(dependantNode);
        }
    }public function removeDependency(dependant : Dynamic, dependency : Dynamic) : Void{if (dependant == dependency) {throw (new Error("Dependant and dependency are the same object"));
        }var dependantNode : DependencyNode = Reflect.field(dependencyNodesTable, Std.string(dependant));if (dependantNode == null) {return;
        }var dependencyNode : DependencyNode = Reflect.field(dependencyNodesTable, Std.string(dependency));if (dependencyNode == null) {return;
        }var index : Int = dependantNode.dependencies.indexOf(dependencyNode);if (index != -1) {dependantNode.dependencies.splice(index, 1);
        }index = dependencyNode.dependants.indexOf(dependantNode);if (index != -1) {dependencyNode.dependants.splice(index, 1);
        }var temp : DependencyNode;if (dependantNode.dependants.length == 0 && dependantNode.dependencies.length == 0) {temp = dependencyNodesTable[dependantNode.object];if (_dependencyNodes.contains(temp)) {_dependencyNodes.removeItem(temp);
            };
        }if (dependencyNode.dependants.length == 0 && dependencyNode.dependencies.length == 0) {temp = dependencyNodesTable[dependencyNode.object];if (_dependencyNodes.contains(temp)) {_dependencyNodes.removeItem(temp);
            };
        }
    }public function getDependencyNode(object : Dynamic) : DependencyNode{return Reflect.field(dependencyNodesTable, Std.string(object));
    }public function getDependants(dependency : Dynamic) : Array<Dynamic>{var node : DependencyNode = Reflect.field(dependencyNodesTable, Std.string(dependency));var returnArray : Array<Dynamic> = [];if (node == null)             return returnArray;for (dependantNode/* AS3HX WARNING could not determine type for var: dependantNode exp: EField(EIdent(node),dependants) type: null */ in node.dependants){returnArray.push(dependantNode.object);
        }return returnArray;
    }public function getImmediateDependencies(dependant : Dynamic) : Array<Dynamic>{var node : DependencyNode = Reflect.field(dependencyNodesTable, Std.string(dependant));var returnArray : Array<Dynamic> = [];if (node == null)             return returnArray;for (dependencyNode/* AS3HX WARNING could not determine type for var: dependencyNode exp: EField(EIdent(node),dependencies) type: null */ in node.dependencies){returnArray.push(dependencyNode.object);
        }return returnArray;
    }public function getAllDependencies(dependant : Dynamic) : Array<Dynamic>{var returnArray : Array<Dynamic> = [];_getAllDependencies(dependant, returnArray);return returnArray;
    }private function _getAllDependencies(dependant : Dynamic, returnVector : Array<Dynamic>) : Void{var node : DependencyNode = Reflect.field(dependencyNodesTable, Std.string(dependant));if (node == null)             return;for (dependencyNode/* AS3HX WARNING could not determine type for var: dependencyNode exp: EField(EIdent(node),dependencies) type: null */ in node.dependencies){if (Lambda.indexOf(returnVector, dependencyNode.object) == -1) {returnVector.push(dependencyNode.object);_getAllDependencies(dependencyNode.object, returnVector);
            }
        }
    }public function getAllDependents(dependency : Dynamic) : Array<Dynamic>{var returnArray : Array<Dynamic> = [];_getAllDependents(dependency, returnArray);return returnArray;
    }private function _getAllDependents(dependency : Dynamic, returnVector : Array<Dynamic>) : Void{var node : DependencyNode = Reflect.field(dependencyNodesTable, Std.string(dependency));if (node == null)             return;for (dependencyNode/* AS3HX WARNING could not determine type for var: dependencyNode exp: EField(EIdent(node),dependants) type: null */ in node.dependants){if (Lambda.indexOf(returnVector, dependencyNode.object) == -1) {returnVector.push(dependencyNode.object);_getAllDependencies(dependencyNode.object, returnVector);
            }
        }
    }public function getAllDependentsAndDependencies(object : Dynamic) : Array<Dynamic>{var returnArray : Array<Dynamic> = [];_getAllDependentsAndDependencies(object, returnArray);return returnArray;
    }private function _getAllDependentsAndDependencies(object : Dynamic, array : Array<Dynamic>) : Void{var node : DependencyNode = Reflect.field(dependencyNodesTable, Std.string(object));if (node == null)             return;var childNode : DependencyNode;for (childNode/* AS3HX WARNING could not determine type for var: childNode exp: EField(EIdent(node),dependants) type: null */ in node.dependants){if (Lambda.indexOf(array, childNode.object) == -1) {array.push(childNode.object);_getAllDependentsAndDependencies(childNode.object, array);
            }
        }for (childNode/* AS3HX WARNING could not determine type for var: childNode exp: EField(EIdent(node),dependencies) type: null */ in node.dependencies){if (Lambda.indexOf(array, childNode.object) == -1) {array.push(childNode.object);_getAllDependentsAndDependencies(childNode.object, array);
            }
        }
    }private function hasDependant(node : DependencyNode, obj : Dynamic) : Bool{for (dependantNode/* AS3HX WARNING could not determine type for var: dependantNode exp: EField(EIdent(node),dependants) type: null */ in node.dependants){if (dependantNode.object == obj)                 return true;var value : Bool = hasDependant(dependantNode, obj);if (value)                 return true;
        }return false;
    }
}