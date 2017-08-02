package modules.roles
{
	import com.zcp.frame.Module;
	
	public class RoleModule extends Module
	{
		public function RoleModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new RoleProcessor(this)
			]
		}
	}
}


