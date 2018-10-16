package com.zcp._special.mic
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * 录音事件 
	 * @author ZCP
	 * 
	 */	
	public class RecordEvent extends Event
	{
		/**
		 * 录音开始 
		 */		
		static public const RECORD_START:String = "RECORD_START";
		/**
		 * 录音停止(完成)
		 */		
		static public const RECORD_STOP:String = "RECORD_STOP";
		/**
		 * 录音暂停 
		 */		
		static public const RECORD_PAUSE:String = "RECORD_PAUSE";
		/**
		 * 录音提示信息
		 */		
		static public const RECORD_MSG:String = "RECORD_MSG";
		/**
		 * 录音数据 
		 */		
		public var recordData:ByteArray;
		/**
		 * 提示信息 
		 */		
		public var msg:String;
		
		public function RecordEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}