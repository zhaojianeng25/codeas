package _Pan3D.skill.traject
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.interfaces.IBind;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.skill.vo.traject.TrajectoryFiexPointVo;
	import _Pan3D.skill.vo.traject.TrajectoryVo;

	/**
	 * 定点目标弹道类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class TrajectoryFiexPoint extends Trajectory
	{
		/**
		 * 弹道数据 
		 */		
		private var _data:TrajectoryFiexPointVo;
		
		public function TrajectoryFiexPoint()
		{
			super();
		}
		
		override public function update(t:int):void{
			super.update(t);
			
			var currentDistance:Number = _currentDirect.length * time;
			
			if(hasReached){
				
			}else{
				var targetDistance:Number = Vector3D.distance(_currentPos,_currentTargetPos);
				
				_currentPos.x += _currentDirect.x * time;
				_currentPos.y += _currentDirect.y * time;
				_currentPos.z += _currentDirect.z * time;
			}
			
			if(currentDistance > targetDistance){
				hasReached = true;
				reacherDistance = 0;
				ParticleManager.getInstance().removeParticle(particle);
				removeCallFun(this);
			}
			
			distance += currentDistance;
			
		}
		
		override public function get data():TrajectoryVo{
			return _data;
		}
		
		override public function addToRender(t:int):void{
			super.addToRender(t);
			var ma:Matrix3D = new Matrix3D;
			ma.appendRotation(active.rotationY,Vector3D.Y_AXIS);
			//自身点+偏移 为起始点
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
			
			
			
			//自身点+结束点 为最终点
			var endPos:Vector3D = ma.transformVector(_data.endPos);
			_currentTargetPos.setTo(active.absoluteX + endPos.x,active.absoluteY + endPos.y,active.absoluteZ + endPos.z);
			
			_currentDirect.x = _currentTargetPos.x - _currentPos.x;
			_currentDirect.y = _currentTargetPos.y - _currentPos.y;
			_currentDirect.z = _currentTargetPos.z - _currentPos.z;
			//_currentDirect = ma.transformVector(_currentDirect);
			_currentDirect.normalize();
			_currentDirect.scaleBy(_data.speed);
			
			_rotationY = - Math.atan2(_currentDirect.z,_currentDirect.x)/Math.PI * 180 + 90;
			
			setRotationMatrix(_currentTargetPos.subtract(_currentPos));
			
			update(t);
			
			if(active){
				particle.setPos(_currentPos.x,_currentPos.y,_currentPos.z);
			}
		}
		
		override public function setInfo(obj:Object):void{
			_data = obj as TrajectoryFiexPointVo;
			_frame = _data.frame;
			_allSourceNum = 1;
			setParticle(_data.particleUrl);
			particle.bindTarget = this;
		}
		
		override public function reset():void{
			super.reset();
			_currentDirect.setTo(0,0,0);
			_currentTargetPos.setTo(0,0,0);
			hasReached = false;
			reacherDistance = 0;
		}
		
		override public function dispose():void{
			super.dispose();
			_data.dispose();
			_data = null;
		}
		
	}
}