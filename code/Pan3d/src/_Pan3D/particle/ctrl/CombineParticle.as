package _Pan3D.particle.ctrl
{
	import flash.display3D.Program3D;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.display3D.interfaces.IBind;
	import _Pan3D.event.LoadCompleteEvent;
	import _Pan3D.particle.Display3DFacetPartilce;
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.Display3DPartilceShader;
	import _Pan3D.particle.ball.Display3DBallNewShader;
	import _Pan3D.particle.ball.Display3DBallPartilceNew;
	import _Pan3D.particle.bone.Display3DBonePartilce;
	import _Pan3D.particle.bone.Display3DBoneShader;
	import _Pan3D.particle.crossFacet.Display3DCrossFacetPartilce;
	import _Pan3D.particle.crossFacet.Display3DCrossFacetShader;
	import _Pan3D.particle.cylinder.Display3DCylinderPartilce;
	import _Pan3D.particle.cylinder.Display3DCylinderShader;
	import _Pan3D.particle.follow.Display3DFollowPartilce;
	import _Pan3D.particle.follow.Display3DFollowShader;
	import _Pan3D.particle.followLocus.Display3DFollowLocusPartilce;
	import _Pan3D.particle.followLocus.Display3DFollowLocusShader;
	import _Pan3D.particle.followLocus.Display3DFollowMulLocusParticle;
	import _Pan3D.particle.locus.Display3DLocusPartilce;
	import _Pan3D.particle.locus.Display3DLocusShader;
	import _Pan3D.particle.locusball.Display3DLocusBallPartilce;
	import _Pan3D.particle.locusball.Display3DLocusBallShader;
	import _Pan3D.particle.modelObj.Display3DModelPartilce;
	import _Pan3D.particle.modelObj.Display3DModelShader;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.utils.Log;
	
	import _me.Scene_data;

	public class CombineParticle extends EventDispatcher
	{
		public var timeLineAry:Vector.<TimeLine>;
		protected var _container:Display3DContainer;
		private var maxTime:Number = 3000;
		protected var currentTime:int;
		private var _bindIndex:int;
		private var _bindTarget:IBind;
		private var _bindSocket:String;
		private var _bindOffset:Vector3D;
		private var _bindRatation:Vector3D;
		public var bindNonRotation:Boolean;
		
		private var _ratationV3d:Vector3D;
		private var _offset:Vector3D;
		
		public var id:uint;
		public var layer:uint=0
			
		public var url:String;
		
		public var isInUI:Boolean = false;
		
		private var _hasStage:Boolean;
		
		private var _hasUnload:Boolean;
		
		/**
		 * 是否已经有粒子数据 
		 */		
		protected var _hasData:Boolean;
		
		protected var _cloneList:Vector.<CombineParticle>;
		
		private var _visible:Boolean = true;
		
		private var _x:int;
		private var _y:int;
		private var _z:int;
		
		private var _rotationX:int;
		private var _rotationY:int;
		private var _rotationZ:int;
		
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		private var _scaleZ:Number = 1;
		
		private var _scale:Number = 1;
		
		private var _absoluteX:int;
		private var _absoluteY:int;
		private var _absoluteZ:int;
		/**
		 * 粒子的资源完成数量 
		 */		
		private var _sourceComNum:int;
		/**
		 * 需要粒子资源的总数量 
		 */		
		private var _sourceAllNum:int = 1000;
		/**
		 * 加载优先级 
		 */		
		public var priority:int;
		
		public var is3D:Boolean;
		
		private var _isInGroup:Boolean;
		private var _groupPos:Vector3D;
		private var _groupScale:Vector3D;
		private var _groupRotation:Vector3D;
		
		public function CombineParticle(container:Display3DContainer)
		{
			timeLineAry = new Vector.<TimeLine>;
			_container = container;
		}
		
		public function set data(ary:Array):void{
			_sourceComNum = 0;
			_sourceAllNum = ary.length;
			for(var i:int;i<ary.length;i++){
				var diaplayInfo:Object = ary[i].display;
				var timelineInfo:Object = ary[i].timeline;
				
				var display3D:Display3DParticle = getDisplay3D(diaplayInfo);
				
				display3D.addEventListener(Event.COMPLETE,onSourceLoadCom);
				
				display3D.layer=layer
				
				var timeline:TimeLine = new TimeLine();
				timeline.setAllInfo(timelineInfo);
				timeline.display3D = display3D;
				
				timeLineAry.push(timeline);
				if(_bindTarget){
					display3D.bindTarget = _bindTarget;
				}
				
				display3D.bindIndex = _bindIndex;

				
				display3D.setAllInfo(diaplayInfo);
				
				display3D.resetPos(_absoluteX,_absoluteY,_absoluteZ);
				
				display3D.setRotation(_rotationX,_rotationY,_rotationZ);
				
				display3D.setScale(_scaleX,_scaleY,_scaleZ);
				
				display3D.priority = priority;
				
				if(_ratationV3d && _offset){
					display3D.setRotationV3d(_ratationV3d,_offset);
				}
				
				display3D.outVisible = this._visible;
			}
			
			if(_bindTarget && _bindTarget is Display3dGameMovie){
//				if(is3D){
//					setXYZ(Display3dGameMovie(_bindTarget).absoluteX,Display3dGameMovie(_bindTarget).absoluteY,Display3dGameMovie(_bindTarget).absoluteZ);
//				}else{
//					setXY(Display3dGameMovie(_bindTarget).x,Display3dGameMovie(_bindTarget).y);
//				}
			}
			
			if(_hasStage){
				addToRender();
			}
			maxTime = getMaxNum();
			_hasData = true;
			if(_cloneList){//如果有对应的克隆队列
				for(i=0;i<_cloneList.length;i++){
					_cloneList[i].cloneData(this);
				}
				_cloneList.length = 0;
				_cloneList = null;
			}
			
			if(_hasRealDispose){
				realDispose();
			}
			
		}
		
		public function setData(ary:Array):void{
			_sourceComNum = 0;
			_sourceAllNum = ary.length;
			for(var i:int;i<ary.length;i++){
				var diaplayInfo:Object = ary[i].display;
				var timelineInfo:Object = ary[i].timeline;
				
				var display3D:Display3DParticle = getDisplay3D(diaplayInfo);
				
				display3D.addEventListener("materialComplete",onSourceLoadCom);
				
				var timeline:TimeLine = new TimeLine();
				timeline.setAllInfo(timelineInfo);
				timeline.display3D = display3D;
				
				timeLineAry.push(timeline);
				
				display3D.bindTarget = _bindTarget;
				display3D.bindSocket = _bindSocket;
				
				display3D.setAllInfo(diaplayInfo);
				
				display3D.priority = priority;
				
				display3D.outVisible = this._visible;
				
				display3D.isInGroup = _isInGroup;
				display3D.groupPos = _groupPos;
				display3D.groupRotation = _groupRotation;
				display3D.groupScale = _groupScale;
				
			}
			
			
			updateMatrix();
			
			updateBind();
			
			if(_hasStage){
				addToRender();
			}
			
			maxTime = getMaxNum();
			_hasData = true;
			if(_cloneList){//如果有对应的克隆队列
				for(i=0;i<_cloneList.length;i++){
					_cloneList[i].cloneData(this);
				}
				_cloneList.length = 0;
				_cloneList = null;
			}
			
			if(_hasRealDispose){
				realDispose();
			}
			
		}
		
		private function getMaxNum():Number{
			var max:Number = 0;
			for(var i:int;i<timeLineAry.length;i++){
				if(max < timeLineAry[i].maxFrameNum){
					max = timeLineAry[i].maxFrameNum;
				}
			}
			max = max * 1000 / 60;
			return max;
		}
		
		public function getDisplay3D(obj:Object):Display3DParticle{
			var type:int = obj.particleType;
			var display3D:Display3DParticle;
			var program:Program3D;
			

			switch(type)
			{
				case 1:
				{
					display3D = new Display3DFacetPartilce(Scene_data.context3D);
					Program3DManager.getInstance().registe(Display3DPartilceShader.DISPLAY3DPARTILCESHADER,Display3DPartilceShader);
					program = Program3DManager.getInstance().getProgram(Display3DPartilceShader.DISPLAY3DPARTILCESHADER);
					break;
				}
			
				case 3:
				{
					display3D = new Display3DLocusPartilce(Scene_data.context3D);
					Program3DManager.getInstance().registe(Display3DLocusShader.DISPLAY3DLOCUSSHADER,Display3DLocusShader);
					program = Program3DManager.getInstance().getProgram(Display3DLocusShader.DISPLAY3DLOCUSSHADER);
					break;
				}	
				case 4:
				{
					display3D = new Display3DCylinderPartilce(Scene_data.context3D);
					Program3DManager.getInstance().registe(Display3DCylinderShader.DISPLAY3DCYLINDERSHADER,Display3DCylinderShader);
					program = Program3DManager.getInstance().getProgram(Display3DCylinderShader.DISPLAY3DCYLINDERSHADER);
					break;
				}	
		
				case 7:
				{
					display3D = new Display3DCrossFacetPartilce(Scene_data.context3D);
					Program3DManager.getInstance().registe(Display3DCrossFacetShader.DISPLAY3DPARTILCESHADER,Display3DCrossFacetShader);
					program = Program3DManager.getInstance().getProgram(Display3DCrossFacetShader.DISPLAY3DPARTILCESHADER);
					break;
				}	
				case 8:
				{
					display3D = new Display3DFollowPartilce(Scene_data.context3D);
					Program3DManager.getInstance().registe(Display3DFollowShader.DISPLAY3DFOLLOWSHADER,Display3DFollowShader);
					program = Program3DManager.getInstance().getProgram(Display3DFollowShader.DISPLAY3DFOLLOWSHADER);
					break;
				}
				case 9:
				{
					display3D = new Display3DModelPartilce(Scene_data.context3D);
					Program3DManager.getInstance().registe(Display3DModelShader.DISPLAY3DMODELSHADER,Display3DModelShader);
					program = Program3DManager.getInstance().getProgram(Display3DModelShader.DISPLAY3DMODELSHADER);
					break;
				}
		
				case 12:
				{
					display3D = new Display3DFollowLocusPartilce(Scene_data.context3D);
					Program3DManager.getInstance().registe(Display3DFollowLocusShader.DISPLAY3DFOLLOWLOCUSSHADER,Display3DFollowLocusShader);
					program = Program3DManager.getInstance().getProgram(Display3DFollowLocusShader.DISPLAY3DFOLLOWLOCUSSHADER);
					break;
				}
				case 13:
				{
					display3D = new Display3DBonePartilce(Scene_data.context3D);
					Program3DManager.getInstance().registe(Display3DBoneShader.DISPLAY3D_BONE_SHADER,Display3DBoneShader);
					program = Program3DManager.getInstance().getProgram(Display3DBoneShader.DISPLAY3D_BONE_SHADER);
					break;
				}
				case 14:
				{
					display3D = new Display3DLocusBallPartilce(Scene_data.context3D);
					Program3DManager.getInstance().registe(Display3DLocusBallShader.DISPLAY3DLOCUSBALLSHADER,Display3DLocusBallShader);
					program = Program3DManager.getInstance().getProgram(Display3DLocusBallShader.DISPLAY3DLOCUSBALLSHADER);
					break;
				}
			
				case 18:
				{
					display3D = new Display3DBallPartilceNew(Scene_data.context3D);
					Program3DManager.getInstance().registe(Display3DBallNewShader.Display3DBallNewShader,Display3DBallNewShader);
					program = Program3DManager.getInstance().getProgram(Display3DBallNewShader.Display3DBallNewShader);
					break;
				}

				case 22:
				{
					display3D = new Display3DFollowMulLocusParticle(Scene_data.context3D);
					Program3DManager.getInstance().registe(Display3DFollowLocusShader.DISPLAY3DFOLLOWLOCUSSHADER,Display3DFollowLocusShader);
					program = Program3DManager.getInstance().getProgram(Display3DFollowLocusShader.DISPLAY3DFOLLOWLOCUSSHADER);
					break;
				}
					
			}
			
			display3D.setProgram3D(program);
			
			display3D.visible = false;
			
			return display3D;
		}
		public function addToRender():void{
			if(_hasDispose){
				return;
			}
			_hasStage = true;
//			for(var i:int;i<timeLineAry.length;i++){
//				_container.addChild(timeLineAry[i].display3D);
//			}
//			ParticleBatch.getInstance().addParticle(this);
			ParticleRender.getInstance().addParticle(this);
		}
		
		public function topRender():void{
//			for(var i:int=timeLineAry.length-1;i>0;i--){
//				_container.setChildIndex(timeLineAry[i].display3D,_container.numChildren-1);
//			}
			
			for(var i:int;i<timeLineAry.length;i++){
				_container.setChildIndex(timeLineAry[i].display3D,_container.numChildren-1);
			}
			
		}
		
		public function resetCam():void{
			if(isInUI){
				for(var i:int;i<timeLineAry.length;i++){
					timeLineAry[i].display3D.resetCamDistance();
				}
			}
		}
		
		public function refreshCam():void{
			if(!isInUI){
				for(var i:int;i<timeLineAry.length;i++){
					timeLineAry[i].display3D.getCamDistance();
				}
			}
		}
		
		/**
		 * 逻辑驱动刷帧更新 
		 * @param t
		 * 
		 */		
		public function update(t:int):void{
//			if(!_visible){
//				return;
//			}
			
			
			if(currentTime > 500000){
				replay();
			}
			
			currentTime += t;
			
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].update(currentTime);
			}
			updateBind();
			
			if(currentTime > maxTime){
				reset();
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 强制渲染刷新（转bitmap用，平时用正常的渲染框架） 
		 * 
		 */		
		public function renderUpdate():void{
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.update();
			}
		}
		
		public function reset(time:Number=0):void{
			currentTime = time;
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].reset();
			}
		}
		/**
		 * 重新播放特效 
		 */		
		public function replay():void{
			reset();
//			visible = true;
		}
		
