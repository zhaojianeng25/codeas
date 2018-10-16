package modules.menu
{
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.utils.ByteArray;
	
	public class MenuTempEvent extends ModuleEvent
	{
		public static var SET_C_DATA_RENDER_FILE:String = "SET_C_DATA_RENDER_FILE";
		public var byte:ByteArray
		public function MenuTempEvent($action:String=null)
		{
			super($action);
		}
	}
}