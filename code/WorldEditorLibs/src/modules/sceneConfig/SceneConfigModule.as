package modules.sceneConfig
{
	import com.zcp.frame.Module;
	

	
	public class SceneConfigModule extends Module
	{
		public function SceneConfigModule()
		{
			super();
		}
		
		override protected function listProcessors():Array
		{
			return [
				new SceneConfigProcessor(this)
			]
		}
		
		
	}
}