//		public function set bingMatrix(value:Matrix3D):void{
//			for(var i:int;i<timeLineAry.length;i++){
//				timeLineAry[i].display3D.bindMatrix = value;
//			}
//		}
		
		public function set bindTarget(value:IBind):void{
			_bindTarget = value;
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.bindTarget = value;
			}
		}
		
		
		public function set bindSocket(value:String):void
		{
			_bindSocket = value;
			
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.bindSocket = value;
			}
			
		}

		
		public function set bindIndex(value:int):void{
			_bindIndex = value;
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.bindIndex = value;
			}
		}
		
		public function destory():void{
//			for(var i:int;i<timeLineAry.length;i++){
//				_container.removeChild(timeLineAry[i].display3D);
//				//timeLineAry[i].display3D.removeBatch();
//			}
//			ParticleBatch.getInstance().removeParticle(this);
			ParticleRender.getInstance().removeParticle(this);
			_hasStage = false;
		}
		
		
		public function get bindOffset():Vector3D{
			return _bindOffset;
		}
		
		public function set bindOffset(value:Vector3D):void{
			_bindOffset = value;
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.bindOffset = value;
			}
		}
		
		public function get bindRatation():Vector3D{
			return _bindRatation;
		}
		
		public function set bindRatation(value:Vector3D):void{
			_bindRatation = value;
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.bindRatation = value;
			}
		}
		
		public function setRotationV3d(ratationV3d:Vector3D,offset:Vector3D):void{
			_ratationV3d = ratationV3d;
			_offset = offset;
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.setRotationV3d(ratationV3d,offset);
			}
			//setXYZ(offset.x,offset.y,offset.z);
		}
		
		public function set visible(value:Boolean):void{
			_visible = value;
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.outVisible = value;
			}
		}
		
		public function toObject():Object{
			var obj:Object = new Object;
			obj.bindIndex = _bindIndex;
			obj.bindOffset = bindOffset;
			return obj;
		}
		/**
		 * 粒子克隆 
		 * @param container 新粒子的容器
		 * @return 新的粒子对象
		 * 
		 */		
		public function clone(container:Display3DContainer=null):CombineParticle{
			
			var combineParticle:CombineParticle;
			if(container){
				combineParticle = new CombineParticle(container);
			}else{
				combineParticle = new CombineParticle(this._container);
			}
			
			if(_hasData){
				combineParticle.cloneData(this);
			}else{
				if(!this._cloneList){
					_cloneList = new Vector.<CombineParticle>;
				}
				_cloneList.push(combineParticle);
			}
			addUse();
			return combineParticle;
		}
		/**
		 * 数据克隆 
		 * @param source
		 * 
		 */		
		public function cloneData(source:CombineParticle):void{
			if(_hasRealDispose || _hasDispose){
				return;
			}
			
			for(var i:int;i<source.timeLineAry.length;i++){
				timeLineAry.push(source.timeLineAry[i].clone());
			}
			this.maxTime = source.maxTime;
			
			//this.bindIndex = source._bindIndex;
			//this.bindOffset = source._bindOffset;
			//this.bindRatation = source._bindRatation;
			
			if(this._hasStage){
				addToRender();
				if(is3D){
					setXYZ();
				}else{
					setXY(_x,_y);
				}
			}
			
			if(this._bindTarget){
				for(i=0;i<timeLineAry.length;i++){
					timeLineAry[i].display3D.bindTarget = _bindTarget;
				}
			}
			
			this.bindIndex = _bindIndex;
			this.bindOffset = _bindOffset;
			this.bindRatation = _bindRatation;
			
			this.visible = _visible;			
			this.scale = _scale;
			//source.addUse();
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
			setXYZ();
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
			setXYZ();
		}
		
		public function get z():int
		{
			return _z;
		}
		
		public function set z(value:int):void
		{
			_z = value;
			setXYZ();
		}
		
		public function get rotationX():int
		{
			return _rotationX;
		}
		
		public function set rotationX(value:int):void
		{
			_rotationX = value;
			setRotation();
		}
		
		public function get rotationY():int
		{
			return _rotationY;
		}
		
		public function set rotationY(value:int):void
		{
			_rotationY = value;
			setRotation();
		}
		
		public function get rotationZ():int
		{
			return _rotationZ;
		}
		
		public function set rotationZ(value:int):void
		{
			_rotationZ = value;
			setRotation();
		}
		
		public function get scaleX():Number
		{
			return _scaleX;
		}
		
		public function set scaleX(value:Number):void
		{
			_scaleX = value;
			setScale();
		}
		
		public function get scaleY():Number
		{
			return _scaleY;
		}
		
		public function set scaleY(value:Number):void
		{
			_scaleY = value;
			setScale();
		}
		
		public function get scaleZ():Number
		{
			return _scaleZ;
		}
		
		public function set scaleZ(value:Number):void
		{
			_scaleZ = value;
			setScale();
		}
		
		public function setRotationNum($rx:Number,$ry:Number,$rz:Number):void{
			_rotationX = $rx;
			_rotationY = $ry;
			_rotationZ = $rz;
			setRotation();
		}
		
		public function setRotation():void{
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.setRotation(_rotationX,_rotationY,_rotationZ);
			}
		}
		
		public function setScale():void{
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.setScale(_scaleX,_scaleY,_scaleZ);
			}
		}
		
		public function updateMatrix():void{
			setXYZ();
			setRotation();
			setScale();
		}
		
		public function setXY(xpos:int,ypos:int):void{
			_x = xpos;
			_y = ypos;
			
			var v3d:Vector3D = MathCore.math2Dto3Dwolrd(_x,_y);
			
			v3d.scaleBy(Scene_data.mainRelateScale);
			
			_absoluteX = v3d.x;
			_absoluteZ = v3d.z;
			
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.resetPos(v3d.x,0,v3d.z);
			}
			
		}
		
		public function refreshPos():void{
			setXY(_x,_y);
		}
		
		public function setXYZ():void{
//			_absoluteX = $xpos;
//			_absoluteY = $ypos; 
//			_absoluteZ = $zpos;
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.resetPos(_x,_y,_z);
			}
		}
		
		public function setPos($xpos:Number,$ypos:Number,$zpos:Number):void{
			_x = $xpos;
			_y = $ypos;
			_z = $zpos;
			
			setXYZ();
		}

		public function get scale():Number
		{
			return _scale;
		}
		
		public function set scale(value:Number):void
		{
			_scale = value;
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.outScale = _scale;
			}
		}
		/**
		 * 资源加载完成进行计数 
		 * 加载完成后对外分发完成事件
		 * @param event
		 * 
		 */		
		private function onSourceLoadCom(event:Event):void{
			event.target.removeEventListener(Event.COMPLETE,onSourceLoadCom);
			_sourceComNum++;
			if(_sourceAllNum == _sourceComNum){
				this.dispatchEvent(new LoadCompleteEvent(LoadCompleteEvent.LOAD_COMPLETE));
			}
		}
		/**
		 * 判读资源是否加载完成 
		 * @return 
		 * 
		 */		
		public function getHasLoadCom():Boolean{
			return _sourceAllNum == _sourceComNum;
		}
		/**
		 * 重新装载粒子 
		 * 
		 */		
		public function reload():void{
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.reload();
			}
		}
		private var _hasRealDispose:Boolean;
		
		private var _hasDispose:Boolean;
		public function dispose():void{
			if(_hasDispose){
				return;
			}
			
			_hasDispose = true;
			
			ParticleManager.getInstance().removeParticle(this);
			
			if(_hasStage){
				destory();
				//ParticleManager.getInstance().removeParticle(this);
			}
			ParticleManager.getInstance().disposeUrl(url);
			
			if(!ParticleManager.getInstance().isSourceParticle(this)){
				disposeClear();
			}else{
				baseClear();
			}
			
		}
		
		public function disposeClear():void{
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].dispose();
			}
			
			clearAttribure();
		}
		
		public function clearAttribure():void{
			timeLineAry = null;
			_container = null;
			_bindTarget = null;
			_bindOffset = null;
			_bindRatation = null;
			_ratationV3d = null;
			_offset = null;
			url = null;
			_cloneList = null;
			bindMatrix = null;
			bindVecter3d = null;
		}
		
		public function baseClear():void{
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.baseClear();
			}
			_bindTarget = null;
		}
		
		public function realDispose():void{
			_hasRealDispose = true;
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.dispose();
				timeLineAry[i].dispose();
			}
			clearAttribure();
		}
		
		public var useTime:int = 1;
		
		public var idleTime:int;
		
		private function addUse():void{
//			for(var i:int;i<timeLineAry.length;i++){
//				timeLineAry[i].display3D.particleData.useTime++;
//			}
			useTime++;
		}
		
		public function removeUse():void{
			useTime--;
		}
		
