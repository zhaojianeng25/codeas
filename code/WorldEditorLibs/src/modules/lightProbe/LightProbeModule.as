package modules.lightProbe
{
	import com.zcp.frame.Module;
	
	public class LightProbeModule extends Module
	{
		public function LightProbeModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new LightProbeProcessor(this)
			]
		}
	}
}