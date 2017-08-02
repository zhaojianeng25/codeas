package common.msg.event.grass
{
	import com.zcp.frame.event.ModuleEvent;
	
	import common.utils.ui.file.FileNode;
	
	public class MEvent_deleGrass extends ModuleEvent
	{
		public static const DELE_GRASS:String="DELE_GRASS"
		public var fileNode:FileNode
		public function MEvent_deleGrass($action:String=null)
		{
			super($action);
		}
	}
}