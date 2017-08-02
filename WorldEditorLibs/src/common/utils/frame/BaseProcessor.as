package common.utils.frame
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	
	import common.msg.event.MEvent_baseShowHidePanel;
	
	/**
	 * UI或逻辑处理 processor(如果模块较大,可以拆分processor为多个processor)
	 * @author nick
	 * Email : 7105647@QQ.com
	 * 
	 */	
	public class BaseProcessor extends Processor
	{
		/**
		 * 
		 * @param $module 所属模块
		 * 
		 */		
		public function BaseProcessor($module:Module)
		{
			super($module);
			
			//创建消息号与消息CLASS对照表（这样就可以使用从服务端发来的消息号，找到对应的解析类，从而转化为ModuleEvent）
			//-------------------------------------------
			var meClassArr:Array = listenModuleEvents();
			if(meClassArr!=null && meClassArr.length>0)
			{
				for each(var meClass:Class in meClassArr)
				{
					//NetManager.registerNet2CClass(meClass);
				}
			}
			//-------------------------------------------
		}
		/**
		 * 向服务器发送消息
		 * @param $net2S
		 * 
		 */		
		//public function sendToServer($net2S:Net2S):void
		//{
		//	NetManager.sendToServer($net2S);
		//}
		
		//--------------------------------------------------------
		// 需要覆写的函数
		//--------------------------------------------------------
		/**
		 * 显示隐藏
		 */		
		public function showHide($me:MEvent_baseShowHidePanel):void{}
	}
}