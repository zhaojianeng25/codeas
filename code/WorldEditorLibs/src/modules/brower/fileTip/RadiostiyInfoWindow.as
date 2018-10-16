package modules.brower.fileTip
{
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.utils.ByteArray;
	
	import mx.events.AIREvent;
	
	import spark.components.Window;
	
	import _me.Scene_data;

	public class RadiostiyInfoWindow
	{
		private static var instance:RadiostiyInfoWindow;
		private var _win:Window
		private var _radiostiyInfoPanel:RadiostiyInfoPanel;
		public function RadiostiyInfoWindow()
		{
		}
		public static function getInstance():RadiostiyInfoWindow{
			if(!instance){
				instance = new RadiostiyInfoWindow();
			}
			return instance;
		}
		public function setInfo($idType:uint,$byte:ByteArray):void
		{
			if(_win&&!_win.closed){
				_radiostiyInfoPanel.setInfo($idType,$byte)
			}
		}
		public function close():void
		{
			if(_win){
			    if(!_win.closed){
					_win.close()
				}
				_win=null
			}
		}
		public function renderFinish():void
		{
			if(_win&&!_win.closed){
			
				_radiostiyInfoPanel.setRenderFinish()
			}
		}
		public function initRadiostiyPanel():void
		{
			if(_win&&!_win.closed){
				_win.close()
			}
			_radiostiyInfoPanel=new RadiostiyInfoPanel
			var $win:Window = new Window;
			$win.transparent=false;
			$win.type=NativeWindowType.NORMAL;
			$win.systemChrome=NativeWindowSystemChrome.STANDARD;
			$win.width= 400;
			$win.height= 400;
			$win.alwaysInFront=false
			$win.resizable=true
			$win.showStatusBar = false;
			
			
			_radiostiyInfoPanel.setStyle("left",0);
			_radiostiyInfoPanel.setStyle("right",0);
			_radiostiyInfoPanel.setStyle("top",0);
			_radiostiyInfoPanel.setStyle("bottom",0);
			
			$win.addElement(_radiostiyInfoPanel);
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


