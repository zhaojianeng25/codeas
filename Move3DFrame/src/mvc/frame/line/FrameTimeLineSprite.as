package mvc.frame.line
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import common.utils.frame.BaseComponent;

	public class FrameTimeLineSprite extends BaseComponent
	{

		private var lineSprite:BaseComponent
		public function FrameTimeLineSprite()
		{
			super();
			
			this.graphics.clear();
			this.graphics.beginFill(0xff0000,0.5);
			this.graphics.lineStyle(1,0x000000);
			
			this.graphics.drawRect(1,1,10,24);
			this.graphics.endFill();
			
			
//			this.graphics.lineStyle(1,0xff0000,0.5);
//			this.graphics.moveTo(6,25);
//			this.graphics.lineTo(6,400);
			
			
			this.lineSprite=new BaseComponent()
			this.addChild(this.lineSprite)
			this.lineSprite.graphics.clear();
			this.lineSprite.graphics.lineStyle(1,0xff0000,0.5);
			this.lineSprite.graphics.moveTo(6,25)
			this.lineSprite.graphics.lineTo(6,800);
			this.lineSprite.mouseEnabled=false
	
			
		}
	}
}


