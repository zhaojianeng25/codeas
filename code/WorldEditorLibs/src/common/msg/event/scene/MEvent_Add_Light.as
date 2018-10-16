package common.msg.event.scene
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_Add_Light extends ModuleEvent
	{
		public static var MEVENT_ADD_LIGHT:String = "MEvent_Add_Light";

		public function MEvent_Add_Light($action:String=null)
		{
			super($action);
		}
	}
}