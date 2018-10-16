package common.msg.event.hierarchy
{
	import com.zcp.frame.event.ModuleEvent;
	
	import common.utils.ui.file.FileNode;
	
	public class MEvent_Hierarchy_Build_Group extends ModuleEvent
	{
		public static var MEVENT_HIERARCHY_BUILD_GROUP:String = "MEvent_Hierarchy_Build_Group";
		public var fileNode:FileNode
		public var fileRoot:String
		public function MEvent_Hierarchy_Build_Group($action:String=null)
		{
			super($action);
		}
	}
}