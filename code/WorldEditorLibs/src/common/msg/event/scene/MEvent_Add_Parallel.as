package common.msg.event.scene
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_Add_Parallel extends ModuleEvent
	{
		public static var MEVENT_ADD_PARALLEL:String = "MEvent_Add_Parallel";
		public function MEvent_Add_Parallel($action:String=null)
		{
			super($action);
		}
	}
}