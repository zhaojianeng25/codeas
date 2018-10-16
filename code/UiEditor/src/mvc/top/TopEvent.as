package mvc.top
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class TopEvent extends ModuleEvent
	{
		public static const SHOW_TOP:String = "SHOW_TOP";
		public function TopEvent($action:String=null)
		{
			super($action);
		}
	}
}