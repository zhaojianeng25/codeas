package common.msg.event.prefabs
{
	import com.zcp.frame.event.ModuleEvent;
	
	import mode3d.XFileBoneStaticMesh;
	
	public class MEvent_XFile_Bone_Show extends ModuleEvent
	{
		
		public static var MEVENT_XFILE_BONE_SHOW:String = "MEvent_XFile_Bone_Show";
		public var xFileBoneStaticMesh:XFileBoneStaticMesh
		public function MEvent_XFile_Bone_Show($action:String=null)
		{
			super($action);
		}
	}
}