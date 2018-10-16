package mvc.scene
{
	import com.zcp.frame.Module;
	
	public class UiSceneModule extends Module
	{
		public function UiSceneModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new UiSceneProcessor(this),
			]
		}
	}
}