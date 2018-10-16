package common.msg.event.hierarchy
{
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.filesystem.File;
	
	public class MEvent_Hierarchy_ReFileName extends ModuleEvent
	{
		public static var MEVENT_HIERARCHY_REFILENAME:String = "MEvent_Hierarchy_ReFileName";
		public  var file:File
		public function MEvent_Hierarchy_ReFileName($action:String=null)
		{
			super($action);
		}
	}
}