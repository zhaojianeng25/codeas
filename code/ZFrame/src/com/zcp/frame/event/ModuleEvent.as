package com.zcp.frame.event
{
	import flash.utils.getQualifiedClassName;

	/**
	 * 框架使用的事件基类 (注意，不是继承自Event,与AS3本身的事件机制不同)
	 * @author zcp
	 * 
	 */	
	public class ModuleEvent
	{
		/**
		 * 事件类型（即该类的完全限定名）
		 * 
		 */
		final public function get type():String
		{
			return getQualifiedClassName(this);
		}
		/**
		 * 事件功能
		 */		
		public var action:String;
		
		public function ModuleEvent($action:String=null)
		{
			action = $action;
		}
		/**
		 * 获取实例的类型类 
		 * @return 
		 * 
		 */		
		public function getClass():Class
		{
			return this["constructor"];//getDefinitionByName(getQualifiedClassName(this));
		}
		public function toString():String
		{
			return "【ModuleEvent type:"+type.split("::")[1]+" action:"+action+"】";
		}
	}
}