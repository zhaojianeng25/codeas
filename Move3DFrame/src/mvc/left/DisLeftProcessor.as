package mvc.left
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	
	import common.msg.event.engineConfig.MEventStageResize;
	
	import manager.LayerManager;
	
	import mvc.centen.DisCentenEvent;
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
		
					break;
				case DisCentenEvent:
		
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

		public function showHide():void
		{
			if(!_rightPanel){
				_rightPanel = new DisLeftPanel;
			}
			_rightPanel.init(this,"库",4);
			LayerManager.getInstance().addPanel(_rightPanel);
			
		}
	}
}


