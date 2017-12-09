package mvc.top
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class TopEvent extends ModuleEvent
	{
		public static const SHOW_TOP:String = "SHOW_TOP";
		public static const SAVE_FILE:String = "SAVE_FILE";
		public function TopEvent($action:String=null)
		{
			super($action);
		}
	}
}