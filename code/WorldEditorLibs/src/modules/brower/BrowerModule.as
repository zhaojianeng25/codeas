package modules.brower
{
	import com.zcp.frame.Module;
	
	public class BrowerModule extends Module
	{
		public function BrowerModule()
		{
			super();
		}
		
		override protected function listProcessors():Array
		{
			return [
				new BrowerProcessor(this),
			]
		}
	}
}