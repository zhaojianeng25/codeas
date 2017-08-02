package modules.brower.fileTip
{
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.AIREvent;
	
	import spark.components.Window;
	
	import _me.Scene_data;
	
	import common.utils.frame.BasePanel;
	import common.utils.ui.prefab.PicBut;

	public class AmaniTexture2DPoint
	{
		private static var instance:AmaniTexture2DPoint;
		public function AmaniTexture2DPoint()
		{
		}
		public static function getInstance():AmaniTexture2DPoint{
			if(!instance){
				instance = new AmaniTexture2DPoint();
			}
			return instance;
		}

		private var _bmpBmp:PicBut;
		private var _bFun:Function;
		public function inputFilePanle(arr:Object,winBackFun:Function):void
		{
			if(_win){
				_win.close()
			}
			_bFun=winBackFun
			
			_caverUi=new BasePanel
			var $win:Window = new Window;
			$win.transparent=false;
			$win.type=NativeWindowType.UTILITY;
			$win.systemChrome=NativeWindowSystemChrome.STANDARD;
			$win.width= 800;
			$win.height= 800;
			$win.alwaysInFront=true
			$win.resizable=false
			$win.showStatusBar = false;
			
			_caverUi.setStyle("left",0);
			_caverUi.setStyle("right",0);
			_caverUi.setStyle("top",0);
			_caverUi.setStyle("bottom",0);
			
			drawback(_caverUi)
			
			
			_bmpBmp=new PicBut()
			_bmpBmp.isEvent=false
			_bmpBmp.setBitmapdata(arr.arrBmp[0])
			_caverUi.addChild(_bmpBmp)
			
			$win.addElement(_caverUi);
			
			
			$win.addEventListener(AIREvent.WINDOW_COMPLETE,kkkdd)
			$win.open(true);
			_win=$win
			_win.visible=false
				
				addEvent();
				
				
		}
		
		private function addEvent():void
		{
			_caverUi.addEventListener(MouseEvent.CLICK,onMouseClik)
			
		}
		
		protected function onMouseClik(event:MouseEvent):void
		{
			var p:Point=new Point
				p.x=_caverUi.mouseX-_bmpBmp.bmp.width/2;
				p.y=_caverUi.mouseY-_bmpBmp.bmp.height/2;
			_bFun(p)
			
		}
		
		private function drawback($cc:BasePanel):void{
			
			var _bg:UIComponent = new UIComponent;
			$cc.addChild(_bg);
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x404040,1);
			_bg.graphics.drawRect(0,0,800,800);
			_bg.graphics.endFill();
		}
		protected function kkkdd(event:AIREvent):void
		{
			Window(event.target).nativeWindow.x=Scene_data.stage.nativeWindow.x+Scene_data.stage.stageWidth/2-Window(event.target).nativeWindow.width/2;
			Window(event.target).nativeWindow.y=Scene_data.stage.nativeWindow.y+Scene_data.stage.stageHeight/2-Window(event.target).nativeWindow.height/2;
			_win.visible=true
			
			
			
		}
		private var _win:Window
		private var _caverUi:BasePanel;
	}
}


