package com.zcp.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * 事件辅助器
	 * @author zcp
	 * 
	 */	
	public class EventHelper
	{
		public function EventHelper()
		{
			throw new Event("静态类");
		}
		/**
		 * 当$toStageDOBJ被添加到舞台上则给$callBackDobj注册$eventType类型回调为$callBack的事件，当$toStageDOBJ从舞台上被移除则移除该事件
		 * @param $toStageDOBJ
		 * @param $callBack 回调类似function $callBack(e:Event):void;
		 * @param $callBackDobj 当为null时，则取$toStageDOBJ
		 * @param $eventType 事件类型
		 * @return 返回的函数为取消此注册的方法，无参数，直接调用即可取消。
		 * 
		 */		
		public static function registerAddToStageEventListener(
			$toStageDOBJ:DisplayObject, $callBack:Function,
			$callBackDobj:DisplayObject=null,$eventType:String=Event.ENTER_FRAME):Function 
		{
			$callBackDobj = $callBackDobj || $toStageDOBJ;
			
			//如果处于在舞台上则执行一次注册
			if($toStageDOBJ.stage!=null)
			{
				onAddToStage(null);
			}
			
			//注册事件
			$toStageDOBJ.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			function onAddToStage(e:Event):void
			{
				$toStageDOBJ.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
				$callBackDobj.addEventListener($eventType,$callBack)	
			}
			function onRemoveFromStage(e:Event):void
			{
				$toStageDOBJ.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
				$callBackDobj.removeEventListener($eventType,$callBack)	
			}
			
			//移除的事件
			var removeEventListenerfunction:Function = function():void
			{
				onRemoveFromStage(null);
				$toStageDOBJ.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			}
			return removeEventListenerfunction;
		}
		
	}
}