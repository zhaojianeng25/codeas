package modules.navMesh
{
	import com.zcp.frame.event.ModuleEvent;
	
	import common.utils.ui.navMesh.NavMeshNode;
	
	import modules.hierarchy.HierarchyFileNode;
	
	public class NavMeshEvent extends ModuleEvent
	{
		
		public static var MEVEN_ADD_NAVMESH:String = "meven_add_navmesh";
		public static var SELECT_NAVMESH_NODE:String = "select_navmesh_node";
		public static var RESET_NAVMESH_SPRITE:String="rest_navmesh_sprite";
		public static var SELECT_NAVEMESH_NODE_MOVE:String="select_navmesh_node_move";
		public static var SHOW_NAVMESH_TRI_LINE:String="show_navmesh_tri_line";
		public static var SHOW_NAVMESH_START_LINE:String="show_navmesh_start_line";
			

		public var navMeshNode:NavMeshNode	
		public var hierarchyFileNode:HierarchyFileNode
		public function NavMeshEvent($action:String=null)
		{
			super($action);
		}
	}
}