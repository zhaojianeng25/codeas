package tempest.utils {
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import tempest.common.staticdata.Access;

	/**
	 * 属性管理器
	 * 下标元算符（支持加法、减法、乘法、除法，特别注意：所有运算符不可同时使用）
	 * 示例：
	 *  加法
	 * [Attribute(index = "{PLAYER_FIELD_MONEY+4},{PLAYER_FIELD_MONEY+5}")] //单个
	 *  public var property:uint;
	 * [Attribute(index = "{PLAYER_FIELD_MONEY+4+3+2+1},{PLAYER_FIELD_MONEY+5+4+3+2+1}")] //多个
	 *  public var property:uint;
	 *  减法
	 * [Attribute(index = "{PLAYER_FIELD_MONEY-4},{PLAYER_FIELD_MONEY-5}")] //单个
	 *  public var property:uint;
	 * [Attribute(index = "{PLAYER_FIELD_MONEY-4-3-2-1},{PLAYER_FIELD_MONEY-5-4-3-2-1}")] //多个
	 *  public var property:uint;
	 *  乘法
	 * [Attribute(index = "{PLAYER_FIELD_MONEY*4},{PLAYER_FIELD_MONEY*5}")] //单个
	 *  public var property:uint;
	 * [Attribute(index = "{PLAYER_FIELD_MONEY*4*3*2*1},{PLAYER_FIELD_MONEY*5*4*3*2*1}")] //多个
	 *  public var property:uint;
	 *  除法
	 * [Attribute(index = "{PLAYER_FIELD_MONEY/4},{PLAYER_FIELD_MONEY/5}")] //单个
	 *  public var property:uint;
	 * [Attribute(index = "{PLAYER_FIELD_MONEY/4/3/2/1},{PLAYER_FIELD_MONEY/5/4/3/2/1}")] //多个
	 *  public var property:uint;
	 * @author zhangyong
	 *
	 */
	public final class AttributeManager {
		private static const attributes:Dictionary = new Dictionary();

		/**
		 * 注册类型
		 * @param type 要注册的类型
		 * @return
		 */
		public static function registerType(type:*):Object {
			var typeName:String = getQualifiedClassName(type);
			var m_attributes:Object = {};
			var list:XMLList = (type is Class) ? describeType(type).factory.* : describeType(type).*;
			//解析可写变量
			for each (var item:XML in list) {
				var name:String = item.name().toString();
				switch (name) {
					case "variable":
						var l1:XMLList = item.metadata;
						for each (var i1:XML in l1) {
							if (i1.@name == "Attribute") {
								var ll1:XMLList = i1.arg;
								for each (var ii1:XML in ll1) {
									if (ii1.@key == "index") {
										var vaa1:Array;
										var indexValue:String = replaceIndex(ii1.@value);
										if (indexValue.indexOf(",") != -1) { //多个编号指向同一个属性
											vaa1 = indexValue.split(",");
											for each (var vv1:String in vaa1) {
												setDataProperty(typeName, vv1, item.@name, m_attributes);
											}
										} else if (indexValue.indexOf("-") != -1) { //一段编号
											vaa1 = indexValue.split("-");
											var firstStr:String = vaa1[0];
											var preFix:String = firstStr.charAt(0);
											var start:int;
											var end:int;
											if (preFix != "s") {
												preFix = "";
												start = int(firstStr);
												end = int(vaa1[1]);
											} else { //一段s
												start = int(firstStr.substring(1, firstStr.length));
												end = int(vaa1[1]);
											}
											while (start <= end) {
												setDataProperty(typeName, preFix + start, "-" + item.@name.toString(), m_attributes);
												start++;
											}
										} else {
											setDataProperty(typeName, indexValue, item.@name, m_attributes);
										}
										break;
									}
								}
								break;
							}
						}
						break;
					case "accessor":
						var access:String = item.@access;
						if (access == "writeonly" || access == "readwrite") {
							var lll2:XMLList = item.metadata;
							for each (var ii2:XML in lll2) {
								if (ii2.@name == "Attribute") {
									var ll2:XMLList = ii2.arg;
									for each (var iii2:XML in ll2) {
										if (iii2.@key == "index") {
											var vaa2:Array;
											var indexValue2:String = replaceIndex(iii2.@value);
											if (indexValue2.indexOf(",") != -1) { //多个编号指向同一个属性
												vaa2 = indexValue2.split(",");
												for each (var vv2:String in vaa2) {
													setDataProperty(typeName, vv2, item.@name, m_attributes);
												}
											} else if (indexValue2.indexOf("-") != -1) { //一段编号
												var start2:int;
												var end2:int;
												vaa2 = indexValue2.split("-");
												var firstStr2:String = vaa2[0];
												var preFix2:String = firstStr2.charAt(0);
												if (preFix2 != "s") {
													preFix2 = "";
													start2 = int(firstStr2);
													end2 = int(vaa2[1]);
												} else { //一段s
													start2 = int(firstStr2.substring(1, firstStr2.length));
													end2 = int(vaa2[1]);
												}
												while (start2 <= end2) {
													setDataProperty(typeName, preFix2 + start2, "-" + item.@name.toString(), m_attributes);
													start2++;
												}
											} else {
												setDataProperty(typeName, indexValue2, item.@name, m_attributes);
											}
											break;
										}
									}
									break;
								}
							}
						}
						break;
					case "method":
						var lll3:XMLList = item.metadata;
						for each (var iii3:XML in lll3) {
							var $name:String = iii3.@name;
							if ($name == "Attribute") {
								var llll3:XMLList = iii3.arg;
								for each (var iiii3:XML in llll3) {
									if (llll3.@key == "index") {
										var vaa3:Array;
										var indexValue3:String = replaceIndex(iiii3.@value);
										if (indexValue3.indexOf(",") != -1) //多个编号指向同一个属性
										{
											vaa3 = indexValue3.split(",");
											for each (var vv3:String in vaa3) {
												setDataProperty(typeName, vv3, item.@name, m_attributes);
											}
										} else if (indexValue3.indexOf("-") != -1) { //一段编号
											vaa3 = indexValue3.split("-");
											var firstStr3:String = vaa3[0];
											var preFix3:String = firstStr3.charAt(0);
											var start3:int;
											var end3:int;
											if (preFix3 != "s") {
												preFix3 = "";
												start3 = int(firstStr3);
												end3 = int(vaa3[1]);
											} else { //一段s
												start3 = int(firstStr3.substring(1, firstStr3.length));
												end3 = int(vaa3[1]);
											}
											while (start3 <= end3) {
												setDataProperty(typeName, preFix3 + start3, "-" + item.@name.toString(), m_attributes);
												start3++;
											}
										} else {
											if (!m_attributes.hasOwnProperty(indexValue3)) {
												setDataProperty(typeName, indexValue3, item.@name, m_attributes);
											}
										}
										break;
									}
								}
								break;
							}
						}
						break;
				}
			}
			attributes[typeName] = m_attributes;
			return m_attributes;
		}

		private static function setDataProperty(typeName:String, index:*, value:String, obj:Object):void {
			if (!obj.hasOwnProperty(index)) {
				obj[index] = value;
			} else {
				trace("-------------------------------对象" + typeName, "下标", index, "已有属性", obj[index], "重复属性", value);
			}
		}
		public static var replaceObj:Object;

		/**
		 * 替换索引
		 * @return
		 *
		 */
		public static function replaceIndex(indexString:String):String {
			var resultStr:String = indexString.replace(/\{.*?\}/g, function replaceHandler():int
			{
				var tempStr:String = arguments[0].replace("{", "").toString().replace("}", "");
				var vi:int = 0;
				var va:Array;
				var tempRep:int;
				var v:String;
				if (tempStr.indexOf("-") != -1) //减法
				{
					va = tempStr.split("-");
					for each (v in va)
					{
						if (replaceObj && replaceObj.hasOwnProperty(v)) {
							tempRep = parseInt(replaceObj[v]);
						}
						else {
							tempRep = parseInt(v);
						}
						if (vi == 0) {
							vi = tempRep;
						}
						else {
							vi -= tempRep;
						}
					}
				}
				else if (tempStr.indexOf("*") != -1) //乘法
				{
					va = tempStr.split("*");
					for each (v in va)
					{
						if (replaceObj && replaceObj.hasOwnProperty(v)) {
							tempRep = parseInt(replaceObj[v]);
						}
						else {
							tempRep = parseInt(v);
						}
						if (vi == 0) {
							vi = tempRep;
						}
						else {
							vi *= tempRep;
						}
					}
				}
				else if (tempStr.indexOf("/") != -1) //除法
				{
					va = tempStr.split("/");
					for each (v in va)
					{
						if (replaceObj && replaceObj.hasOwnProperty(v)) {
							tempRep = parseInt(replaceObj[v]);
						}
						else {
							tempRep = parseInt(v);
						}
						if (vi == 0) {
							vi = tempRep;
						}
						else {
							vi /= tempRep;
						}
					}
				}
				else
				{
					va = tempStr.split("+");
					for each (v in va)
					{
						if (replaceObj && replaceObj.hasOwnProperty(v)) {
							vi += parseInt(replaceObj[v]);
						}
						else {
							vi += parseInt(v);
						}
					}
				}
				if (isNaN(vi))
				{
					throw new Error("字符串替换错误" + indexString);
				}
				return vi;
			});
			return resultStr;
		}
		private static var _classNames:Object = {};
		/**对象更新时执行*/
		public static var updateHandler:Function;

		/**
		 * 更新对象
		 * @param	obj 要更新的对象
		 * @param	index 属性索引
		 * @param	value 要更新的值
		 */
		public static function update(obj:*, index:*, value:*):void {
			if (obj) {
				var className:String = _classNames[obj];
				if (!className) {
					className = getQualifiedClassName(obj);
					_classNames[obj] = className;
				}
				var atts:* = attributes[className];
				if (atts == null) {
					atts = registerType(obj);
				}
				var property:String = atts[index];
				if (atts && property) {
					if (property.charAt(0) != "-") {
						obj[property] = value;
					} else {
						property = property.substring(1, property.length);
						obj[property](value, index); //如果使用- 必须是绑定方法
					}
					if (updateHandler != null) { //用于外部打印
						updateHandler(obj.guid, className, value, index);
					}
				}
			}
		}

		/**
		 * 获得对象属性对应的属性索引值
		 * @param objClass 类名
		 * @param attrName 属性名
		 * @return 索引值
		 *
		 */
		public static function getAttrIndex(objClass:Class, attrName:String):* {
			var attrList:* = getAttrList(objClass);
			for (var i:String in attrList) {
				if (attrList[i] == attrName) {
					return i;
				}
			}
		}

		/**
		 * 获取属性列表
		 * @param objClass
		 * @param replace
		 * @return
		 *
		 */
		public static function getAttrList(objClass:Class):* {
			var atts:* = attributes[getQualifiedClassName(objClass)];
			if (atts == null) {
				atts = registerType(objClass);
			}
			return atts;
		}

		/**
		 * 获取属性描述字符串
		 * @param obj
		 */
		public static function getAttString(obj:Object):String {
			var attributes:Object = Fun.getProperties(obj, Access.READ_ONLY | Access.READ_WRITE);
			var result:String = "";
			for (var att:String in attributes) {
				result += att + ":" + obj[att] + " ";
			}
			return result;
		}
	}
}
