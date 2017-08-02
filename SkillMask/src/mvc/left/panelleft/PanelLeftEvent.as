package mvc.left.panelleft
{
	import com.zcp.frame.event.ModuleEvent;
	
	import mvc.left.panelleft.vo.PanelNodeVo;
	import mvc.left.panelleft.vo.PanelSkillMaskNode;
	
	public class PanelLeftEvent extends ModuleEvent
	{
		public static const SHOW_LEFT:String = "SHOWLEFT";
		
		public static const SELECT_PANEL_NODEVO:String = "SELECT_PANEL_NODEVO";
		public static const DELE_PANEL_NODE_INFO_VO:String = "DELE_PANEL_NODE_INFO_VO";
		public static const DELE_PANEL_RECT_NODE_INFO_VO:String = "DELE_PANEL_RECT_NODE_INFO_VO";
		public static const REFRESH_PANEL_TREE:String = "REFRESH_PANEL_TREE";
		
		public var panelNodeVo:PanelNodeVo;
		public var panelRectInfoNode:PanelSkillMaskNode
		
		public function PanelLeftEvent($action:String=null)
		{
			super($action);
		}
	}
}