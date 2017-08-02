package com.zcp.worker
{
	import flash.events.Event;
	import com.zcp.worker.vo.WorkReturnData;
	
	/**
	 * WorkThreadEvent
	 * @author ZCP
	 * 
	 */	
	public class WorkThreadEvent extends Event
	{
		/**
		 * 准备完毕 
		 */		
		static public const WT_READY:String = "WT_READY";
		/**
		 * 有返回数据 
		 */		
		static public const WT_DATA:String = "WT_DATA";
		
		/**
		 * 返回数据 
		 */		
		public var data:WorkReturnData;
		
		public function WorkThreadEvent(type:String, $data:WorkReturnData=null)
		{
			super(type, false, false);
			data = $data;
		}
	}
}