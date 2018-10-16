package common.msg.event.hierarchy
{
	import com.zcp.frame.event.ModuleEvent;
	
	import modules.hierarchy.HierarchyFileNode;
	
	public class MEvent_Hierarchy_MoveNode extends ModuleEvent
	{
		public static var MEVENT_HIERARCHY_MOVENODE:String = "MEvent_Hierarchy_MoveNode";
		public var moveNode:HierarchyFileNode
		public var toNode:HierarchyFileNode
		public function MEvent_Hierarchy_MoveNode($action:String=null)
		{
			super($action);
		}
	}
}