package common.msg.event.scene
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class Mevent_ExpToH5_Event extends ModuleEvent
	{
		public static var MEVENT_EXPTOH5_EVENT:String = "Mevent_ExpToH5_Event";
		public static var CANCEL_MERGE_SCENE:String="Cancel_Megre_scene"
		public static var EVENT_COMBINE_LIGHT_H5:String = "event_combine_light_h5";
		public var data:Object;
		public function Mevent_ExpToH5_Event($action:String=null)
		{
			super($action);
		}
	}
}