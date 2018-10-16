package mvc.centen.discenten
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	import common.utils.frame.BasePanel;
	
	public class DisCentenPanel extends BasePanel
	{
	
		private var _bmpLevel:BmpLevel;
		private var _InfoLevel:InfoLevel;
		private var _sizeTxt:Label;
		private var _selectLineSprite:UIComponent


		public function DisCentenPanel()
		{
			super();
			
			//this.setStyle("borderColor",0x151515);
			//this.setStyle("borderStyle","solid");
			//this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";

			addBmpLevel();
			addInfoLevel();
			addLabel();
			addLineSprite()
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage)
		}

		public function get beginLinePoin():Point
		{
			return _beginLinePoin;
		}

		private function addLineSprite():void
		{
			_selectLineSprite=new UIComponent;
			this.addChild(_selectLineSprite)
		}
		private var _beginLinePoin:Point
		public function beginDrawLine():void
		{
			_beginLinePoin=new Point(this.mouseX,this.mouseY)
		}
		public function endDrawLine():void
		{
			_selectLineSprite.graphics.clear();
			_beginLinePoin=null;
		}
		public function drawSelectLine():void
		{
			if(_beginLinePoin){
				var a:Point=_beginLinePoin
				var b:Point=new Point(this.mouseX,this.mouseY)
				_selectLineSprite.graphics.clear();
				_selectLineSprite.graphics.lineStyle(1,0xff0000,1)
				_selectLineSprite.graphics.moveTo(a.x,a.y)
				_selectLineSprite.graphics.lineTo(a.x,b.y)
				_selectLineSprite.graphics.lineTo(b.x,b.y)
				_selectLineSprite.graphics.lineTo(b.x,a.y)
				_selectLineSprite.graphics.lineTo(a.x,a.y)
			}
			
	
		
		}
		
		private function addLabel():void
		{
			_sizeTxt=new Label
			_sizeTxt.width=80
			_sizeTxt.height=20
			this.addChild(_sizeTxt)
			_sizeTxt.text="比例:100%"
			
		}
		
		protected function onPanelClik(event:MouseEvent):void
		{
		
			
		}
		
		protected function onAddToStage(event:Event):void
		{
			UiData.editMode=0
			
		}
		
		public function get scaleNum():Number
		{
			return _scaleNum;
		}

		public function get bmpLevel():BmpLevel
		{
			return _bmpLevel;
		}

		override public function onSize(event:Event= null):void
		{

			_sizeTxt.x=this.width-81
		}

		
		private function addBmpLevel():void
		{
			_bmpLevel=new BmpLevel()
			this.addChild(_bmpLevel)
			
		}	
		private function addInfoLevel():void
		{
			_InfoLevel=new InfoLevel();
			this.addChild(_InfoLevel)

		}
		public  function resetInfoArr():void
		{

			_InfoLevel.clearLevel();
			_InfoLevel.setInfoItem(UiData.nodeItem)
			_bmpLevel.setBmpItem(UiData.bmpitem)
			
		}
	
		public function changeSceneColor():void
		{
			_bmpLevel.drawColorSprite()
		
		}
		private var _scaleNum:Number=1;
		
		
		
		private var lastMousePos:Point;
		private var lastDisPos:Point
		public function set middleDown(value:Boolean):void
		{
			_middleDown = value;
			if(_middleDown){
				lastMousePos=new Point(this.mouseX,this.mouseY)
				lastDisPos=new Point(_bmpLevel.x,_bmpLevel.y)
			}
		}
		public function mouseMove():void
		{
			if(_middleDown){
				var nowMouse:Point=new Point(this.mouseX,this.mouseY)
				_bmpLevel.x=lastDisPos.x+(nowMouse.x-lastMousePos.x);
				_bmpLevel.y=lastDisPos.y+(nowMouse.y-lastMousePos.y);
				
				_InfoLevel.x=_bmpLevel.x;
				_InfoLevel.y=_bmpLevel.y;
			}
		}
		public function getBmpPostion():Point
		{
		   return new Point(_bmpLevel.x,_bmpLevel.y)
		
		}
		
		public function KeyAdd():void
		{
			_scaleNum=_scaleNum*1.1
			if(Math.abs(1-_scaleNum)<0.05){
				_scaleNum=1
			}	
			_bmpLevel.scaleX=_scaleNum;
			_bmpLevel.scaleY=_scaleNum;
			_InfoLevel.scaleX=_scaleNum;
			_InfoLevel.scaleY=_scaleNum;
			_sizeTxt.text="比例:"+String(int(_scaleNum*100))+"%"
		}
		public function KeySub():void
		{
			_scaleNum=_scaleNum*0.9
			if(Math.abs(1-_scaleNum)<0.05){
				_scaleNum=1
			}	
			_bmpLevel.scaleX=_scaleNum;
			_bmpLevel.scaleY=_scaleNum;
			_InfoLevel.scaleX=_scaleNum;
			_InfoLevel.scaleY=_scaleNum;

			_sizeTxt.text="比例:"+String(int(_scaleNum*100))+"%"+"\n ctrl+r"
			
		}
		private var _middleDown:Boolean=false
		
	
	
	}
}


