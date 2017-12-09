package mvc.libray
{
	import com.zcp.frame.event.ModuleEvent;

	public class LibraryEvent extends ModuleEvent
	{
		public static const SHOW_RIGHT:String = "SHOWRIGHT";
		
		public static var MEVENT_LIBRAY_MOVENODE:String = "MEVENT_LIBRAY_MOVENODE";
		public static var MEVENT_LIBRAY_DELENODE:String = "MEVENT_LIBRAY_DELENODE";
		public static var MEVENT_LIBRAY_REFRISHNAME:String = "MEVENT_LIBRAY_REFRISHNAME";
		public var moveNode:LibrayFildNode
		public var toNode:LibrayFildNode
		public var fileNode:LibrayFildNode
		
		public function LibraryEvent($action:String=null)
		{
			super($action);
		}
	}
}