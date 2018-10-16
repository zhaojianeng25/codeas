package common.msg.event.hierarchy
{
	import com.zcp.frame.event.ModuleEvent;
	
	import common.utils.ui.file.FileNode;
	
	public class MEvent_Hierarchy_Reset extends ModuleEvent
	{
		public static var MEVENT_HIERARCHY_RESET:String = "MEvent_Hierarchy_Reset";
		public var fileNode:FileNode
		public function MEvent_Hierarchy_Reset($action:String=null)
		{
			super($action);
		}
	}
}