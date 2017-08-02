package mvc.left.disleft
{
	import com.zcp.frame.Module;
	
	public class DisLeftModule extends Module
	{
		public function DisLeftModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new DisLeftProcessor(this),
			]
		}
	}
}