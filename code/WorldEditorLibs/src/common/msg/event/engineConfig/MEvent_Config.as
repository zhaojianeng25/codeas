package common.msg.event.engineConfig
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_Config extends ModuleEvent
	{
		public static const MEVENT_CONFIG:String = "MEvent_Config";
		public function MEvent_Config($action:String=null)
		{
			super($action);
		}
	}
}