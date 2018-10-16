package common.msg.event.hierarchy
{
	import com.zcp.frame.event.ModuleEvent;
	
	import pack.HierarchyGroupMesh;
	
	public class MEvent_Hierarchy_Group_Model_hide extends ModuleEvent
	{
		public static var MEVENT_HIERARCHY_GROUP_MODEL_HIDE:String = "MEVENT_HIERARCHY_GROUP_MODEL_HIDE";

		public var hierarchyGroupMesh:HierarchyGroupMesh
		public function MEvent_Hierarchy_Group_Model_hide($action:String=null)
		{
			super($action);
		}
	}
}