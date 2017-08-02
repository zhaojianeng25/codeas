package _Pan3D.display3D
{
	import com.zcp.utils.ZMath;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.batch.RoleBatch;
	import _Pan3D.core.MathCore;
	import _Pan3D.event.PlayEvent;
	import _Pan3D.event.PosCompleteEvent;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.program.shaders.Md5LightShader;
	import _Pan3D.program.shaders.Md5LightSwimShader;
	import _Pan3D.program.shaders.Md5SelectShader;
	import _Pan3D.program.shaders.Md5Shader;
	import _Pan3D.program.shaders.Md5SwimShader;
	import _Pan3D.role.AvatarParamData;
	import _Pan3D.role.BoneLoadUtils;
	import _Pan3D.role.BuffUtil;
	import _Pan3D.role.CharBar;
	import _Pan3D.role.EquipData;
	import _Pan3D.role.FlowLightUtils;
	import _Pan3D.role.MeshUtils;
	import _Pan3D.text.Text3Dynamic;
	import _Pan3D.text.TextFieldManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.utils.TestBoundManager;
	import _Pan3D.vo.anim.AnimVo;
	import _Pan3D.vo.pos.PosVo;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	public class Display3dGameMovie extends Display3DBindMovie
	{
		public var position3D:Point=new Point;
		protected var equDic:Object;
		public var buffDic:Object;
		protected var _barDic:Object;
		protected var _equipList:Vector.<EquipData> = new Vector.<EquipData>;
		public var _alpha:Number=1;
		private var _colorID:uint;
		private var _swimProgram:Program3D;
		private var _selectProgram:Program3D;
		private var _lightProgram:Program3D;
		private var _lightSwimProgram:Program3D;
		public var isSwim:Boolean;
		public var islight:Boolean;
		protected var _posVec:Vector.<PosVo>;
		private var _selected:Boolean;
		
		private var _hasDisposed:Boolean;
		
		/**
		 * 文本的字典 
		 */		
		protected var titleDic:Object;
		
		/**
		 * 默认动作数组 
		 */		
		private var _defaultAnimAry:Vector.<MovieAction>;
		/**
		 * 旋转角度 
		 */		
		private var _angle:Number=0;
		
		/**
		 * 隐藏的换装类型
		 */	
		private const _hideAvatarPartTypes:Array = [];
		/**
		 * 隐藏的换装ID类型
		 */	
		private const _hideAvatarPartIds:Array = [];
		
		private var _hasShadow:Boolean = true;
		/**
		 * 阴影剔除 
		 */		
		public var excludShadow:Boolean;
		/**
		 * mesh正在加载中的工具列表 
		 */		
		private var _meshUtilList:Vector.<MeshUtils>;
		
		private var _buffUtilsList:Vector.<BuffUtil>;
		
		public var levHeight:Number = 0;
		
		/**
		 * 换装apd的回调列表 
		 */		
		private var _apdCallBackDic:Dictionary;
		protected var _defaultImg:Text3Dynamic;
		/**
		 * 是否需要更新Update
		 */		
		public var updateAble:Boolean;
		
		public var color:Vector3D;
		
		private var _colorString:String;
		/**
		 * 是否受全局缩放影响 
		 */		
		public var useMainScale:Boolean = true;
		
		public var secondScale:Number = 1;
		
		public var fileScale:Number = 1;
		
		public var _uiScale:Number = 1;
		
		public static var allNum:int;
		
		public function Display3dGameMovie(context:Context3D)
		{
			super(context);
			equDic = new Object;
			titleDic = new Object;
			buffDic = new Object;
			_barDic = new Object;
			_meshUtilList = new Vector.<MeshUtils>;
			_buffUtilsList = new Vector.<BuffUtil>;
			_apdCallBackDic = new Dictionary;
			color = new Vector3D(1,1,1);
			
			angle = 0;
			//_boneUtilList = new Vector.<BoneLoadUtils>;
			//setFlowLight();
			allNum++;
		}
		
		public function get equipList():Vector.<EquipData>
		{
			return _equipList;
		}

		public function set equipList(value:Vector.<EquipData>):void
		{
			_equipList = value;
		}
		
		public function sortEquipList(a:EquipData,b:EquipData):int{
			return a.renderPriority - b.renderPriority;
		}

		public function addMeshRender(equipData:EquipData):void{
			if(equDic[equipData.data.id]){//装备还在身上
				equipList.push(equipData);
				equipList.sort(sortEquipList);
				if(this.parent){
					equipData.addToRender(this);
					RoleBatch.getInstance().addEquip(equipData,this);
				}
				if(isInUI){
					equipData.particleScale = scale/(Scene_data.mainScale/2);
				}
				var index:int = _hideAvatarPartIds.indexOf(equipData.data.id);
				if(index != -1){//该ID装备已经隐藏
					equipData.visible = false;
					//return;
				}
				index = _hideAvatarPartTypes.indexOf(equipData.data.type);
				if(index != -1){//该Type装备已经隐藏
					equipData.visible = false;
				}
				
				if(!_visible){
					equipData.visible = false;
				}
				
				if(!hasDispose){
					equipData.meshData.useNum++;
					equipData.textureVo.useNum++;
				}
			}
		}
		/**
		 * 添加骑乘位置数组 
		 * @param posVec
		 * 
		 */		
		private function addPos(posVec:Vector.<PosVo>):void{
			_posVec = posVec;
			this.dispatchEvent(new PosCompleteEvent(PosCompleteEvent.POS_COMPLETE_EVENT));
		}
		/**
		 * 获取该对象上的骑乘位置
		 * @return 
		 * 
		 */		
		public function getPosList():Vector.<PosVo>{
			return _posVec;
		}
		/**
		 * 重置对象的绑定位置 
		 * 
		 */		
		public function resetPos():void{
			_posVec = null;
		}
		/**
		 * 添加绑定  
		 * @param target 要绑定的对象（绑定目标）
		 * @param index 绑定的位置
		 * 
		 */		
		public function setBind(target:Display3dGameMovie,index:int):void{
			this.bindTarget = target;
			posIndex = index;
			var posAry:Vector.<PosVo> = target.getPosList();
			if(posAry){//当绑定对象存在可绑定位置
				var pos:PosVo = posAry[index];
				this.bindIndex = pos.bindIndex;
				this.bindOffset = pos.bindOffset;
				this.bindRatation = null;
			}else{//绑定位置未加载 等待加载完成重新绑定
				target.addEventListener(PosCompleteEvent.POS_COMPLETE_EVENT,reBind);
			}
			updateBind();
			updataPos();
			updatePosMatrix();
		}
		/**
		 * 切换目标的强制绑定状态 
		 * @param mode 0为弱绑定 1为强绑定
		 * <li>弱绑定 = 不跟随角色转向而旋转
		 */		
		public function switchBindMode(mode:int):void{
			if(mode == 0){
				this.bindRatation = null;
			}else if(mode == 1){	
				if(bindTarget && bindTarget is Display3dGameMovie){
					var posAry:Vector.<PosVo> = Display3dGameMovie(bindTarget).getPosList();
					var pos:PosVo = posAry[posIndex];
					this.bindRatation = pos.bindRatation;
				}
			}
		}
		
		/**
		 * 添加动态绑定 
		 * @param $target 绑定目标
		 * @param $isSoft 是否为软绑定
		 * @param $index  绑定的骨骼
		 * @param $pos    绑定偏移
		 * 
		 */		
		public function setDynamicBind($target:Display3dGameMovie,$isSoft:Boolean = true,$index:int = 0,$pos:Vector3D = null):void{
			this.bindTarget = $target;
			this.bindIndex = $index;
			this.bindOffset = $pos;
			this.isSoftBind = $isSoft;
		}
		
		
		/**
		 * 移除绑定对象
		 * 移除后该对象将自由移动 不受绑定对象约束
		 */		
		public function removeBind():void{
			var target:Display3dGameMovie = bindTarget as Display3dGameMovie;
			if(target)
				target.removeEventListener(PosCompleteEvent.POS_COMPLETE_EVENT,reBind);
			this.bindTarget = null;
			updataPos();
		}
		/**
		 * 移除绑定并保持其在世界中的位置 
		 * 
		 */		
		public function removeBindKeepPos():void{
			var target:Display3dGameMovie = bindTarget as Display3dGameMovie;
			if(target)
				target.removeEventListener(PosCompleteEvent.POS_COMPLETE_EVENT,reBind);
			this.bindTarget = null;
			
			var p:Point = MathCore.math3Dto2Dwolrd(bindVecter3d.x,bindVecter3d.y,bindVecter3d.z);
			_x = p.x;
			_y = p.y;
			
			updataPos();
		}
		
		/**
		 * 重新绑定
		 * 当绑定目标分发位置加载完成事件时 将该对象重新绑定到目标对象 
		 * @param event
		 * 
		 */		
		private function reBind(event:Event):void{
			event.target.removeEventListener(PosCompleteEvent.POS_COMPLETE_EVENT,reBind);
			var target:Display3dGameMovie = bindTarget as Display3dGameMovie;
			var posAry:Vector.<PosVo> = target.getPosList();
			if(posAry){
				var pos:PosVo = posAry[posIndex];
				this.bindIndex = pos.bindIndex;
				this.bindOffset = pos.bindOffset;
				this.bindRatation = null;
			}
			updateBind();
			updataPos();
			updatePosMatrix();
		}
		
		
		
		override public function update():void{
//			if(this.name == "[0区]钱子骞"){
//				trace(this.name)
//			}
			if(!this._visible){
				return;
			}
			if(_defaultImg){
				return;
			}
			if(!_animDic.hasOwnProperty(_defaultAction) && !_animDic.hasOwnProperty(_curentAction)){
				return;
			}
			
			this.updateMatrix(); 
			
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,8,Vector.<Number>([levHeight, -1, 0, 0.2]));
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, Vector.<Number>([color.x, color.y, color.z, _alpha]));
			//如果处于选中状态
			if(_selected){
				_context.setDepthTest(false,Context3DCompareMode.LESS);
				_context.setProgram(this._selectProgram);
				if(_alpha != 1 || isSwim){
					_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1, 1, 0, 0.05]));
				}else{
					_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1, 1, 0, 0.5]));
				}
				for(i=0;i<equipList.length;i++){
					if(!equipList[i].visible){
						continue;
					}
					setMeshVc(equipList[i].meshData);
					_context.setTextureAt(1,equipList[i].textureVo.texture);
					setMeshVa(equipList[i].meshData);
				}
				_context.setDepthTest(true,Context3DCompareMode.LESS);
			}
			
			if(islight){
				if(isSwim){
					_context.setProgram(this._lightSwimProgram);
				}else{
					_context.setProgram(this._lightProgram);
				}
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,2, Vector.<Number>([-_allRunTime * 0.001 / 16, -_allRunTime * 0.004 / 16, 1, 1]));
				_context.setTextureAt(2,_lightTextureVo.texture);
			}else{ 
				if(isSwim){//是否处于游泳状态
					_context.setProgram(this._swimProgram);
				}else{
					_context.setProgram(this.program);
				}
			}
			
			for(var i:int=0;i<equipList.length;i++){
				if(!equipList[i].visible){
					continue;
				}
				setMeshVc(equipList[i].meshData);
				_context.setTextureAt(1,equipList[i].textureVo.texture);
				setMeshVa(equipList[i].meshData);
			}
			
			
			if(islight){
				_context.setTextureAt(2,null);
			}
			
			resetVa();

		}
		
		public function updateShadow():void{
			
			for(var i:int=0;i<equipList.length;i++){
				if(!equipList[i].visible){
					continue;
				}
				
				setVaShadow(equipList[i].meshData);
				updateShadowMatrix();
				_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelShadowMatrix, true);
				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,8,Vector.<Number>([this.absoluteY, -1, 0, 2]));
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, Vector.<Number>([1, _alpha, 0.2, 0.8]));
				setMeshVc(equipList[i].meshData);
				_context.drawTriangles(equipList[i].meshData.indexBuffer, 0, -1);
				
			}
			resetVa();
		}
		
		override public function setIsUpdate():void{
			if(!hasDispose){
				updateAble = _visible && !_defaultImg && (_animDic[_defaultAction] || _animDic[_curentAction]);
			}
			
			//fileScale = _animDic[_curentAction].
			
//			if(!this._visible){
//				return false;
//			}
//			if(_defaultImg){
//				return false;
//			}
//			if(!_animDic.hasOwnProperty(defaultAction) && !_animDic.hasOwnProperty(_curentAction)){
//				return false;
//			}
//			return true;
		}
		
		public function updateSelect():void{
			if(!this._visible){
				return;
			}
			if(_defaultImg){
				return;
			}
			if(!_animDic.hasOwnProperty(_defaultAction) && !_animDic.hasOwnProperty(_curentAction)){
				return;
			}
			
			this.updateMatrix(); 
			
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,8,Vector.<Number>([levHeight, -1, 0, 2/fileScale]));
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, Vector.<Number>([1, _alpha, 0.2, 0.8]));
			//如果处于选中状态

			if(_alpha != 1 || isSwim){
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1, 1, 0, 0.05]));
			}else{
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1, 1, 0, 0.5]));
			}
			for(var i:int=0;i<equipList.length;i++){
				if(!equipList[i].visible){
					continue;
				}
				setMeshVc(equipList[i].meshData);
				_context.setTextureAt(1,equipList[i].textureVo.texture);
				setMeshVa(equipList[i].meshData);
			}
		
			
		}
		
		public function updateFrame(t:int):void{
			this.updateMatrix();
			if(_pause){
				return;
			}
			_time += t;
			_allRunTime += t;
			calculateFrame();
		}
		
		override public function calculateFrame():void{
			if(_curentAction && _animDic.hasOwnProperty(_curentAction)){
				_curentFrame = _time/(frameRate*Scene_data.frameTime*2);
				if(_curentFrame >= _animDic[_curentAction].length){
					if(_completeState == 0){
						_time = 0;
						_curentFrame = 0;
					}else if(_completeState == 1){ 
						_curentFrame = _animDic[_curentAction].length-1;
					}else if(_completeState == 2){
						play(_defaultAction);
					}else if(_completeState == 3 || _completeState == 4){
						_curentFrame = _loopDic[_curentAction];
						_time = _curentFrame*(frameRate*Scene_data.frameTime*2);
					}
					playOver();
					this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_COMPLETE_EVENT));
				}
			}else if(_animDic.hasOwnProperty(_defaultAction)){
				_curentFrame = _time/(frameRate*Scene_data.frameTime*2);
				if(_curentFrame >= _animDic[_defaultAction].length){
					if(_completeState == 0){
						_time = 0;
						_curentFrame = 0;
					}else if(_completeState == 1){
						_curentFrame = _animDic[_defaultAction].length-1;
					}else if(_completeState == 2){
						play(_defaultAction);
					}else if(_completeState == 3 || _completeState == 4){
						_curentFrame = _loopDic[_defaultAction];
						_time = _curentFrame*(frameRate*Scene_data.frameTime*2);
					}
					playOver();
					this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_COMPLETE_EVENT));
				}
				
			}
		}
		
		override public function blinkFrame():void{
			//trace(12)
		}
		
		
		
		override public function gotoAndPlay(value:int):void{
			if(_curentAction && _animDic.hasOwnProperty(_curentAction)){
				if(value < _animDic[_curentAction].length){
					_curentFrame = value;
				}else{
					_curentFrame = _animDic[_curentAction].length;
				}
				_time = (frameRate*Scene_data.frameTime*2)*_curentFrame;
			}
			_pause = false;
		}
	
