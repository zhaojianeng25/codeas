package com.zcp.frame.event{
	import com.zcp.observer.Notification;
	import com.zcp.observer.Observer;
	import com.zcp.observer.ObserverThread;

	/**
	 * 事件管理器
	 * 此管理器可实现了实践的派发和接收（另外，框架外只需使用派发的方法）
	 * @author zcp
	 * 
	 */	
	public class ModuleEventManager{

		/**
		 * 消息观察线程
		 */		
		private static var ot:ObserverThread = new ObserverThread();
		
		/**
		 * 注册事件
		 * @param $meClass 继承自ModuleEvent的CLASS
		 * @param $callBack 接收数据回调 ,回调类似:function receivedEventHandle( $notification:Notification):void;
		 * @param $owner 所有者标识
		 * 
		 */	
		public static function addEvent ($meClass:Class, $callBack:Function, $owner:*) : void
		{
			var observer:Observer = new Observer($callBack, $owner);
			ot.registerObserver($meClass,observer);
		}
		/**
		 * 批量注册事件
		 * @param $meClassArr ModuleEvent的CLASS
		 * @param $callBack 接收数据回调， 回调类似:function receivedEventHandle( $notification:Notification):void;
		 * @param $owner 所有者标识
		 * 
		 */	
		public static function addEvents ($meClassArr:Array, $callBack:Function, $owner:*) : void
		{
			for each(var meClass:Class in $meClassArr)
			{
				addEvent(meClass, $callBack, $owner);
			}
		}
		/**
		 * 移除事件
		 * @param $meClass 继承自ModuleEvent的CLASS
		 * @param $owner 所有者标识
		 * 
		 */	
		public static function removeEvent ($meClass:Class, $owner:*) : void
		{
			ot.removeObserver($meClass,$owner);
		}
		/**
		 * 移除事件(通过所有者标识)
		 * @param $owner 所有者标识
		 * 
		 */	
		public static function removeEventByOwner ($owner:*) : void
		{
			ot.removeObserverByNotifyContext($owner);
		}
		/**
		 * 批量删除事件
		 * @param $meClassArr 继承自ModuleEvent的CLASS的集合
		 * @param $owner 所有者标识
		 * 
		 */	
		public static function removeEvents ($meClassArr:Array,  $owner:*) : void
		{
			for each(var meClass:Class in $meClassArr)
			{
				removeEvent(meClass, $owner);
			}
		}

		/**
		 * 派发事件
		 * 此方法在框架外也会用到
		 */		
		public static function dispatchEvent($mEvent:ModuleEvent):void
		{
			//由实例获取类
			var meCLASS:Class = $mEvent.getClass();
			//通知
			var notification:Notification = new Notification(meCLASS, $mEvent);
			ot.notifyObservers(notification);
		}
	}
}