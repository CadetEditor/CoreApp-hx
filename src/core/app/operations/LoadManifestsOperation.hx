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

import core.app.CoreApp;import core.app.core.serialization.Deserializer;import core.app.core.serialization.Manifest;import core.app.core.serialization.Serializer;class LoadManifestsOperation extends CompoundOperation
{private var manifestsXML : FastXMLList;private var manifest : Manifest;public function new(manifestsXML : FastXMLList)
    {
        super();this.manifestsXML = manifestsXML;
    }override public function execute() : Void{manifest = new Manifest();CoreApp.resourceManager.addResource(manifest);Serializer.setDefaultManifest(manifest);Deserializer.setDefaultManifest(manifest);for (i in 0...manifestsXML.length()){var manifestNode : FastXML = manifestsXML.get(i);var url : String = Std.string(manifestNode.nodes.url.get(0).node.text.innerData());var loadManifestOperation : LoadManifestOperation = new LoadManifestOperation(url, manifest);addOperation(loadManifestOperation);
        }super.execute();
    }override private function get_Label() : String{return "Load manifests.";
    }
}