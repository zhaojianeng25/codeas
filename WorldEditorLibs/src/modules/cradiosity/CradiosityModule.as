package modules.cradiosity
{
	import com.zcp.frame.Module;
	
	public class CradiosityModule extends Module
	{
		public function CradiosityModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new CradiosityProcessor(this)
			]
		}
	}
}


