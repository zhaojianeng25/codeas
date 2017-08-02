package com.zcp.frame
{
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	import com.zcp.observer.Notification;

	/**
	 * Processor基类 
	 * Processor为单一功能控制类（比如：网络通讯、模块事件、UI逻辑、业务逻辑等均可交由此类控制）
	 * 重写方法举例
	 * 1.重写listenModuleEvents方法
	 * 例如：
	 * override protected function listenModuleEvents():Array
	 * {
	 * 		return [ModuleEvent_1001,ModuleEvent_1002];
	 * }
	 * 2.重写receivedModuleEvent方法
	 * 例如：
	 * override protected receivedModuleEvent($me:ModuleEvent):void
	 * {
	 *  	switch($me.getClass())
	 *  	{
	 *  		case ModuleEvent_1001:
	 *  			(module.getProcessor(View_processor.Name) as View_processor).doSomething();
	 *  			break;
	 *  	}
	 * }
	 * @author zcp
	 * 
	 */	
	public class Processor
	{
		//所属模块
		private var _module:Module;
		/**所属模块*/		
		public function get module():Module{return _module;}
		
		public function Processor($module:Module)
		{
			_module = $module;
			
			//初始化
			onInit();
		}
		/**
		 * 获取实例的类型类 
		 * @return 
		 * 
		 */		
		final public function getClass():Class
		{
			return this["constructor"];//getDefinitionByName(getQualifiedClassName(this));
		}
		/**
		 * 派发事件
		 * 
		 */		
		final public function dispatchEvent(e:ModuleEvent):void
		{
			ModuleEventManager.dispatchEvent(e);
		}
		
		//--------------------------------------------------------
		// 供框架自身调用的API， 用于注册和移除事件监听
		//--------------------------------------------------------
		/**
		 * 注册事件
		 * 此方法仅供框架内使用
		 */ 
		final public function registerEvents():void {
			//注册消息监听
			var meClassArr:Array = listenModuleEvents();
			if(meClassArr!=null && meClassArr.length>0)
			{
				ModuleEventManager.addEvents(meClassArr,receivedModuleEventHandle,this);
			}
		}
		
		/**
		 * 移除事件
		 * 此方法仅供框架内使用
		 */ 
		final public function removeEvents():void {
			ModuleEventManager.removeEventByOwner(this);
		}
		
		/**
		 * 解析事件，之后交给处理函数
		 * @param $notification
		 */
		private function receivedModuleEventHandle( $notification:Notification):void
		{
//			var meEventClass:Class = $notification.name;
			var meEvent:ModuleEvent = $notification.body as ModuleEvent;
			//处理
			receivedModuleEvent(meEvent);
			return;
		}

		
		//--------------------------------------------------------
		// 以下为需要覆写的函数
		//--------------------------------------------------------
		/**
		 * 初始化
		 */		
		protected function onInit():void {}
		
		/**
		 * 当被注册时
		 */ 
		public function onRegister():void {}
		
		/**
		 * 当被移除时
		 */ 
		public function onRemove():void {}
		
		/**
		 * 监听的事件类的集合
		 * 请注意：返回为事件的CLASS(这些CLASS必须继承自ModuleEvent)的数组
		 * @return 
		 * 
		 */		
		protected function listenModuleEvents():Array
		{
			return null;
		}
		
		/**
		 * 处理事件
		 * @param $netMsg2C
		 */
		protected function receivedModuleEvent($me:ModuleEvent):void{}
	}
}