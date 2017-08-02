package common.msg.event.grass
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_addGrass extends ModuleEvent
	{
		public static const ADD_GRASS:String = "ADD_GRASS";
		public var url:String
		public function MEvent_addGrass($action:String=null)
		{
			super($action);
		}
	}
}