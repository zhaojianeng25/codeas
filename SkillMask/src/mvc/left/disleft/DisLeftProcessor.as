package mvc.left.disleft
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	
	import common.msg.event.engineConfig.MEventStageResize;
	
	import manager.LayerManager;
	
	import mvc.centen.discenten.DisCentenEvent;
	import mvc.scene.UiSceneEvent;
	
	public class DisLeftProcessor extends Processor
	{
		private var _rightPanel:DisLeftPanel;
		public function DisLeftProcessor($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				DisLeftEvent,
				UiSceneEvent,
				DisCentenEvent,
				MEventStageResize,
				
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case DisLeftEvent:
					if($me.action==DisLeftEvent.SHOW_RIGHT){
						showHide()
					}
				
					break;
				case UiSceneEvent:
					if($me.action==UiSceneEvent.REFRESH_SCENE_DATA){
						refreshSceneData()
					}
					
					break;
				case DisCentenEvent:
					if($me.action==DisCentenEvent.REFRESH_SELECT_FILENODE){
						refreshSelectFileNode()
					}
					break;
				case MEventStageResize:
					resize($me as MEventStageResize)
					break;
			}
		}
		
		private function resize($mEventStageResize:MEventStageResize):void
		{
			if(_rightPanel){
				_rightPanel.onSize()
			}
		
			
		}
		private function refreshSelectFileNode():void
		{
			_rightPanel.refreshSelect();
			
		}
		private function refreshSceneData():void
		{
			_rightPanel.resetInfoArr();
			
		}
		public function showHide():void
		{
			if(!_rightPanel){
				_rightPanel = new DisLeftPanel;
			}
			return 
			_rightPanel.init(this,"分割",4);
			LayerManager.getInstance().addPanel(_rightPanel);
			
		}
	}
}


