package core.app.util;

class IntrospectionUtil
{
	static private var descriptionCache : Dictionary = new Dictionary();
		
	/**
	 * Returns the fully qualified class path for an object.
	 * Eg MovieClip would be returned as flash.display.MovieClip 
	 * @param object
	 * @return 
	 * 
	 */		
	static public function getClassPath(object : Dynamic): String
	{
		return flash.utils.getQualifiedClassName(object).replace("::",".");
	}
	
	static public function isRelatedTo(objectA : Dynamic, objectB : Dynamic): Boolean
	{
		var typeA : Class = getType(objectA);
		var typeB : Class = getType(objectB);
		
		if (typeA == typeB) return true;
		if (doesTypeExtend(typeA, typeB)) return true;
		if (doesTypeImplement(typeA, typeB)) return true;
		return false;
	}
	
	static public function getClassName(object : Dynamic ) : String
	{
		var classPath : String = flash.utils.getQualifiedClassName(object).replace("::",".");
		if (classPath.indexOf(".") == -1) return classPath;
		var split : Array = classPath.split( "." );
		return split[split.length-1];
	}
	
	static public function getType(object : Dynamic): Class
	{
		var classPath : String = getClassPath(object);
		
		if (classPath == "null") return Xml;
		
		return Class(getDefinitionByName(classPath));
	}
	
	static public function doesTypeExtend(type : Class, superType : Class ): Bool
	{
		var description : Xml = getDescription(type);
		var superDescription : Xml = getDescription(superType);
		return description.factory.extendsClass.(@type == superDescription.@name).length() > 0;
	}
	
	static public function doesTypeImplement(type : Class, interfaceType : Class ) : Bool
	{
		if (type == interfaceType) return true;
		var description : Xml = getDescription(type);
		var superDescription : Xml = getDescription(interfaceType);
		return description.factory.implementsInterface.(@type == superDescription.@name).length() > 0;
	}
	
	static public function getSuperType(object : Dynamic) : Class
	{
		var description : Xml = getDescription(object);
		return Class(getDefinitionByName(String(description.extendsClass[0].@type)));
	}
	
	static public function getDistanceToSuperType(object : Dynamic, superType : Class ) : Int
	{
		var superClassPath : String = getDescription(superType).@name;		
		var description : Xml  = getDescription(object);
		if (description.@name == superClassPath) return 0;
		var i : Int
		for (i in 0...description.implementsInterface.length()){
			if ( description.implementsInterface[i].@type == superClassPath ){
				return 0;
			}
		}
		for (i in 0...description.extendsClass.length()){
			if (description.extendsClass[i].@type == superClassPath){
				return i+1;
			}
		}
		return -1;
	}
	
	public static function getPropertyMetadata(obj : Dynamic, propertyName : String ) : XMLList
	{
		var description : Xml = getPropertyDescription(obj, propertyName);
		return description.metadata;
	}
	
	public static function getPropertyMetadataByName(obj : Dynamic, propertyName : String, name : String) : Xml
	{
		var metadata : XMLList = getPropertyMetadata(obj, propertyName);
		if (!metadata) return null;
		return metadata.(@name==name)[0];
	}
	
	public static function getPropertyMetadataByNameAndKey(obj : Dynamic, propertyName : String, name : String, key : String ) : String
	{
		var metadataNode : Xml = getPropertyMetadataByName(obj, propertyName, name);
		if (!metadataNode) return null;
		return String(metadataNode.arg.(@key==key)[0].@value);
	}
	
	public static function getMetadata(obj : Dynamic) : XMLList
	{
		var description : Xml = getDescription(obj);
		return description.factory[0].metadata;
	}
	
	public static function getMetadataByName(obj : Dynamic, name : String ) : Xml
	{
		var metadata : XMLList = getMetadata(obj);
		if (!metadata) return null;
		return metadata.(@name==name)[0];
	}
	
	public static function getMetadataByNameAndKey(obj : Dynamic, name : String, key : String ) : String
	{
		var metadataNode : Xml = getMetadataByName(obj, name);
		if (!metadataNode) return null;
		return metadataNode.arg.(@key==key)[0].@value;
	}
	
	public static function getPropertyDescription(obj : Dynamic, propertyName : String ) : Xml
	{
		var description : Xml = getDescription(obj);
		var propertyNode : Xml = description.factory.accessor.(@name==propertyName)[0];
		
		if (!propertyNode){
			propertyNode = description.factory.variable.(@name==propertyName)[0];
		}
		
		return propertyNode;
	}
	
	/**
	 * It is preferable to use this function instead of flash.utils.describeType as it will
	 * cache returned values so further calls will execute much faster. This is particularly
	 * important when many descriptions may be needed, such as serialization or filtering . 
	 * @param obj
	 * @return 
	 * 
	 */		
	public static function getDescription(obj : Dynamic) : Xml
	{
		var type:Class;
		if (obj is Class)
		{
			type = obj as Class
		}
		else
		{
			var description : Xml = describeType(obj);
			var classPath : String = String(description.@name).replace( "::", "." );
			
			//TODO: XML has a description.@name of "null"?
			if (classPath == "null") {
				type = Xml;
			} else {
				type = getDefinitionByName(classPath) as Class;
			}
		}
		
		if (descriptionCache[type] == null){
			descriptionCache[type] = describeType(type);
		}
		return descriptionCache[type];
	}
	
	/**
	 * Returns the type of the property on the host.
	 * Use this method when a property on an object is set to null, but you'd still like to know
	 * the type specified for that property.
	 * 
	 */
	static public function getPropertyType(host : Dynamic, propertyName : String ) : Class
	{
		var propertyDescription : Xml = getPropertyDescription(host, propertyName);
		var classPath : String = String(propertyDescription.@type);
		classPath = classPath.replace("::", ".");
		return Class(getDefinitionByName(classPath));
	}
	
}