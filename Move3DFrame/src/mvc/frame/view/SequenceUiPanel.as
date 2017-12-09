package mvc.frame.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import mx.core.UIComponent;
	
	import _me.Scene_data;
	
	import common.utils.frame.BaseComponent;
	
	import mvc.frame.FrameModel;
	import mvc.frame.line.FrameLineCavans;
	import mvc.frame.line.FrameLinePointSprite;
	import mvc.frame.line.FrameTimeLineSprite;
	
	public class SequenceUiPanel extends BaseComponent
	{

		


		public function SequenceUiPanel()
		{
			super();

			this.setStyle("top",0);
			this.setStyle("left",260);
			this.setStyle("right",20);
			this.setStyle("bottom",0);
			this.horizontalScrollPolicy = "on";
			//this.verticalScrollPolicy = "on";
			
			this.setStyle("contentBackgroundColor",0x505050);
			this.setStyle("color",0x9f9f9f);
			
			this.initData();




		}
		

		
		

	
		private function initData():void
		{
		
			this.gridSprite=new UIComponent;
			this.addChild(this.gridSprite);
			this.graduation=new UIComponent;
			this.addChild(this.graduation);
			this.setFrameNum(1000);
				
		

			
			this._frameLineCavans=new FrameLineCavans();
			this.addChild(this._frameLineCavans);
			
			this._frameTimeLineSprite=new FrameTimeLineSprite();
			this.addChild(this._frameTimeLineSprite);
			this._frameTimeLineSprite.x=400
			
			
			graduation.addEventListener(MouseEvent.MOUSE_DOWN,graduationOnMouseDown)

			_frameTimeLineSprite.addEventListener(MouseEvent.MOUSE_DOWN,graduationOnMouseDown)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp)
		
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,sequenceUiMouseMove)
		
			gridSprite.addEventListener(MouseEvent.MOUSE_DOWN,gridSpriteOnMouseDown)
			this._frameLineCavans.addEventListener(MouseEvent.MOUSE_DOWN,gridSpriteOnMouseDown)
		
		
		}
		private var lastMousePos:Point;
		private var _gridhaveMouseDown:Boolean
		protected function gridSpriteOnMouseDown(event:MouseEvent):void
		{
			
			if(event.target is FrameLinePointSprite){
				return 
			}
			this.lastMousePos=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
			this._gridhaveMouseDown=true
		
		
			
		}

		private var _frameTimeLineSprite:FrameTimeLineSprite
		
		private var graduation:UIComponent
		private var gridSprite:UIComponent

		private var _frameLineCavans:FrameLineCavans;
		
		public function setFrameNum(num:int):void{
			var baseW:int=FrameModel.getInstance().baseW
			var bitmapdata:BitmapData = new BitmapData(8*num,800,true,0xff2a2a2a);
			var bitmapdataBg:BitmapData = new BitmapData(8*num,30,true,0xff2a2a2a);
			var sp1:Shape = new Shape();
			sp1.graphics.beginFill(0x505050,1);
			sp1.graphics.lineStyle(1,0x353535);
			sp1.graphics.drawRect(0,0,baseW,20);
			sp1.graphics.endFill();
			
			var sp2:Shape = new Shape();
			sp2.graphics.beginFill(0x404040,1);
			sp2.graphics.lineStyle(1,0x353535);
			sp2.graphics.drawRect(0,0,baseW,20);
			sp2.graphics.endFill();
			
			var txt:TextField = new TextField();
			txt.width = 25;
			txt.height = 20;
			var ma:Matrix = new Matrix();
			ma.ty = 30;
			var txtma:Matrix = new Matrix();
			txtma.ty = 15;
			for(var j:int=0;j<40;j++){
				for(var i:int=0;i<num;i++){
					if(i%5){
						bitmapdata.draw(sp1,ma);
					}else{
						if(j==0){
							txt.htmlText = "<font size='10' face='Microsoft Yahei' color='#666666'>" + i + "</font>"
							bitmapdataBg.draw(txt,txtma);
						}
						bitmapdata.draw(sp2,ma);
					}
					ma.tx = i*baseW;
					txtma.tx = i*baseW;
				}
				ma.ty += 20;
			}
			
			txtma.tx = 0;
			txtma.ty = 0;
			ma.tx = 0;
			ma.ty = 12;
			sp1.graphics.clear();
			sp1.graphics.lineStyle(1,0x777777);
			sp1.graphics.moveTo(0,-2);
			sp1.graphics.lineTo(0,7);
			sp1.graphics.moveTo(0,0);
			sp1.graphics.lineTo(50,0);
			
			for(i=0;i<num;i+=6){
				txtma.tx = i*baseW;
				ma.tx = i*baseW;
				txt.htmlText = "<font size='10' face='Microsoft Yahei' color='#666666'>" + (i/6*100) + "</font>"
				bitmapdataBg.draw(txt,txtma);
				bitmapdataBg.draw(sp1,ma);
				
			}
			
			var bitmap:Bitmap = new Bitmap(bitmapdata);
			gridSprite.addChild(bitmap);
			gridSprite.width = bitmap.width;


			var bitmapTimeBg:Bitmap = new Bitmap(bitmapdataBg);
			bitmapTimeBg.y = -3;
			
	
			graduation.addChild(bitmapTimeBg);
			
			
	
		}
		private var mouseLineSprite:Sprite=new Sprite
		protected function sequenceUiMouseMove(event:MouseEvent):void
		{
			
			if(this._mouseDownSelectFrameTittle){
				var baseW:int=FrameModel.getInstance().baseW
				FramePanel(this.parent).playFrameTo(Math.max(Math.floor(graduation.mouseX/baseW),0))
			}else
			if(this._gridhaveMouseDown){
				if(!this.mouseLineSprite.parent){
					Scene_data.stage.addChild(this.mouseLineSprite)
				}
				this.mouseLineSprite.graphics.clear()
				this.mouseLineSprite.graphics.lineStyle(1,0xFFFFFF,0.5)
				this.mouseLineSprite.graphics.beginFill(0xFFFFFF,0.2);
				var $rect:Rectangle=getMouseRect()
				this.mouseLineSprite.graphics.drawRect($rect.x,$rect.y,$rect.width,$rect.height);
				this.mouseLineSprite.graphics.endFill();
			}
		}
		private function getMouseRect():Rectangle
		{
			var rect:Rectangle=new Rectangle;
			rect.x=Math.min(this.lastMousePos.x,Scene_data.stage.mouseX);
			rect.y=Math.min(this.lastMousePos.y,Scene_data.stage.mouseY);
			rect.width=Math.abs(this.lastMousePos.x-Scene_data.stage.mouseX);
			rect.height=Math.abs(this.lastMousePos.y-Scene_data.stage.mouseY);
			
			return rect
		}
		
		protected function onStageMouseUp(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
			this._mouseDownSelectFrameTittle=false

			if(this.mouseLineSprite.parent){
				this.mouseLineSprite.graphics.clear()
			}
			if(this._gridhaveMouseDown){
				FrameModel.getInstance().selectPointKeyInRect(getMouseRect())
			}
			this._gridhaveMouseDown=false
		}
		
		public function playFrameTo($num:Number):void
		{
			var baseW:int=FrameModel.getInstance().baseW
			this._frameTimeLineSprite.x=$num*baseW-3
		}
		private var _mouseDownSelectFrameTittle:Boolean=false;

		protected function graduationOnMouseDown(event:Event):void
		{
			var baseW:int=FrameModel.getInstance().baseW
			FramePanel(this.parent).playFrameTo(Math.floor(graduation.mouseX/baseW))
			this._mouseDownSelectFrameTittle=true;
		}
		public function onSize(event:Event= null):void
		{

			this.resetView()
		
		}
		public function resetView():void
		{
			this._frameLineCavans.resetView()
		}

		public function downKeyBoardF():void
		{
			var $num:int=AppDataFrame.frameNum*FrameModel.getInstance().baseW;
			this.horizontalScrollPosition=$num;
			
		}
	}
}