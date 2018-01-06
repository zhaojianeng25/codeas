package tempest.utils
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	import tempest.common.staticdata.Access;

	/**
	 * XML解析器
	 * @author
	 */
	public class XMLAnalyser
	{
		/**
		 * 解析XML
		 * @param	xml 包含一条记录的XML
		 * @param	obj 要解析到的对象
		 * @param	attributes 可以赋值的属性映射 通过ObjectUtil.getWritableAttributes可以获取
		 */
		public static function parse(xml:XML, obj:Object, attributes:Object=null):void
		{
			if (attributes == null)
				attributes=Fun.getProperties(obj);
			var list:XMLList=xml.attributes();
			for each (var item:XML in list)
			{
				var name:String=item.name().toString();
				if (attributes.hasOwnProperty(name))
				{
					switch (attributes[name])
					{
						case "int":
						case "uint":
							obj[name]=parseInt(item);
							break;
						case "Boolean":
							obj[name]=Boolean(parseInt(item));
							break;
						case "Number":
							obj[name]=parseFloat(item);
							break;
						case "String":
							obj[name]=item;
							break;
					}
				}
			}
		}

		/**
		 * 获取映射对象
		 * @param	xml 包含一条记录的XML
		 * @param	cls 用于生成对象的类定义
		 * @param	attributes 可以赋值的属性映射 通过ObjectUtil.getWritableAttributes可以获取
		 * @return 返回解析出来的对象
		 */
		public static function getParse(xml:XML, cls:Class, attributes:Object=null):*
		{
			var obj:*=new cls();
			parse(xml, obj, attributes);
			return obj;
		}

		/**
		 * 获取映射对象数组
		 * @param	xml 包含所有对象记录的XML
		 * @param	cls 用于生成对象的类定义
		 * @return 返回解析出来的对象数组
		 */
		public static function getParseList(xml:XML, cls:Class):Array
		{
			var lsit:Array=[];
			if (xml)
			{
				var attributes:Object=Fun.getProperties(cls);
				var list:XMLList=xml.*;
				for each (var item:XML in list)
				{
					var obj:*=getParse(item, cls, attributes);
					lsit.push(obj);
				}
			}
			return lsit;
		}

		/**
		 * 序列化一组对象到XML
		 * @param list
		 * @param byOrder 属性有序
		 * @param ignoreList 忽略的属性列表
		 * @return
		 */
		public static function serializeAttributes(list:Array, byOrder:Boolean=true, ignoreList:Array=null):XML
		{
			var xml:XML=<root></root>;
			if (list != null && list.length > 0)
			{
				var className:String=getQualifiedClassName(list[0]);
				var flag:int=className.indexOf("::");
				if (flag != -1)
					className=className.substr(flag + 2);
				for each (var item:* in list)
				{
					var node:String="<" + className;
					var props:Object=Fun.getProperties(item, Access.READ_ONLY | Access.READ_WRITE);
					var prop:String;
					if (byOrder)
					{
						var temp:Object;
						var tempArr:Array=[];
						for (prop in props)
						{
							if (ignoreList && ignoreList.indexOf(prop) != -1)
								continue;
							tempArr.push(prop);
						}
						tempArr.sort();
						for each (prop in tempArr)
						{
							node+=" " + prop + "=\"" + item[prop] + "\"";
						}
					}
					else
					{
						for (prop in props)
						{
							if (ignoreList && ignoreList.indexOf(prop) != -1)
								continue;
							node+=" " + prop + "=\"" + item[prop] + "\"";
						}
					}
					node+="/>";
					xml.appendChild(new XML(node));
				}
			}
			return xml;
		}

		/**
		 * 序列化一组对象到txt
		 * @param list
		 * @param byOrder 属性有序
		 * @param ignoreList 忽略的属性列表
		 * @return
		 */
		public static function serializeAttributesToTxt(list:Array, byOrder:Boolean=true, ignoreList:Array=null):String
		{
			var str:String="";
			if (list != null && list.length > 0)
			{
				for each (var item:* in list)
				{
					var node:String="";
					var props:Object=Fun.getProperties(item, Access.READ_ONLY | Access.READ_WRITE);
					var prop:String;
					if (byOrder)
					{
						var temp:Object;
						var tempArr:Array=[];
						for (prop in props)
						{
							if (ignoreList && ignoreList.indexOf(prop) != -1)
								continue;
							tempArr.push(prop);
						}
						tempArr.sort();
						for each (prop in tempArr)
						{
							node+=(node.length > 0 ? "|" : "") + item[prop];
						}
					}
					else
					{
						for (prop in props)
						{
							if (ignoreList && ignoreList.indexOf(prop) != -1)
								continue;
							node+=(node.length > 0 ? "|" : "") + item[prop];
						}
					}
					str+=node + "\n";
				}
			}
			return str;
		}
		/**
		 * 获取对象数组
		 * @param obj
		 * @return
		 *
		 */
		public static function getObjectPropertys(obj:*, byOrder:Boolean=true, ignoreList:Array=null):Array
		{
			var props:Object=Fun.getProperties(obj, Access.READ_ONLY | Access.READ_WRITE);
			var prop:String;
			var tempArr:Array=[];
			for (prop in props)
			{
				if (ignoreList && ignoreList.indexOf(prop) != -1)
					continue;
				tempArr.push(prop);
			}
			if (byOrder)
			{
				tempArr.sort();
			}
			return tempArr;
		}
	}
}


