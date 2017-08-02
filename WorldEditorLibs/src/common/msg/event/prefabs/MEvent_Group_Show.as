package common.msg.event.prefabs
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_Group_Show extends ModuleEvent
	{
		public static var MEVENT_GROUP_SHOW:String = "Mevent_Group_Show";
		public var url:String;
		public function MEvent_Group_Show($action:String=null)
		{
			super($action);
		}
	}
}