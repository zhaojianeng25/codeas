package _Pan3D.skill.traject
{
	import _Pan3D.display3D.interfaces.IAbsolute3D;
	import _Pan3D.event.LoadCompleteEvent;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.skill.SkillManager;
	import _Pan3D.skill.custom.Path;
	import _Pan3D.skill.interfaces.IPath;
	import _Pan3D.skill.vo.traject.TrajectoryDynamicTargetVo;
	import _Pan3D.skill.vo.traject.TrajectoryVo;
	import _Pan3D.vo.particle.ParticleVo;
	
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * 自定义弹道类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class TrajectoryCustom extends Trajectory
	{
		/**
		 * 动态弹道目标数据 
		 */		
		private var _data:TrajectoryDynamicTargetVo;
		
		/**
		 * 目标对象 
		 */		
		public var target:IAbsolute3D;
		
		public var targetParam:Object;
		
		/**
		 * 弹道结束后要播放的粒子 
		 */		
		public var endParticle:CombineParticle;
		
		private var path:IPath;
		
		private var _particleVec:Vector.<CombineParticle> = new Vector.<CombineParticle>;
		private var _pathVec:Vector.<Path> = new Vector.<Path>;
		private var _dicKey:Dictionary = new Dictionary;
		public var pathCls:Class;
		
		public function TrajectoryCustom()
		{
			super();
//			path = new CustomTestPath();
//			if(Math.random() > 0.5){
//				pathCls = CustomXuanPath;
//			}else{
//				pathCls = CustomTestPath;
//			}
//			
//			pathCls = CustomDanmuPath;
			
		}
		/**
		 * 逻辑刷帧 
		 * @param t
		 * 
		 */		
		override public function update(t:int):void{
			super.update(t);
			//path.update(t);
			for(var i:int;i<_pathVec.length;i++){
				_pathVec[i].update(t);
			}
			
		}
		
		override public function getPosV3d(index:int,out:Vector3D):void{
			path.getPosV3d(index,out);
		}
		
		override public function getPosMatrix(index:int):Matrix3D{
			return path.getPosMatrix(index);
		}
		
		private var reachedNum:int;
		private function pathArrive($path:Path):void{
			var pathParticle:CombineParticle = _dicKey[$path]
			if(pathParticle){
				ParticleManager.getInstance().removeParticle(pathParticle);
			}
			reachedNum++;
			if(reachedNum == $path.num){
				arrive();
			}
		}
		
		/**
		 * 弹道到达 
		 * @param t
		 * 
		 */		
		private function arrive(t:int=0):void{
			hasReached = true;
			//ParticleManager.getInstance().removeParticle(particle);
			//trace(getTimer() - getAllTime);
			if(endParticle){
				ParticleManager.getInstance().addParticle(endParticle);
				endParticle.reset(t);
				endParticle.addEventListener(Event.COMPLETE,onPlayCom);
				
				endParticle.bindOffset = new Vector3D(target.absoluteX,target.absoluteY + _data.height,target.absoluteZ);
			}else{
				removeCallFun(this);
			}
			
		}
		
		private function setClass(cls:Class):void{
			pathCls = cls;
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
		private var getAllTime:int;
		override public function addToRender(t:int):void{
			//super.addToRender(t);
			for(var i:int;i<_pathVec.length;i++){
				if(targetParam){
					_pathVec[i].targetParam = targetParam;
				}
				_pathVec[i].setInfo(active,target,pathArrive,pathStart);
			}
			
//			for(i = 0;i<_particleVec.length;i++){
//				ParticleManager.getInstance().addParticle(_particleVec[i]);
//			}
			getAllTime = getTimer();
		}
		
		private function pathStart($path:Path):void{
			var pathParticle:CombineParticle = _dicKey[$path]
			if(pathParticle){
				pathParticle.reset();
				//pathParticle.setXYZ(active.absoluteX,active.absoluteY + $path.baseHeight,active.absoluteZ);
				pathParticle.x = active.absoluteX
				pathParticle.y = active.absoluteY + $path.baseHeight;
				pathParticle.z = active.absoluteZ;
				ParticleManager.getInstance().addParticle(pathParticle);
			}
		}
		
		override public function get data():TrajectoryVo{
			return _data;
		}
		
		override public function setInfo(obj:Object):void{
			_data = obj as TrajectoryDynamicTargetVo;
			_frame = _data.frame;
			//setParticle(_data.particleUrl);
			//particle.bindTarget = this;
			//particle.bindRatation = new Vector3D;
			if(_data.endParticleUrl){
				_allSourceNum = 2;
				setEndParticle(_data.endParticleUrl);
			}else{
				endParticle = null;
				_allSourceNum = 1;
			}
			
			addPathPaticles();
		}
		
		public function addPathPaticles():void{
			var num:int = 1;
			for(var i:int;i<num;i++){
				var path:Path = new pathCls();
				num = path.num;
				path.id = i;
				var pathParticle:CombineParticle = loadParticle(_data.particleUrl);
				pathParticle.bindTarget = path;
				pathParticle.bindRatation = new Vector3D;
				_pathVec.push(path);
				_particleVec.push(pathParticle);
				_dicKey[path] = pathParticle;
				
				if(i == 0){
					pathParticle.addEventListener(LoadCompleteEvent.LOAD_COMPLETE,onSourceCom);
					if(pathParticle.getHasLoadCom()){//如果已经完成则直接执行回调函数（如果缓存中有 事件在监听前已经分发）
						onSourceCom();
					}
				}
			}
			
		}
		
		public function loadParticle(url:String):CombineParticle{
			//url = "../res/data/res3d/particle2/lid654.lyf";
			var particleVo:ParticleVo = new ParticleVo;
			var $particle:CombineParticle = ParticleManager.getInstance().loadParticle(url,particleVo,SkillManager.priority,Boolean(particleContainer),particleContainer);
			return $particle;
		}
		
		override public function reset():void{
			time = 0;

			hasReached = false;
			reacherDistance = 0;
			if(endParticle){
				endParticle.reset();
				ParticleManager.getInstance().removeParticle(endParticle);
			}
			for(var i:int;i<_pathVec.length;i++){
				_pathVec[i].reset();
			}
			
			for(i=0;i<_particleVec.length;i++){
				_particleVec[i].reset();
			}
			reachedNum = 0;
			
			//targetParam = null;
		}
		
		override public function stop():void{
			for each(var pathParticle:CombineParticle in  _dicKey){
				ParticleManager.getInstance().removeParticle(pathParticle);
			}
			
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
			_visible = value;
			if(endParticle)
				endParticle.visible = value;
		}
		
		override public function reload():void{
			super.reload();
			
			for(var i:int=0;i<_particleVec.length;i++){
				_particleVec[i].reload()
			}
			
			if(endParticle)
				endParticle.reload();
		}
		private var hasDisposed:Boolean;
		override public function dispose():void{
			if(hasDisposed){
				return;
			}
			//super.dispose();
			if(_particleVec){
				for(var i:int=0;i<_particleVec.length;i++){
					_particleVec[i].dispose()
				}
			}
			
			if(endParticle){
				endParticle.dispose();
				endParticle = null;
			}
			
			if(_pathVec){
				_pathVec.length = 0;
			}
			
			_pathVec = null;
			
			if(_data){
				_data.dispose();
			}
			_data = null;
			
			target = null;
			
			targetParam = null;
			
			if(_dicKey){
				for(var key:String in _dicKey){
					delete _dicKey[key];
				}
			}
			
			_dicKey = null
				
			pathCls = null;
			if(_pathVec){
				for(i=0;i<_pathVec.length;i++){
					_pathVec[i].dispose();
				}
				_pathVec.length = 0;
				_pathVec = null;
			}
			
			particleContainer = null;
			
			hasDisposed = true;
		}
		
	}
}