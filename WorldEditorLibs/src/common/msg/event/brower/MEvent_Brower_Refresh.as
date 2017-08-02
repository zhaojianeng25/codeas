package common.msg.event.brower
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_Brower_Refresh extends ModuleEvent
	{
		public static var MEVENT_BROWER_REFRESH:String = "MEvent_Brower_Refresh";
		public function MEvent_Brower_Refresh($action:String=null)
		{
			super($action);
		}
	}
}