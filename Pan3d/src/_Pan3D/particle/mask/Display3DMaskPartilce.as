package _Pan3D.particle.mask
{
	import _Pan3D.base.MakeModelData;
	import _Pan3D.base.ObjData;
	import _Pan3D.batch.IBatch;
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.ParticleData;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DMaskPartilce extends Display3DParticle implements IBatch
	{
		//protected var _closeGround:Boolean;//紧贴地面
		//protected var _gormalsGround:Boolean;//使用地面法线
				
		//protected var _bitmapdata:BitmapData;
		//protected var _baseMatrix:Matrix3D;
		
		protected var _maxAnimTime:int;
		private var _maskUrl:String;
		//private var _maskTexture:Texture;
		//private var _maskTextureVo:TextureVo;
		
		//private var _particleMaskData:ParticleMaskData;
		public function Display3DMaskPartilce(context:Context3D)
		{
			super(context);
			_particleData = new ParticleMaskData;
			//_particleMaskData = new ParticleMaskData;
			//initData();
			this.particleType = 11;
			useTextureColor = false;
		}
		
		public function initData():void{
			//_bitmapdata = new BitmapData(512,512,true,0xffffffff);
			_normal = new Vector3D(0,0,1);
			
			try{
				uplodToGpu();
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
		}
		
		override protected function uplodToGpu() : void {
			var objData:ObjData = MakeModelData.makeRectangleMaskData(this._width,this._height,this._originWidthScale,this._originHeightScale,_isUV,_isU,_isV,_animLine,_animRow);
			
			particleData.vertices = objData.vertices;
			particleData.uvs = objData.uvs;
			particleData.indexs = objData.indexs;
			
			pushToGpu();
			
		}
		
		override public function pushToGpu():void{
			particleData.vertexBuffer = this._context3D.createVertexBuffer(particleData.vertices.length / 3, 3);
			particleData.vertexBuffer.uploadFromVector(Vector.<Number>(particleData.vertices), 0, particleData.vertices.length / 3);
			
			particleData.uvBuffer = this._context3D.createVertexBuffer(particleData.uvs.length / 4, 4);
			particleData.uvBuffer.uploadFromVector(Vector.<Number>(particleData.uvs), 0, particleData.uvs.length / 4);
			
			particleData.indexBuffer = this._context3D.createIndexBuffer(particleData.indexs.length);
			particleData.indexBuffer.uploadFromVector(Vector.<uint>(particleData.indexs), 0, particleData.indexs.length);
		}
		
		override protected function setVa() : void {
			_context3D.setVertexBufferAt(0, particleData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, particleData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context3D.setTextureAt(1, particleData.texture);
//			_context3D.setTextureAt(2,_textureColor);
			_context3D.setTextureAt(3,ParticleMaskData(particleData).maskTexture);
			_context3D.drawTriangles(particleData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(particleData.indexs.length/3);
		}
		
		override protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setTextureAt(1,null);
			_context3D.setTextureAt(2,null);
			_context3D.setTextureAt(3,null);
		}
		
		override protected function setVaBatch() : void {
			_context3D.setVertexBufferAt(0, particleData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, particleData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
//			_context3D.setTextureAt(2,_textureColor);
			_context3D.setTextureAt(3,ParticleMaskData(particleData).maskTexture);
			_context3D.drawTriangles(particleData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			if(particleData.indexs){
				Scene_data.drawTriangle += int(particleData.indexs.length/3);
			}else{
				trace("&&&&&&&&&&error&&&&&&&&&&")
			}
		}
		
		override protected function resetVaBatch() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setTextureAt(2,null);
			_context3D.setTextureAt(3,null);
		}
		
		override protected function setVc() : void {
			this.updateMatrix();
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, modeRotationMatrix, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 24, modeZiZhuanMatrix3D, true);// 传入整个粒子的旋转 
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>( [_gpuTime/Scene_data.frameTime/_life,_gpuTime/Scene_data.frameTime,_animInterval,_maxAnimTime])); 
			
//			if(_colorChange){
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1+_colorChange.rValue*_colorChange.num, 1+_colorChange.gValue*_colorChange.num, 1+_colorChange.bValue*_colorChange.num, 1+_colorChange.aValue*_colorChange.num]));
//			}else{
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1,1,1,1]));
//			}
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, getColor());
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,3,Vector.<Number>( [ _animLine,_animRow,_uSpeed,_vSpeed ])); //UV移动

			if(_timer/Scene_data.frameTime > (_life-2)){
				this.visible = false;
			}
		}
		
		private var _colorVec:Vector.<Number>;
		public function getResultColor():Vector.<Number>{
			if(_colorChange){
				_colorVec[0] = 1+_colorChange.rValue*_colorChange.num;
				_colorVec[1] = 1+_colorChange.gValue*_colorChange.num;
				_colorVec[2] = 1+_colorChange.bValue*_colorChange.num;
				_colorVec[3] = (1+_colorChange.aValue*_colorChange.num)*_alpha;
			}else{
				_colorVec[3] = _alpha;
			}
			return _colorVec;
		}
		
		//private var _rotationMatrix:Matrix3D = new Matrix3D;
		protected  function  get modeRotationMatrix():Matrix3D
		{
			_rotationMatrix.identity();
			if(!_watchEye){
				return _rotationMatrix; 
			}
			if(_axisRotaion){
				_rotationMatrix.prependRotation(-_axisRotaion.num,_axisRotaion.axis);
			}
			//var m:Matrix3D=bindMatrix.clone();
			//if(bindTarget){
				//bindMatrix.invert();
				//_rotationMatrix.prepend(bindMatrix);
			//}
			inverBind();
			_rotationMatrix.prependRotation(-Scene_data.cam3D.angle_y , Vector3D.Y_AXIS);
			_rotationMatrix.prependRotation(-Scene_data.cam3D.angle_x , Vector3D.X_AXIS);
	
			return _rotationMatrix;
		}
		
		protected function get modeZiZhuanMatrix3D():Matrix3D
		{
			_rotationMatrix.identity();
			if(_ziZhuanAngly.x==_ziZhuanAngly.y&&_ziZhuanAngly.y==_ziZhuanAngly.z&&_ziZhuanAngly.z==0){
				
			}else{
				if(_selfRotaion){
					_rotationMatrix.prependRotation(_selfRotaion.num,_ziZhuanAngly);
				}
			}
			if(_scaleChange)
				_rotationMatrix.prependScale(_widthFixed?1:_scaleChange.num,_heightFixed?1:_scaleChange.num,_scaleChange.num);
	
			return _rotationMatrix;
		}
		
