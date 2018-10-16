package mvc.project
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class ProjectEvent extends ModuleEvent
	{
		public static const OPEN_PROJECT_FILE:String = "OPEN_PROJECT_FILE";
		public var url:String
		public function ProjectEvent($action:String=null)
		{
			super($action);
		}
	}
}