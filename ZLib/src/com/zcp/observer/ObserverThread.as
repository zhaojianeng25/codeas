package com.zcp.observer
{
	import flash.utils.Dictionary;
	

	/**
	 * 观察者线程
	 * @author zcp
	 * 
	 */	
	public class ObserverThread
	{
		/**
		 * @private
		 * 观察者集
		 */		
		private var _observerMap:Dictionary = new Dictionary();
		
		/**
		 * ObserverThread
		 * 
		 */	
		public function ObserverThread()
		{

		}
		/**
		 * 清除所有观察者
		 */
		public function clear():void
		{
			_observerMap = new Dictionary();
		}
		/**
		 * 注册观察者
		 * @param $notificationName
		 * @param $observer
		 * 
		 */	
		public function registerObserver ($notificationName:*, $observer:Observer) : void
		{
			if( _observerMap[ $notificationName ] != null ) {
				_observerMap[ $notificationName ].push( $observer );
			} else {
				_observerMap[ $notificationName ] = [ $observer ];	
			}
		}
		/**
		 * 移除观察者
		 * @param $notificationName
		 * @param $notifyContext
		 * 
		 */	
		public function removeObserver($notificationName:*, $notifyContext:*) : void
		{
			var observers:Array = _observerMap[ $notificationName ] as Array;
			
			//查找并移除
			for (var i:int = observers.length-1; i>=0; i-- ) 
			{
				if ( Observer(observers[i]).compareNotifyContext( $notifyContext ) ) {
					observers.splice(i,1);
				}
			}
			
			//如果没有观察者再注意此通知，则移除对于这个通知的观察数组
			if ( observers.length == 0 ) {
				delete _observerMap[ $notificationName ];
			}
		}
		/**
		 * 移除观察者(通过notificationName)
		 * @param $notificationName
		 * 
		 */	
		public function removeObserverByNotificationName($notificationName:*) : void
		{
			if(_observerMap[$notificationName]!=null)
			{
				_observerMap[ $notificationName ] = null;
				delete _observerMap[ $notificationName ];
			}
		}
		/**
		 * 移除观察者(通过notifyContext)
		 * @param $notifyContext
		 * 
		 */	
		public function removeObserverByNotifyContext($notifyContext:*) : void
		{
			for(var notificationName:* in _observerMap)
			{
				removeObserver(notificationName, $notifyContext);
			}
		}
		
		
		/**
		 * 将数据通知观察者
		 * @param $notification
		 */
		public function notifyObservers($notification:Notification) : void
		{
			var observers_ref:Array = _observerMap[ $notification.name ] as Array;
			if( observers_ref != null ) {
				var observers:Array = []; 
				var observer:Observer;
				var i:int;
				var len:int = observers_ref.length;
				
				//检索出所有观察此消息号的回调函数,因为在执行回调的过程中observers_ref这个数组可能发生改变，所以需要这样操作
				for (i = 0; i < len; i++) { 
					observer = observers_ref[ i ];
					observers.push( observer );
				}
				//执行所有观察此消息号的回调函数
				for (i = 0; i < len; i++) {
					observer = observers[ i ];
					observer.notifyObserver($notification);
				}
			}
		}
	}
}