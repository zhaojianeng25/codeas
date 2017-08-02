package view.controlCenter
{
	import flash.display.Sprite;
	
	public class ShockSprite extends Sprite
	{
		public function ShockSprite()
		{
			super();
		}
		
		public function draw(time:int):void{
			this.graphics.clear();
			this.graphics.lineStyle(2,0xffff00,1);
			
			var pixL:Number = time * 480 / 1000;
			
			var num:int = pixL/10;
			
			this.graphics.moveTo(0,7);
			for(var i:int;i<num;i++){
				this.graphics.lineTo(i*10 + 5,12);
				this.graphics.lineTo(i*10 + 10,7);
			}
			
		}
		
	}
}