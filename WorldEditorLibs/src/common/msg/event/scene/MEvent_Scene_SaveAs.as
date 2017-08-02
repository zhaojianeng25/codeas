package common.msg.event.scene
{
	import com.zcp.frame.event.ModuleEvent;

	public class MEvent_Scene_SaveAs extends ModuleEvent
	{
		public static var MEVENT_SCENE_SAVEAS:String = "MEvent_Scene_SaveAs";
		public function MEvent_Scene_SaveAs($action:String=null)
		{
			super($action);
		}
	}
}