//		private var point2D:Point=new Point;
//		override public function set x(value:Number):void
//		{
//			point2D.x=value
//			updataPos();
//		}
//		override public function set y(value:Number):void
//		{
//			point2D.y=value
//			updataPos();
//		}
//		
		public var baseHeight:Number = 0;
		public var relativeHeight:Number = 0;
		override public function updataPos():void{
			
			if(is3D){
				var xpos:int;
				var ypos:int;
				if(this.parent){
					xpos = _x * this.parent.scale + this.parent.x;
					ypos = _y * this.parent.scale + this.parent.y;
				}else{
					xpos = _x;
					ypos = _y;
				}
				_absoluteX = x*Scene_data.mainRelateScale; //这块是否正确???1111111111111111111
				_absoluteY = y*Scene_data.mainRelateScale;
				_absoluteZ = z*Scene_data.mainRelateScale;
			}else if(isInUI){
				if(this.parent){
					xpos = _x * this.parent.scale + this.parent.x;
					ypos = _y * this.parent.scale + this.parent.y;
				}else{
					xpos = _x - 50000;
					ypos = _y;
				}
				_absoluteX=-Scene_data.cam3D.fovw/2+xpos;
				_absoluteY=(Scene_data.cam3D.fovh/2-ypos)/Math.cos(Scene_data.uiCamAngle/180*Math.PI);
				_absoluteZ=0;
				_scale = _uiScale;
				_scale *= fileScale;
				
			}else{
				var P:Vector3D=MathCore.math2Dto3Dwolrd(_x,_y);
				_absoluteX=P.x*Scene_data.mainRelateScale;
				_absoluteY=_z*Scene_data.mainRelateScale;
				_absoluteZ=P.z*Scene_data.mainRelateScale;
				if(useMainScale){
					_scale = Scene_data.mainScale/2;
				}else{
					_scale = Scene_data.default_mainScale/2;
				}
				_scale *=  secondScale;
				_scale *= fileScale;
			}
			
			updatePosMatrix();
			baseHeight = 0;
			
			
			if(_defaultImg){
				relativeHeight = baseHeight = _defaultImg.height * getMainScale();
			}else{		
				relativeHeight = baseHeight = int(_nameHeightDic ? (_nameHeightDic[_curentAction] ? _nameHeightDic[_curentAction] : _nameHeightDic[defaultAction]) : 0) * getMainScale();
				
				if(bindTarget){
					baseHeight += TestBoundManager.getInstance().math3DLenght(bindVecter3d.y);
				}else if(_z){
					baseHeight += TestBoundManager.getInstance().math3DLenght(_z * getMainScale());
				}
			}
			
//			if(bindTarget && false){
//				var pixelPoint:Point = MathCore.math3Dto2Dwolrd(bindVecter3d.x,bindVecter3d.y,bindVecter3d.z);
//				xpos = pixelPoint.x;
//			}else{
			xpos = _x*Scene_data.mainRelateScale;
//			}
			ypos = _y*Scene_data.mainRelateScale;
			
			for each(var txt:Text3Dynamic in titleDic){
				if(txt.visible){
					txt.x = xpos + txt.offsetX;
					if(txt.relativeoffsetY > 0){
						txt.y = ypos + (relativeHeight * txt.relativeoffsetY - baseHeight);
					}else if(txt.relativeoffsetY == -1){
						txt.y = ypos + (getZeroHeight() - baseHeight);
					}else{
						txt.y = ypos + (txt.offsetY - baseHeight);
					}
				}else{
					txt.y = -50000;
				}
			}
			
			for each(var bar:CharBar in _barDic){
				if(bar.visible){
					bar.x = xpos + bar.offsetX;
					bar.y = ypos + (bar.offsetY - baseHeight);
				}else{
					bar.y = -50000;
				}
			}
			
			if(_defaultImg){
				_defaultImg.x = xpos + _defaultImg.offsetX;
				_defaultImg.y = ypos + _defaultImg.offsetY*getMainScale();
			}
			
		}
		public function changeSize():void
		{
			updataPos();
		}
		
		
		public function getMainScale():Number{
			if(useMainScale){
				return Scene_data.mainRelateScale * secondScale;
			}else{
				return secondScale;
			}
		}
		
		/**
		 * 获取头顶到腰部的高度 
		 * @return 
		 * 
		 */		
		protected function getZeroHeight():Number{
			var testmatix:Matrix3D
			if(_animDic[_curentAction]){
				testmatix = _animDic[_curentAction][_animDic[_curentAction].length-1][0];
			}else if(_animDic[_defaultAction]){
				testmatix = _animDic[_defaultAction][_animDic[_defaultAction].length-1][0];
			}else{
				testmatix = new Matrix3D;
			}
			
			var zeroHeight:Number = _scale * testmatix.position.y;
			zeroHeight = TestBoundManager.getInstance().math3DLenght(zeroHeight)
			zeroHeight = int(_nameHeightDic[_curentAction] ? _nameHeightDic[_curentAction] : _nameHeightDic[defaultAction]) - zeroHeight;
			zeroHeight *= getMainScale();
			return zeroHeight;
			
		}
		
