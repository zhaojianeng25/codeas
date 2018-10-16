package modules.menu
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MenuReadyEvent extends ModuleEvent
	{
		
		public static var MENU_READY_EVENT:String = "Menu_Ready_Event";
		
		public function MenuReadyEvent($action:String=null)
		{
			super($action);
		}
	}
}