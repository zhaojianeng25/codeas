package common.msg.event.prefabs
{
	import com.zcp.frame.event.ModuleEvent;
	
	import pack.PrefabStaticMesh;
	
	public class MEvent_Prefab extends ModuleEvent
	{
		public static var MEVENT_PREFAB_CREATNEW:String = "MEvent_Prefab_CreatNew";
		public static var MEVENT_PREFAB_SHOW:String = "MEvent_prefab_show";
		
		public var url:String;
		public var name:String;
		public var prefabStaticMesh:PrefabStaticMesh
		public function MEvent_Prefab($action:String=null)
		{
			super($action);
		}
	}
}