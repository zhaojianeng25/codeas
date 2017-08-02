package common.msg.event.scene
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_Radiosity_To_C extends ModuleEvent
	{
		public static var MEVENT_RADIOSITY_TO_C:String="MEVENT_RADIOSITY_TO_C";
		public function MEvent_Radiosity_To_C($action:String=null)
		{
			super($action);
		}
	}
}