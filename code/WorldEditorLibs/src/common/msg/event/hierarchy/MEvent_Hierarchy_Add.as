package common.msg.event.hierarchy
{
	import com.zcp.frame.event.ModuleEvent;
	
	import common.utils.ui.file.FileNode;
	
	public class MEvent_Hierarchy_Add extends ModuleEvent
	{
		public static var MEVENT_HIERARCHY_ADD:String = "MEvent_Hierarchy_Add";
		public var fileNode:FileNode
		public var toFileNode:FileNode
		public function MEvent_Hierarchy_Add($action:String=null)
		{
			super($action);
		}
	}
}