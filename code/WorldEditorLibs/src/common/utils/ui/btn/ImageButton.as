package common.utils.ui.btn
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
		
		override public function set width(value:Number):void{
			super.width = value;
			img.width = value;
		}
		
		override public function set height(value:Number):void{
			super.height = value;
			img.height = value;
		}
		
		private function onOver(event:MouseEvent):void{
			draw(0x202020);
		}
		private function onDown(event:MouseEvent):void{
			draw(0x999999);
			this.setFocus();
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