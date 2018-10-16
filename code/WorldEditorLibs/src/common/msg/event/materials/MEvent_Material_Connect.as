package common.msg.event.materials
{
	import com.zcp.frame.event.ModuleEvent;
	
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialNodeLineUI;
	
	public class MEvent_Material_Connect extends ModuleEvent
	{
		public static var MEVENT_MATERIAL_CONNECT_STARTDRAG:String = "MEvent_Material_Connect_startDrag";
		public static var MEVENT_MATERIAL_CONNECT_STOPDRAG:String = "MEvent_Material_Connect_stopDrag";
		public static var MEVENT_MATERIAL_CONNECT_REMOVELINE:String = "MEvent_Material_Connect_removeLine";
		public static var MEVENT_MATERIAL_CONNECT_DOUBLUELINE:String = "MEvent_Material_Connect_doublueLine";
		
		public var itemNode:ItemMaterialUI;
		public var line:MaterialNodeLineUI;
		
		public var startNode:ItemMaterialUI;
		public var endNode:ItemMaterialUI;
		public function MEvent_Material_Connect($action:String=null)
		{
			super($action);
		}
	}
}