// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package core.app.validators;

import core.app.validators.ArrayCollection;
import core.app.validators.ArrayCollectionEvent;
import core.app.validators.CollectionValidatorEvent;
import core.data.ArrayCollection;import core.events.ArrayCollectionEvent;import core.app.events.CollectionValidatorEvent;import core.app.util.ArrayUtil;@:meta(Event(type="core.app.events.CollectionValidatorEvent",name="validItemsChanged"))
class CollectionValidator extends AbstractValidator
{
    public var collection(get, set) : ArrayCollection;
    public var validType(get, set) : Class<Dynamic>;
    public var min(get, set) : Int;
    public var max(get, set) : Int;
private var _collection : ArrayCollection;private var _validType : Class<Dynamic>;private var _min : Int;private var _max : Int;private var oldCollection : Array<Dynamic>;public function new(collection : core.data.ArrayCollection = null, validType : Class<Dynamic> = null, min : Int = 1, max : Int = Int.MAX_VALUE)
    {
        super();oldCollection = [];this.collection = collection;this.validType = validType;this.min = min;this.max = max;
    }override public function dispose() : Void{if (_collection != null) {_collection.removeEventListener(ArrayCollectionEvent.CHANGE, collectionChangeHandler);
        }_collection = null;_validType = null;super.dispose();
    }private function set_Collection(value : ArrayCollection) : ArrayCollection{if (value == _collection)             return;if (value == null) {value = new ArrayCollection();
        }if (_collection != null) {_collection.removeEventListener(ArrayCollectionEvent.CHANGE, collectionChangeHandler);
        }_collection = value;if (_collection != null) {_collection.addEventListener(ArrayCollectionEvent.CHANGE, collectionChangeHandler);
        }updateState();
        return value;
    }private function get_Collection() : ArrayCollection{return _collection;
    }private function collectionChangeHandler(event : ArrayCollectionEvent) : Void{updateState();
    }private function set_ValidType(value : Class<Dynamic>) : Class<Dynamic>{if (value == null)             value = Dynamic;_validType = value;updateState();
        return value;
    }private function get_ValidType() : Class<Dynamic>{return _validType;
    }private function set_Min(value : Int) : Int{_min = value;updateState();
        return value;
    }private function get_Min() : Int{return _min;
    }private function set_Max(value : Int) : Int{_max = value;updateState();
        return value;
    }private function get_Max() : Int{return _max;
    }public function getValidItems() : Array<Dynamic>{if (_collection == null)             return [];var validItems : Array<Dynamic> = ArrayUtil.filterByType(_collection.source, _validType);if (validItems.length < _min)             return [];if (validItems.length > _max)             return [];return validItems;
    }private function updateState() : Void{var validItems : Array<Dynamic> = getValidItems();if (validItems.length == 0) {setState(false);
        }
        else {setState(true);
        }if (ArrayUtil.compare(oldCollection, validItems) == false) {oldCollection = validItems;dispatchEvent(new CollectionValidatorEvent(CollectionValidatorEvent.VALID_ITEMS_CHANGED, validItems));
        }
    }
}