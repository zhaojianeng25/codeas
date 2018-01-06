package tempest.utils
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.describeType;
	
	import tempest.common.staticdata.Access;
	import tempest.core.IDisposable;

	/**
	 * 工具类
	 * @author wushangkun
	 */
	public class Fun
	{
		///////////////////////////////////////////////////对象操作///////////////////////////////////////////////////////
		/**
		 * 获取一个对象或Class的属性
		 * @writeable 是否只获取可写属性
		 * @param obj 一个实例或Class
		 * @return
		 */
		public static function getProperties(obj:*, accessType:int=3 /*Access.WRITE_ONLY | Access.READ_WRITE*/):Object
		{
			var attributes:Object={};
			if (obj)
			{
				var list:XMLList=(obj is Class) ? describeType(obj).factory.* : describeType(obj).*;
				//解析可写变量
				for each (var item:XML in list)
				{
					var name:String=item.name().toString();
					switch (name)
					{
						case "variable":
							attributes[item.@name.toString()]=item.@type.toString();
							break;
						case "accessor":
							var access:String=item.@access;
							if ((accessType & Access.WRITE_ONLY) && access == "writeonly")
								attributes[item.@name.toString()]=item.@type.toString();
							else if ((accessType & Access.READ_WRITE) && access == "readwrite")
								attributes[item.@name.toString()]=item.@type.toString();
							else if ((accessType & Access.READ_ONLY) && access == "readonly")
								attributes[item.@name.toString()]=item.@type.toString();
							break;
					}
				}
			}
			return attributes;
		}

		public static function copySimpleProperties(target:Object, src:Object):void
		{
			for (var att:String in src)
			{
				if (target.hasOwnProperty(att))
				{
					target[att]=src[att];
				}
			}
		}

		private static var protyKey:String;

		/**
		 * 拷贝属性
		 * @param target
		 * @param src
		 */
		public static function copyProperties(target:Object, src:Object):void
		{
			//为了提高效率 (1)不要使用 hasPropery方法(2)也不要使用反射去获取列表
			for (protyKey in src) //拷贝文字类型的属性
			{
				target[protyKey]=src[protyKey];
			}
//			if (src == null)
//				return;
//			var attributes:Object=getProperties(target);
//			for (var att:String in attributes)
//			{
//				if (src.hasOwnProperty(att))
//				{
//					switch (attributes[att])
//					{
//						case "int":
//						case "uint":
//							target[att]=parseInt(src[att]);
//							break;
//						case "Boolean":
//							target[att]=isNaN(parseInt(src[att])) ? Boolean(src[att]) : Boolean(parseInt(src[att]));
//							break;
//						case "Number":
//							target[att]=parseFloat(src[att]);
//							break;
//						case "String":
//						case "Array":
//							target[att]=(arrayFormat) ? String(src[att]).split(",") : src[att];
//							break;
//						default:
//							//try
//							//{
//							if (target[att] != null)
//							{
//								copyProperties(target[att], src[att]);
//							}
//							//}
//							//catch (e:Error)
//							//{
//							//}
//							break;
//					}
//				}
//			}
		}

		/////////////////////////////////////////////////显示相关////////////////////////////////////////////////////////
		/**
		 * 获取子元件数量
		 * @param container
		 * @param allChildren
		 */
		public static function getNumChildren(container:DisplayObjectContainer, allChildren:Boolean=true):int
		{
			if (container == null)
				return 0;
			if (!allChildren)
				return container.numChildren;
			var num:int;
			var total:int;
			var temp:DisplayObjectContainer;
			total=num=container.numChildren;
			for (var i:int=0; i < num; i++)
			{
				temp=container.getChildAt(i) as DisplayObjectContainer;
				if (temp)
				{
					total+=getNumChildren(temp);
				}
			}
			return total;
		}

		/**
		 * 是否可见
		 * @param obj
		 * @return
		 */
		public static function isVisible(obj:DisplayObject):Boolean
		{
			if (obj == null || obj.visible == false)
			{
				return false;
			}
			if (obj is Stage)
			{
				return true;
			}
			return isVisible(obj.parent);
		}

		//DEBUG
//		public static var stopCount:int = 0;
		/**
		 * 停止MC组件播放
		 * @param mc
		 * @param allChildren 停止所有子元件
		 */
		public static function stopMC(mc:*, allChildren:Boolean=true):void
		{
			if (mc == null)
				return;
//			if (mc.name == "mc_KeXueXi")
//			{
//				stopCount++;
//				//DEBUG
//				trace("++DEBUG stopCount = " + stopCount);
//				if (stopCount > 27)
//				{
//					trace("DEBUG");
//				}
//			}
			if (mc is MovieClip)
				mc.gotoAndStop(1);
			if (allChildren && (mc is DisplayObjectContainer) && mc.numChildren > 0)
			{
				for (var i:int=0; i < mc.numChildren; i++)
				{
					stopMC(mc.getChildAt(i));
				}
			}
		}

		/**
		 * 移除容器所有子对象
		 * @param ui
		 */
		public static function removeAllChildren(container:DisplayObject, clearBitmap:Boolean=false, clearChilds:Boolean=true, dispose:Boolean=false):void
		{
			if (container)
			{
				if (container is DisplayObjectContainer)
				{
					while ((DisplayObjectContainer(container)).numChildren != 0)
					{
						if (clearChilds)
							removeAllChildren((DisplayObjectContainer(container)).getChildAt(0), clearBitmap, clearChilds, dispose);
						DisplayObjectContainer(container).removeChildAt(0);
					}
				}
				else
				{
					if (dispose && (container is IDisposable))
					{
						IDisposable(container).dispose();
					}
					if (clearBitmap && (container is Bitmap) && (container as Bitmap).bitmapData)
					{
						Bitmap(container).bitmapData.dispose();
						Bitmap(container).bitmapData=null;
					}
				}
			}
		}

		/**
		 * 设置对象是否可以双击
		 * @param obj
		 * @param enable
		 */
		public static function setDoubleClickEnable(obj:*, enable:Boolean):void
		{
			if (obj is InteractiveObject)
			{
				obj.doubleClickEnabled=enable;
				if (obj is DisplayObjectContainer)
				{
					for (var i:int=0; i != obj.numChildren; i++)
					{
						setDoubleClickEnable(obj.getChildAt(i), enable);
					}
				}
			}
		}

		/**
		 * 调试工具
		 * @param container
		 *
		 */
		public static function printMouseEnabled(container:Sprite):void
		{
			if (container)
			{
				var _container:DisplayObjectContainer=container as DisplayObjectContainer;
				if (_container && _container.numChildren > 0)
				{
					for (var i:int=0; i < _container.numChildren; i++)
					{
						var _mc:Sprite=_container.getChildAt(i) as Sprite;
						if (_mc)
						{
							printMouseEnabled(_mc);
						}
					}
					if (_container.mouseEnabled == false)
					{
						trace(_container.name + " mouseEnabled  == false");
					}
					if (_container.mouseChildren == false)
					{
						trace(_container.name + " mouseChildren  == false!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
					}
				}
				else
				{
					if (container.mouseEnabled == false)
					{
						trace(container.name + "mouseEnabled  == false");
					}
				}
			}
		}

		/////////////////////////////////////////////////位操作相关//////////////////////////////////////////
		/**
		 * 取Int中的位
		 * @param data
		 * @param index
		 * @return
		 */
		public static function getBit(data:int, index:int):int
		{
			return (data >> index) & 1;
		}

		////////////////////////////////////////////////系统相关////////////////////////////////////////////
		/**
		 * 强制回收内存
		 * 不稳定 不建议使用
		 */
		public static function gc():void
		{
			if (Capabilities.isDebugger)
			{
				System.gc();
				trace("调用系统回收");
			}
			else
			{
				try
				{
					new LocalConnection().connect("foo");
					new LocalConnection().connect("foo");
				}
				catch (e:Error)
				{
				}
				finally
				{
					trace("调用强制回收");
				}
			}
		}
		private static var _flashVersion:Number=10.0;

		/**
		 * 获取Flash Player版本
		 * @return
		 */
		public static function getFlashVersion():Number
		{
			var tempArr:Array=Capabilities.version.split(" ")[1].split(",");
			return _flashVersion||=parseFloat(tempArr.shift().concat('.', tempArr.join("")));
		}

		/////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * 获取时间
		 * @return
		 */
		public static function getTime():Number
		{
			return _lastDateTime + (Time.now - _lastTime);
		}
		private static var _lastTime:Number=Time.now; //时钟时间
		private static var _lastDateTime:Number=new Date().time;

		public static function set lastDateTime(value:Number):void
		{
			_lastDateTime=value;
			_lastTime=Time.now;
		}

		public static function get lastDateTime():Number
		{
			return _lastDateTime;
		}
	}
}
