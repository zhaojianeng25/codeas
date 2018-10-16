package modules.brower.fileTip
{
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.geom.Matrix;
	
	import mx.events.AIREvent;
	
	import spark.components.Window;
	
	import _me.Scene_data;

	public class InputWindow
	{
		private static var instance:InputWindow;
		public function InputWindow()
		{
		}
		public static function getInstance():InputWindow{
			if(!instance){
				instance = new InputWindow();
			}
			return instance;
		}
//		public function close():void
//		{
//			if(_win){
//				_win.close()
//			}
//		}

		public function inputFilePanle($typeStr:String,winBackFun:Function):void
		{
			if(_win){
				_win.close()
			}
	
			var $InputFilePanel:InputFilePanel=new InputFilePanel
			var $win:Window = new Window;
			$win.transparent=false;
			$win.type=NativeWindowType.UTILITY;
			$win.systemChrome=NativeWindowSystemChrome.STANDARD;
			$win.width= 350;
			$win.height= 200;
			$win.alwaysInFront=true
			
			$win.resizable=false
			$win.showStatusBar = false;
			
			$InputFilePanel.setStyle("left",0);
			$InputFilePanel.setStyle("right",0);
			$InputFilePanel.setStyle("top",0);
			$InputFilePanel.setStyle("bottom",0);
			
			$InputFilePanel.typeStr=$typeStr;
			$InputFilePanel.bFun=winBackFun
			$InputFilePanel.win=$win
			
			$win.addElement($InputFilePanel);
			
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