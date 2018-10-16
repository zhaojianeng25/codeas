package modules.scene
{
	import com.zcp.frame.Module;
	
	import modules.scene.scenProp.ScenePropProcessor;
	import modules.scene.sceneCtrl.SceneCtrlProcessor;
	
	public class SceneModule extends Module
	{
		public function SceneModule()
		{
			super();
			
		}
		
		override protected function listProcessors():Array
		{
			return [
				new SceneCtrlProcessor(this),
				new ScenePropProcessor(this)
			]
		}
	}
}