package common.msg.event.scene
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_Add_Grass extends ModuleEvent
	{
		public static var MEVENT_ADD_GRASS:String = "MEvent_Add_Grass";
		public function MEvent_Add_Grass($action:String=null)
		{
			super($action);
		}
	}
}