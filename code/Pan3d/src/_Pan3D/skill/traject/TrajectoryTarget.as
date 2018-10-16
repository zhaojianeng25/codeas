package _Pan3D.skill.traject
{
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.Display3DMovie;
	import _Pan3D.display3D.interfaces.IAbsolute3D;
	import _Pan3D.display3D.interfaces.IBind;
	import _Pan3D.event.LoadCompleteEvent;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.skill.SkillManager;
	import _Pan3D.skill.vo.traject.TrajectoryDynamicTargetVo;
	import _Pan3D.skill.vo.traject.TrajectoryVo;
	import _Pan3D.vo.particle.ParticleVo;

	/**
	 * 动态目标弹道类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class TrajectoryTarget extends Trajectory
	{
		/**
		 * 动态弹道目标数据 
		 */		
		private var _data:TrajectoryDynamicTargetVo;
		
		/**
		 * 目标对象 
		 */		
		public var target:IAbsolute3D;
		
		/**
		 * 弹道结束后要播放的粒子 
		 */		
		public var endParticle:CombineParticle;
		
		
		private var _socketMaxrix:Matrix3D = new Matrix3D;
		
		
		
		public function TrajectoryTarget()
		{
			super();
		}
		/**
		 * 逻辑刷帧 
		 * @param t
		 * 
		 */		
		override public function update(t:int):void{
			super.update(t);
			
			if(hasReached){
				return;
			}
			
			if(setCurrentPos()){
				
				_currentDirect.x = _currentTargetPos.x - _currentPos.x;
				_currentDirect.y = _currentTargetPos.y - _currentPos.y;
				_currentDirect.z = _currentTargetPos.z - _currentPos.z;
				
				_currentDirect.normalize();
				_currentDirect.scaleBy(_data.speed);
				
				//_rotationY = - Math.atan2(_currentDirect.z,_currentDirect.x)/Math.PI * 180 + 90;
				
				setRotationMatrix(_currentTargetPos.subtract(_currentPos));
				
				if(_currentDirect.length == 0){
					arrive(t);
					return;
				}
			}
			
			var currentDistance:Number = _currentDirect.length * time;
			
			if(hasReached){

			}else{
				var targetDistance:Number = Vector3D.distance(_currentPos,_currentTargetPos);
				
				_currentPos.x += _currentDirect.x * time;
				_currentPos.y += _currentDirect.y * time;
				_currentPos.z += _currentDirect.z * time;
			}
			
			if(currentDistance > targetDistance){
				arrive(t);
			}
			
			distance += currentDistance;
			
			
		}
		
		private function setCurrentPos():Boolean{
			if(_data.hitSocket && target is IBind){
				IBind(target).getSocket(_data.hitSocket,_socketMaxrix);
				if(_currentTargetPos.equals(_socketMaxrix.position)){
					return false;
				}else{
					_currentTargetPos.setTo(_socketMaxrix.position.x,_socketMaxrix.position.y,_socketMaxrix.position.z);
					return true;
				}
			}else{
				if(_currentTargetPos.x && target.absoluteX && _currentTargetPos.y == target.absoluteY &&_currentTargetPos.z == target.absoluteZ){
					return false;
				}else{
					_currentTargetPos.setTo(target.absoluteX,target.absoluteY,target.absoluteZ);
					return true;
				}
			}
		}
		/**
		 * 弹道到达 
		 * @param t
		 * 
		 */		
		private function arrive(t:int):void{
			hasReached = true;
			reacherDistance = 0;
			ParticleManager.getInstance().removeParticle(particle);
			
			if(endParticle){
				ParticleManager.getInstance().addParticle(endParticle);
				endParticle.reset(t);
				endParticle.addEventListener(Event.COMPLETE,onPlayCom);
				
				endParticle.setPos(_currentTargetPos.x,_currentTargetPos.y,_currentTargetPos.z);
			}else{
				removeCallFun(this);
			}
			if(Boolean(completeFun)){
				completeFun();
			}
		}
		/**
		 * 击中粒子播放完成 
		 * @param event
		 * 
		 */		
		private function onPlayCom(event:Event):void{
			endParticle.removeEventListener(Event.COMPLETE,onPlayCom);
			ParticleManager.getInstance().removeParticle(endParticle);
			removeCallFun(this);
		}
		override public function addToRender(t:int):void{
			super.addToRender(t);
			var ma:Matrix3D = new Matrix3D;
			ma.appendRotation(active.rotationY,Vector3D.Y_AXIS);
			
			var beginPos:Vector3D;
			if(data.beginType == 0){
				beginPos = ma.transformVector(data.beginPos);
				_currentPos.setTo(active.absoluteX + beginPos.x,active.absoluteY + beginPos.y,active.absoluteZ + beginPos.z);
			}else if(data.beginType == 1 && active is IBind){
				var tempMa:Matrix3D = new Matrix3D;
				
				IBind(active).getSocket(data.beginSocket,tempMa);
				_currentPos.setTo(tempMa.position.x,tempMa.position.y,tempMa.position.z);
			}else{
				_currentPos.setTo(active.absoluteX,active.absoluteY,active.absoluteZ);
			}
			
			if(active){ 
				particle.setPos(_currentPos.x,_currentPos.y,_currentPos.z);  
			}
			
			update(t);
		}
		
		override public function get data():TrajectoryVo{
			return _data;
		}
		
		override public function setInfo(obj:Object):void{
			_data = obj as TrajectoryDynamicTargetVo;
			_frame = _data.frame;
			if(_data.endParticleUrl){
				_allSourceNum = 2;
				setEndParticle(_data.endParticleUrl);
			}else{
				_allSourceNum = 1;
				endParticle = null;
			}
			setParticle(_data.particleUrl);
			particle.bindTarget = this;
		}
		
		override public function reset():void{
			super.reset();
			_currentDirect.setTo(0,0,0);
			_currentTargetPos.setTo(0,0,0);
			hasReached = false;
			reacherDistance = 0;
			if(endParticle){
				endParticle.reset();
				ParticleManager.getInstance().removeParticle(endParticle);
			}
		}
		
		/**
		 * 装载对应的弹道结束后的粒子特效 
		 * @param 粒子路径
		 * 
		 */		
		public function setEndParticle(url:String):void{
			var particleVo:ParticleVo = new ParticleVo;
			endParticle = ParticleManager.getInstance().loadParticle(url,particleVo,SkillManager.priority,Boolean(particleContainer),particleContainer);
			
			endParticle.addEventListener(LoadCompleteEvent.LOAD_COMPLETE,onSourceCom);
			if(endParticle.getHasLoadCom()){//如果已经完成则直接执行回调函数（如果缓存中有 事件在监听前已经分发）
				onSourceCom();
			}
		}
		
		override public function set visible(value:Boolean):void{
			super.visible = value;
			if(endParticle)
				endParticle.visible = value;
		}
		
		override public function reload():void{
			super.reload();
			if(endParticle)
				endParticle.reload();
		}
		
		override public function stop():void{
			
			hasReached = true;
			reacherDistance = 0;
			ParticleManager.getInstance().removeParticle(particle);
			
			if(endParticle && endParticle.hasStage){
				endParticle.removeEventListener(Event.COMPLETE,onPlayCom);
				ParticleManager.getInstance().removeParticle(endParticle);
			}
			removeCallFun(this);
			
			if(Boolean(completeFun)){
				completeFun();
			}
		}
		
		override public function dispose():void{
			super.dispose();
			
			if(endParticle){
				endParticle.dispose();
				endParticle.removeEventListener(LoadCompleteEvent.LOAD_COMPLETE,onSourceCom);
			}
			if(_data){
				_data.dispose();
				_data = null;
			}
			target = null;
			
			particleContainer = null;
		}
		
	}
}