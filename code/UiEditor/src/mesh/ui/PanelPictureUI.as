package mesh.ui
{
	import flash.display.BitmapData;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	
	import mx.controls.Label;
	import mx.events.AIREvent;
	
	import spark.components.Window;
	
	import _me.Scene_data;
	
	import common.utils.frame.BaseComponent;
	import common.utils.ui.prefab.PicBut;
	
	import modules.brower.fileWin.BrowerManage;
	
	public class PanelPictureUI extends BaseComponent
	{
		protected var _iconBmp:PicBut;
		protected var _labelTxt:Label
		protected var _titleLabel:Label;
		protected var _donotDubleClik:uint

		public function PanelPictureUI()
		{
			super();
			
			this.baseWidth = 45;
			_iconBmp=new PicBut
			this.addChild(_iconBmp)
			
			_iconBmp.setBitmapdata(BrowerManage.getIcon("meinv"),64,64)
			_iconBmp.y=0
			_iconBmp.x=baseWidth + 5;
			_iconBmp.buttonMode=true
			_iconBmp.filters=[getBitmapFilter()]
			
			
			_labelTxt=new Label
			_labelTxt.setStyle("color",0x9f9f9f);
			_labelTxt.setStyle("paddingTop",4);
			_labelTxt.y=65
			_labelTxt.x=baseWidth + 5;
			this.addChild(_labelTxt)
			
			
			_titleLabel=new Label
			_titleLabel.setStyle("color",0x9f9f9f);
			_titleLabel.setStyle("paddingTop",4);
			_titleLabel.setStyle("textAlign","right");
			_titleLabel.width=baseWidth;
			_titleLabel.x=0
			_titleLabel.y=5
			_titleLabel.text="预览 :"
			this.addChild(_titleLabel)
			
			this.height=90
			this.isDefault=false
			
			addEvents();
		}
		

		
		public function resetPos():void{
			_iconBmp.x= baseWidth + 5;
			_labelTxt.x= baseWidth + 5;
		}
		
		
		
		public function set donotDubleClik(value:uint):void
		{
			_donotDubleClik = value;
			if(_donotDubleClik!=1){
				_iconBmp.doubleClickEnabled = true;
			}
			
		}
		
		public function set titleLabel(value:String):void{
			_titleLabel.text = value;
			if(_titleLabel.measureText(value).width > baseWidth){
				_titleLabel.width = _labelTxt.measureText(value).width + 5;
				baseWidth = _titleLabel.width;
				resetPos();
			}
		}
		

		private function getBitmapFilter():BitmapFilter {
			var color:Number = 0x000000;
			var angle:Number = 45;
			var alpha:Number = 0.8;
			var blurX:Number = 8;
			var blurY:Number = 8;
			var distance:Number = 5;
			var strength:Number = 0.65;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			return new DropShadowFilter(distance,
				angle,
				color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
		}
		
		
		private function addEvents():void
		{

			_iconBmp.addEventListener(MouseEvent.CLICK,onDubleClik)

		}

		protected function onDubleClik(event:MouseEvent):void
		{
			if(_donotDubleClik==1){
				return 
			}
			openDisChooseFile();
			
		}
		private function openDisChooseFile():void
		{
			addPreFabMovePanel("ccav")
		}
		private var _win:Window
		private function addPreFabMovePanel($typeStr:String):void
		{
			if(_win){
				_win.close()
			}
			var $preFabMovePanel:UiItemPanel=new UiItemPanel
			var $win:Window = new Window;
			
			$win.transparent=false;
			$win.type=NativeWindowType.UTILITY;
			$win.systemChrome=NativeWindowSystemChrome.STANDARD;
			$win.width= 500;
			$win.height= 400;
			$win.alwaysInFront=true
			
			$win.resizable=false
			$win.showStatusBar = false;
			
			$preFabMovePanel.setStyle("left",0);
			$preFabMovePanel.setStyle("right",0);
			$preFabMovePanel.setStyle("top",0);
			$preFabMovePanel.setStyle("bottom",0);
			
		
			$preFabMovePanel.bFun=winBackFun
			
			$win.addElement($preFabMovePanel);
			
			$win.addEventListener(AIREvent.WINDOW_COMPLETE,showWinPanel)
			$win.open(true);
			_win=$win
			_win.visible=false
		}
		public function winBackFun($str:String):void
		{
			if(_win){
				_win.close()
			}
			target[FunKey]=$str

		}
		protected function showWinPanel(event:AIREvent):void
		{
			Window(event.target).nativeWindow.x=Scene_data.stage.nativeWindow.x+Scene_data.stage.stageWidth/2-Window(event.target).nativeWindow.width/2;
			Window(event.target).nativeWindow.y=Scene_data.stage.nativeWindow.y+Scene_data.stage.stageHeight/2-Window(event.target).nativeWindow.height/2;
			_win.visible=true
			
		}

	
		override public function refreshViewValue():void
		{
			if(target&&FunKey){
				var nodeName:String=target[FunKey]
		        var bmp:BitmapData=UiData.getUIBitmapDataByName(nodeName)
				if(bmp){
					_iconBmp.setBitmapdata(bmp,64,64)
					_labelTxt.text=nodeName
				}else{
					_labelTxt.text=""
					_iconBmp.setBitmapdata(BrowerManage.getIcon("meinv"),64,64)
				}
			}

		}
		
	}
}



