package mvc.left.panelleft
{
	import com.zcp.frame.Module;
	
	public class PanelLeftModule extends Module
	{
		public function PanelLeftModule()
		{
			super();
		}
		
		override protected function listProcessors():Array
		{
			return [
				new PanelLeftProcessor(this),
			]
		}
	}
}


