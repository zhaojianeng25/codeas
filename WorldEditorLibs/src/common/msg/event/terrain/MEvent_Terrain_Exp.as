package common.msg.event.terrain
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_Terrain_Exp extends ModuleEvent
	{
		public static const TERRAIN_EXP_OBJ:String = "terrain_exp_obj";
		public static const TERRAIN_EXP_BYTE:String = "terrain_exp_byte"
		public static const TERRAIN_EXP_A3D:String = "terrain_exp_a3d"

		
		public function MEvent_Terrain_Exp($action:String=null)
		{
			super($action);
		}
	}
}