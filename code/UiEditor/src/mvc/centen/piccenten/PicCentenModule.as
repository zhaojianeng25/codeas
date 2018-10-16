package  mvc.centen.piccenten
{
	import com.zcp.frame.Module;
	
	public class PicCentenModule extends Module
	{
		public function PicCentenModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new PicCentenProcessor(this),
			]
		}
	}
}