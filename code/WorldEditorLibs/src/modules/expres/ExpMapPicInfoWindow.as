
package modules.expres
{
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	
	import mx.events.AIREvent;
	
	import spark.components.Window;
	
	import _me.Scene_data;
	
	import modules.brower.fileTip.InputFilePanel;
	
	public class ExpMapPicInfoWindow
	{
		private static var instance:ExpMapPicInfoWindow;
		public function ExpMapPicInfoWindow()
		{
		}
		public static function getInstance():ExpMapPicInfoWindow{
			if(!instance){
				instance = new ExpMapPicInfoWindow();
			}
			return instance;
		}
	
		public function inputFilePanle():void
		{
			if(_win){
				_win.close()
			}
			
			var $expMapPicInfoPanel:ExpMapPicInfoPanel=new ExpMapPicInfoPanel
			var $win:Window = new Window;
			$win.transparent=false;
			$win.type=NativeWindowType.UTILITY;
			$win.systemChrome=NativeWindowSystemChrome.STANDARD;
			$win.width= 350;
			$win.height= 200;
			$win.alwaysInFront=true
			
			$win.resizable=false
			$win.showStatusBar = false;
			
			$expMapPicInfoPanel.setStyle("left",0);
			$expMapPicInfoPanel.setStyle("right",0);
			$expMapPicInfoPanel.setStyle("top",0);
			$expMapPicInfoPanel.setStyle("bottom",0);
			
	
			$expMapPicInfoPanel.win=$win
			
			$win.addElement($expMapPicInfoPanel);
			
			$win.addEventListener(AIREvent.WINDOW_COMPLETE,kkkdd)
			$win.open(true);
			_win=$win
			_win.visible=false
		}
		protected function kkkdd(event:AIREvent):void
		{
			Window(event.target).nativeWindow.x=Scene_data.stage.nativeWindow.x+Scene_data.stage.stageWidth/2-Window(event.target).nativeWindow.width/2;
			Window(event.target).nativeWindow.y=Scene_data.stage.nativeWindow.y+Scene_data.stage.stageHeight/2-Window(event.target).nativeWindow.height/2;
			_win.visible=true
			
		}
		private var _win:Window
	}
}


