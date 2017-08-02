package modules.menu
{
	import com.zcp.frame.Module;
	
	import modules.menu.view.MenuProcessor;
	
	public class MenuModule extends Module
	{
		public function MenuModule()
		{
			super();
		}
		
		override protected function listProcessors():Array
		{
			return [
				new MenuProcessor(this)
			]
		}
		
		
	}
}