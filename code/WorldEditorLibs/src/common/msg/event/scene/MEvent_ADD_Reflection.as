package common.msg.event.scene
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_ADD_Reflection extends ModuleEvent
	{
		public static var MEVENT_ADD_REFLECTION:String = "MEvent_Add_Reflection";
		public function MEvent_ADD_Reflection($action:String=null)
		{
			super($action);
		}
	}
}