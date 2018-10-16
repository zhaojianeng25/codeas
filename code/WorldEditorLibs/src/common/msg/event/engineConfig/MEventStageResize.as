package common.msg.event.engineConfig
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEventStageResize extends ModuleEvent
	{
		public static const MEVENT_STAGE_RESIZE:String = "MEventStageResize";
		
		public var xpos:int;
		public var ypos:int;
		public var width:int;
		public var height:int;
		
		public function MEventStageResize($action:String=null)
		{
			super($action);
		}
	}
}