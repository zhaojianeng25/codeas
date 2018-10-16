package _Pan3D.skill.effect
{
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.event.LoadCompleteEvent;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.skill.SkillManager;
	import _Pan3D.skill.interfaces.ISkill;
	import _Pan3D.skill.vo.effect.EffectSkillVo;
	import _Pan3D.skill.vo.effect.EnumEffectType;
	import _Pan3D.vo.particle.ParticleVo;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	
	/**
	 * 技能效果类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class EffectSkill extends EventDispatcher implements ISkill
	{
		/**
		 * 对应的数据Vo 
		 */		
		public var data:EffectSkillVo;
		/**
		 * 效果对应的粒子 
		 */		
		public var particle:CombineParticle;
		/**
		 * 帧数 
		 */		
		protected var _frame:int;
		
		/**
		 * 效果完成的回调函数 
		 */		
		public var removeCallFun:Function;
		
		/**
		 * 播放完成的回调函数
		 */		
		public var completeFun:Function;
		
		private var _used:Boolean;
		
		private var _visible:Boolean = true;
		
		public var particleContainer:Display3DContainer;
		
		public function EffectSkill()
		{
		}
		
		public function update(t:int):void
		{
			
		}
		/**
		 * 添加到渲染列表 
		 * @param t
		 * 
		 */		
		public function addToRender(t:int):void
		{
			ParticleManager.getInstance().addParticle(particle);
			particle.reset(t);
			particle.addEventListener(Event.COMPLETE,onPlayCom);
		}
		/**
		 * 粒子播放完成 
		 * @param event
		 * 
		 */		
		private function onPlayCom(event:Event=null):void{
			particle.removeEventListener(Event.COMPLETE,onPlayCom);
			ParticleManager.getInstance().removeParticle(particle);
			removeCallFun(this);
		}
		/**
		 * 设置信息 
		 * @param obj
		 * 
		 */		
		public function setInfo(obj:Object):void
		{
			data = obj as EffectSkillVo;
			_frame = data.frame;
			setParticle(data.particleUrl);
		}
		
		public function get frame():int
		{
			return _frame;
		}
		
		public function set frame(value:int):void
		{
			_frame = value;
		}
		
		public function addFrame(value:int):void{
			_frame = data.frame + value;
		}
			
		/**
		 * 重置数据 
		 * 
		 */		
		public function reset():void{
			particle.reset();
			ParticleManager.getInstance().removeParticle(particle);
			//_frame = data.frame;
		}
		
		/**
		 * 装载对应的粒子特效 
		 * @param 粒子路径
		 * 
		 */		
		public function setParticle(url:String):void{
			var particleVo:ParticleVo = new ParticleVo;
			particleVo.bindIndex = -1;
			particle = ParticleManager.getInstance().loadParticle(url,particleVo,SkillManager.priority,Boolean(particleContainer),particleContainer);
			
			particle.addEventListener(LoadCompleteEvent.LOAD_COMPLETE,onSourceCom);
			if(particle.getHasLoadCom()){//如果已经完成则直接执行回调函数（如果缓存中有 事件在监听前已经分发）
				onSourceCom();
			}
		}
		
		protected function onSourceCom(event:Event=null):void{
			if(event){
				event.target.removeEventListener(LoadCompleteEvent.LOAD_COMPLETE,onSourceCom);
			}
			
			this.dispatchEvent(new LoadCompleteEvent(LoadCompleteEvent.LOAD_COMPLETE))
		}
		
		/**
		 * 获取一个按给定数据类型指定的特效 
		 * @param $vo 特效模型数据
		 * @return  特效
		 * 
		 */		
		public static function getEffectSkill($vo:EffectSkillVo,$particleContainer:Display3DContainer = null):EffectSkill{
			var effectSkill:EffectSkill;
			if($vo.effectType == EnumEffectType.FIXED_POINT){
				effectSkill = new EffectFiexSkill;
			}else if($vo.effectType == EnumEffectType.DYNAMIC_POINT){
				effectSkill = new EffectDynamicSkill;
			}
			effectSkill.particleContainer = $particleContainer;
			
			effectSkill.setInfo($vo);
			
			return effectSkill;
		}
		
		public function reload():void{
			particle.reload();
		}

		public function get used():Boolean
		{
			return _used;
		}

		public function set used(value:Boolean):void
		{
			_used = value;
		}
		
		public function stop():void{
			onPlayCom();
		}
		
		public function dispose():void{
			particle.dispose();
			
			data.dispose();
			
			data = null;
			
			removeCallFun = null;
			
			completeFun = null;
			
			particleContainer = null;
		}

		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			_visible = value;
			particle.visible = _visible;
		}
		
		

		
	}
}