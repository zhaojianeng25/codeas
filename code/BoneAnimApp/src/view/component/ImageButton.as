package view.component
{
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	
	public class ImageButton extends UIComponent
	{
		private var img:Image;
		public var data:Object;
		public function ImageButton()
		{
			super();
			img = new Image;
			img.width = 16;
			img.height = 16;
			img.x = 2;
			img.y = 2;
			this.addChild(img);
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			this.addEventListener(MouseEvent.MOUSE_UP,onOut);
		}
		public function set source(value:String):void{
			img.source = value;
		}
		private function onOver(event:MouseEvent):void{
			draw(0xdddddd);
		}
		private function onDown(event:MouseEvent):void{
			draw(0x999999);
		}
		private function onOut(event:MouseEvent):void{
			this.graphics.clear();
		}
		private function draw(color:uint):void{
			this.graphics.clear();
			this.graphics.beginFill(color);
			this.graphics.drawRect(0,0,20,20);
			this.graphics.endFill();
		}
	}
}