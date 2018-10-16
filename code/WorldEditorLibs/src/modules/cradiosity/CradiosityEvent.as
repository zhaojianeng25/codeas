package modules.cradiosity
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class CradiosityEvent extends ModuleEvent
	{
		public static var SHOW_RADIOSITY_C_PROJECT:String = "SHOW_RADIOSITY_C_PROJECT";
		
		public function CradiosityEvent($action:String=null)
		{
			super($action);
		}
	}
}