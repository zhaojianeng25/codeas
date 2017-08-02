package view.controlCenter
{
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.FlyCombineParticle;
	import _Pan3D.particle.ctrl.Flyer;
	import _Pan3D.particle.ctrl.FlyerEvent;
	import _Pan3D.particle.ctrl.ParticleManager;
	
	import _me.Scene_data;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.flash_proxy;
	/**
	 * 关键帧的显示类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class SkillKeyFrameNewSprite extends Sprite
	{
		public var frameNum:int;
		private var _info:Object;
		public function SkillKeyFrameNewSprite(info:Object)
		{
			super();
			this._info = info;
			this.frameNum = info.frameNum;
			draw();
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
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
			this.frameNum = this.x/8;
			info.frameNum = this.frameNum;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onMouseMove(event:MouseEvent):void{
			this.x = this.parent.mouseX;
		}
		/**
		 * 绘制出背景 
		 * 
		 */		
		private function draw():void{
			this.graphics.clear();
			if(_info.type == 1){
				this.graphics.lineStyle(2,0x00ff00);
			}else if(_info.type == 2){
				this.graphics.lineStyle(2,0x0000ff);
			}
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,6,8,8);
		}

		public function get info():Object
		{
			return _info;
		}

		public function set info(value:Object):void
		{
			_info = value;
		}
		
	}
}