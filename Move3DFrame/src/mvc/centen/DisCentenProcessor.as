package mvc.centen
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	
	import _me.Scene_data;
	
	import common.msg.event.engineConfig.MEventStageResize;
	import common.msg.event.engineConfig.MEvent_Config;
	
	import manager.LayerManager;
	
	import mvc.project.ProjectEvent;
	import mvc.scene.UiSceneEvent;
	
	import proxy.top.render.Render;
	
	public class DisCentenProcessor extends Processor
	{
		private var _centenPanel:DisCentenPanel;
		public function DisCentenProcessor($module:Module)
		{
			super($module);

			
	
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				DisCentenEvent,
				MEventStageResize,
				ProjectEvent,
				UiSceneEvent,
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case DisCentenEvent:
					if($me.action==DisCentenEvent.SHOW_CENTEN){
						showHide()
					}
					break;
				case MEventStageResize:
					resize($me as MEventStageResize)
					
					break;
			}
			

		
		}
	
		private function resize(evt:MEventStageResize):void
		{
			if(_centenPanel){
				_centenPanel.onSize()
			}
			if(Scene_data.context3D){
				Render.changeStage3DView(evt.xpos,evt.ypos,evt.width,evt.height)
			}
		}		

		public function showHide():void
		{
			if(!_centenPanel){
				_centenPanel = new DisCentenPanel;
			}
			_centenPanel.init(this,"中",1);
			LayerManager.getInstance().addPanel(_centenPanel);
	
		}
	}
}