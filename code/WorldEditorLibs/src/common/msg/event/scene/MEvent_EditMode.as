package common.msg.event.scene
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_EditMode extends ModuleEvent
	{
		public static var MEVENT_EDITMODE_CHANGE:String = "MEVENT_EDITMODE_CHANGE";
		
		public var mode:String;
		public function MEvent_EditMode($action:String=null)
		{
			super($action);
		}
	}
}