package modules.enginConfig
{
	import com.zcp.frame.Module;
	
	public class EngineConfigModule extends Module
	{
		public function EngineConfigModule()
		{
			super();
		}
		
		override protected function listProcessors():Array
		{
			return [
				new EngineConfigProcessor(this),
			]
		}
		
	}
}