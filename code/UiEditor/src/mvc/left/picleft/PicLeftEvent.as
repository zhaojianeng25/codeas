package mvc.left.picleft
{
	import com.zcp.frame.event.ModuleEvent;

	public class PicLeftEvent extends ModuleEvent
	{
		public static const SHOW_PIC_LEFT:String = "SHOW_PIC_LEFT";
		public function PicLeftEvent($action:String=null)
		{
			super($action);
		}
	}
}

