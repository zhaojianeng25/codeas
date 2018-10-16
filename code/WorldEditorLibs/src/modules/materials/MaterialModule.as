package modules.materials
{
	import com.zcp.frame.Module;
	
	public class MaterialModule extends Module
	{
		public function MaterialModule()
		{
			super();
		}
		
		override protected function listProcessors():Array
		{
			return [
				new MaterialProcessor(this)
			]
		}
		
	}
}