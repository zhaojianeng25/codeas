package view.controlCenter
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ShockSprite extends Sprite
	{
		public var data:Object;
		public function ShockSprite()
		{
			super();
			this.draw();
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		public function draw():void{
			this.graphics.clear();
			this.graphics.lineStyle(2,0xff0000,1);
			
			var num:int = 2;
			
			this.graphics.moveTo(0,7);
			for(var i:int;i<num;i++){
				this.graphics.lineTo(i*10 + 5,12);
				this.graphics.lineTo(i*10 + 10,7);
			}
			this.graphics.lineStyle(2,0xff0000,0);
			this.graphics.beginFill(0xff0000,0);
			this.graphics.drawRect(0,4,20,8);
			this.graphics.endFill();
			
		}
		
		/**
		 * 可以拖动关键帧 
		 * @param event
		 * 
		 */		
		protected function onMouseDown(event:MouseEvent):void{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.x = this.x - this.x%8;
			var frameNum:int = this.x/8;
			data.time = frameNum;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onMouseMove(event:MouseEvent):void{
			this.x = this.parent.mouseX;
		}
		
	}
}