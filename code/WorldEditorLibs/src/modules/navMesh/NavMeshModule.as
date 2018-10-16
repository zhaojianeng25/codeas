package modules.navMesh
{
	import com.zcp.frame.Module;
	
	public class NavMeshModule extends Module
	{
		public function NavMeshModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new NavMeshProcessor(this)
			]
		}
	}
}