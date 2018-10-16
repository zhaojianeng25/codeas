package com.zcp.observer
{
	/**
	 * 观察者
	 * @author zcp
	 */
	public class Observer
	{
		/**通知函数*/
		public var notifyMethod:Function;
		/**通知的所属标识，一般为一个字符串， 即该通知属于哪个所有者*/
		public var notifyContext:*;
		
		/**
		 * 观察者
		 * @parm $notifyMethod 通知函数
		 * @parm $notifyContext 通知的所属标识，一般为一个字符串， 即该通知属于哪个所有者
		 */
		public function Observer( $notifyMethod:Function, $notifyContext:* )
		{
			notifyMethod = $notifyMethod;
			notifyContext = $notifyContext;
		}
		/**
		 * 通知Observer
	 	 * @parm $notification
		 */
		public function notifyObserver( $notification:Notification ):void
		{
			notifyMethod.apply(notifyContext,[$notification]);
		}
		/**
		 * 比较是不是属于同一所有者
		 * @parm $notifyContext
		 */
		public function compareNotifyContext( $notifyContext:* ):Boolean
		{
			return $notifyContext === notifyContext;
		}	
	}
}