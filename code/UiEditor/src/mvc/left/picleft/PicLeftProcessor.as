package mvc.left.picleft
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	
	import common.msg.event.engineConfig.MEventStageResize;
	
	import manager.LayerManager;
	
	import mvc.centen.discenten.DisCentenEvent;
	import mvc.scene.UiSceneEvent;
	
	public class PicLeftProcessor extends Processor
	{
		private var _picLeftPanel:PicLeftPanel;
		public function PicLeftProcessor($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				PicLeftEvent,
				UiSceneEvent,
				DisCentenEvent,
				MEventStageResize,
				
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
	
			switch($me.getClass()) {
				case PicLeftEvent:
					if($me.action==PicLeftEvent.SHOW_PIC_LEFT){
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

					break;
			}
		}
		
		private function refreshSelectFileNode():void
		{
			if(_picLeftPanel){
				_picLeftPanel.refreshSelect();
			}
		}
		
		private function refreshSceneData():void
		{
			if(_picLeftPanel){
				_picLeftPanel.resetInfoArr();
			}
		}
		
		public function showHide():void
		{
			if(!_picLeftPanel){
				_picLeftPanel = new PicLeftPanel;
			}
			_picLeftPanel.init(this,"添加",4);
			LayerManager.getInstance().addPanel(_picLeftPanel);
			
		}
	}
}


