// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.core.serialization;

import core.app.core.serialization.IResource;
import core.app.core.serialization.Namespace;
import nme.errors.Error;
import core.app.resources.IResource;class Manifest implements IResource
{private var namespaceVar : Namespace;private var classMaps : Dynamic;private var namespaceTable : Dynamic;public function new()
    {namespaceTable = { };classMaps = { };
    }public function getLabel() : String{return "Manifest";
    }public function getNamespaceForClassPath(classPath : String) : Namespace{return Reflect.field(namespaceTable, classPath);
    }public function getTypeForPrefixAndName(prefix : String, name : String) : Class<Dynamic>{var classMap : ManifestClassMap = classMaps[prefix + ":" + name];if (classMap == null) {return null;
        }return classMap.type;
    }public function parse(xml : FastXML) : Void{var prefix : String = xml.att.prefix;if (prefix == null) {throw (new Error("Missing 'prefix' attribute for manifest xml : " + xml.node.toXMLString.innerData()));return;
        }var url : String = xml.att.url;if (url == null) {throw (new Error("Missing 'url' attribute for manifest xml : " + xml.node.toXMLString.innerData()));return;
        }namespaceVar = new Namespace(prefix, url);for (i in 0...xml.nodes.classMap.length()){var classMapNode : FastXML = xml.nodes.classMap.get(i);var classMap : ManifestClassMap = new ManifestClassMap();classMap.name = classMapNode.att.name;if (classMap.name == null) {throw (new Error("Missing 'name' attribute for classMap node : " + classMapNode.node.toXMLString.innerData()));{i++;continue;
                }
            }try{classMap.classPath = classMapNode.node.attribute.innerData("class");classMap.type = cast((Type.resolveClass(classMap.classPath)), Class);
            }            catch (e : Error){trace("Warning : Could not find class for classMap node : " + classMapNode.node.toXMLString.innerData());trace("Attempting to deserialize XML containing this class will fail");{i++;continue;
                }
            }namespaceTable[classMap.classPath] = namespaceVar;classMaps[prefix + ":" + classMap.name] = classMap;
        }
    }  // Implement IResouce  public function getID() : String{return "Manifest";
    }
}class ManifestClassMap
{public var name : String;public var classPath : String;public var type : Class<Dynamic>;@:allow(core.app.core.serialization)
    private function new()
    {
    }
}