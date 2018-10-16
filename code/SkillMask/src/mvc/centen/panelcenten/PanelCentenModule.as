package mvc.centen.panelcenten
{
	import com.zcp.frame.Module;
	
	public class PanelCentenModule extends Module
	{
		public function PanelCentenModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new PanelCentenProcessor(this),
			]
		}
	}
}