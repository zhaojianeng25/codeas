package common.msg.event
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_MainOperate extends ModuleEvent
	{
		public static var TERRAIN_HEIGHT_OPERATE:String = "terrain_height_operate";
		public static var TERRAIN_GRASS_OPERATE:String = "terrain_grass_operate";
		public static var DEFAULT_OPERATE:String = "Default_operate";
		
		public function MEvent_MainOperate($action:String=null)
		{
			super($action);
		}
	}
}