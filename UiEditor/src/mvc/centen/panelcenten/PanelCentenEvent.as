package mvc.centen.panelcenten
{
	import com.zcp.frame.event.ModuleEvent;
	
	import mvc.left.panelleft.vo.PanelRectInfoNode;
	
	public class PanelCentenEvent extends ModuleEvent
	{
		public static const SHOW_UI_PANNEL:String = "SHOW_UI_PANNEL";
		public static const SELECT_PANEL_INFO_NODE:String = "SELECT_PANEL_INFO_NODE";
		public static const PANEL_RECT_INFO_START_MOVE:String = "PANEL_RECT_INFO_START_MOVE";
		
		public static const REFRESH_PANEL_RECT_INFO_SIZE_VIEW:String = "REFRESH_PANEL_RECT_INFO_SIZE_VIEW";
		
		public static const REFRESH_PANEL_RECT_INFO_SELECT_ITEM:String = "REFRESH_PANEL_RECT_INFO_SELECT_ITEM";
		
		public var selectItem:Vector.<PanelRectInfoNode>
		
		public var panelRectInfoNode:PanelRectInfoNode;
		public var shiftKey:Boolean;
		public var ctrlKey:Boolean;

		public function PanelCentenEvent($action:String=null)
		{
			super($action);
		}
	}
}