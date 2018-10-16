package common.msg.event
{
	import com.zcp.frame.event.ModuleEvent;
	
	/**
	 * 显示隐藏面板事件基类
	 * @author nick
	 * Email : 7105647@QQ.com
	 */
	public class MEvent_baseShowHidePanel extends ModuleEvent
	{
		/**
		 * 自动（显示则隐藏，隐藏则显示 ）
		 */
		public static const AUTO:String = "0";
		/**
		 * 显示
		 */
		public static const SHOW:String = "1";
		/**
		 * 隐藏
		 */
		public static const HIDE:String = "2";
		
		public function MEvent_baseShowHidePanel($action:String = AUTO)
		{
			super($action);
		}
	}
}