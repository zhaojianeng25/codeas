package common.utils.ui.layout
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import manager.LayerManager;
	
	public class ResponseSprite extends Sprite
	{
		private var _leftSp:Sprite;
		private var _rightSp:Sprite;
		private var _topSp:Sprite;
		private var _bottomSp:Sprite;
		private var _topTopSp:Sprite;
		private var _centerSp:Sprite;
		
		private var _spWidth:int;
		private var _spHeight:int;
		
		private var widthNum:int = 30;
		private var baseHeightNum:int = 20;
		public function ResponseSprite()
		{
			super();
			
			_leftSp = new Sprite;
			_rightSp = new Sprite;
			_topSp = new Sprite;
			_bottomSp = new Sprite;
			
			_topTopSp = new Sprite;
			_centerSp = new Sprite;
			
			this.addChild(_leftSp);
			this.addChild(_rightSp);
			this.addChild(_topSp);
			this.addChild(_bottomSp);
			this.addChild(_topTopSp);
			this.addChild(_centerSp);
			
			_leftSp.addEventListener(MouseEvent.MOUSE_UP,onLeftClick);
			_rightSp.addEventListener(MouseEvent.MOUSE_UP,onRightClick);
			_topSp.addEventListener(MouseEvent.MOUSE_UP,onTopClick);
			_bottomSp.addEventListener(MouseEvent.MOUSE_UP,onBottomClick);
			_topTopSp.addEventListener(MouseEvent.MOUSE_UP,ontopTopClick);
			_centerSp.addEventListener(MouseEvent.MOUSE_UP,onCenterClick);
			
			_leftSp.addEventListener(MouseEvent.MOUSE_OVER,leftOver);
			_leftSp.addEventListener(MouseEvent.MOUSE_OUT,leftOut);
			
			_rightSp.addEventListener(MouseEvent.MOUSE_OVER,rightOver);
			_rightSp.addEventListener(MouseEvent.MOUSE_OUT,rightOut);
			
			_topSp.addEventListener(MouseEvent.MOUSE_OVER,topOver);
			_topSp.addEventListener(MouseEvent.MOUSE_OUT,topOut);
			
			_bottomSp.addEventListener(MouseEvent.MOUSE_OVER,bottomOver);
			_bottomSp.addEventListener(MouseEvent.MOUSE_OUT,bottomOut);
			
			_topTopSp.addEventListener(MouseEvent.MOUSE_OVER,topTopOver);
			_topTopSp.addEventListener(MouseEvent.MOUSE_OUT,topTopOut);
		}
		
		protected function onCenterClick(event:MouseEvent):void
		{
			LayerManager.getInstance().removeDragPanle();
			LayerManager.getInstance().addWindowPanle();
		}
		
		protected function topTopOut(event:MouseEvent):void
		{
			drawTopTop(0.1);
		}
		
		protected function topTopOver(event:MouseEvent):void
		{
			drawTopTop(0.3);
		}
		
		protected function leftOut(event:MouseEvent):void
		{
			drawLeft(0.1);
		}
		protected function leftOver(event:MouseEvent):void
		{
			drawLeft(0.3);
		}
		
		protected function rightOut(event:MouseEvent):void
		{
			drawRight(0.1);
		}
		protected function rightOver(event:MouseEvent):void
		{
			drawRight(0.3);
		}
		
		protected function topOut(event:MouseEvent):void
		{
			drawTop(0.1);
		}
		protected function topOver(event:MouseEvent):void
		{
			drawTop(0.3);
		}
		
		protected function bottomOut(event:MouseEvent):void
		{
			drawBottom(0.1);
		}
		protected function bottomOver(event:MouseEvent):void
		{
			drawBottom(0.3);
		}
		
		
		
		
		protected function ontopTopClick(event:MouseEvent):void
		{
			var evt:LayoutSunEvent = new LayoutSunEvent(LayoutSunEvent.LAYOUTSUN_EVENT);
			evt.direct = "center";
			LayerManager.getInstance().removeDragPanle();
			evt.panel = LayerManager.getInstance().getPanle();
			this.dispatchEvent(evt);
		}
		
		protected function onBottomClick(event:MouseEvent):void
		{
			var evt:LayoutSunEvent = new LayoutSunEvent(LayoutSunEvent.LAYOUTSUN_EVENT);
			evt.direct = "bottom";
			evt.panel = LayerManager.getInstance().getPanle();
			LayerManager.getInstance().removeDragPanle();
			this.dispatchEvent(evt);
		}
		
		protected function onTopClick(event:MouseEvent):void
		{
			var evt:LayoutSunEvent = new LayoutSunEvent(LayoutSunEvent.LAYOUTSUN_EVENT);
			evt.direct = "top";
			evt.panel = LayerManager.getInstance().getPanle();
			LayerManager.getInstance().removeDragPanle();
			this.dispatchEvent(evt);
		}
		
		protected function onRightClick(event:MouseEvent):void
		{
			var evt:LayoutSunEvent = new LayoutSunEvent(LayoutSunEvent.LAYOUTSUN_EVENT);
			evt.direct = "right";
			evt.panel = LayerManager.getInstance().getPanle();
			LayerManager.getInstance().removeDragPanle();
			this.dispatchEvent(evt);
		}
		
		protected function onLeftClick(event:MouseEvent):void
		{
			var evt:LayoutSunEvent = new LayoutSunEvent(LayoutSunEvent.LAYOUTSUN_EVENT);
			evt.direct = "left";
			evt.panel = LayerManager.getInstance().getPanle();
			LayerManager.getInstance().removeDragPanle();
			this.dispatchEvent(evt);
		}
		
		
		
		private function drawLeft(drawAlpha:Number=0.1):void{
			_leftSp.graphics.clear();
			_leftSp.graphics.beginFill(0x0000ff,drawAlpha);
			_leftSp.graphics.lineStyle(1,0x666666,1);
			
			var star_commands:Vector.<int> = new Vector.<int>(4, true);
			star_commands[0] = 1;
			star_commands[1] = 2;
			star_commands[2] = 2;
			star_commands[3] = 2;
			
			var star_coord:Vector.<Number> = new Vector.<Number>(10, true);
			star_coord[0] = 0; //x
			star_coord[1] = baseHeightNum; //y
			
			star_coord[2] = widthNum;
			star_coord[3] = widthNum + baseHeightNum;
			
			star_coord[4] = widthNum;
			star_coord[5] = spHeight-widthNum;
			
			star_coord[6] = 0;
			star_coord[7] = spHeight;
			
			_leftSp.graphics.drawPath(star_commands,star_coord);
			_leftSp.graphics.endFill();
		}
		
		private function drawRight(drawAlpha:Number=0.1):void{
			_rightSp.graphics.clear();
			_rightSp.graphics.beginFill(0x0000ff,drawAlpha);
			_rightSp.graphics.lineStyle(1,0x666666,1);
			
			var star_commands:Vector.<int> = new Vector.<int>(4, true);
			star_commands[0] = 1;
			star_commands[1] = 2;
			star_commands[2] = 2;
			star_commands[3] = 2;
			
			var star_coord:Vector.<Number> = new Vector.<Number>(10, true);
			star_coord[0] = spWidth; //x
			star_coord[1] = baseHeightNum; //y
			
			star_coord[2] = spWidth;
			star_coord[3] = spHeight;
			
			star_coord[4] = spWidth - widthNum;
			star_coord[5] = spHeight - widthNum;
			
			star_coord[6] = spWidth - widthNum;
			star_coord[7] = widthNum + baseHeightNum;
			
			_rightSp.graphics.drawPath(star_commands,star_coord);
			_rightSp.graphics.endFill();
		}
		
		private function drawTop(drawAlpha:Number=0.1):void{
			_topSp.graphics.clear();
			_topSp.graphics.beginFill(0x0000ff,drawAlpha);
			_topSp.graphics.lineStyle(1,0x666666,1);
			
			var star_commands:Vector.<int> = new Vector.<int>(4, true);
			star_commands[0] = 1;
			star_commands[1] = 2;
			star_commands[2] = 2;
			star_commands[3] = 2;
			
			var star_coord:Vector.<Number> = new Vector.<Number>(10, true);
			
			star_coord[0] = 0; //x
			star_coord[1] = baseHeightNum; //y
			
			star_coord[2] = spWidth;
			star_coord[3] = baseHeightNum;
			
			star_coord[4] = spWidth - widthNum;
			star_coord[5] = widthNum + baseHeightNum;
			
			star_coord[6] = widthNum;
			star_coord[7] = widthNum + baseHeightNum;
			
			_topSp.graphics.drawPath(star_commands,star_coord);
			_topSp.graphics.endFill();
		}
		
		private function drawBottom(drawAlpha:Number=0.1):void{
			_bottomSp.graphics.clear();
			_bottomSp.graphics.beginFill(0x0000ff,drawAlpha);
			_bottomSp.graphics.lineStyle(1,0x666666,1);
			
			var star_commands:Vector.<int> = new Vector.<int>(4, true);
			star_commands[0] = 1;
			star_commands[1] = 2;
			star_commands[2] = 2;
			star_commands[3] = 2;
			
			var star_coord:Vector.<Number> = new Vector.<Number>(10, true);
			
			star_coord[0] = 0; //x
			star_coord[1] = spHeight; //y
			
			star_coord[2] = spWidth;
			star_coord[3] = spHeight;
			
			star_coord[4] = spWidth - widthNum;
			star_coord[5] = spHeight - widthNum;
			
			star_coord[6] = widthNum;
			star_coord[7] = spHeight - widthNum;
			
			_bottomSp.graphics.drawPath(star_commands,star_coord);
			_bottomSp.graphics.endFill();
		}
		
		public function drawTopTop(drawAlpha:Number=0.1):void{
			_topTopSp.graphics.clear();
			_topTopSp.graphics.beginFill(0x00ff00,drawAlpha);

			_topTopSp.graphics.drawRect(0,0,spWidth,baseHeightNum);
		
			_topTopSp.graphics.endFill();
		}
		
		public function drawCenter(drawAlpha:Number=0.1):void{
			_centerSp.graphics.clear();
			_centerSp.graphics.beginFill(0x00ff00,drawAlpha);
			
			_centerSp.graphics.drawRect(widthNum,widthNum + baseHeightNum,spWidth - 2*widthNum,spHeight - 2*widthNum - baseHeightNum);
			
			_centerSp.graphics.endFill();
		}
		
		public function reDraw():void{
			drawLeft();
			drawRight();
			drawTop();
			drawBottom();
			drawTopTop();
			drawCenter();
		}
		
		public function get spWidth():int
		{
			return _spWidth;
		}

		public function set spWidth(value:int):void
		{
			_spWidth = value;
			
			reDraw();
		}

		public function get spHeight():int
		{
			return _spHeight;
		}

		public function set spHeight(value:int):void
		{
			_spHeight = value;
			reDraw();
		}


	}
}