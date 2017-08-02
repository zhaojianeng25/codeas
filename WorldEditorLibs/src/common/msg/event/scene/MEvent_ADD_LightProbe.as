package common.msg.event.scene
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_ADD_LightProbe extends ModuleEvent
	{
		public static var MEVENT_ADD_LIGHTPROBE:String = "MEvent_ADD_LightProbe";
		public function MEvent_ADD_LightProbe($action:String=null)
		{
			super($action);
		}
	}
}