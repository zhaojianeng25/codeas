package common.msg.event.hierarchy
{
	import com.zcp.frame.event.ModuleEvent;
	
	import common.utils.ui.file.FileNode;
	
	public class MEvent_Hierarchy_Dele extends ModuleEvent
	{
		public static var MEVENT_HIERARCHY_DELE:String = "MEvent_Hierarchy_Dele";
		public var fileNode:FileNode
		public function MEvent_Hierarchy_Dele($action:String=null)
		{
			super($action);
		}
	}
}