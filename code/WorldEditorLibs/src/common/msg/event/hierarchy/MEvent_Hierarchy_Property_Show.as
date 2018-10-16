package common.msg.event.hierarchy
{
	import com.zcp.frame.event.ModuleEvent;
	
	import proxy.top.model.IModel;
	
	import xyz.draw.TooXyzMoveData;
	
	public class MEvent_Hierarchy_Property_Show extends ModuleEvent
	{
		public static var MEVENT_HIERARCHY_PROPERTY_SHOW:String = "MEvent_Hierarchy_Property_Show";
		public var modeItem:Vector.<IModel>
		public var selectType:uint
		public var tooXyzMoveData:TooXyzMoveData
		public function MEvent_Hierarchy_Property_Show($action:String=null)
		{
			super($action);
		}
	}
}