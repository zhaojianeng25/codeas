package common.msg.event.grass
{
	import common.msg.event.MEvent_baseShowHidePanel;
	
	public class MEvent_ShowGrass extends MEvent_baseShowHidePanel
	{
		public function MEvent_ShowGrass($action:String=AUTO)
		{
			super($action);
		}
	}
}