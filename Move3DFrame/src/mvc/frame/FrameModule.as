package mvc.frame
{
	import com.zcp.frame.Module;
	
	public class FrameModule extends Module
	{
		public function FrameModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new FrameProcessor(this),
			]
		}
	}
}


