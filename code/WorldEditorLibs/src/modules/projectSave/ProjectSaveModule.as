package modules.projectSave
{
	import com.zcp.frame.Module;
	
	public class ProjectSaveModule extends Module
	{
		public function ProjectSaveModule()
		{
			super();
		}
		
		override protected function listProcessors():Array
		{
			return [
				//new SceneCtrlProcessor(this),
				//new ScenePropProcessor(this)
				new ProjectSaveProcess(this)
			]
		}
		
	}
}