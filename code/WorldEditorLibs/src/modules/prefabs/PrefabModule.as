package modules.prefabs
{
	import com.zcp.frame.Module;
	
	public class PrefabModule extends Module
	{
		public function PrefabModule()
		{
			super();
		}
		
		override protected function listProcessors():Array
		{
			return [
				new PrefabProcessor(this)
			]
		}
		
		
	}
}