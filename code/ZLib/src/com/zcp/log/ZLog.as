package com.zcp.log
{
	import com.zcp.handle.HandleThread;
	
	import flash.text.TextField;

	/**
	 * 日志
	 * @author zcp
	 * 
	 */	
	public class ZLog
	{
		private static const _logHt:HandleThread = new HandleThread();
		
		/**
		 * 是否启用日志
		 */	
		public static var enableLog:Boolean = true;
		/**
		 * 是否启用trace
		 */	
		public static var enableTrace:Boolean = true;
		/**
		 * 是否启用TextFiled打印
		 */	
		public static var enableShowInLogArea:Boolean = false;
		/**
		 * 目标TextFiled最大显示打印条数
		 */	
		public static var max_log_num:Number;
		
		private static var _logArea:TextField;
		private static var _logNum:Number;
		/**
		 * 初始化日志管理器
		 * @param $logArea 日志打印目标TextFiled
		 * @param $max_log_num 目标TextFiled最大显示打印条数
		 * @param $enableTrace 是否执行trace
		 * @param $enableShowInLogArea 是否打印
		 * 
		 */	
		public static function init($logArea:TextField=null,$max_log_num:int=1000,$enableTrace:Boolean=true,$enableShowInLogArea:Boolean=false):void
		{
			
			enableLog = true;
			max_log_num = $max_log_num;
			enableTrace = $enableTrace;
			enableShowInLogArea = $enableShowInLogArea;
			_logArea = $logArea;
			if(_logArea)
			{
				_logArea.text = "";
			}
			_logNum = 0;
			return;
		}
		
		/**
		 * 添加一条日志
		 * @param $str 日志信息
		 */	
		public static function add($str:*):void
		{
			if(!enableLog)return;
			
			//trace
			var str:String = ($str is Array && $str.length>0)?$str.slice(" "):$str;
			if(enableTrace)
			{
				trace(str);
			}	
			
			//show in textFiled
			if(enableShowInLogArea&&_logArea!=null)
			{
				_logHt.push(doAdd,[str],10);
			}
			return;
		}
		
		
		/**
		 * @private
		 * 执行添加
		 * 
		 */	
		private static function doAdd($str:*):void
		{
			if(enableShowInLogArea&&_logArea!=null)
			{
				_logArea.appendText($str+"\n");
				_logNum++;	
				var index:int;
				while(_logNum>max_log_num)
				{
					index = _logArea.text.indexOf("\r");
					_logArea.replaceText(0,index!=-1?index+1:0,"");
					_logNum--;	
				}
			}
			return;
		}

	}
}