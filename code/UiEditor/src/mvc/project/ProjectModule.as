package mvc.project
{
	import com.zcp.frame.Module;
	
	public class ProjectModule extends Module
	{
		public function ProjectModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new ProjectProcessor(this),
			]
		}
	}
}