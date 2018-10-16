package view.frame
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class FrameView extends Sprite
	{
		private var _select:Boolean;

		private var bgUnSelSp:Shape;
		private var bgSelSp:Shape;
		
		private var defaultSp:Shape;
		private var interSp:Shape;
		
		private var _txt:TextField;
		private var _frameNum:int;
		
		private var _preFrame:FrameView;
		private var _nextFrame:FrameView;
		
		private var _isInter:Boolean;
		
		public function FrameView()
		{
			initBg();
		}
		private function initBg():void{
			bgUnSelSp = new Shape();
			bgUnSelSp.graphics.beginFill(0x505050,1);
			bgUnSelSp.graphics.lineStyle(1,0x323232);
			bgUnSelSp.graphics.drawRect(0,0,8,20);
			bgUnSelSp.graphics.endFill();
			this.addChild(bgUnSelSp);
			
			bgSelSp = new Shape();
			bgSelSp.graphics.beginFill(0x505050,1);
			bgSelSp.graphics.lineStyle(1,0xff0000);
			bgSelSp.graphics.drawRect(0,0,8,20);
			bgSelSp.graphics.endFill();
			this.addChild(bgSelSp);
			bgSelSp.visible = false;
			
			defaultSp = new Shape();
			defaultSp.graphics.beginFill(0x2d882d,1);
			defaultSp.graphics.drawCircle(4.5,10,3);
			defaultSp.graphics.endFill();
			this.addChild(defaultSp);
			//defaultSp.visible = false;
			
			interSp = new Shape();
			interSp.graphics.beginFill(0xeeb10c,1);
			interSp.graphics.drawCircle(4.5,10,3);
			interSp.graphics.endFill();
			this.addChild(interSp);
			interSp.visible = false;
			
			_txt = new TextField;
			_txt.width = 60;
			_txt.mouseEnabled = false;
			_txt.selectable = false;
			_txt.height = 18;
			_txt.y = -18;
			_txt.x = -(60-8)/2;
			this.addChild(_txt);
		}

		public function get select():Boolean
		{
			return _select;
		}

		public function set select(value:Boolean):void
		{ 
			_select = value;
			if(value){
				bgSelSp.visible = true;
				bgUnSelSp.visible = false;
			}else{
				bgSelSp.visible = false;
				bgUnSelSp.visible = true;
			}
		}

		public function get frameNum():int
		{
			return _frameNum;
		}

		public function set frameNum(value:int):void
		{
			_frameNum = value;
			_txt.htmlText = "<p align='center'><font size='10' face='Microsoft Yahei' color='#666666'><b>" + (value+1) + "</b></font></p>";
		}

		public function get isInter():Boolean
		{
			return _isInter;
		}

		public function set isInter(value:Boolean):void
		{
			_isInter = value;
			
			if(value){
				defaultSp.visible = false;
				interSp.visible = true;
			}else{
				defaultSp.visible = true;
				interSp.visible = false;
			}
		}
		

	}
}