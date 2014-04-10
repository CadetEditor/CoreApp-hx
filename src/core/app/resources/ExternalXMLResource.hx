package core.app.resources;

import nme.events.Event;import nme.utils.ByteArray;import core.app.entities.URI;class ExternalXMLResource extends AbstractExternalResource
{private var xml : FastXML;public function new(id : String, uri : URI)
    {super(id, uri);type = FastXML;
    }override public function unload() : Void{if (isLoaded) {xml = null;
        }super.unload();
    }override private function parseBytes(bytes : ByteArray) : Void{xml = cast((bytes.readUTFBytes(bytes.length)), XML);isLoading = false;isLoaded = true;dispatchEvent(new Event(Event.COMPLETE));
    }override public function getInstance() : Dynamic{return xml;
    }
}