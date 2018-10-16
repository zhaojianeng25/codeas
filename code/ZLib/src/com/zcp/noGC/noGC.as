package com.zcp.noGC
{
	import flash.utils.Dictionary;

	/**
	 * 私有数据暂存器（目的：不被GC自动回收）
	 * @author zcp
	 * 
	 */	
	public class noGC
	{
		/**
		 * 数据存储器
		 */		
		static private var _objDict: Dictionary = new Dictionary();

		/**
		 * noGC
		 * 
		 */	
		public function noGC()
		{

		}
		/**
		 * 添加一个私有数据
		 * @parm $obj
		 */
		static public function addObject($obj:Object):void
		{
			_objDict[$obj] = true;
		}
		/**
		 * 删除一个私有数据
		 * @parm $obj
		 */
		static public function removeObject($obj:Object):void
		{
			_objDict[$obj] = null;
			delete _objDict[$obj];
		}
		/**
		 * 清空
		 */
		static public function clear():void
		{
			var key:*;
			for(key in _objDict)
			{
				_objDict[key] = null;
				delete _objDict[key];
			}
		}
	}
}