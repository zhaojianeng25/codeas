package common.msg.event.terrain
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_init_Terrain extends ModuleEvent
	{
		
		public static const MEVENT_INIT_TERRAIN:String = "MEvent_init_Terrain";
		
		public var w:int;
		public var h:int;
	
		public function MEvent_init_Terrain($action:String=null)
		{
			super($action);
		}
	}
}