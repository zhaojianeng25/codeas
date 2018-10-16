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
	 * <font size=20 color='#ff0000'>废弃类</font>
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class SkillKeyFrameSprite extends Sprite
	{
		public var frameNum:int;
		public var frameTime:Number;
		public var particle:CombineParticle;
		private var _info:Object;
		public var particleName:String;
		public var bindFly:SkillKeyFrameSprite;
		public function SkillKeyFrameSprite(info:Object)
		{
			super();
			this._info = info;
			this.frameNum = info.frameNum;
			this.particle = info.particle;
			this.particleName = info.particleName;
			frameTime = frameNum * Scene_data.frameTime;
			if(info.bindFly && info.bindFly is SkillKeyFrameSprite){
				bindFly = info.bindFly;
				bindFly.addEventListener(FlyerEvent.FLYREACH,onReach);
			}
			draw();
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		protected function onMouseDown(event:MouseEvent):void{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		public function setBindFly(flykey:SkillKeyFrameSprite):void{
			bindFly = flykey;
			bindFly.addEventListener(FlyerEvent.FLYREACH,onReach);
		}
		
		public function removeBind():void{
			if(bindFly)
				bindFly.removeEventListener(FlyerEvent.FLYREACH,onReach);
		}
		
		protected function onMouseUp(event:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.x = this.x - this.x%8;
			this.frameNum = this.x/8;
			info.frameNum = this.frameNum;
			this.frameTime = frameNum * Scene_data.frameTime;
			this.dispatchEvent(new Event(Event.CHANGE));
			//trace("frameNum" +  frameNum)
		}
		
		protected function onMouseMove(event:MouseEvent):void{
			this.x = this.parent.mouseX;
		}
		
		public function addToRender(time:Number,timeout:int=0):void{
			if(_info.target == 1){
				particle.bindTarget = AppDataBone.role;
			}else if(_info.target == 2){
				particle.bindTarget = AppDataBone.targetRole;
			}else if(_info.target == 3){
				FlyCombineParticle(particle).bindFLyTarget(AppDataBone.role,AppDataBone.targetRole);
				FlyCombineParticle(particle).addEventListener(FlyerEvent.FLYREACH,onReachFly);
			}
			if(bindFly){
				particle.reset(timeout);
			}else{
				particle.reset(time-frameTime);
			}
//			particle.visible = true;
			ParticleManager.getInstance().addParticle(particle);
			particle.addEventListener(Event.COMPLETE,onPlayCom);
			
		}
		
		protected function onReachFly(event:FlyerEvent):void{
			this.dispatchEvent(event);
		}
		
		protected function onReach(event:FlyerEvent):void{
			var evt:FlyerEvent = new FlyerEvent(FlyerEvent.FLYSTART);
			evt.timeout = event.timeout;
			this.dispatchEvent(evt);
		}
		
		private function onPlayCom(event:Event):void{
			particle.removeEventListener(Event.COMPLETE,onPlayCom);
			ParticleManager.getInstance().removeParticle(particle);
		}
		
		public function reset():void{
			ParticleManager.getInstance().removeParticle(particle);
			particle.reset();
		}
		
		private function draw():void{
			this.graphics.clear();
			if(bindFly){
				this.graphics.lineStyle(2,0x0000ff);
			}else{
				this.graphics.lineStyle(2,0x00ff00);
			}
			this.graphics.beginFill(0x0000ff,0);
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
		
		public function getAllInfo():Object{
			var obj:Object = new Object;
			for(var str:String in _info){
				if(str != "particle"){
					obj[str] = _info[str];
				}
			}
			if(bindFly){
				obj.bindFly = bindFly.info.fly.idStr;
			}
			
			return obj;
		}

		
	}
}