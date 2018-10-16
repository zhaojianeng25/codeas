package mvc.left.panelleft
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	
	import common.msg.event.engineConfig.MEventStageResize;
	
	import manager.LayerManager;
	
	import mvc.centen.panelcenten.PanelCentenEvent;
	import mvc.left.panelleft.vo.PanelNodeVo;
	import mvc.left.panelleft.vo.PanelSkillMaskNode;
	import mvc.scene.UiSceneEvent;
	
	public class PanelLeftProcessor extends Processor
	{
		private var _panelLeftPanel:PanelLeftPanel;
		public function PanelLeftProcessor($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				PanelLeftEvent,
				UiSceneEvent,
				PanelCentenEvent,
				MEventStageResize,

			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case PanelLeftEvent:
					if($me.action==PanelLeftEvent.SHOW_LEFT){
						showHide()
						//willDele()
					}
					if($me.action==PanelLeftEvent.DELE_PANEL_NODE_INFO_VO){
						delePanelNodelVo(PanelLeftEvent($me).panelNodeVo)
					}
					if($me.action==PanelLeftEvent.REFRESH_PANEL_TREE){
				
						_panelLeftPanel.refreshView()
					}
					break;
				case UiSceneEvent:
					if($me.action==UiSceneEvent.REFRESH_SCENE_DATA){
						refreshSceneData()
					}
					break;
				case PanelCentenEvent:
					if($me.action==PanelCentenEvent.REFRESH_PANEL_RECT_INFO_SELECT_ITEM){
						refreshPanelRectInofSelectItem(PanelCentenEvent($me).selectItem)
					}
				
					break;
				case MEventStageResize:

					break;
			}
		}
		
	
		
		
		private function delePanelNodelVo($delNode:PanelNodeVo):void
		{
			for(var i:uint=0;i<PanelModel.getInstance().item.length;i++){
				if(PanelModel.getInstance().item[i]==$delNode){
					PanelModel.getInstance().item.removeItemAt(i)
				}
			}
			_panelLeftPanel.resetInfoArr();
			
			
		}
		
		private function refreshPanelRectInofSelectItem($arr:Vector.<PanelSkillMaskNode>):void
		{
			_panelLeftPanel.selectRectInfoItem=$arr
		}
		private function willDele():void
		{
			var $PanelLeftEvent:PanelLeftEvent=new PanelLeftEvent(PanelLeftEvent.SELECT_PANEL_NODEVO)
			$PanelLeftEvent.panelNodeVo=PanelModel.getInstance().item[0];
			ModuleEventManager.dispatchEvent($PanelLeftEvent);
		}
		
		private function refreshSceneData():void
		{
		
			if(_panelLeftPanel){
				_panelLeftPanel.resetInfoArr();
			}
			
		}
		public function showHide():void
		{
			if(!_panelLeftPanel){
				_panelLeftPanel = new PanelLeftPanel;
			}
			_panelLeftPanel.init(this,"面板",4);
			LayerManager.getInstance().addPanel(_panelLeftPanel);
			
		}
	}
}