//		public function get useTime():int{
//			if(timeLineAry.length){
//				return timeLineAry[0].display3D.particleData.useTime;
//			}else{
//				return 1;
//			}
//		}
		
		public var bindMatrix:Matrix3D = new Matrix3D;
		public var bindVecter3d:Vector3D = new Vector3D;
		
		public function updateBind_Bak():void{
			if(_bindTarget){
				
				if((_bindTarget) is Display3dGameMovie && Display3dGameMovie(_bindTarget).hasDispose){
					
					if(bindOffset){
						bindVecter3d = bindOffset;
						setToBindV3d();
					}
					
					return;
				}
				
				if(bindOffset){
					bindVecter3d = _bindTarget.getOffsetPos(_bindOffset,_bindIndex);
				}else{
					_bindTarget.getPosV3d(_bindIndex,bindVecter3d);
				}
				
				bindMatrix.identity();
				if(!bindNonRotation){
					if(bindRatation){
						bindMatrix.appendRotation(bindRatation.x,Vector3D.X_AXIS);
						bindMatrix.appendRotation(bindRatation.y,Vector3D.Y_AXIS);
						bindMatrix.appendRotation(bindRatation.z,Vector3D.Z_AXIS);
						bindMatrix.append(_bindTarget.getPosMatrix(_bindIndex));
					}else{
						bindMatrix.prependRotation(_bindTarget.getRotation(),Vector3D.Y_AXIS);
					}
				}
				setToBind(_bindTarget.getBindAlpha());
			}else{
				if(bindOffset){
					bindVecter3d = bindOffset;
					setToBindV3d();
				}
			}
			
		}
		
		public function updateBind():void{
			if(_bindTarget){
				
				_bindTarget.getSocket(_bindSocket,bindMatrix);
				
				bindVecter3d.setTo(bindMatrix.position.x,bindMatrix.position.y,bindMatrix.position.z);
				
				bindMatrix.appendTranslation(-bindMatrix.position.x,-bindMatrix.position.y,-bindMatrix.position.z); 
				
				setToBind(_bindTarget.getBindAlpha());
				
			}
			
		}
		
		public function setToBind(_alpha:Number=1):void{
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.setBind(bindVecter3d,bindMatrix,_alpha);
			}
		}
		
		public function setToBindV3d():void{
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.setBind(bindVecter3d,null);
			}
		}

		/**
		 * 是否已经添加到舞台 
		 */
		public function get hasStage():Boolean
		{
			return _hasStage;
		}
		
		public function getBufferNum():int{
			var num:int;
//			if(_hasUnload){
//				trace(num);
//			}
			
			for(var i:int;i<timeLineAry.length;i++){
				num += timeLineAry[i].display3D.getBufferNum();
			}
			
//			if(_hasUnload){
//				trace(num);
//			}
			
			return num;
		}
		
		public function getMaterialAry():Array{
			var ary:Array = new Array;
			for(var i:int;i<timeLineAry.length;i++){
				ary.push(timeLineAry[i].display3D.getMaterialTree());
			}
			return ary;
		}
		
		public function getMaterialTexUrlAry():Array{
			var ary:Array = new Array;
			for(var i:int;i<timeLineAry.length;i++){
				ary = ary.concat(timeLineAry[i].display3D.getMaterialParamUrl());
			}
			return ary;
		}
		
		public function unloadBuffer():void{
			
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.unloadBuffer();
			}
			
			_hasUnload = true;
		}
		
		public function uploadBuffer():void{
			if(!_hasUnload){
				return;
			}
			Log.add("重新上传技能");
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.uploadBuffer();
			}
			_hasUnload = false;
		}

		public function get isInGroup():Boolean
		{
			return _isInGroup;
		}

		public function set isInGroup(value:Boolean):void
		{
			_isInGroup = value;
			
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.isInGroup = value;
			}
		}

		

		public function set groupPos(value:Vector3D):void
		{
			_groupPos = value;
			
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.groupPos = value;
			}
		}

		

		public function set groupScale(value:Vector3D):void
		{
			_groupScale = value;
			
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.groupScale = value;
			}
		}

		public function set groupRotation(value:Vector3D):void
		{
			_groupRotation = value;
			
			for(var i:int;i<timeLineAry.length;i++){
				timeLineAry[i].display3D.groupRotation = value;
			}
		}
		
		public function get groupPos():Vector3D
		{
			return _groupPos;
		}
		
		
		
		public function get groupScale():Vector3D
		{
			return _groupScale;
		}
		
		public function get groupRotation():Vector3D
		{
			return _groupRotation;
		}

		
		
	}
}