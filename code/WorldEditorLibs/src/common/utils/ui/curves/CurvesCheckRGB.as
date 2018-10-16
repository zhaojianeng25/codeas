package common.utils.ui.curves
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	public class CurvesCheckRGB extends UIComponent
	{
		private var _check:Boolean = true;
		private var _color:uint;
		public var type:int;
		public function CurvesCheckRGB()
		{
			super();
			draw();
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			check = !check;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		public function draw():void{
			this.graphics.clear();
			this.graphics.beginFill(_color,_check?1:0);
			this.graphics.lineStyle(1,_color);
			this.graphics.drawRect(0,0,7,7);
			this.graphics.endFill();
		}

		public function get check():Boolean
		{
			return _check;
		}

		public function set check(value:Boolean):void
		{
			_check = value;
			draw();
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
			draw();
		}


	}
}