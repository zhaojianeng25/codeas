package mvc.centen.panelcenten
{
	import com.zcp.frame.event.ModuleEvent;
	
	import mvc.left.panelleft.vo.PanelNodeVo;
	import mvc.left.panelleft.vo.PanelSkillMaskNode;
	
	public class PanelCentenEvent extends ModuleEvent
	{
		public static const SHOW_UI_PANNEL:String = "SHOW_UI_PANNEL";
		public static const SELECT_PANEL_INFO_NODE:String = "SELECT_PANEL_INFO_NODE";
		public static const PANEL_RECT_INFO_START_MOVE:String = "PANEL_RECT_INFO_START_MOVE";
		
		public static const REFRESH_PANEL_RECT_INFO_SIZE_VIEW:String = "REFRESH_PANEL_RECT_INFO_SIZE_VIEW";
		
		public static const REFRESH_PANEL_RECT_INFO_SELECT_ITEM:String = "REFRESH_PANEL_RECT_INFO_SELECT_ITEM";
		
		public static const EXP_SKILL_MASK_INFO:String = "EXP_SKILL_MASK_INFO";
		
		public var selectItem:Vector.<PanelSkillMaskNode>
		
		public var panelRectInfoNode:PanelSkillMaskNode;
		public var panelNodeVo:PanelNodeVo;
		public var shiftKey:Boolean;
		public var ctrlKey:Boolean;

		public function PanelCentenEvent($action:String=null)
		{
			super($action);
		}
	}
}