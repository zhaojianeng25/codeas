package modules.collision
{
	import com.zcp.frame.Module;
	
	public class CollisionModule extends Module
	{
		public function CollisionModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new CollisionProcessor(this)
			]
		}
	}
}