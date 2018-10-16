package mvc.top
{
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	
	import mx.core.Window;
	import mx.events.AIREvent;
	
	import _me.Scene_data;
	
	import modules.sceneConfig.SceneConfigPanel;

	public class OutTxtModel
	{
		public function OutTxtModel()
		{
		}
		private static var instance:OutTxtModel;

		private var _outPanel:OutPanel;
	
		public static function getInstance():OutTxtModel{
			if(!instance){
				instance = new OutTxtModel();
			}
			return instance;
		}

		private var _win:Window
		private var _sceneConfigPanel:OutPanel;
		public function initSceneConfigPanel($str:String):void
		{
			if(_win&&!_win.closed){
				_win.close()
			}
			_sceneConfigPanel=new OutPanel
			var $win:Window = new Window;
			$win.transparent=false;
			$win.type=NativeWindowType.NORMAL;
			$win.systemChrome=NativeWindowSystemChrome.STANDARD;
			$win.width= 800;
			$win.height= 600;
			$win.alwaysInFront=false
			$win.resizable=false
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
			
			
			_sceneConfigPanel.width=800
			_sceneConfigPanel.height=600
			_sceneConfigPanel.setText($str)
		}
		public function addLine($str:String):void
		{
			_sceneConfigPanel.addLine($str)
		
		
		}
			
		
		protected function windowActivate(event:AIREvent):void
		{
	
			
		}
		protected function windowComplete(event:AIREvent):void
		{
			Window(event.target).nativeWindow.x=Scene_data.stage.nativeWindow.x+Scene_data.stage.stageWidth/2-Window(event.target).nativeWindow.width/2;
			Window(event.target).nativeWindow.y=Scene_data.stage.nativeWindow.y+Scene_data.stage.stageHeight/2-Window(event.target).nativeWindow.height/2;
			_win.visible=true
			
		}
	}
}



