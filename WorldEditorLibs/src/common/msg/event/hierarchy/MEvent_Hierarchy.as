package common.msg.event.hierarchy
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_Hierarchy extends ModuleEvent
	{
		public static var MEVENT_HIERARCHY_SHOW:String = "MEvent_Hierarchy_Show";
		public static var GET_SCENE_TO_C_FILE_DATA:String="GET_SCENE_TO_C_FILE_DATA";
		
		public function MEvent_Hierarchy($action:String=null)
		{
			super($action);
		}
	}
}