package common.msg.event.menu
{
	import common.msg.event.MEvent_baseShowHidePanel;
	
	public class MEvent_ShowMenu extends MEvent_baseShowHidePanel
	{
		public function MEvent_ShowMenu($action:String=AUTO)
		{
			super($action);
		}
	}
}