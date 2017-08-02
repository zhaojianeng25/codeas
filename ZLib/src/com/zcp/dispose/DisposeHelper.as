package com.zcp.dispose
{
	import com.zcp.timer.Tick;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	/**
	 * Dispose辅助器
	 * @author zcp
	 * 
	 */	
	public class DisposeHelper
	{
		
		/**判断是否处于睡眠模式的刷帧时间建个*/
		private static var sleepModeRenderTime:int = 1000/12;//只要低于12帧就认为是睡眠模式
		/**当前FLASH所在窗体是否处于最小化模式或隐藏选项卡内， 处于该模式下则不进行队列处理*/
		private static var inSleepMode:Boolean = false;
		/**上次运行的结束时间*/
		private static var lastRunTime:int = 0;
		
		
		private static var _sprite:Sprite = new Sprite();
		//等待卸载列表
		private static var _disposList:Array = [];
		
		public function DisposeHelper()
		{
			throw new Event("静态类");
		}
		public static function get length():int
		{
			return _disposList.length;
		}
		/**
		 * 队列卸载
		 * @param $obj 一般为BitmapData或XML或ByteArry
		 * 
		 */		
		public static function add($obj:*):void 
		{
			if($obj==null)return;
			_disposList.push($obj);
//			if(!_sprite.hasEventListener(Event.ENTER_FRAME))
			if(!Tick.hasCallback(onEnterFrame))
			{
				lastRunTime = getTimer();//获取一次时间
//				_sprite.addEventListener(Event.ENTER_FRAME,onEnterFrame);
				
				Tick.addCallback(onEnterFrame);
			}
		}
		private static function onEnterFrame():void
		{
			var time:int = getTimer();
			//是否处于睡眠模式
			inSleepMode = time-lastRunTime>sleepModeRenderTime;
			lastRunTime = time;
			
			//睡眠模式一次性处理
			if(inSleepMode)
			{
				while(_disposList.length>0)
				{
					disposeObj(_disposList.shift());
				}
			}
			else
			{
				while(_disposList.length>0)
				{
					disposeObj(_disposList.shift());
					
					//时间判断（在非睡眠模式下， 消息处理要均匀的分布在刷帧中）
					if(getTimer()-time>=5)break;
				}
			}
			
			//处理完毕移除事件
			if(_disposList.length==0)
			{
				//				_sprite.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				
				Tick.removeCallback(onEnterFrame);
			}
		}
		private static function disposeObj($obj:*):void
		{
			if($obj is BitmapData)
			{
				($obj as BitmapData).dispose();
				$obj = null;
			}
			else if($obj is XML)
			{
				System.disposeXML($obj as XML);
			}
			else if($obj is ByteArray)
			{
				($obj as ByteArray).clear();
			}
		}
		
	}
}