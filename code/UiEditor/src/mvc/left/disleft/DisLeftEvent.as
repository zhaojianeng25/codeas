package mvc.left.disleft
{
	import com.zcp.frame.event.ModuleEvent;

	public class DisLeftEvent extends ModuleEvent
	{
		public static const SHOW_RIGHT:String = "SHOWRIGHT";
		public function DisLeftEvent($action:String=null)
		{
			super($action);
		}
	}
}