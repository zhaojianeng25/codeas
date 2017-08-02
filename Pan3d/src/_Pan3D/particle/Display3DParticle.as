package _Pan3D.particle
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	
	import _Pan3D.display3D.Display3D;
	import _Pan3D.display3D.Display3DBindMovie;
	import _Pan3D.display3D.interfaces.IBind;
	import _Pan3D.display3D.interfaces.IClone;
	import _Pan3D.display3D.interfaces.IDisplay3D;
	import _Pan3D.load.LoadManager;
	import _Pan3D.particle.ctrl.utils.AxisMove;
	import _Pan3D.particle.ctrl.utils.AxisRotaion;
	import _Pan3D.particle.ctrl.utils.BaseAnim;
	import _Pan3D.particle.ctrl.utils.Centrifugal;
	import _Pan3D.particle.ctrl.utils.ColorChange;
	import _Pan3D.particle.ctrl.utils.ScaleAnim;
	import _Pan3D.particle.ctrl.utils.ScaleChange;
	import _Pan3D.particle.ctrl.utils.ScaleNoise;
	import _Pan3D.particle.ctrl.utils.SelfRotation;
	import _Pan3D.texture.TextureCount;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.utils.MaterialManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import materials.ConstItem;
	import materials.DynamicConstItem;
	import materials.DynamicTexItem;
	import materials.MaterialTree;
	import materials.MaterialTreeParam;
	import materials.TexItem;

	public class Display3DParticle extends Display3D implements IDisplay3D
	{
		private var _delayedTime:Number=0 //   延时
		protected var _data:Object;
		protected var _width:Number = 100;//宽度
		protected var _height:Number = 100;//高度
//		protected var _closeGround:Boolean;//紧贴地面
//		protected var _gormalsGround:Boolean;//使用地面法线
		protected var _widthFixed:Boolean;//宽度比例不变
		protected var _heightFixed:Boolean;//高度比例不变
		protected var _tileMode:Boolean;//高度比例不变
		protected var _originWidthScale:Number = 0.5;//原点宽度比例
		protected var _originHeightScale:Number = 0.5;//原点高度比例
		protected var _eyeDistance:int = 0;//距离视点距离
		protected var _eyeDistanceVec:Vector3D = new Vector3D;
		protected var _alphaMode:int;//alpha混合模式
		protected var _testAlphaModeStr:String;
		protected var _testAlphaMode:Array;
		protected var _textureUrl:String;//贴图图片路径
		protected var _uSpeed:Number;//u坐标平移速度
		protected var _vSpeed:Number;//v坐标平移速度
		protected var _animLine:int;//动画行数
		protected var _animRow:int;//动画列数 
		protected var _animInterval:int;//动画时间间隔
		protected var _renderPriority:int;//渲染优先级
		protected var _distortion:Boolean;//是否扭曲
		
		protected var _center:Vector3D = new Vector3D();//中心点
		protected var _normal:Vector3D = new Vector3D(0,0,1);//法线
		protected var _life:int;//时间长度
		protected var _watchEye:Boolean=false  //是否面向视点
		protected var _ziZhuanAngly:Vector3D=new Vector3D(0,0,0);
		
		protected var _particleData:ParticleData;
		protected var _context3D:Context3D;
//		protected var _bitmapdata:BitmapData;
		
//		protected var _baseMatrix:Matrix3D;
		protected var _basePos:Vector3D;
		
		protected var _selfRotaion:SelfRotation;
		protected var _axisRotaion:AxisRotaion;
		protected var _centrifugal:Centrifugal;
		protected var _axisMove:AxisMove;
		protected var _colorChange:ColorChange;
		protected var _scaleChange:ScaleChange;
		protected var _scaleAnim:ScaleAnim;
		protected var _scaleNosie:ScaleNoise;
		protected var animAry:Vector.<BaseAnim>;
		
		protected var _isUV:Boolean;
		protected var _isU:Boolean;
		protected var _isV:Boolean;
		
		public var baseColor:Vector.<Number> = Vector.<Number>([1,1,1,1]);
		
		protected var _modelMatrix:Matrix3D;
		protected var _posMatrix:Matrix3D;
		
		protected var _loadComplete:Boolean;
		protected var _textureColor:Texture;
		protected var _textureColorAry:Vector.<Vector3D>;
		protected var _textureColorInfo:Object;
		
		protected var _particleType:int = 1;
		
		private var _materialUrl:String;
		
		public var materialParam:MaterialTreeParam;
		
		/**
		 * 显卡使用的逻辑时间 
		 */		
		protected var _gpuTime:int;
		
		public var overAllScale:Number = 1;
		private var _outScale:Number = 1;
		public var layer:uint=0;
		
		protected var _scaleX:Number = 1;
		protected var _scaleY:Number = 1;
		protected var _scaleZ:Number = 1;
		
		/**
		 * 该粒子加载的资源已经完成的个数 
		 */		
		protected var souceLoadNum:int;
		
		protected var _rotationMatrix:Matrix3D = new Matrix3D;
		
		public var priority:int;
		
		
		public var outVisible:Boolean = true;
		/**
		 * 透明度 
		 */		
		protected var _alpha:Number = 0.1;
		
		protected var useTextureColor:Boolean = true;
		
		public function Display3DParticle(context:Context3D)
		{
			super();
			this._context3D = context;
			_particleData = new ParticleData;
			
			//animAry = new Vector.<BaseAnim>(null,_selfRotaion,_axisRotaion,_centrifugal,_axisMove,_colorChange,null,_scaleChange,_scaleAnim,_scaleNosie);
		}
		
		public function get delayedTime():Number
		{
			return _delayedTime;
		}

		public function set delayedTime(value:Number):void
		{
			_delayedTime = value;
		}

		protected function uplodToGpu() : void {
			
		}
		
		public function pushToGpu():void{
			
		}
		
		protected function setVa() : void {
			
		}
		
		public function setMaterialTexture():void{
			if(!materialParam){
				return;
			}
			var texVec:Vector.<TexItem> = materialParam.material.texList;
			for(var i:int;i<texVec.length;i++){
				if(texVec[i].isDynamic){
					continue;
				}
				_context3D.setTextureAt(texVec[i].id, texVec[i].texture);
			}
			
			var texDynamicVec:Vector.<DynamicTexItem> = materialParam.dynamicTexList;
			for(i = 0;i<texDynamicVec.length;i++){
				_context3D.setTextureAt(texDynamicVec[i].target.id, texDynamicVec[i].texture);
			}
		}
		
		public function resetMaterialTexture():void{
			if(!materialParam){
				return;
			}
			var texVec:Vector.<TexItem> = materialParam.material.texList;
			for(var i:int;i<texVec.length;i++){
				_context3D.setTextureAt(texVec[i].id,null);
			}
		}
		
		protected function setVaBatch() : void {
			
		}
		
		protected function resetVa() : void {
			
		}
		protected function resetVaBatch() : void {
			
		}
		
		
		protected function setVc() : void {
			//_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12, new Matrix3D, true);
		}
		
		public function setMaterialVc():void{
			if(!materialParam){
				return;
			}
			var dynamicConstList:Vector.<DynamicConstItem> = materialParam.dynamicConstList;
			var t:Number = _gpuTime%(Scene_data.frameTime*_life);
			for(var i:int;i<dynamicConstList.length;i++){
				dynamicConstList[i].update(t);
			}
			
			if(materialParam.material.hasTime){
				t = t * materialParam.material.timeSpeed;
			}
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1,0,materialParam.material.killNum,t]));
			
			var constVec:Vector.<ConstItem> = materialParam.material.constList;
			for(i=0;i<constVec.length;i++){
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, constVec[i].id, constVec[i].vecNum);
			}
			
		}
		
		public var bindMatrix:Matrix3D = new Matrix3D;
		public var bindVecter3d:Vector3D = new Vector3D;
		
		public var bindOffset:Vector3D;
		public var bindRatation:Vector3D;
		
		public var bindIndex:int;
		public var bindTarget:IBind;
		public var bindSocket:String;
		
		/*public function get bindMatrix():Matrix3D{
			var m3d:Matrix3D = new Matrix3D;
			return m3d;
		}*/
		
		public function updateBind():void{
			return;
			if(bindTarget){
				//bindMatrix.identity();
				//bindMatrix.append(bindTarget.getPosMatrix(bindIndex));
				
				if(bindOffset){
					bindVecter3d = bindTarget.getOffsetPos(bindOffset,bindIndex);
				}else{
					bindTarget.getPosV3d(bindIndex,bindVecter3d);
				}
				
				bindMatrix.identity();
				if(bindRatation){
					//bindMatrix.appendRotation(-Scene_data.cam3D.angle_y , Vector3D.Y_AXIS);
					//bindMatrix.appendRotation(-Scene_data.cam3D.angle_x , Vector3D.X_AXIS);
					bindMatrix.appendRotation(bindRatation.x,Vector3D.X_AXIS);
					bindMatrix.appendRotation(bindRatation.y,Vector3D.Y_AXIS);
					bindMatrix.appendRotation(bindRatation.z,Vector3D.Z_AXIS);
					bindMatrix.append(bindTarget.getPosMatrix(bindIndex));
					//bindMatrix.appendTranslation(bindVecter3d.x,bindVecter3d.y,bindVecter3d.z);
				}else{
					bindMatrix.prependRotation(bindTarget.getRotation(),Vector3D.Y_AXIS);
				}
				
			}else{
				//bindMatrix.identity();
				if(bindOffset){
					bindVecter3d = bindOffset;
				}
			}
		}
		
		public function setBind($bindVecter3d:Vector3D,$bindMatrix:Matrix3D,_bindAlpha:Number=1):void{
			bindVecter3d = $bindVecter3d;
			if($bindMatrix){
				if(isInGroup){
					bindMatrix.copyFrom($bindMatrix);
				}else{
					bindMatrix = $bindMatrix;
				}
			}
			_alpha = _bindAlpha;
		}
		
		/**
		 * 设定该粒子的旋转和位移(静态模式) 
		 * @param ratationV3d 旋转
		 * @param offset 位移
		 * 
		 */		
		public function setRotationV3d(ratationV3d:Vector3D,offset:Vector3D):void{
			bindMatrix.identity();
			bindMatrix.appendRotation(ratationV3d.x,Vector3D.X_AXIS);
			bindMatrix.appendRotation(ratationV3d.y,Vector3D.Y_AXIS);
			bindMatrix.appendRotation(ratationV3d.z,Vector3D.Z_AXIS);
			
			bindVecter3d = bindOffset = offset;
		}
		
		public function setRotation($rx:int,$ry:int,$rz:int):void{
			bindMatrix.identity();
			bindMatrix.appendRotation($rx,Vector3D.X_AXIS);
			bindMatrix.appendRotation($ry,Vector3D.Y_AXIS);
			bindMatrix.appendRotation($rz,Vector3D.Z_AXIS);
		}
		
		public function setScale($sx:Number,$sy:Number,$sz:Number):void{
			_scaleX = $sx;
			_scaleY = $sy;
			_scaleZ = $sz;
		}
		
		override public function updateMatrix():void{
			modelMatrix.identity();
			
			
			if(isInGroup){
				posMatrix.appendScale(groupScale.x,groupScale.y,groupScale.z);
				posMatrix.appendRotation(groupRotation.x , Vector3D.X_AXIS);
				posMatrix.appendRotation(groupRotation.y , Vector3D.Y_AXIS); 
				posMatrix.appendRotation(groupRotation.z , Vector3D.Z_AXIS);
				posMatrix.appendTranslation(groupPos.x,groupPos.y,groupPos.z);
			}
			
			modelMatrix.append(posMatrix);
			
			modelMatrix.append(bindMatrix);
			
			if(isInGroup){
				bindMatrix.prependRotation(groupRotation.z , Vector3D.Z_AXIS);
				bindMatrix.prependRotation(groupRotation.y , Vector3D.Y_AXIS);
				bindMatrix.prependRotation(groupRotation.x , Vector3D.X_AXIS);
			}
			
			modelMatrix.appendTranslation(bindVecter3d.x,bindVecter3d.y,bindVecter3d.z);
			
			
			
			modelMatrix.append(Scene_data.cam3D.cameraMatrix);
			
			
			
		}
		
		public function getCamDistance():void{
			var m:Matrix3D=new Matrix3D;
			m.appendRotation(-Scene_data.cam3D.angle_x,Vector3D.X_AXIS)
			m.appendRotation(-Scene_data.cam3D.angle_y,Vector3D.Y_AXIS)
			_eyeDistanceVec = m.transformVector(new Vector3D(0,0,-_eyeDistance));
			//_eyeDistanceVec = new Vector3D;
		}
		
		public function resetCamDistance():void{
			var m:Matrix3D=new Matrix3D;
			m.appendRotation(-Scene_data.uiCamAngle,Vector3D.X_AXIS)
			_eyeDistanceVec = m.transformVector(new Vector3D(0,0,-_eyeDistance));
		}
		
		public function inverBind():void{
			bindMatrix.invert();
			_rotationMatrix.prepend(bindMatrix);
			bindMatrix.invert();
		}
		
		public function update() : void {

			if(this._renderPriority>Scene_data.effectsLev){
				return;
			}
			if (!this._visible) {
				return;
			}
			if(!this.outVisible){
				return;
			}
			if(_alphaMode == -1){
				setTestBlendFactors(_testAlphaMode[0],_testAlphaMode[1]);
			}else{
				setBlendFactors(_alphaMode);
			}
			
			if(materialParam){
				_context3D.setProgram(materialParam.program);
				
				if(materialParam.material.backCull){
					_context3D.setCulling(Context3DTriangleFace.BACK);
				}else{
					_context3D.setCulling(Context3DTriangleFace.NONE);
				}
				
			}else{
				_context3D.setProgram(this.program);
				//return;
			}
			
			setVc();
			setVa();
			resetVa();
				
		}
		public function updateBatch():void{
			if(this._renderPriority>Scene_data.effectsLev){
				return;
			}
			if (!this._visible) {
				return;
			}
			if(!this.outVisible){
				return;
			}
			
			setBlendFactors(_alphaMode);
			_context3D.setProgram(this.program);
			
			setVc();
			setVaBatch();
			resetVaBatch();
		}
		protected function setBlendFactors(type:int):void{
			switch(type){
				case 0:
					_context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
					break;
				case 1:
					_context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE);
					break;
				case 2:                    
					_context3D.setBlendFactors(Context3DBlendFactor.DESTINATION_COLOR,Context3DBlendFactor.ZERO);
					break;
				case 3:
					_context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
					break;
				case 4:
					_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE);
					break;
			}
		}
		
		protected function setTestBlendFactors(source:String,des:String):void{
			_context3D.setBlendFactors(source,des);
		}
		
		public function get textureUrl():String
		{
			return _textureUrl;
		}

		public function set textureUrl(value:String):void
		{
			_textureUrl = value;
			if(_textureUrl){
				TextureManager.getInstance().addTexture(Scene_data.particleRoot + value,onTextureLoad,null,priority);
			}
		}
		
		private function onTextureLoad(textureVo : TextureVo,info:Object):void{
			if(!particleData){
				return;
			}
			particleData.texture = textureVo.texture;
			particleData.textureVo = textureVo;
			//particleData.applyCallBack();
			textureVo.useNum++;
			sourceLoadCom();
			//addBatch();
		}

		
		override public function updatePosMatrix():void{
			posMatrix.identity();
			/*
			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
			posMatrix.prependScale(this._scale,this._scale,this._scale);
			posMatrix.prependRotation(_rotationX , Vector3D.X_AXIS);
			posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
			posMatrix.prependRotation(_rotationZ , Vector3D.Z_AXIS);
			*/
			
			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
			posMatrix.prependRotation(_rotationZ , Vector3D.Z_AXIS);
			posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
			posMatrix.prependRotation(_rotationX , Vector3D.X_AXIS);
			posMatrix.prependScale(this._scale,this._scale,this._scale);
		}
		
		override public function updataPos():void{
			if(this._parent){
				this._absoluteX = this._x + this._parent.absoluteX;
				this._absoluteY = this._y + this._parent.absoluteY;
				this._absoluteZ = this._z + this._parent.absoluteZ;
			}else{
				this._absoluteX = this._x;
				this._absoluteY = this._y;
				this._absoluteZ = this._z;
			}
			updatePosMatrix();
		}


		public function set center(value:Vector3D):void
		{
			_center = value;
			this.x = value.x;
			this.y = value.y;
			this.z = value.z;
		}
		
		public function get center():Vector3D
		{
			return this._center;
		}

		public function initAnim(rootAry:Array):void{
			if(rootAry == null){
				return;
			}
			for(var j:int=0;j<rootAry.length;j++){
				var ary:Array = rootAry[j].animData;
				if(!ary){
					return;
				}
				for(var i:int=0;i<ary.length;i++){
					if(ary[i].type == 1){
						if(!_selfRotaion)
							_selfRotaion = new SelfRotation;
						_selfRotaion.data = ary[i].data;
					}else if(ary[i].type == 2){
						if(!_axisRotaion)
							_axisRotaion = new AxisRotaion;
						_axisRotaion.data = ary[i].data;
					}else if(ary[i].type == 3){
						if(!_centrifugal)
							_centrifugal = new Centrifugal;
						_centrifugal.data = ary[i].data;
					}else if(ary[i].type == 4){
						if(!_colorChange)
							_colorChange = new ColorChange;
						_colorChange.data = ary[i].data;
					}else if(ary[i].type == 6){
						if(!_scaleChange)
							_scaleChange = new ScaleChange;
						_scaleChange.data = ary[i].data;
						_scaleChange.num = 1;
					}else if(ary[i].type == 7){
						if(!_scaleAnim)
							_scaleAnim = new ScaleAnim;
						_scaleAnim.data = ary[i].data;
						_scaleAnim.num = 1;
					}else if(ary[i].type == 8){
						if(!_scaleNosie)
							_scaleNosie = new ScaleNoise;
						_scaleNosie.data = ary[i].data;
						_scaleNosie.num = 1;
					}else if(ary[i].type == 9){
						if(!_axisMove)
							_axisMove = new AxisMove;
						_axisMove.data = ary[i].data;
					}
				}
				
			}
			
		}
		
		public function enterKeyFrame(ary:Array,baseTime:int=0,baseValue:Array=null):void{
			if(baseValue == null){
				return;
			}
			for(var i:int;i<baseValue.length;i++){
				if(!baseValue[i]){
					continue;
				}
				switch(i){
					case 1:
						if(!_selfRotaion)
							_selfRotaion = new SelfRotation;
						_selfRotaion.num = _selfRotaion.baseNum = baseValue[i];
						break;
					case 2:
						if(!_axisRotaion)
							_axisRotaion = new AxisRotaion;
						_axisRotaion.num =_axisRotaion.baseNum = baseValue[i];
						break;
					case 3:
						if(!_centrifugal)
							_centrifugal = new Centrifugal;
						_centrifugal.num = _centrifugal.baseNum = baseValue[i];
						break;
					case 4:
						if(!_colorChange)
							_colorChange = new ColorChange;
						_colorChange.num = _colorChange.baseNum = baseValue[i];
						break;
					case 6:
						if(!_scaleChange)
							_scaleChange = new ScaleChange;
						_scaleChange.num = _scaleChange.baseNum = baseValue[i];
						break;
					case 7:
						if(!_scaleAnim)
							_scaleAnim = new ScaleAnim;
						_scaleAnim.num = _scaleAnim.baseNum = baseValue[i];
						break;
					case 8:
						if(!_scaleNosie)
							_scaleNosie = new ScaleNoise;
						_scaleNosie.num = _scaleNosie.baseNum = baseValue[i];
						break;
					case 9:
						if(!_axisMove)
							_axisMove = new AxisMove;
						_axisMove.num = _axisMove.baseNum = baseValue[i];
						break;
				}
			}
			
			if(_selfRotaion)
				_selfRotaion.isDeath = true;
			if(_axisRotaion)
				_axisRotaion.isDeath = true;
			if(_centrifugal)
				_centrifugal.isDeath = true;
			if(_colorChange)
				_colorChange.isDeath = true;
			if(_scaleChange)
				_scaleChange.isDeath = true;
			if(_scaleAnim)
				_scaleAnim.isDeath = true;
			if(_scaleNosie)
				_scaleNosie.isDeath = true;
			if(_axisMove)
				_axisMove.isDeath = true;
			
			if(ary == null){
				return;
			}
			
			for(i=0;i<ary.length;i++){
				if(ary[i].type == 1){
					if(!_selfRotaion){
						_selfRotaion = new SelfRotation;
					}else{
						_selfRotaion.reset();
					}
					_selfRotaion.data = ary[i].data;
					_selfRotaion.baseTime = baseTime;
				}else if(ary[i].type == 2){
					if(!_axisRotaion){
						_axisRotaion = new AxisRotaion;
					}else{
						_axisRotaion.reset();
					}
					_axisRotaion.data = ary[i].data;
					_axisRotaion.baseTime = baseTime;
				}else if(ary[i].type == 3){
					if(!_centrifugal){
						_centrifugal = new Centrifugal;
					}else{
						_centrifugal.reset();
					}
					_centrifugal.data = ary[i].data;
					_centrifugal.baseTime = baseTime;
				}else if(ary[i].type == 4){
					if(!_colorChange){
						_colorChange = new ColorChange;
					}else{
						_colorChange.reset();
					}
					_colorChange.data = ary[i].data;
					_colorChange.baseTime = baseTime;
				}else if(ary[i].type == 6){
					if(!_scaleChange){
						_scaleChange = new ScaleChange;
					}else{
						_scaleChange.reset();
					}
					_scaleChange.data = ary[i].data;
					_scaleChange.baseTime = baseTime;
				}else if(ary[i].type == 7){
					if(!_scaleAnim){
						_scaleAnim = new ScaleAnim;
					}else{
						_scaleAnim.reset();
					}
					_scaleAnim.data = ary[i].data;
					_scaleAnim.baseTime = baseTime;
				}else if(ary[i].type == 8){
					if(!_scaleNosie){
						_scaleNosie = new ScaleNoise;
					}else{
						_scaleNosie.reset();
					}
					_scaleNosie.data = ary[i].data;
					_scaleNosie.baseTime = baseTime;
				}else if(ary[i].type == 9){
					if(!_axisMove){
						_axisMove = new AxisMove;
					}else{
						_axisMove.reset();
					}
					_axisMove.data = ary[i].data;
					_axisMove.baseTime = baseTime;
				}
			}
		}
		
		protected var _timer:int;
		public var beginTime:Number = 0;
		public function updateTime(t:int):void{
			if(_selfRotaion)
				_selfRotaion.update(t);
			if(_axisRotaion)
				_axisRotaion.update(t);
			if(_centrifugal)
				_centrifugal.update(t);
			if(_axisMove)
				_axisMove.update(t);
			if(_scaleChange)
				_scaleChange.update(t);
			if(_scaleNosie){
				_scaleNosie.update(t);
			}
			if(_scaleAnim){
				_scaleAnim.update(t);
			}
			if(_colorChange){
				_colorChange.update(t);
			}
			updateAnimMatix();
			_timer = t - beginTime;
			if(_timer < 0){
				_timer = 0;
			}
			updateParticle();
			//if(this.particleType != 13){
				updateBind();
			//}
			_gpuTime = _timer%500000;
			_gpuTime+=this.delayedTime
			//trace(_gpuTime)
		}
		
		public function updateParticle():void{
			
		}
		
		public function updateAnimMatix():void{
			
			posMatrix.identity();
			
			
			
			
			//0.1是用来统一粒子和模型的比例
			posMatrix.prependScale(overAllScale*_scaleX*0.1,overAllScale*_scaleY*0.1,overAllScale*_scaleZ*0.1);
			
			if(_axisMove)
				posMatrix.prependTranslation(_axisMove.axis.x*_axisMove.num, _axisMove.axis.y*_axisMove.num, _axisMove.axis.z*_axisMove.num);
			
			if(_axisRotaion){
				posMatrix.prependRotation(_axisRotaion.num,_axisRotaion.axis,_axisRotaion.axisPos);
			}
			
			if(_centrifugal){
				_basePos = new Vector3D(this._absoluteX, this._absoluteY, this._absoluteZ);
				var tempVec:Vector3D = _basePos.subtract(_centrifugal.center)
				tempVec.scaleBy(1+_centrifugal.num);
				tempVec = tempVec.add(_centrifugal.center);
				posMatrix.prependTranslation(tempVec.x,tempVec.y,tempVec.z);
			}else{
				posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
			}
			posMatrix.prependRotation(_rotationZ , Vector3D.Z_AXIS);
			posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
			posMatrix.prependRotation(_rotationX , Vector3D.X_AXIS);
	
		
			
			if(_scaleChange){
				processScale();
			}else if(_scaleNosie){
				processNosie();
			}else if(_scaleAnim){
				processScaleAnim();
			}else{
				posMatrix.prependScale(this._scale,this._scale,this._scale);
			}
			
			
			
			
			
			
			
		}
		
		protected function processScaleAnim():void{
			if(_scaleAnim.num==0){
				_scaleAnim.num=0.001  //特殊处理当为
			}
			posMatrix.prependScale(_widthFixed?1:_scaleAnim.num,_heightFixed?1:_scaleAnim.num,_widthFixed?1:_scaleAnim.num);
		}
		
		protected function processScale():void{
			if(_scaleChange.num==0){
				_scaleChange.num=0.001  //特殊处理当为
			}
			posMatrix.prependScale(_widthFixed?1:_scaleChange.num,_heightFixed?1:_scaleChange.num,_widthFixed?1:_scaleChange.num);
		}
		
		protected function processNosie():void{
			if(_scaleNosie.num==0){
				_scaleNosie.num=0.001  //特殊处理当为
			}
			posMatrix.prependScale(_widthFixed?1:(this._scale + _scaleNosie.num),_heightFixed?1:(this._scale + _scaleNosie.num),_widthFixed?1:(this._scale + _scaleNosie.num));
		}
		
		public function clearAllAnim():void{
			 _selfRotaion = null;
			 _axisRotaion = null;
			 _centrifugal = null;
			 _axisMove = null;
			 _colorChange = null;
			 _scaleChange = null;
			 _scaleAnim = null;
			 _scaleNosie = null;
			 _alpha = 1;
		}
		
		public function set alpha(value:Number):void{
			_alpha = value;
		}
		
		public function get alpha():Number{
			return _alpha;
		}
		
		public function setMatrix(modelMatrix : Matrix3D) : void {
			
		}
		
		public function updataAndScanning():void
		{
			
			
		}
		
		public function set testAlphaMode(str:String):void{
			_testAlphaModeStr = str;
			if(!str){
				str = "one|zero";
			}
			_testAlphaMode = str.split("|");
		}
		
		public function getAllInfo():Object{
			var obj:Object = new Object;
			obj.delayedTime=_delayedTime;
			obj.name = this.name;
			obj.width = _width;
			obj.height = _height;
			obj.widthFixed = _widthFixed;
			obj.heightFixed = _heightFixed;
			obj.originWidthScale = _originWidthScale;
			obj.originHeightScale = _originHeightScale;
			obj.eyeDistance = _eyeDistance;
			obj.alphaMode = _alphaMode;
			obj.testAlphaMode = _testAlphaModeStr;
			obj.textureUrl = _textureUrl;
			obj.uSpeed = _uSpeed;
			obj.vSpeed = _vSpeed;
			obj.animLine = _animLine;
			obj.animRow = _animRow; 
			obj.animInterval = _animInterval;
			obj.renderPriority = _renderPriority;
			obj.distortion = _distortion;
			
			obj.center = _center;
			obj.normal = _normal;
			obj.life = _life;
			obj.watchEye = _watchEye;
			obj.ziZhuanAngly = _ziZhuanAngly;
			obj.basePos = _basePos;
			obj.baseColor = baseColor;
			
			obj.rotationX = this.rotationX;
			obj.rotationY = this.rotationY;
			obj.rotationZ = this.rotationZ;
			
			obj.isUV = _isUV;
			obj.isU = _isU;
			obj.isV = _isV;
			
			obj.textureColor = _textureColorInfo;
			
			obj.particleType = _particleType;
			
			obj.overAllScale = overAllScale;
			
			obj.materialUrl = this.materialUrl;
			
			if(this.materialParam){
				obj.materialParam = this.materialParam.getData();
			}
			
			return obj;
		}
		
		public function setAllInfo(obj:Object,isClone:Boolean=false):void{
			_data = obj;
			this._delayedTime=isNaN(obj.delayedTime)?0:obj.delayedTime;
			this.name = obj.name;
			this._width = obj.width;
			this._height = obj.height;
			this._widthFixed = obj.widthFixed;
			this._heightFixed = obj.heightFixed;
			this._originWidthScale = obj.originWidthScale;
			this._originHeightScale = obj.originHeightScale;
			this._eyeDistance = obj.eyeDistance;
			this._alphaMode = obj.alphaMode;
			this.testAlphaMode = obj.testAlphaMode;
			//this.textureUrl = obj.textureUrl;
			this._uSpeed = obj.uSpeed;
			this._vSpeed = obj.vSpeed;
			this._animLine = obj.animLine==0?1:obj.animLine;
			this._animRow = obj.animRow==0?1:obj.animRow; 
			this._animInterval = obj.animInterval==0?1:obj.animInterval;
			this._renderPriority = obj.renderPriority;
			this.distortion = obj.distortion;
			
			this._isUV = obj.isUV;
			this._isU = obj.isU;
			this._isV = obj.isV;
			
			this._life = obj.life>10000?int.MAX_VALUE:obj.life;
			this._watchEye=obj.watchEye;
			this._ziZhuanAngly = getVector3DByObject(obj.ziZhuanAngly);
			
			if(obj.rotationX)
				this.rotationX = obj.rotationX;
			if(obj.rotationY)
				this.rotationY = obj.rotationY;
			if(obj.rotationZ)
				this.rotationZ = obj.rotationZ;
			
			if(obj.center){
				this.center = getVector3DByObject(obj.center);
				processNaN(this.center);
			}
			if(obj.overAllScale){
				overAllScale = obj.overAllScale;
			}
			
			if(isClone){
				this._textureUrl = obj.textureUrl;
				this._textureColorInfo = obj.textureColor;
			}else{
				this.textureUrl = obj.textureUrl;
				this.textureColor = obj.textureColor;
			}
			
			if(materialParam){
				materialParam.setLife(this._life);
				MaterialManager.getInstance().loadDynamicTexUtil(materialParam);
			}
			
			this.materialUrl = obj.materialUrl;
			
			getCamDistance();
		}
		
		private function processNaN(v3d:Vector3D):void{
			if(isNaN(v3d.x)){
				v3d.x = 0;
			}
			if(isNaN(v3d.y)){
				v3d.y = 0;
			}
			if(isNaN(v3d.z)){
				v3d.z = 0;
			}
			if(isNaN(v3d.w)){
				v3d.w = 0;
			}
			
		}
		
		public function setBeginInfo(obj:Object):void{
			this.center = new Vector3D(obj.center.x,obj.center.y,obj.center.z);
			_center = obj.center;
			this.x = _center.x;
			this.y = _center.y;
			this.z = _center.z; 
			
			this._normal = new Vector3D(obj.normal.x,obj.normal.y,obj.normal.z);
			this.baseColor = obj.baseColor;

			this.rotationX = obj.rotationX;
			this.rotationY = obj.rotationY;
			this.rotationZ = obj.rotationZ;
			this.updateAnimMatix();
		}
		
		protected function set textureColor(colorInfo:Object):void{
			if(!colorInfo){
				return;
			}
			
			_textureColorInfo = colorInfo;
			
			var num:int = 2;
			for(var i:int=1;i<10;i++){
				num = num*2;
				if(_life < num){
					break;
				}
			}
			
			var matr:Matrix = new Matrix();
			matr.createGradientBox(num, 20, 0, 0, 0);
			
			var shape:Shape = new Shape;
			shape.graphics.clear();
			shape.graphics.beginGradientFill(GradientType.LINEAR, colorInfo.color, colorInfo.alpha, colorInfo.pos, matr, SpreadMethod.PAD);  
			shape.graphics.drawRect(0,0,num,1);
			
			var bitmapdata:BitmapData = new BitmapData(num,1,true,0);
			bitmapdata.draw(shape);
			_textureColorAry = new Vector.<Vector3D>;
			for(i=0;i<num;i++){
				var expColor:uint = bitmapdata.getPixel32(i,0);
				var expA:Number = ((expColor>>24) & 0xFF)/255;
				var expR:Number = ((expColor>>16) & 0xFF)/255;
				var expG:Number = ((expColor>>8) & 0xFF)/255;
				var expB:Number = ((expColor) & 0xFF)/255;
				expR *= expA;
				expG *= expA;
				expB *= expA;
				_textureColorAry.push(new Vector3D(expR,expG,expB,expA));
			}
			
			try{
				if(useTextureColor){
					_textureColor = _context3D.createTexture(num,1,Context3DTextureFormat.BGRA,true);
					_textureColor.uploadFromBitmapData(bitmapdata);
				}
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
			colorWidth = num;
			TextureCount.getInstance().countParticleColor(num);
		}
		private var colorWidth:int;
			
		public function getVector3DByObject(obj:Object):Vector3D{
			if(!obj){
				return null;
			}
			return new Vector3D(obj.x,obj.y,obj.z,obj.w);
		}

		public function get particleType():int
		{
			return _particleType;
		}

		public function set particleType(value:int):void
		{
			_particleType = value;
		}
		
		public function clone():Display3DParticle{
			return null;
		}
		
		public function removeRender():void{
			if(this.parent){
				this.parent.removeChild(this);
			}
		}
		/**
		 * 获取该粒子需要加载资源的个数 
		 * @return int
		 * 
		 */		
		public function get loadNum():int{
			return 1;
		}
		/**
		 * 资源加载完成 +1 
		 * 
		 */		
		public function sourceLoadCom():void{
			souceLoadNum++;
			if(souceLoadNum == loadNum){
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		/**
		 * 重新装载 
		 * 
		 */		
		public function reload():void{
			_context3D = Scene_data.context3D;
			particleData.texture = 	TextureManager.getInstance().reloadTexture(Scene_data.particleRoot + _textureUrl);
			textureColor = _textureColorInfo;
		}
		
		public function resetPos($xpos:int,$ypos:int,$zpos:int):void{
			bindVecter3d.x = $xpos;
			bindVecter3d.y = $ypos;
			bindVecter3d.z = $zpos;
		}

		public function get alphaMode():int
		{
			return _alphaMode;
		}
		override public function set visible(value:Boolean):void{
			super.visible = value;
		}
		
		protected var _hasBatch:Boolean;
		//protected var _batchMode:Boolean = false;
//		public function addBatch():void{
//			if(!_batchMode){
//				return;
//			}
//			if(!_hasBatch){
//				if(visible && particleData.texture && this.parent){
//					Batch.getInstance().addParticle(this);
//					_hasBatch = true;
//				}
//			}
//		}
		
//		public function removeBatch():void{
//			if(_hasBatch){
//				Batch.getInstance().removePaticle(this);
//				_hasBatch = false;
//			}
//		}

		public function get particleData():ParticleData
		{
			return _particleData;
		}

		public function set particleData(value:ParticleData):void
		{
			_particleData = value;
			//_particleData.callBack(addBatch);
		}
		protected var hasDispose:Boolean;
		override public function dispose():void{
			hasDispose = true;
			if(_particleData){
				_particleData.dispose();
				_particleData.hasDispose = true;
			}
			if(_textureColor){
				_textureColor.dispose();
			}
			TextureCount.getInstance().countParticleColor(-colorWidth);
		}
		/**
		 * 卸载buffer 
		 * 
		 */		
		public function unloadBuffer():void{
			particleData.unload();
		}
		/**
		 * 装载buffer 
		 * 
		 */		
		public function uploadBuffer():void{
			if(particleData.hasUnload){
				pushToGpu();
				particleData.hasUnload = false;
			}
		}
		
		
		public function baseClear():void{
			bindTarget = null;
		}
		
		public function clear():void{
			bindMatrix = null;
			bindVecter3d = null;
			
			bindOffset = null;
			bindRatation = null;
			
			bindTarget = null;
			
			_data = null;
			_eyeDistanceVec = null;
			_testAlphaModeStr = null;
			_testAlphaMode = null;
			_textureUrl = null;
			
			_center = null;
			_normal = null
			_ziZhuanAngly = null;
			
			_particleData = null;
			
			_basePos = null;
			
			_selfRotaion = null;
			_axisRotaion = null;
			_centrifugal = null;
			_axisMove = null;
			_colorChange = null;
			_scaleChange = null;
			_scaleAnim = null;
			_scaleNosie = null;
			animAry = null;
			
			baseColor = null;
			
			_modelMatrix = null;
			_posMatrix = null;
			
			_textureColor = null;
			_textureColorAry = null;
			_textureColorInfo = null;
			
			_rotationMatrix = null;
			
		}
		
		public function getBufferNum():int{
			throw new Error("没有重写");
			return 0;
		}

		public function get materialUrl():String
		{
			return _materialUrl;
		}

		public function set materialUrl(value:String):void
		{
			if(_materialUrl == value){
				return;
			}
			
			_materialUrl = value;
			
			MaterialManager.getInstance().getMaterial(Scene_data.fileRoot + value,onMaterialLoad,value);
		}
		
		public function setMaterialUrlEnforce(value:String):void
		{
			
			_materialUrl = value;
			
			MaterialManager.getInstance().getMaterial(Scene_data.fileRoot + value,onMaterialLoad,value);
		}
		
		public function regShader():void{
			
		}
		
		public function getMaterialTree():MaterialTree{
			if(materialParam){
				return materialParam.material;
			}
			return null;
		}
		
		public function getMaterialParamUrl():Array{
			var ary:Array = new Array;
			if(this.materialParam){
				var dynamicTexList:Vector.<DynamicTexItem> = this.materialParam.dynamicTexList;
				
				for(var i:int;i<dynamicTexList.length;i++){
					ary.push(dynamicTexList[i].url);
				}
				
			}
			return ary;
		}
		
		private function onMaterialLoad($matrial:MaterialTree,$url:String):void
		{
			materialParam = new MaterialTreeParam;
			materialParam.setMaterial($matrial);
			materialParam.setLife(this._life);
			
			var materialParamData:Object = _data.materialParam;
			if(materialParamData){
				materialParam.setTextObj(materialParamData.texAry);
				materialParam.setConstObj(materialParamData.conAry);
			}
			
			MaterialManager.getInstance().loadDynamicTexUtil(materialParam);
			
			regShader();
			
			if(Scene_data.isDevelop){
				this.dispatchEvent(new Event("materialComplete"));
			}
			
		}

		public function get distortion():Boolean
		{
			return _distortion;
		}

		public function set distortion(value:Boolean):void
		{
			_distortion = value;
			this.dispatchEvent(new Event(Event.CHANNEL_STATE));
		}

		public function get outScale():Number
		{
			return _outScale;
		}

		public function set outScale(value:Number):void
		{
			_outScale = value;
			
			_scaleX = _scaleY = _scaleZ = value;
		}

		
	}
}