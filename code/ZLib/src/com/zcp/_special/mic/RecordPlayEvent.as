package com.zcp._special.mic
{
	import flash.events.Event;
	
	/**
	 * 播放录音事件 
	 * @author ZCP
	 * 
	 */	
	public class RecordPlayEvent extends Event
	{
		/**
		 * 播放开始 
		 */		
		static public const PLAY_START:String = "PLAY_START";
		/**
		 * 播放停止 
		 */		
		static public const PLAY_STOP:String = "PLAY_STOP";
		/**
		 * 播放暂停 
		 */		
		static public const PLAY_PAUSE:String = "PLAY_PAUSE";
		/**
		 * 播放完成 
		 */		
		static public const PLAY_COMPLETE:String = "PLAY_COMPLETE";
		
		public function RecordPlayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}