package mvc.top
{
	import com.zcp.frame.Module;
	
	public class TopModule extends Module
	{
		public function TopModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new TopProcessor(this),
			]
		}
	}
}