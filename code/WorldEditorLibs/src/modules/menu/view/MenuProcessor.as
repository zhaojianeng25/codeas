package modules.menu.view
{
	import com.zcp.frame.Module;
	import com.zcp.frame.event.ModuleEvent;
	
	import common.msg.event.MEvent_baseShowHidePanel;
	import common.msg.event.menu.MEvent_ShowMenu;
	import common.utils.frame.BaseProcessor;
	
	import flashx.textLayout.elements.BreakElement;
	
	import modules.menu.MenuReadyEvent;
	import modules.menu.MenuTempEvent;
	
	public class MenuProcessor extends BaseProcessor
	{
		private var _menu:MenuView;
		public function MenuProcessor($module:Module)
		{
			super($module);
		}
		
		public function get menu():MenuView
		{
			if(!_menu){
				_menu = new MenuView();
				_menu.init(this);
			}
			return _menu;
		}


		override public function showHide($me:MEvent_baseShowHidePanel):void
		{
			if($me.action == MEvent_baseShowHidePanel.SHOW){
				menu.showMenu();
			}
		}
		
		override protected function listenModuleEvents():Array 
		{
			return [
				MEvent_ShowMenu,
				MenuTempEvent,
				MenuReadyEvent,
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case MEvent_ShowMenu:
					showHide($me as MEvent_ShowMenu);
					break;
				case MenuTempEvent:
					if($me.action == MenuTempEvent.SET_C_DATA_RENDER_FILE){
						trace("收到的内容",MenuTempEvent(	$me ).byte.length)
						this._menu.sendScneToCplusRender(MenuTempEvent($me).byte);
					}
					break;
				case MenuReadyEvent:
					this._menu.renderCplusScene();  
					break;
			}
		}
		
		
	}
}