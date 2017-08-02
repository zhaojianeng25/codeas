package common.msg.event.prefabs
{
	import com.zcp.frame.event.ModuleEvent;
	
	import mode3d.Model3DStaticMesh;

	public class Mevent_Model3D_Show extends ModuleEvent
	{
		public static var MEVENT_MODEL3D_SHOW:String = "Mevent_Model3D_Show";
		public var model3DStaticMesh:Model3DStaticMesh
		public function Mevent_Model3D_Show($action:String=null)
		{
			super($action);
		}
	}
}