package common.msg.event.scene
{
	import common.msg.event.MEvent_baseShowHidePanel;
	
	public class MEvent_ShowSceneCtrl extends MEvent_baseShowHidePanel
	{
		public function MEvent_ShowSceneCtrl($action:String=AUTO)
		{
			super($action);
		}
	}
}