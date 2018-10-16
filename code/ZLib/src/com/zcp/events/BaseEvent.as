package com.zcp.events
{
	import flash.events.Event;
	/**
	 * 事件基类
	 * @author zcp
	 * 
	 */	
	public class BaseEvent extends Event
	{
		/**行为*/
		public var action:String;
		/**数据*/
		public var data:Object;
	    /**
		 * BaseEvent构造
		 * @param $type 类型
		 * @param $action 行为
		 * @param $data 数据
		 * */
		public function BaseEvent($type:String, $action:String="",$data:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			action = $action;
			data = $data;
		}
		/**创建一个副本*/
        override public function clone():Event
        {
        	return new BaseEvent(type,action,data, bubbles, cancelable);
        }
        
        override public function toString():String
        {
        	return "[BaseEvent]";
        }
	}
}