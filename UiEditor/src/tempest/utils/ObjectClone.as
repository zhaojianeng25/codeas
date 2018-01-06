package tempest.utils
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ObjectClone
	{
		/**
		 *克隆对象  不能进行深度克隆，所以克隆对象的属性不能为自定义对象，或者需要手动为属性为自定义的对象赋值
		 * @param source
		 * @return
		 *
		 */
		public static function clone(source:Object):Object
		{
			var clone:Object;
			if (source)
			{
				clone = newSibling(source);
				if (clone)
				{
					copyData(source, clone);
				}
			}
			return clone;
		}

		/**
		 *获取对象副本
		 * @param sourceObj  需要克隆的对象
		 * @return  对象副本
		 *
		 */
		private static function newSibling(sourceObj:Object):*
		{
			if (sourceObj)
			{
				var objSibling:*;
				try
				{
					var classOfSourceObj:Class = getDefinitionByName(getQualifiedClassName(sourceObj)) as Class;
					objSibling = new classOfSourceObj();
				}
				catch (e:Object)
				{
				}
				return objSibling;
			}
			return null;
		}

		/**
		 *为对象副本复制
		 * @param source   源对象
		 * @param destination   副本对象
		 *
		 */
		private static function copyData(source:Object, destination:Object):void
		{
			//copies data from commonly named properties and getter/setter pairs
			if ((source) && (destination))
			{
				try
				{
					var sourceInfo:XML = describeType(source);
					var prop:XML;
					for each (prop in sourceInfo.variable)
					{
						if (destination.hasOwnProperty(prop.@name))
						{
							destination[prop.@name] = source[prop.@name];
						}
					}
					for each (prop in sourceInfo.accessor)
					{
						if (prop.@access == "readwrite")
						{
							if (destination.hasOwnProperty(prop.@name))
							{
								destination[prop.@name] = source[prop.@name];
							}
						}
					}
				}
				catch (err:Object)
				{
					;
				}
			}
		}
	}
}