//		override public function updatePosMatrix():void{
//			posMatrix.identity();
//			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
//			posMatrix.prependScale(this._scale,this._scale,this._scale);
//			posMatrix.prependRotation(_rotationX , Vector3D.X_AXIS);
//			posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
//			posMatrix.prependRotation(_rotationZ , Vector3D.Z_AXIS);
//		}
		private var _resultMatrix:Matrix3D = new Matrix3D;
		public function getResultMatrix():Matrix3D{
			this.updateMatrix();
			
			_resultMatrix.identity();
			_resultMatrix.append(modeZiZhuanMatrix3D);
			_resultMatrix.append(modeRotationMatrix);
			_resultMatrix.append(modelMatrix);
			
			return _resultMatrix;
		}
		public function getResultUV():Vector.<Number>{
			var currentFrame:int = (_timer/Scene_data.frameTime/_animInterval)%(_animLine*_animRow);
			var uPos:Number = int(currentFrame%_animLine)/_animLine + _timer/Scene_data.frameTime*_uSpeed;
			var vPos:Number = int(currentFrame/_animLine)/_animRow + _timer/Scene_data.frameTime*_vSpeed;
			return Vector.<Number>([uPos,vPos,0,0]);
		}
		public function getColor():Vector.<Number>{
			var per:Number = Math.abs((_timer/Scene_data.frameTime/_life)%1);
			var color:Vector3D = _textureColorAry[int((_textureColorAry.length-1)*per)]
			
			if(_colorChange){
				_colorVec[0] = 1+_colorChange.rValue*_colorChange.num;
				_colorVec[1] = 1+_colorChange.gValue*_colorChange.num;
				_colorVec[2] = 1+_colorChange.bValue*_colorChange.num;
				_colorVec[3] = (1+_colorChange.aValue*_colorChange.num) * _alpha;
			}else{
				_colorVec[3] = _alpha;
			}
			
			return Vector.<Number>([_colorVec[0] * color.x,_colorVec[1] * color.y,_colorVec[2] * color.z,_colorVec[3] * color.w]);
		}
		
		override protected function processScale():void{
			
			//posMatrix.prependScale(_widthFixed?1:_scaleChange.num,_heightFixed?1:_scaleChange.num,_scaleChange.num);
		}
		
		public function setDynamicVc():void{
			
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, baseColor); 
		}
		
		override public function getAllInfo():Object{
			var obj:Object = super.getAllInfo();
			//obj.closeGround = _closeGround;//紧贴地面
			//obj.gormalsGround = _gormalsGround;//使用地面法线
			obj.maxAnimTime = _maxAnimTime;
			obj.maskUrl = _maskUrl;
			return obj;
		}
		
		override public function setAllInfo(obj:Object,isClone:Boolean=false):void{
			//this._closeGround = obj.closeGround;
			//this._gormalsGround = obj.gormalsGround;
			this._maxAnimTime = obj.maxAnimTime;
			
			_colorVec = Vector.<Number>( [1,1,1,1]);
			
			if(!isClone){
				maskUrl = obj.maskUrl;
			}else{
				_maskUrl = obj.maskUrl;
			}
			
			super.setAllInfo(obj,isClone);
			
			if(!isClone){
				try{
					uplodToGpu();
				} 
				catch(error:Error) {
					if(!Scene_data.disposed){
						throw error;
					}
				}
			}
			
		}
		
		public function set maskUrl(value:String):void
		{
			_maskUrl = value;
			if(_maskUrl){
				TextureManager.getInstance().addTexture(Scene_data.particleRoot + value,onMaskTextureLoad,null,priority);
			}
		}
		
		public function get maskUrl():String{
			return _maskUrl;
		}
		
		private function onMaskTextureLoad(textureVo : TextureVo,info:Object):void{
			//particleData.texture = texture;
//			_maskTexture = textureVo.texture;
//			_maskTextureVo = textureVo;
			ParticleMaskData(particleData).maskTexture = textureVo.texture;
			ParticleMaskData(particleData).maskTextureVo = textureVo;
			textureVo.useNum++;
			sourceLoadCom();
			//addBatch();
			//ParticleMaskData(particleData).applyCallMaskBack();
		}
		
		override public function set particleData(value:ParticleData):void
		{
			super.particleData = value;
			//ParticleMaskData(particleData).callMaskBack(addBatch);
		}
		
		
		override public function clone():Display3DParticle{
			var display:Display3DMaskPartilce = new Display3DMaskPartilce(_context3D);
			display.setProgram3D(this._program);
			display.setAllInfo(_data,true);
			display.particleData = particleData;
			display._textureColor = _textureColor;
			display._textureColorAry = _textureColorAry;
//			display._maskTexture = _maskTexture;
			return display;
		}
		
		override public function get loadNum():int{
			return 2;
		}
		
		override public function reload():void{
			super.reload();
			_program = Program3DManager.getInstance().getProgram(Display3DMaskShader.DISPLAY3DMASKSHADER);
			//_maskTexture = TextureManager.getInstance().reloadTexture(Scene_data.particleRoot + _maskUrl);
			ParticleMaskData(particleData).maskTexture =  TextureManager.getInstance().reloadTexture(Scene_data.particleRoot + _maskUrl);
			pushToGpu();
		}
		
		override public function clear():void{
			super.clear();
			
			_colorVec = null;
			_resultMatrix = null;

		}

//		public function get maskTexture():Texture
//		{
//			return _maskTexture;
//		}
		
//		override public function addBatch():void{
//			if(!_batchMode){
//				return;
//			}
//			if(!_hasBatch){
//				if(visible && particleData.texture && this.parent && ParticleMaskData(particleData).maskTexture){
//					Batch.getInstance().addParticle(this);
//					_hasBatch = true;
//				}
//			}
//		}
		
//		override public function dispose():void{
//			super.dispose();
////			if(_maskTextureVo){
////				_maskTextureVo.useNum--;
////			}
//		}
		
		override public function getBufferNum():int{
			return particleData.hasUnload ? 0 : 2;
		}
		
		
	}
}