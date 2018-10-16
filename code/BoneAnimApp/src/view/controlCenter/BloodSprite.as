package view.controlCenter
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BloodSprite extends Sprite
	{
		public function BloodSprite()
		{
			super();
			this.draw();
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		public function draw():void{
			this.graphics.clear();
			this.graphics.beginFill(0xff0000,0);
			this.graphics.lineStyle(2,0xffff00,1);
			this.graphics.drawCircle(0,10,5);
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
			//this.frameNum = this.x/8;
			//info.frameNum = this.frameNum;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onMouseMove(event:MouseEvent):void{
			this.x = this.parent.mouseX;
		}
		
	}
}