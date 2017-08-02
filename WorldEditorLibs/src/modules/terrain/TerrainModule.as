package modules.terrain
{
	import com.zcp.frame.Module;
	
	public class TerrainModule extends Module
	{
		public function TerrainModule()
		{
			super();
		}
		
		override protected function listProcessors():Array
		{
			return [
				new TerrainProcessor(this),
			]
		}
	}
}