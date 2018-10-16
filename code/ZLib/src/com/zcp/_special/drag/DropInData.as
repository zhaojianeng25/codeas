package com.zcp._special.drag
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * 拖放时携带的数据 
	 * 继承自Event的好处是直接可以被界面通过派发事件转发出去, 处理成功之后请标识hasDone为true
	 * @author zcp
	 * 
	 */	
	public class DropInData extends Event
	{
		/**
		 * 可以通过监听此字符串事件来监听接收拖入的界面转发的拖入数据 
		 */		
		public static const DROP_IN_DATA:String = "DROP_IN_DATA";
		
		/**
		 * 源(拖拽的是谁)
		 */		
		public var from:DisplayObject;
		/**
		 * 类型 
		 */		
		public var action:String;
		/**
		 * 数据（携带数据）
		 */		
		public var data:*;
		
		
		//两个控制变量
		//---------------------------------
		/**
		 * 用来标识此事件是否被处理了
		 */		
		public var hasDone:Boolean;
		/**
		 * 是否打断此事件继续向上冒泡
		 */		
		public var breakUp:Boolean;
		//---------------------------------
		
		/**
		 * 
		 * @param $from 源
		 * @param $action 类型
		 * @param $data 数据
		 * 
		 */		
		public function DropInData($from:DisplayObject, $action:String=null, $data:*=null)
		{
			super(DROP_IN_DATA);
			
			from = $from;
			action = $action;
			data = 	$data;
		}
		
		override public function toString():String
		{
			return "[DropInData: from:"+from+" action:"+action+" data:"+data+"]";
		}
	}
}