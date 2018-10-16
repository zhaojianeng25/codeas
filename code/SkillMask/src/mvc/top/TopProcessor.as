package mvc.top
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	
	public class TopProcessor extends Processor
	{
		private var _topPanel:TopPanel;
		private var _menu:TopMenuView;
		public function TopProcessor($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				TopEvent,
				
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case TopEvent:
					if($me.action==TopEvent.SHOW_TOP){
						showHide()
					}
					break;
			}
		}


		public function showHide():void
		{
			if(!_menu){
				_menu = new TopMenuView();
			}
			_menu.showMenu();
			
		}
	}
}