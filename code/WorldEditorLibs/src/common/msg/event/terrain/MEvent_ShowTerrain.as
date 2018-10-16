package common.msg.event.terrain
{
	import common.msg.event.MEvent_baseShowHidePanel;
	
	public class MEvent_ShowTerrain extends MEvent_baseShowHidePanel
	{
		public function MEvent_ShowTerrain($action:String="0")
		{
			super($action);
		}
	}
}