package common.msg.event.scene
{
	import common.msg.event.MEvent_baseShowHidePanel;
	
	public class MEvent_ShowSceneProp extends MEvent_baseShowHidePanel
	{
		public function MEvent_ShowSceneProp($action:String=AUTO)
		{
			super($action);
		}
	}
}