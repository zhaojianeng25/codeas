package mvc.scene
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	
	import manager.LayerManager;
	
	import mvc.centen.DisCentenEvent;
	
	public class UiSceneProcessor extends Processor
	{
		private var _uiScenePanel:UiScenePanel;


		public function UiSceneProcessor($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				DisCentenEvent,
				UiSceneEvent,
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case UiSceneEvent:
					if($me.action==UiSceneEvent.SHOW_UI_SCENE){
						showuiscene()
					}
					if($me.action==UiSceneEvent.REFRESH_SCENE_DATA){
						refreshSceneData()
					}
					break;

				
			}
		}
		private function refreshSceneData():void
		{
			_uiScenePanel.refreshSceneData()
		}
		public function showuiscene():void
		{
			if(!_uiScenePanel){
				_uiScenePanel = new UiScenePanel;
			}
			_uiScenePanel.init(this,"属性",2);
			LayerManager.getInstance().addPanel(_uiScenePanel);
			
		}
		
	}
}