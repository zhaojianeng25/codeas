package com.zcp.events
{
	import flash.events.EventDispatcher;
	/**
	 * 事件派发器(EventDispatchCenter)
	 * @author zcp
	 * 
	 */	
	public class EventDispatchCenter extends EventDispatcher
	{
		private static var _instance:EventDispatchCenter;

		public function EventDispatchCenter()
		{
	        if(_instance != null) {   
	            throw new Error("单例!");   
	        }  
		}
		/**单例(getInstance)*/
		public static function getInstance():EventDispatchCenter {
			if(_instance == null) {
				_instance = new EventDispatchCenter();
			}
			return _instance;
		}
		
	}
}