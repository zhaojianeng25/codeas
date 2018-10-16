package common.msg.event.prefabs
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_Objs_Show extends ModuleEvent
	{
		public static var MEVENT_OBJS_SHOW:String = "MEvent_Objs_Show";
		public var url:String;
		public function MEvent_Objs_Show($action:String=null)
		{
			super($action);
		}
	}
}