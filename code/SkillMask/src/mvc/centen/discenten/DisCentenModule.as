package mvc.centen.discenten
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