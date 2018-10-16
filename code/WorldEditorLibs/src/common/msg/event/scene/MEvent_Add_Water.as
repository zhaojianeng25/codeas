package common.msg.event.scene
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_Add_Water extends ModuleEvent
	{
		public static var MEVENT_ADD_WATER:String = "MEvent_Add_Water";
		public function MEvent_Add_Water($action:String=null)
		{
			super($action);
		}
	}
}