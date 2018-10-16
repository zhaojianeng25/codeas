package modules.hierarchy
{
	import com.zcp.frame.Module;
	
	import modules.prefabs.PrefabProcessor;
	
	public class HierarchyModule extends Module
	{
		public function HierarchyModule()
		{
			super();
		}
		
		override protected function listProcessors():Array
		{
			return [
				new HierarchyProcessor(this)
			]
		}
		
	}
}