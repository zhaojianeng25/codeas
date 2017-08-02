package common.msg.event.scene
{
	import com.zcp.frame.event.ModuleEvent;
	
	import proxy.top.model.IModel;
	
	public class MEvent_Show_Imodel extends  ModuleEvent
	{
		public static var MEVENT_SHOW_IMODEL:String = "MEvent_Show_Imodel";
		public static var MEVENT_SELECT_ITEM_IMODEL:String = "MEvent_Select_item_Imodel";
		public var iModel:IModel
		public var item:Vector.<IModel>;
		public var shiftKey:Boolean;
		public function MEvent_Show_Imodel($action:String="0")
		{
			super($action);
		}
	}
}