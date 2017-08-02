package common.msg.event.scene
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_Add_Capture extends ModuleEvent
	{
		public static var MEVENT_ADD_CAPTURE:String = "MEvent_Add_Capture";
		public function MEvent_Add_Capture($action:String=null)
		{
			super($action);
		}
	}
}