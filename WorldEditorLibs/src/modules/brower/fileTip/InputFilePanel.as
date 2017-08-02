package modules.brower.fileTip
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.TextInput;
	import spark.components.Window;
	
	import common.utils.frame.BasePanel;
	import common.utils.ui.btn.LButton;
	import common.utils.ui.prefab.PicBut;
	import common.utils.ui.tab.TabButton;
	
	import modules.brower.fileWin.BrowerManage;
	
	public class InputFilePanel extends BasePanel
	{
		private var _btnVec:Vector.<TabButton>;
		private var _panelVec:Vector.<BasePanel>;
		private var _bg:UIComponent;
		private var _shape:UIComponent;

		private var _inputTxt:TextInput;
		private var _searchBut:PicBut;
		private var _enterBut:LButton;
		public function InputFilePanel()
		{
			super();
			//this.setStyle("backgroundColor",0x404040);
			this.setStyle("borderColor",0x151515);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";
			
			
			
			addBack()
			addLabels();
			addInputTxt();
			addButs();

			addEvents();
			
		}
		
		private function addButs():void
		{
			_searchBut=new PicBut
			_searchBut.setBitmapdata(BrowerManage.getIcon("search"))
			_searchBut.x=270
			_searchBut.y=80
			_searchBut.filters=[getBitmapFilter()]
			_searchBut.buttonMode=true
			this.addChild(_searchBut)
				
				
			 _enterBut= new LButton;
			_enterBut.label ="确定提交"
			_enterBut.setStyle("left",40);
			_enterBut.y=150
			this.addChild(_enterBut)
				
			
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

		
		private function addInputTxt():void
		{
			_inputTxt = new TextInput;
			//_txt.setStyle("top",0);
			//_txt.setStyle("bottom",0);
			_inputTxt.setStyle("contentBackgroundColor",0x404040);
			_inputTxt.setStyle("borderVisible",true);
			_inputTxt.setStyle("color",0x9f9f9f);
			//_inputTxt.setStyle("textDecoration","underline");
			_inputTxt.setStyle("paddingTop",4);
			
			_inputTxt.x=50
			_inputTxt.y=80
			_inputTxt.width=200
		
			this.addChild(_inputTxt);
			
		}
		
		private function addLabels():void
		{
			var _labelTxt:Label=new Label
			_labelTxt.setStyle("color",0x9f9f9f);
			_labelTxt.setStyle("paddingTop",4);
			_labelTxt.y=50
			_labelTxt.x=50
			_labelTxt.text="请输入文件名:";
			this.addChild(_labelTxt)
			
		}
		public var bFun:Function
		public var typeStr:String
		public var win:Window
		private function addEvents():void
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onStage);
			this.addEventListener(ResizeEvent.RESIZE,onStage);
			_enterBut.addEventListener(MouseEvent.CLICK,_enterButClik)
			
		}
		protected function _enterButClik(event:MouseEvent):void
		{
			if(Boolean(bFun)){
				bFun(_inputTxt.text,typeStr)
			}
			
			//InputWindow.getInstance().close()
				
			if(win){
				win.close()
			}
		}
		
		private function addBack():void
		{
			_bg = new UIComponent;
			this.addChild(_bg);
			_shape = new UIComponent;
			this.addChild(_shape);
			
		}
		
		protected function onStage(event:Event):void
		{
			drawback();
		}

		private function drawback():void{
			_shape.graphics.clear();
			_shape.graphics.beginFill(0x303030,1);
			_shape.graphics.lineStyle(1,0x151515);
	
			_shape.graphics.drawRect(0,0,this.width,20);
			_shape.graphics.endFill();
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x404040,1);
			_bg.graphics.drawRect(0,0,this.width,this.height);
			_bg.graphics.endFill();
		}
		
		override public function set width(value:Number):void{
			super.width = value;
			drawback();
		}
		
		override public function changeSize():void{
			drawback();
			
		}
		override public function show($parent:Sprite):void{
			if(this.parent != $parent){
				$parent.addChild(this);
			}
		}
		
		
	}
}


