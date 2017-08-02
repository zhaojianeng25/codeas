package view.controlCenter
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * 技能条背景显示类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class SkillBgSprite extends Sprite
	{
		private var _info:Object;
		private var _offsetX:int;
		public function SkillBgSprite(data:Object)
		{
			super();
			this._info = data;
			draw();
			//this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		protected function onMouseDown(event:MouseEvent):void{
			_offsetX = this.mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		protected function onMouseMove(event:MouseEvent):void{
			this.x = this.parent.mouseX - _offsetX;
			if(this.x < 0 ){
				this.x = 0;
			}
		}
		
		private function draw():void{
			var length:int = _info.data.length*8*2;
			this.graphics.lineStyle(1,0x000000);
			this.graphics.beginFill(0xffffff);

			this.graphics.drawRect(0,0,6,14);
			this.graphics.drawRect(length,0,6,14);
			this.graphics.moveTo(7,7);
			this.graphics.lineTo(length,7);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1,0,0);
			this.graphics.beginFill(0x00ff00,0);
			this.graphics.drawRect(0,0,length,18);
			this.graphics.endFill();
			
		}

		public function get info():Object
		{
			return _info;
		}

		public function set info(value:Object):void
		{
			_info = value;
		}
		
		public function getAllInfo():void{
			
		}
		
	}
}