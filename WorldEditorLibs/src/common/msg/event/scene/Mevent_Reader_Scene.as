package common.msg.event.scene
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class Mevent_Reader_Scene extends ModuleEvent
	{
		public static var MEVENT_READER_SCENE:String = "Mevent_Reader_Scene";
		public function Mevent_Reader_Scene($action:String=null)
		{
			super($action);
		}
	}
}