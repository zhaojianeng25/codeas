



package  modules.expres	
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.TextInput;
	import spark.components.Window;
	
	import common.AppData;
	import common.msg.event.projectSave.MEvent_ProjectData;
	import common.utils.frame.BasePanel;
	import common.utils.ui.btn.LButton;
	import common.utils.ui.prefab.PicBut;
	import common.utils.ui.tab.TabButton;
	
	public class ExpMapPicInfoPanel extends BasePanel
	{
		private var _btnVec:Vector.<TabButton>;
		private var _panelVec:Vector.<BasePanel>;
		private var _bg:UIComponent;
		private var _shape:UIComponent;
		

		private var _searchBut:PicBut;
		private var _enterBut:LButton;
		public function ExpMapPicInfoPanel()
		{
			super();
			//this.setStyle("backgroundColor",0x404040);
			this.setStyle("borderColor",0x151515);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";
			
			
			
			addBack()
			addLabels("请修改参数",50,30);
			this.textInputX=addInputTxt(" x:",50,60,50);

			this.textInputZ=addInputTxt(" z:",50,90,50);
			
			this.textInputSize=addInputTxt("范围:",150,60,50);
			this.textInputRotation=addInputTxt("角度:",150,90,50);
			
			addButs();
			addEvents();
			
			if(AppData.minmappicInfo){
				this.textInputX.text=AppData.minmappicInfo[0]
				this.textInputZ.text=AppData.minmappicInfo[1]
				this.textInputSize.text=AppData.minmappicInfo[2]
				this.textInputRotation.text=AppData.minmappicInfo[3]
			}
			

			
		}
	
		private var textInputX:TextInput

		private var textInputZ:TextInput
		private var textInputSize:TextInput
		private var textInputRotation:TextInput
		
	
		private function addButs():void
		{

			
			_enterBut= new LButton;
			_enterBut.label ="确定提交"
			_enterBut.setStyle("left",40);
			_enterBut.y=150
			this.addChild(_enterBut)
			
			
		}
		
		
		
		private function addInputTxt($str:String,tx:Number,ty:Number,tw:Number):TextInput
		{
			var _inputTxt:TextInput = new TextInput;
			//_txt.setStyle("top",0);
			//_txt.setStyle("bottom",0);
			_inputTxt.setStyle("contentBackgroundColor",0x404040);
			_inputTxt.setStyle("borderVisible",true);
			_inputTxt.setStyle("color",0x9f9f9f);
			//_inputTxt.setStyle("textDecoration","underline");
			_inputTxt.setStyle("paddingTop",4);
			
			_inputTxt.x=tx+30
			_inputTxt.y=ty
			_inputTxt.width=tw
			_inputTxt.text="0"
			addLabels($str,tx,ty-4);
			
			this.addChild(_inputTxt);
			return _inputTxt
			
		}
		
		private function addLabels($str:String, tx:Number,ty:Number):void
		{
			var _labelTxt:Label=new Label
			_labelTxt.setStyle("color",0x9f9f9f);
			_labelTxt.setStyle("paddingTop",4);
			_labelTxt.x=tx
			_labelTxt.y=ty
			_labelTxt.text=$str;
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
	
			//ExpMapPicAndStart.getInstance().scanPic()

			var $size:Number=Number(textInputSize.text) ;
			if($size>10){
				trace("用输入 数据")
				
				AppData.minmappicInfo=new Array;
				AppData.minmappicInfo=[Number(textInputX.text),Number(textInputZ.text),$size,Number(textInputRotation.text)]
				
				var $rect:Rectangle=new Rectangle(Number(textInputX.text)-$size/2 ,Number(textInputZ.text)-$size/2 ,$size,$size)
				ExpMapPicAndStart.getInstance().scanGroundHigth($rect,Number(textInputRotation.text))
					
				
			
			}else{
				trace("自动生存")
				ExpMapPicAndStart.getInstance().scanPic();
			}
			
			
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



