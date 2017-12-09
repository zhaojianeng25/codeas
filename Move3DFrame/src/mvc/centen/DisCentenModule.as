package mvc.centen
{
	import com.zcp.frame.Module;
	
	public class DisCentenModule extends Module
	{
		public function DisCentenModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new DisCentenProcessor(this),
			]
		}
	}
}