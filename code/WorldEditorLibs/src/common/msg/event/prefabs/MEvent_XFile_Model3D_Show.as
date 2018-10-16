package common.msg.event.prefabs
{
	import com.zcp.frame.event.ModuleEvent;
	
	import mode3d.XFileMode3DStaticMesh;
	
	public class MEvent_XFile_Model3D_Show extends ModuleEvent
	{
		public static var MEVENT_XFILE_MODEL3D_SHOW:String = "MEvent_XFile_Model3D_Show";
		public var xFileMode3DStaticMesh:XFileMode3DStaticMesh
		public function MEvent_XFile_Model3D_Show($action:String=null)
		{
			super($action);
		}
	}
}