//		override public function updatePosMatrix():void{
//			posMatrix.identity();
//			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
//			this._scale=1.2
//			posMatrix.prependScale(this._scale,this._scale,this._scale);
//			posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
//		}
		/**
		 * 更新位置属性 
		 * 当游戏窗口大小改变时，须调用此方法更新位置
		 */		
//		override public function updataPos():void{
//			var xpos:Number;
//			var ypos:Number;
//			if(this.parent){
//				xpos = this._x + this.parent.x;
//				ypos = this._y + this.parent.y;
//			}else{
//				xpos = this._x
//				ypos = this._y
//			}
//			if(id == 12312){
//				//trace(xpos,ypos,_x,_y,parent.x,parent.y)
//				//trace(_x,Scene_data.focus3D.x,_x-Scene_data.focus3D.x)
//			}
//			_absoluteX=_x
//			_absoluteZ=_z
//			
//			updatePosMatrix();
//			
//			for each(var txt:Text3Dynamic in titleDic){
//				txt.x = xpos + txt.offestX;
//				txt.y = ypos + txt.offsetY;
//			}
//			
//			for each(var bar:CharBar in _barDic){
//				bar.x = xpos + bar.offsetX;
//				bar.y = ypos + bar.offsetY;
//			}
//			
//		}
//		override public function updatePosMatrix():void{
//			posMatrix.identity();
//			posMatrix.prependTranslation(_absoluteX, _absoluteY, _absoluteZ);
//			posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
//		}
//		
//		override public function updateMatrix():void{
//		
//			modelMatrix.identity();
//			modelMatrix.prepend(Scene_data.cam3D.cameraMatrix);
//			modelMatrix.prepend(posMatrix);
//		}
		
		/**
		 * 当前对象面朝另外一个对象 
		 * @param target 朝向的对象
		 * 
		 */		
		public function watch(target:Display3D):void{
			var xpos:int = _absoluteX - target.absoluteX;
			var ypos:int = _absoluteZ - target.absoluteZ;
			var angle:Number = Math.atan(xpos/ypos)/Math.PI*180;
			if(ypos > 0){
				angle += 180;
			}
			
			this._rotationY  = angle;
			updatePosMatrix();
		}
			
		
		override protected function setMeshVa(meshData:MeshData):void{
			if(Scene_data.compressBuffer){
				_context.setVertexBufferAt(0,meshData.vertexBuffer1, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(1,meshData.vertexBuffer1, 3, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(2,meshData.vertexBuffer1, 6, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(3,meshData.vertexBuffer1, 9, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(4,meshData.vertexBuffer1, 12, Context3DVertexBufferFormat.FLOAT_2);
				_context.setVertexBufferAt(5,meshData.vertexBuffer1, 14, Context3DVertexBufferFormat.FLOAT_4);
				_context.setVertexBufferAt(6,meshData.vertexBuffer1, 18, Context3DVertexBufferFormat.FLOAT_4);
			}else{
				_context.setVertexBufferAt(0,meshData.vertexBuffer1, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(1,meshData.vertexBuffer2, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(2,meshData.vertexBuffer3, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(3,meshData.vertexBuffer4, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(4,meshData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				_context.setVertexBufferAt(5,meshData.boneWeightBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
				_context.setVertexBufferAt(6,meshData.boneIdBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			}
			
			_context.drawTriangles(meshData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(meshData.faceNum);
		}
		
		public function setVaShadow(meshData:MeshData):void{
			if(Scene_data.compressBuffer){
				_context.setVertexBufferAt(0,meshData.vertexBuffer1, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(1,meshData.vertexBuffer1, 3, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(2,meshData.vertexBuffer1, 6, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(3,meshData.vertexBuffer1, 9, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(4,meshData.vertexBuffer1, 12, Context3DVertexBufferFormat.FLOAT_2);
				_context.setVertexBufferAt(5,meshData.vertexBuffer1, 14, Context3DVertexBufferFormat.FLOAT_4);
				_context.setVertexBufferAt(6,meshData.vertexBuffer1, 18, Context3DVertexBufferFormat.FLOAT_4);	
			}else{
				_context.setVertexBufferAt(0,meshData.vertexBuffer1, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(1,meshData.vertexBuffer2, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(2,meshData.vertexBuffer3, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(3,meshData.vertexBuffer4, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(5,meshData.boneWeightBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
				_context.setVertexBufferAt(6,meshData.boneIdBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			}
			
		}
		
		/**
		 * 设置默认的动作数组 
		 * @param value 默认动作Ary
		 * 
		 */		
		public function set defaultAnimAry(value:Vector.<MovieAction>):void
		{
			_defaultAnimAry = value;
			for(var i:int;i<_defaultAnimAry.length;i++){
				addAnim(_defaultAnimAry[i].url,_defaultAnimAry[i].name);
			}
			//play(MovieAction.STAND);
		}
		/**
		 * 添加一个动作 
		 * @param value 动作对象
		 * 
		 */		
		public function addAction(value:MovieAction):void{
			preLoadActionDic[value.name] = value.url;
			if(value.name == _defaultAction || value.name == _curentAction){
				addAnim(value.url,value.name);
			}else if(value.needPerLoad){
				addAnim(value.url,value.name);
			}
//			addAnim(value.url,value.name);
		}
		override public function setFileScale(value:Number):void{
			fileScale = value;
			if(isInUI){
				updataPos();
				updateScale();
			}
		}
		override public function setMeshVc(meshData:MeshData):void{
			try
			{
				super.setMeshVc(meshData);
			} 
			catch(error:Error) 
			{
				var animStr:String;
				for(var keys:String in preLoadActionDic){
					animStr = preLoadActionDic[keys];
				}
				throw new Error("Setvc错误！ 角色ID：" +　this.id  + " 角色名字： " +　this.name 
					+ "\n当前动作：" + this.curentAction + "\n当前Mesh：" + meshData.key + " \n当前action" +　animStr);
			}
			
		}
		/**
		 * 删除一个动作
		 * @param 动作名字
		 *  
		 */		
		public function removeAction(key:String):void{
			delete _animDic[key];
			setIsUpdate();
		}
		
		/**
		 * 删除该角色的所有动作 
		 * 
		 */		
		public function removeAllAction():void{
			for(var key:String in _animDic){
				delete _animDic[key];
			}
			for(key in preLoadActionDic){
				delete preLoadActionDic[key];
			}
			removeAllBoneUtil();
			setIsUpdate();
			
		}
		
		public function addEquList(ary:Array):void{
			for(var i:int;i<ary.length;i++){
				//addEqu(ary[i]);
			}
		}
		
		/**
		 * 是否有指定ID的换装
		 * @param $id 换装ID
		 * @param $checkResReady 是否检查资源已经准备完毕
		 */
		public function hasIDAvatarPart($id:String, $checkResReady:Boolean=false):Boolean{
			for(var i:int;i<equipList.length;i++){
				if(equipList[i].data.id == $id){
					return true;
				}
			}
			if(buffDic[$id]){
				return true;
			}
			if(!$checkResReady){
				for each(var obj:AvatarParamData in equDic){
					if(obj.id == $id){
						return true;
					}
				}
			}
			return false;
		}
			
		/**
		 * 是否有指定类型的换装
		 * @param $type 换装类型
		 * @param $checkResReady 是否检查资源已经准备完毕
		 */
		public function hasTypeAvatarParts($type:String, $checkResReady:Boolean=false):Boolean{
			for(var i:int;i<equipList.length;i++){
				if(equipList[i].data.type == $type){
					return true;
				}
			}
			if(!$checkResReady){
				for each(var obj:AvatarParamData in equDic){
					if(obj.type == $type){
						return true;
					}
				}
			}
			return false;
		}
				
		/**
		 * 是否有相同的（主要指ID和样式）换装
		 * @param $apd 换装APD
		 * @param $checkResReady 是否检查资源已经准备完毕
		 */
		public function hasSameAvatarPart($apd:AvatarParamData, $checkResReady:Boolean=false):Boolean{
			if(!$apd){
				return false;
			}
			for(var i:int;i<equipList.length;i++){
				if(equipList[i].data.id == $apd.id && equipList[i].data.source == $apd.source && equipList[i].data.level == $apd.level && equipList[i].data.secondLevel == $apd.secondLevel){
					return true;
				}
			}
			if(!$checkResReady){
				for each(var obj:AvatarParamData in equDic){
					if(obj.id == $apd.id && obj.source == $apd.source && obj.level == $apd.level && obj.secondLevel == $apd.secondLevel){
						return true;
					}
				}
			}
			return false;
		}
			
			
		/**
		 * 添加一项AvatarPart
		 *  @param $apd 换装数据
		 *  @param completeFun 换装加载完成回调
		 *  @param $level 装备强化等级, 这个只对装备生效
		 *  @param $secondLevel 神兵强化等级, 这个只对装备生效
		 */
		public function addAvatarPart($apd:AvatarParamData,completeFun:Function = null, $level:int=0,$secondLevel:int=0):void{
			if(!$apd){
				return;
			}
			if($apd.source.indexOf("343") != -1){
				trace("nani");
			}
			if(Boolean(completeFun)){
				_apdCallBackDic[$apd] = completeFun;
			}
			if($apd.showType == 0){
				//存在完全一样的换装
				if(equDic[$apd.id] && equDic[$apd.id].source == $apd.source && equDic[$apd.id].level == $level && equDic[$apd.id].secondLevel == $secondLevel){
					if(Boolean(completeFun)){
						delete _apdCallBackDic[$apd];
						completeFun();
					}
					return;
				}else{
					removeAvatarPart($apd.id);
				}
				equDic[$apd.id] = $apd;
				$apd.level = $level;
				$apd.secondLevel = $secondLevel;
				var meshUtiles:MeshUtils = new MeshUtils();
				_meshUtilList.push(meshUtiles);
				meshUtiles.addEquip($apd.source,addMeshRender,addPos,$apd,removeMeshUtils,this,loadPriority,isInUI||is3D);
			}else{
				//return;
				if(buffDic[$apd.id] && buffDic[$apd.id].apd.source == $apd.source){
					return;
				}else{
					removeAvatarPart($apd.id);
				}
				var obj:Object = new Object;
				if($apd.id){
					buffDic[$apd.id] = obj;
				}
				var buffUtil:BuffUtil = new BuffUtil();
				buffUtil.addBuff($apd,obj,this,loadPriority);
				_buffUtilsList.push(buffUtil);
			}
		}
		
		/**
		 * 改变默认的主要换装 
		 * 
		 */		
		public function changeMainAvatar():void{
			remveAllMeshUtils();
			removeAllBoneUtil();
			removeAllAction();
			removeAllAvatarParts();
		}
			
		private function removeMeshUtils(meshUtil:MeshUtils):void{
			var index:int = _meshUtilList.indexOf(meshUtil);
			if(index != -1){
				_meshUtilList.splice(index,1);
			}
			
			if(_apdCallBackDic[meshUtil.apd] && (_animDic[_defaultAction] || _animDic[_curentAction])){
				(_apdCallBackDic[meshUtil.apd])();
				delete _apdCallBackDic[meshUtil.apd];
			}
		}
		
		override protected function removeBoneUtil(boneUtil:BoneLoadUtils):void{
			super.removeBoneUtil(boneUtil);
			for(var key:* in _apdCallBackDic){
				var apd:AvatarParamData = key;
				if(apd.complete && (_animDic[_defaultAction] || _animDic[_curentAction])){
					(_apdCallBackDic[apd])();
					delete _apdCallBackDic[apd];
				}
			}
		}
		
		private function remveAllMeshUtils():void{
			for(var i:int;i<_meshUtilList.length;i++){
				_meshUtilList[i].isInterrupt = true;
			}
			_meshUtilList.length = 0;
		}
		
		/**
		 * 移除指定ID的AvatarPart
		 * @param $avatarPartID 换装类型
		 */
		public function removeAvatarPart($avatarPartID:String):void{
			if(hasDispose){
				return;
			}
			if(equDic[$avatarPartID]){
				var apd:AvatarParamData = equDic[$avatarPartID];
				delete equDic[$avatarPartID];
				removeID($avatarPartID);
				for(var i:int=equipList.length-1;i>=0;i--){
					if(equipList[i].data.id == $avatarPartID){
						equipList[i].removeRender();
						RoleBatch.getInstance().removeEquip(equipList[i],this);
						if(!hasDispose){
							equipList[i].meshData.useNum--;
							equipList[i].textureVo.useNum--;
							equipList[i].dispose();
						}
						equipList.splice(i,1);
						//break;
					}
				}
				for(i=0;i<_meshUtilList.length;i++){
					if(_meshUtilList[i].apd == apd){
						_meshUtilList[i].isInterrupt = true;
						_meshUtilList.splice(i,1);
						break;
					}
				}
			}else{
				//trace("remove: " + $avatarPartID)
				var obj:Object = buffDic[$avatarPartID];
				if(obj){
					obj.buffUtil.cancle();
				}
				if(obj && obj.particle){
					ParticleManager.getInstance().removeParticle(obj.particle);
					CombineParticle(obj.particle).dispose();
				}
				
				delete buffDic[$avatarPartID];
			}
			
		}
		
					
		/**
		 * 移除指定类型的AvatarPart
		 * @param $avatarPartType 换装类型
		 */
		public function removeAvatarPartsByType($avatarPartType:String):void{
			removeType($avatarPartType);
			for(var i:int = equipList.length-1;i>=0;i--){
				if(equipList[i].data.type == $avatarPartType){
					delete equDic[equipList[i].data.id];
					equipList[i].removeRender();
					RoleBatch.getInstance().removeEquip(equipList[i],this);
					equipList.splice(i,1);
				}
			}
		}
						
		/**
		 * 移除所有AvatarPart((此函数执行后,不会检查主体换装是否存在)
		 */
		public function removeAllAvatarParts():void{
			while(equipList.length){
				var equ:EquipData = equipList.pop();
				equ.removeRender();
				RoleBatch.getInstance().removeEquip(equ,this);
			}
			for(var key:String in equDic){
				delete equDic[key];
			}
			while(_hideAvatarPartIds.length){
				_hideAvatarPartIds.pop();
			}
			while(_hideAvatarPartTypes.length){
				_hideAvatarPartTypes.pop();
			}
		}
							
		/**
		 * 查看某ID的换装是否可显示
		 *  @param $id
		 */
		public function getIDAvatarPartVisible($id:String):Boolean{
			/*
			for(var i:int;i<equipList.length;i++){
				if(equipList[i].data.id == $id){
					return equipList[i].visible;
				}
			}
			return false;
			*/
			var index:int = _hideAvatarPartIds.indexOf($id);
			if(index == -1){
				return true;
			}else{
				return false;
			}
		}
								
		/**
		 * 显示某ID换装
		 *  @param $id
		 */
		public function showAvatarPartByID($id:String):void{
			for(var i:int;i<equipList.length;i++){
				if(equipList[i].data.id == $id){
					equipList[i].visible = true;
					break;
				}
			}
			removeID($id);
		}
		
		/**
		 * 隐藏某ID换装
		 *  @param $id
		 */
		public function hideAvatarPartByID($id:String):void{
			for(var i:int;i<equipList.length;i++){
				if(equipList[i].data.id == $id){
					equipList[i].visible = false;
					break;
				}
			}
			removeID($id);
			_hideAvatarPartIds.push($id);
		}
		/**
		 * 从隐藏ID数组中移除指定ID 
		 * @param $id 移除的id
		 * 
		 */		
		private function removeID($id:String):void{
			var index:int = _hideAvatarPartIds.indexOf($id);
			if(index != -1){
				_hideAvatarPartIds.splice(index,1);
			}
		}
		/**
		 *  从隐藏Type数组中移除指定Type
		 * @param $type 移除的type
		 * 
		 */		
		private function removeType($type:String):void{
			var index:int = _hideAvatarPartTypes.indexOf($type);
			if(index != -1){
				_hideAvatarPartTypes.splice(index,1);
			}
		}
		/**
		 * 查看某类型的换装是否可显示
		 *  @param $id
		 */
		public function getTypeAvatarPartsVisible($type:String):Boolean{
			var index:int = _hideAvatarPartTypes.indexOf($type);
			if(index == -1){
				return true;
			}else{
				return false;
			}
		}
		/**
		 * 显示某类型换装
		 *  @param $type
		 */
		public function showAvatarPartsByType($type:String):void{
			for(var i:int;i<equipList.length;i++){
				if(equipList[i].data.type == $type){
					equipList[i].visible = true;
				}
			}
			removeType($type);
		}
		/**
		 * 隐藏某类型换装
		 *  @param $type
		 */
		public function hideAvatarPartsByType($type:String):void{
			for(var i:int;i<equipList.length;i++){
				if(equipList[i].data.type == $type){
					equipList[i].visible = false;
				}
			}
			removeType($type);
			_hideAvatarPartTypes.push($type);
		}
													
//		/**
//		 * @private
//		 * 是否与某个点发生碰撞
//		 * @param $checkMouseEnabled 是否判断鼠标响应
//		 */
//		public function hitPoint($p:Point, $checkMouseEnabled:Boolean=false):Boolean{
//			var rec:Rectangle = new Rectangle(0,0,60,140);
//			rec.x = this.x-rec.width/2;
//			rec.y = this.y-rec.height;
//			return rec.containsPoint($p);
//		}
		/**
		 * 面向像素点
		 * @param $piexl_x
		 * @param $piexl_y
		 */		
		public function faceTo($piexl_x:Number, $piexl_y:Number):void{
			if($piexl_x == this.x && $piexl_y == this.y){
				return;
			}
			
			
//			var $angle:Number = Math.atan2($piexl_y - y, $piexl_x - x);
//			if ($angle < 0) {
//				$angle = $angle + 2 * Math.PI;
//			}
//			$angle = $angle * 180 / Math.PI;
//			_angle = ($angle%360+360)%360;
			

			var v3d:Vector3D = MathCore.math2Dto3Dwolrd($piexl_x-x,$piexl_y-y);
			var angle:Number = Math.atan(v3d.x/v3d.z)/Math.PI*180;

			if(v3d.z <= 0){
				angle = angle-180;
			}
			
			this._rotationY  = angle;
//			if(_rotationY == 45){
//				trace(45)
//			}
			updatePosMatrix(); 
			
			
			angle = ZMath.getTowPointsAngle(new Point(x,y),new Point($piexl_x,$piexl_y));
			angle = (angle%360+360)%360;//将角度控制在[0-360)范围内
			_angle = angle;
			
			
			
		}
		/**
		 * 设置3D旋转角度 
		 * @param $angle
		 * 
		 */		
		public function set angle3d($angle:Number):void{
			this._rotationY = $angle + 90;
			updatePosMatrix();
		}
		
		public function get angle3d():Number{
			return this._rotationY-90;
		}
		/**
		 * 设置2D角度
		 * @param $angle
		 */		
		public function set angle($angle:Number):void{
			$angle = ($angle%360+360)%360;//将角度控制在[0-360)范围内
			_angle = $angle;
			
			var ypos:Number = Math.tan($angle/180*Math.PI);
			var xpos:int = 1;
			if($angle == 90){
				xpos = 0;
			}else if($angle > 90 && $angle<=270){
				xpos = -xpos;
				ypos = -ypos;
			}
			
			var v3d:Vector3D = MathCore.math2Dto3Dwolrd(xpos,ypos);
			
			var angle:Number = Math.atan(v3d.x/v3d.z)/Math.PI*180;
			
			if(v3d.z <= 0){
				angle = angle-180;
			}
			if(angle == -270){
				angle = 270;
			}
			
			this._rotationY  = angle;
			updatePosMatrix();
		}
		/**
		 * 获取2D角度
		 * @param $angle
		 */		
		public function get angle():Number{
			return _angle;
		}
		/**
		 * 添加一个图片文本 
		 * @param $key 唯一的key
		 * @param $img 图片的bitmapdata
		 * @param $offsetX 相对于基础点的X偏移
		 * @param $offsetY 相对于基础点的Y偏移
		 * @param $zbuff 高度信息 默认0.2 越小层级越高 不能小于0
		 */		
		protected  function addTextImage($key:String, $img:BitmapData, $offsetX:int, $offsetY:int,$zbuff:Number = 0.2):Text3Dynamic{
//			if(this.name == "夺命帝王蝎"){
//				trace(this.name)
//			}
			var txt:Text3Dynamic;
			if(titleDic[$key]){
				txt = titleDic[$key];
			}else{
				txt = TextFieldManager.getInstance().getText3Dynamic($img.width,$img.height,$zbuff);
				titleDic[$key] = txt;
			}
			txt.target = this;
			txt.bitmapdata = $img;
			txt.offsetX = $offsetX;
			txt.offsetY = $offsetY;
			updataPos();
			return txt;
		}
		/**
		 * 添加默认的换装图片 
		 * @param $img
		 * 
		 */		
		public function addDefaultImage($img:BitmapData):void{
			if(!$img){
				return;
			}
			if(!_defaultImg){
				_defaultImg = TextFieldManager.getInstance().getText3Dynamic($img.width,$img.height,0.9);
			}
			_defaultImg.target = this;
			_defaultImg.bitmapdata = $img;
			_defaultImg.offsetX = -$img.width/2;
			_defaultImg.offsetY = -$img.height;
			_defaultImg.add();
			_defaultImg.visible = _visible;
			updataPos();
			setIsUpdate();
		}
		/**
		 * 是否拥有默认换装 
		 * @return 
		 * 
		 */		
		public function hasDefaultImg():Boolean{
			return Boolean(_defaultImg);
		}
		/**
		 * 移除默认换装图片 
		 * 
		 */		
		public function removeDefaultImg():void{
			if(!_defaultImg)
				return;
			if(_selected){
				TextFieldManager.getInstance().removeSelect(_defaultImg);
			}
			TextFieldManager.getInstance().removeSelect(_defaultImg);
			_defaultImg.remove();
			_defaultImg.dispose();
			_defaultImg = null;
			updataPos();
			setIsUpdate();
		}
		
		/**
		 * 删除图片文本 （彻底从内存中清空）
		 * @param $key 唯一key
		 * 
		 */		
		protected  function removeTextImage($key:String):void{
			var txt:Text3Dynamic = titleDic[$key];
			if(txt){
				txt.dispose();
				//txt.bitmapdata.dispose();
			}
			delete titleDic[$key];
		}
		

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
		/**
		 * 对象的相对于舞台的2d绝对X坐标 
		 * @return Number
		 * 
		 */		
		public function get absolute2Dx():Number{
			if(this.parent){
				return this._x + this.parent.x;
			}else{
				return this._x;
			}
		}
		/**
		 *  对象的相对于舞台的2d绝对Y坐标 
		 * @return Number
		 * 
		 */		
		public function get absolute2Dy():Number{
			if(this.parent){
				return this._y + this.parent.y;
			}else{
				return this._y;
			}
		}
		
		/**
		 * 影子2dX坐标 
		 * @return Number
		 * 
		 */		
		public function get shadow2DX():Number{
			//return point2D.x
			if(this.parent){
				return this._x + this.parent.x;
			}else{
				return this._x;
			}
		}
		/**
		 *  影子3dY坐标 
		 * @return Number
		 * 
		 */		
		public function get shadow2DY():Number{
			//return point2D.y;
			if(this.parent){
				return this._y + this.parent.y;
			}else{
				return this._y;
			}
		}
		
		/**
		 * 影子3dX坐标 
		 * @return Number
		 * 
		 */		
		public function get shadow3DX():Number{
			return _absoluteX;
		}
		/**
		 *  影子3dY坐标 
		 * @return Number
		 * 
		 */		
		public function get shadow3DY():Number{
			return _absoluteZ;
		}
		
		public function get colorID():uint
		{
			return _colorID;
		}
		/**
		 * 鼠标点击测试用ID 
		 * @param value
		 * 
		 */		
		public function set colorID(value:uint):void
		{
			_colorID = value;
		}
		
		/**
		 * 在角色身上指定位置添加一个显示条
		 * @param $key 唯一标识
		 * @param $bar 显示条
		 * @param $offsetX 显示的x偏移
		 * @param $offsetY 显示的y偏移
		 */		
		protected function addBar($key:String,$bar:CharBar, $offsetX:Number, $offsetY:Number):void{
			_barDic[$key] = $bar;
			$bar.offsetX = $offsetX;
			$bar.offsetY = $offsetY;
			$bar.add();
			updataPos();
		}
		/**
		 * 去掉角色身上的一个显示条
		 * @param $key 唯一标识
		 */		
		protected function removeBar($key:String):void{
			if(_barDic[$key]){
				_barDic[$key].remove();
				CharBar(_barDic[$key]).dispose();
			}
		}
		/**
		 * 取得角色身上的一个显示条
		 * @param $key 唯一标识
		 */		
		protected function getBar($key:String):CharBar{
			return _barDic[$key];
		}
		
		override public function set scale(value:Number):void{
			super.scale = value;
			//uiScale = value;
			updateScale();
		}
		
		public function set uiScale(value:Number):void{
			//super.scale = value * fileScale;
			_uiScale = value;
			updataPos();
			updateScale();
		}
		
		public function get uiScale():Number{
			return _uiScale;
		}
		
		override public function get scale():Number{
			
			return _scale*(this.parent? this.parent.scale : 1);
			
		}
		
		override public function get pureScale():Number{
			if(useMainScale){
				return Scene_data.mainScale/2;
			}else{
				return Scene_data.default_mainScale/2;
			}
		}
		
		public function updateScale():void{
			
			for(var i:int;i<equipList.length;i++){
				equipList[i].particleScale = scale/(Scene_data.mainScale/2);
			}
			
			for each(var obj:Object in buffDic){
				if(obj.particle){
					obj.particle.scale = scale/(Scene_data.mainScale/2);
				}
			}
			
			updataPos();
		}
		
		override public function removeRender():void{
			super.removeRender();
			for(var i:int;i<equipList.length;i++){
				equipList[i].removeRender();
				RoleBatch.getInstance().removeEquip(equipList[i],this);
			}
			for each(var obj:Object in buffDic){
				if(obj.particle)
					ParticleManager.getInstance().removeParticle(obj.particle);
			}
			if(_selected){
				RoleBatch.getInstance().removeSelect(this);
			}
			
		}
		public function addRender(container:Display3DContainer):void{
			container.addChild(this);
			for(var i:int;i<equipList.length;i++){
				equipList[i].addToRender(this);
				RoleBatch.getInstance().addEquip(equipList[i],this);
			}
			for each(var obj:Object in buffDic){
				if(obj.particle)
					ParticleManager.getInstance().addParticle(obj.particle);
			}
		}
		/**
		 * 移除装备附带的粒子， buff等
		 * 
		 */	
		public function removeExtra():void{
			for(var i:int;i<equipList.length;i++){
				equipList[i].removeRender();
				//RoleBatch.getInstance().removeEquip(equipList[i],this);
			}
			for each(var obj:Object in buffDic){
				if(obj.particle)
					ParticleManager.getInstance().removeParticle(obj.particle);
			}
		}
		/**
		 * 移除身上所有相关buff（特效和颜色） 
		 * 
		 */		
		public function clearBuff():void{
			for each(var obj:Object in buffDic){
				if(obj.particle)
					ParticleManager.getInstance().removeParticle(obj.particle);
			}
			buffDic = new Object;
			this.color.setTo(1,1,1);
		}
		
		/**
		 * 添加装备附带的粒子， buff等
		 * 
		 */		
		public function addExtra():void{
			for(var i:int;i<equipList.length;i++){
				equipList[i].addToRender(this);
				//RoleBatch.getInstance().addEquip(equipList[i],this);
			}
			for each(var obj:Object in buffDic){
				if(obj.particle){
					ParticleManager.getInstance().addParticle(obj.particle);
				}
			}
		}
		/**
		 * 设置游泳着色器 
		 * @param program
		 * 
		 */		
		public function setSwimProgram(program:Program3D):void{
			this._swimProgram = program;
		}
		public function setSelectProgram(program:Program3D):void{
			this._selectProgram = program;
		}
		/**
		 * 点是否在该角色上 
		 * @param p 鼠标x，y
		 * @return 是否选中
		 * 
		 */		
		public function testPoint(p:Point):Boolean{
			if(_boundsDic[_curentAction]){
				return TestBoundManager.getInstance().test3DPoint(_boundsDic[_curentAction],this._rotationY,_absoluteX,_absoluteY,_absoluteZ,p);
			}else if(_boundsDic[_defaultAction]){
				return TestBoundManager.getInstance().test3DPoint(_boundsDic[_defaultAction],this._rotationY,_absoluteX,_absoluteY,_absoluteZ,p);
			}
			if(_defaultImg){
				return TestBoundManager.getInstance().test2DPoint(_defaultImg.bitmapdata,this.x,this.y,p);
			}
			return false;
		}
		
		public function getTestPointAry(p:Point,scX:Number,scY:Number):Vector.<Point>{
			if(_boundsDic[_curentAction]){
				return TestBoundManager.getInstance().get3DTo2DPoint(_boundsDic[_curentAction],this._rotationY,_absoluteX,_absoluteY,_absoluteZ,scX,scY,p);
			}
			return null;
		}
		/**
		 * 重新装载资源数据 
		 * 
		 */		
		override public function reload():void{
			_context = Scene_data.context3D;
//			for(var i:int;i<_equipList.length;i++){
//				_equipList[i].texture = TextureManager.getInstance().reloadTexture(_equipList[i].textureUrl);
//			}
			this._program = Program3DManager.getInstance().getProgram(Md5Shader.MD5SHADER);
			this._swimProgram = Program3DManager.getInstance().getProgram(Md5SwimShader.MD5SWIMSHADER);
			this._selectProgram = Program3DManager.getInstance().getProgram(Md5SelectShader.MD5_SELECT_SHADER);
			
			if(_lightProgram){
				_lightProgram = Program3DManager.getInstance().getProgram(Md5LightShader.MD5_LIGHT_SHADER);
			}
			
			//if(_lightTexture){
				//_lightTexture = TextureManager.getInstance().reloadTexture(_lightUrl);;
				//_maskTextur = TextureManager.getInstance().reloadTexture(_maskUrl);
			//}
			
			for(var i:int;i<equipList.length;i++){
				equipList[i].reload();
			}
			
			for each(var obj:Object in buffDic){
				if(obj.particle)
					obj.particle.reload();
			}
			
		}
		
		override public function set visible(value:Boolean):void{
			super.visible = value;
			
			for each(var obj:Object in buffDic){
				if(obj.particle)
					obj.particle.visible = value;
			}
			
			if(equipList){
				for(var i:int;i<equipList.length;i++){
					equipList[i].visible = value;
				}
			}
			
			if(_defaultImg){
				_defaultImg.visible = value;
			}
			
			setIsUpdate();
			//this.hasShadow = value;
		}
		/**
		 * 获取当前角色的高度 
		 * @return 
		 * 
		 */		
		public function getCurrentHeight():Number{
			var baseHeight:Number = 0;
			baseHeight = int(_nameHeightDic[_curentAction]);
			
			if(bindTarget){
				baseHeight += TestBoundManager.getInstance().math3DLenght(bindVecter3d.y)
			}else if(_z){
				baseHeight += TestBoundManager.getInstance().math3DLenght(_z);
			}
			
			baseHeight = baseHeight * getMainScale();
			
			return baseHeight;
		}

		public function get selected():Boolean
		{
			return _selected;
		}
		/**
		 * 选中描边 
		 * @param value
		 * 
		 */		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(value){
				if(_defaultImg){
					TextFieldManager.getInstance().addSelect(_defaultImg);
				}
				RoleBatch.getInstance().addSelect(this);
			}else{
				if(_defaultImg){
					TextFieldManager.getInstance().removeSelect(_defaultImg);
				}
				RoleBatch.getInstance().removeSelect(this);
			}
		}
		
		public function get hasShadow():Boolean
		{
			return _hasShadow && _visible;
		}
		
		/**
		 * 是否显示阴影 
		 */
		public function set hasShadow(value:Boolean):void
		{
			_hasShadow = value;
		}
		
		//public function setFlowLight(lightUrl:String,maskUrl:String):void{
			//_lightUrl = lightUrl;
			//_maskUrl = maskUrl;
			//_flowLightProgram = Program3DManager.getInstance().getProgram(Md5LightShader.MD5_LIGHT_SHADER);
			//new FlowLightUtils().setUrl(lightUrl,maskUrl,FlowlightTexture);
			//new FlowLightUtils().setUrl("../res/data/res3d/tempLight/levelUp_crystals.png","../res/data/res3d/tempLight/zuoqibao_2a.jpg",FlowlightTexture);
			//new FlowLightUtils().setUrl("../res/data/res3d/tempLight/disintegrate_clouds_alpha.png","../res/data/res3d/tempLight/zuoqibao_2a.jpg",FlowlightTexture);
			//new FlowLightUtils().setUrl("../res/data/res3d/tempLight/arcaneTorrent_galaxyTrails_Alpha.png","../res/data/res3d/tempLight/zuoqibao_2a.jpg",FlowlightTexture);
		//}
		
		
		
		private var _lightTextureVo:TextureVo;

		public function get lightTextureVo():TextureVo
		{
			return _lightTextureVo;
		}

		private var _allRunTime:int;
		/**
		 * 添加流光效果 
		 * @param url
		 * 
		 */		
		public function addLight(url:String):void{
			islight = true;
			
			if(!_lightProgram){
				_lightProgram = Program3DManager.getInstance().getProgram(Md5LightShader.MD5_LIGHT_SHADER);
			}
			
			if(!_lightSwimProgram){
				_lightSwimProgram = Program3DManager.getInstance().getProgram(Md5LightSwimShader.MD5LIGHTSWIMSHADER);
			}
			
			_lightTextureVo = TextureManager.getInstance().defaultLightTextVo;
			
			TextureManager.getInstance().addTexture(url,onLightTexture,null);
		}
		
		private function onLightTexture($textureVo:TextureVo,info:Object):void{
			if(islight){
				_lightTextureVo = $textureVo;
				_lightTextureVo.useNum++;
			}
		}
		
		public function get allRunTime():int{
			return _allRunTime;
		}
		/**
		 * 移除流光效果 
		 * 
		 */		
		public function removeLight():void{
			islight = false;
			if(_lightTextureVo && _lightTextureVo != TextureManager.getInstance().defaultLightTextVo){
				_lightTextureVo.useNum--;
			}
		}
		
		
		public function setColor(r:int=255,g:int=255,b:int=255):void{
			color.x = r/255;
			color.y = g/255;
			color.z = b/255;
			_colorString = String(r) + String(g) + String(b);
		}
		
		public function compareColor(r:int,g:int,b:int):Boolean{
			return _colorString == String(r) + String(g) + String(b);
		}
		
		
		/**
		 * 设置动作的函数, 仅供子类复写 
		 */		
		public function setStatus($status:String, $completeState:int=-1, $lockTime:int=0):void
		{
			
		}
		
		override public function dispose():void{
			if(_hasDisposed){
				return;
			}
			
			super.dispose();
			
			if(equipList){
				for(var i:int;i<equipList.length;i++){
					equipList[i].meshData.useNum --;
					equipList[i].textureVo.useNum --;
					equipList[i].dispose();
				}
				equipList.length = 0;
			}
			
			for each (var animVo:AnimVo in _animSouceDataDic){
				animVo.useNum--;
			}
			
			for each(var obj:Object in buffDic){
				if(obj.particle){
					obj.particle.dispose();
				}
				obj.buffUtil.cancle();
				obj.buffUtil.dispose();
			}
			
			for each(var txt:Text3Dynamic in titleDic){
				txt.dispose();
			}
			
			for(i=0;i<_meshUtilList.length;i++){
				_meshUtilList[i].isInterrupt = true;
				_meshUtilList[i].dispose();
			}
			
			_meshUtilList.length = 0;
			
			_animSouceDataDic = null;
			
			buffDic = null;
			
			titleDic = null;
			
			hasDispose = true;
			
			
			position3D = null;
			
			equDic = null;
			
			if(islight){
				removeLight();
			}
			_lightTextureVo = null;
			
			
			for each(var bar:CharBar in _barDic){
				bar.dispose();
			}
			
			_equipList = null;
			
			_posVec = null;
			
			_defaultAnimAry = null;
			
			_apdCallBackDic = null;
			if(_defaultImg){
				_defaultImg.dispose();
				_defaultImg = null;
			}
			
			color = null;
			
			_colorString = null;
			
			_hasDisposed = true;
			
			allNum--;
			
		}
		
		
		
	}
}