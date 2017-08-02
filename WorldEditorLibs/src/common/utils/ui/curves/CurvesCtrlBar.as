package common.utils.ui.curves
{
	import flash.display.Sprite;
	
	public class CurvesCtrlBar extends Sprite
	{
		public static var LEFT:int = 0;
		public static var RIGHT:int = 1;
		private var _type:int;
		private var _select:Boolean;
		private var _isLine:Boolean;
		public function CurvesCtrlBar()
		{
			super();
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
			draw();
		}
		
		public function draw():void{
			this.graphics.clear();
			this.graphics.lineStyle(1,_isLine ? 0x00ffff : 0xffffff);
			
			
			if(type == LEFT){
				
				this.graphics.moveTo(-40,0);
				this.graphics.lineTo(-4,0);
				
				this.graphics.lineStyle(1,0xffffff);
				this.graphics.beginFill(_select ? 0x00ff00 : 0xff0000);
				this.graphics.drawCircle(-40,0,4);
			}else if(type == RIGHT){
				
				this.graphics.moveTo(4,0);
				this.graphics.lineTo(40,0);
				
				this.graphics.lineStyle(1,0xffffff);
				this.graphics.beginFill(_select ? 0x00ff00 : 0xff0000);
				this.graphics.drawCircle(40,0,4);
				this.graphics.endFill();
			}
			
			
		}

		public function get select():Boolean
		{
			return _select;
		}

		public function set select(value:Boolean):void
		{
			_select = value;
			draw();
		}

		public function get isLine():Boolean
		{
			return _isLine;
		}

		public function set isLine(value:Boolean):void
		{
			_isLine = value;
			draw();
		}


	}
}