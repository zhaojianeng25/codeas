package   modules.sceneConfig
{
	import com.zcp.frame.Module;
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	
	import mx.events.AIREvent;
	
	import spark.components.Window;
	
	import _me.Scene_data;
	
	import common.utils.frame.BaseProcessor;
	

 
	
	public class SceneConfigProcessor extends BaseProcessor
	{
		private var _sceneConfigPanel:SceneConfigPanel;

		public function SceneConfigProcessor($module:Module)
		{
			super($module);
		}
		
		override protected function listenModuleEvents():Array 
		{
			return [
				SceneConfigEvent,
	
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case SceneConfigEvent:
					if($me.action == SceneConfigEvent.SHOW_SCENE_CONFIG_PANEL){
						initSceneConfigPanel()
					}
					if($me.action == SceneConfigEvent.CLOSE_CENEN_CONFIG_PANEL){
						closeSceneConfigPanel()
					}
	
					
					break;
			}

			
		}
		
		private function closeSceneConfigPanel():void
		{
			if(_win){
				if(!_win.closed){
					_win.close()
				}
				_win=null
			}
		}
		
		private var _win:Window
		public function initSceneConfigPanel():void
		{
			if(_win&&!_win.closed){
				_win.close()
			}
			_sceneConfigPanel=new SceneConfigPanel
			var $win:Window = new Window;
			$win.transparent=false;
			$win.type=NativeWindowType.NORMAL;
			$win.systemChrome=NativeWindowSystemChrome.STANDARD;
			$win.width= 400;
			$win.height= 400;
			$win.alwaysInFront=false
			$win.resizable=true
			$win.showStatusBar = false;
			
			
			_sceneConfigPanel.setStyle("left",0);
			_sceneConfigPanel.setStyle("right",0);
			_sceneConfigPanel.setStyle("top",0);
			_sceneConfigPanel.setStyle("bottom",0);
			
			$win.addElement(_sceneConfigPanel);
			$win.addEventListener(AIREvent.WINDOW_COMPLETE,windowComplete)
			$win.addEventListener(AIREvent.APPLICATION_ACTIVATE,windowActivate)
			
			
			$win.open(true);
			_win=$win
			_win.visible=false
			
			
			
		}
		
		protected function windowActivate(event:AIREvent):void
		{
			//trace(event.target)
			
		}
		protected function windowComplete(event:AIREvent):void
		{
			Window(event.target).nativeWindow.x=Scene_data.stage.nativeWindow.x+Scene_data.stage.stageWidth/2-Window(event.target).nativeWindow.width/2;
			Window(event.target).nativeWindow.y=Scene_data.stage.nativeWindow.y+Scene_data.stage.stageHeight/2-Window(event.target).nativeWindow.height/2;
			_win.visible=true
			
		}
	}
}


