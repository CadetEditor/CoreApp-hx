  // =================================================================================================    //    //	CoreApp Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package core.app.resources;

import core.app.resources.IFactoryResource;
import nme.errors.Error;
import core.app.resources.IFactoryResource;import core.app.util.IntrospectionUtil;class FactoryResource implements IFactoryResource
{
    public var icon(get, never) : Class<Dynamic>;
private var _type : Class<Dynamic>;private var _icon : Class<Dynamic>;private var _label : String;private var _constructorParams : Array<Dynamic>;public function new(type : Class<Dynamic>, label : String, icon : Class<Dynamic> = null, constructorParams : Array<Dynamic> = null)
    {_type = type;_label = label;_icon = icon;_constructorParams = constructorParams;
    }public function getLabel() : String{return _label;
    }private function get_Icon() : Class<Dynamic>{return _icon;
    }  // Implement IFactoryResource  public function getID() : String{return IntrospectionUtil.getClassName(_type);
    }public function getInstance() : Dynamic{if (_constructorParams == null) {return Type.createInstance(_type, []);
        }var p : Array<Dynamic> = _constructorParams;  // Eeeeeewwww! Yeah, I know. But no other way.  var _sw0_ = (p.length);        

        switch (_sw0_)
        {case 0:return Type.createInstance(_type, []);case 1:return Type.createInstance(_type, [p[0]]);case 2:return Type.createInstance(_type, [p[0], p[1]]);case 3:return Type.createInstance(_type, [p[0], p[1], p[2]]);case 4:return Type.createInstance(_type, [p[0], p[1], p[2], p[3]]);case 5:return Type.createInstance(_type, [p[0], p[1], p[2], p[3], p[4]]);case 6:return Type.createInstance(_type, [p[0], p[1], p[2], p[3], p[4], p[5]]);case 7:return Type.createInstance(_type, [p[0], p[1], p[2], p[3], p[4], p[5], p[6]]);case 8:return Type.createInstance(_type, [p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]]);case 9:return Type.createInstance(_type, [p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]]);
        }throw (new Error("Urgh, too many constructor params"));return null;
    }public function getInstanceType() : Class<Dynamic>{return _type;
    }
}