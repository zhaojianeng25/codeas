package _Pan3D.skill
{
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.FlyCombineParticle;
	import _Pan3D.particle.ctrl.Flyer;
	import _Pan3D.particle.ctrl.FlyerEvent;
	import _Pan3D.particle.ctrl.ParticleManager;
	
	import _me.Scene_data;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.flash_proxy;
	
	public class SkillKeyFrame extends EventDispatcher
	{
		public var frameNum:int;
		public var frameTime:Number;
		public var particle:CombineParticle;
		private var _info:Object;
		public var particleName:String;
		public var bindFly:SkillKeyFrame;
		public var parent:SkillTimeLine;
		public function SkillKeyFrame(info:Object,isClone:Boolean=false)
		{
			super();
			this._info = info;
			this.frameNum = info.frameNum;
			this.particle = info.particle;
			this.particleName = info.particleName;
			frameTime = frameNum * Scene_data.frameTime;
			if(!isClone && info.bindFly && info.bindFlyFrame is SkillKeyFrame){
				bindFly = info.bindFlyFrame;
				bindFly.addEventListener(FlyerEvent.FLYREACH,onReach);
			}
		}
		
		public function setBindFly(flykey:SkillKeyFrame):void{
			bindFly = flykey;
			bindFly.addEventListener(FlyerEvent.FLYREACH,onReach);
		}
		
		public function addToRender(time:Number,timeout:int=0):void{
			if(_info.target == 1){
				//particle.bindTarget = parent.activeRole;
			}else if(_info.target == 2){
				particle.bindTarget = parent.targetRole;
			}else if(_info.target == 3){
//				FlyCombineParticle(particle).bindFLyTarget(parent.activeRole,parent.targetRole);
				//FlyCombineParticle(particle).addEventListener(FlyerEvent.FLYREACH,onReachFly);
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
			this.dispatchEvent(event);
			trace("播放完成")
		}
		
		public function reset():void{
			ParticleManager.getInstance().removeParticle(particle);
			particle.reset();
		}
		

		public function get info():Object
		{
			return _info;
		}

		public function set info(value:Object):void
		{
			_info = value;
		}
		
		public function clone():SkillKeyFrame{
			var skillKeyFrame:SkillKeyFrame = new SkillKeyFrame(this._info,true);
			skillKeyFrame.particle = particle.clone();
			skillKeyFrame.bindFly = null;
			return skillKeyFrame;
		}
		
	}
}