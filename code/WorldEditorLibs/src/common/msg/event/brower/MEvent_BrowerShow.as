package common.msg.event.brower
{
	import common.msg.event.MEvent_baseShowHidePanel;
	
	public class MEvent_BrowerShow extends MEvent_baseShowHidePanel
	{
		public static var BROWER_CHANGE:String = "Brower_change";
		public function MEvent_BrowerShow($action:String="0")
		{
			super($action);
		}
	}
}