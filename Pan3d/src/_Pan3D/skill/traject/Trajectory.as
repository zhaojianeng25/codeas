package _Pan3D.skill.traject
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.IDataInput;
	
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3DMovie;
	import _Pan3D.display3D.interfaces.IAbsolute3D;
	import _Pan3D.display3D.interfaces.IBind;
	import _Pan3D.event.LoadCompleteEvent;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.skill.SkillManager;
	import _Pan3D.skill.custom.PathManager;
	import _Pan3D.skill.interfaces.ISkill;
	import _Pan3D.skill.vo.traject.EnumTrajectoryType;
	import _Pan3D.skill.vo.traject.TrajectoryDynamicTargetVo;
	import _Pan3D.skill.vo.traject.TrajectoryVo;
	import _Pan3D.vo.particle.ParticleVo;

	/**
	 * 弹道控制类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Trajectory extends EventDispatcher implements IBind,ISkill
	{
		/**
		 * 弹道数据 
		 */		
		//private var _data:TrajectoryVo;
		protected var _frame:int;
		/**
		 * 迭代时间 
		 */		
		public var time:int;
		/**
		 * 弹道对应的粒子 
		 */		
		public var particle:CombineParticle;
		/**
		 * 弹道走过的距离 
		 */		
		public var distance:int;
		
		/**
		 * 弹道当前所在的点 
		 */		
		protected var _currentPos:Vector3D = new Vector3D;
		/**
		 * 弹道当前的旋转 
		 */		
		protected var _rotationY:Number=0;
		
		/**
		 * 当前方向 
		 */		
		protected var _currentDirect:Vector3D = new Vector3D;
		/**
		 * 当前目标点 
		 */		
		protected var _currentTargetPos:Vector3D = new Vector3D;
		
		/**
		 * 弹道击中目标的回调函数 
		 */		
		public var completeFun:Function;
		
		/**
		 * 是否已经到达 
		 */		
		protected var hasReached:Boolean;
		
		protected var reacherDistance:int;
		
		/**
		 * 删除自身弹道的回调函数 
		 */		
		public var removeCallFun:Function;
		
		/**
		 * 弹道的发起者对象（用于计算起始位置） 
		 */		
		public var active:IAbsolute3D;
		
		private var _used:Boolean;
		
		protected var _visible:Boolean = true;
		
		protected var _allSourceNum:int;
		
		protected var _sourceNum:int;
		
		public var particleContainer:Display3DContainer;
		
		private var _addFrame:int;
		
		public var rotationMatrix:Matrix3D = new Matrix3D;
		public var tempRotationMatrix:Matrix3D = new Matrix3D;
		
		public function Trajectory()
		{
			
		}
		/**
		 * 刷帧更新逻辑 
		 * @param t
		 * 
		 */		
		public function update(t:int):void{
			time = t;
		}
		/**
		 * 启动弹道
		 * 弹道对应的粒子添加到渲染列表
		 * @param t
		 * 
		 */		
		public function addToRender(t:int):void{
			ParticleManager.getInstance().addParticle(particle);
			//_currentPos.setTo(active.absoluteX + ,active.absoluteY,active.absoluteZ);
			//update(t);
		}
		
		/**
		 * 提供当前弹道的位置 
		 * @param index
		 * @return 
		 * 
		 */		
		public function getPosV3d(index:int,out:Vector3D):void{
			//return _currentPos;
			if(out && _currentPos){
				out.setTo(_currentPos.x,_currentPos.y,_currentPos.z);
			}
		}
		
		public function getSocket(socketName:String,resultMatrix:Matrix3D):void{
			resultMatrix.identity();
			resultMatrix.append(rotationMatrix);
			resultMatrix.appendTranslation(_currentPos.x,_currentPos.y,_currentPos.z);
			
		}
		
		public function setRotationMatrix($newPos:Vector3D):void{
			$newPos.normalize();
			rotationMatrix.identity();
			tempRotationMatrix.identity();
			rotationMatrix.pointAt(Vector3D.Z_AXIS,Vector3D.X_AXIS, Vector3D.Y_AXIS);
			tempRotationMatrix.pointAt($newPos,Vector3D.X_AXIS, Vector3D.Y_AXIS);
			rotationMatrix.append(tempRotationMatrix);
		}
		
		/**
		 * 提供当前弹道的旋转 
		 * @return 
		 * 
		 */		
		public function getRotation():Number{
			return _rotationY;
		}
		
		public function getPosMatrix(index:int):Matrix3D{
			return null;
		}
		public function getOffsetPos(v3d:Vector3D,index:int):Vector3D{
			return null;
		}
		public function getBindAlpha():Number{
			return 1;
		}
		/**
		 * 获取弹道的数据 
		 * @return 
		 * 
		 */		
		public function get data():TrajectoryVo
		{
			return null;
		}
		/**
		 * 装载入数据 
		 * @param obj
		 * 
		 */		
		public function setInfo(obj:Object):void{
			
		}
		/**
		 * 获取一个按给定数据的指定的弹道类型 
		 * @param $vo 弹道模型数据
		 * @return 弹道
		 * 
		 */		
		public static function getTrajectory($vo:TrajectoryVo,$specialType:int = -1,$particleContainer:Display3DContainer=null):Trajectory{
			var trajectoty:Trajectory;
			if($specialType != -1){
				trajectoty = new TrajectoryCustom;
				TrajectoryCustom(trajectoty).pathCls = PathManager.getPath($specialType);
			}else if($vo.trajectoryType == EnumTrajectoryType.dynamicTarget){
				trajectoty = new TrajectoryTarget;
			}else if($vo.trajectoryType == EnumTrajectoryType.FixedPoint){
				trajectoty = new TrajectoryFiexPoint;
			}else if($vo.trajectoryType == EnumTrajectoryType.dynamicPoint){
				trajectoty = new TrajectoryDynamicPoint;
			}
			
			trajectoty.particleContainer = $particleContainer;
			
			trajectoty.setInfo($vo);
			
			return trajectoty;
		}
		
		/**
		 * 帧数 
		 */
		public function get frame():int
		{
			return _frame + _addFrame;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set frame(value:int):void
		{
			_frame = value;
		}
		/**
		 * 装载对应的粒子特效 
		 * @param 粒子路径
		 * 
		 */		
		public function setParticle(url:String):void{
			var particleVo:ParticleVo = new ParticleVo;
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
			_sourceNum++;
			
			if(_sourceNum == _allSourceNum){
				this.dispatchEvent(new LoadCompleteEvent(LoadCompleteEvent.LOAD_COMPLETE))
			}
		}
		
		/**
		 * 重置弹道 
		 * 
		 */		
		public function reset():void{
			time = 0;
			_currentPos.setTo(0,0,0);
			_rotationY = 0;
			particle.reset();
			ParticleManager.getInstance().removeParticle(particle);
			//_addFrame = 0;
		}
		
		public function reload():void{
			if(particle)
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
			
		}
		
		public function dispose():void{
			particle.dispose();
			
			_currentPos = null;
			_currentDirect = null;
			_currentTargetPos = null;
			completeFun = null;
			removeCallFun = null;
			active = null;
			
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

		public function get addFrame():int
		{
			return _addFrame;
		}

		public function set addFrame(value:int):void
		{
			_addFrame = value;
		}

		
	}
	
}