package _Pan3D.particle
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DFacetPartilce extends Display3DParticle
	{
		//protected var _closeGround:Boolean;//紧贴地面
		//protected var _gormalsGround:Boolean;//使用地面法线
				
		protected var _bitmapdata:BitmapData;
		protected var _baseMatrix:Matrix3D;
		
		protected var _maxAnimTime:int;
		protected var _lockx:Boolean;
		protected var _locky:Boolean;
		
		protected var _isCycle:Boolean = false;//是否循环
		
		private var _verterBufferVc:Array = new Array;
		
		public static var shareParticleData:ParticleData;
		
		public function Display3DFacetPartilce(context:Context3D)
		{
			super(context);
			particleData = new ParticleConstData;
		}
		
		override protected function uplodToGpu() : void {
			_verterBufferVc = makeRectangleData(this._width,this._height,this._originWidthScale,this._originHeightScale,_isUV,_isU,_isV,_animLine,_animRow);
			particleData.vertexBuffer = shareParticleData.vertexBuffer;
			particleData.indexBuffer = shareParticleData.indexBuffer;
		}
		
		/**
		 * 初始化共用buffer 
		 * 
		 */		
		public static function initBuffer():void{
			shareParticleData = new ParticleConstData();
			
			var vertices:Vector.<Number> = shareParticleData.vertices = new Vector.<Number>;
			vertices.push(30,34,31,35,32,36,33,37);
			
			var indexs:Vector.<uint> = shareParticleData.indexs = new Vector.<uint>;
			indexs.push(0,1,2,0,2,3);
			
			shareParticleData.vertexBuffer = Scene_data.context3D.createVertexBuffer(vertices.length / 2, 2);
			shareParticleData.vertexBuffer.uploadFromVector(Vector.<Number>(vertices), 0, vertices.length / 2);
			
			
			shareParticleData.indexBuffer = Scene_data.context3D.createIndexBuffer(indexs.length);
			shareParticleData.indexBuffer.uploadFromVector(Vector.<uint>(indexs), 0, indexs.length);
		}
		
		
		
		public function makeRectangleData(width:Number,height:Number,offsetX:Number=0.5,offsetY:Number=0.5,isUV:Boolean=false,isU:Boolean=false,isV:Boolean=false,animLine:int=1,animRow:int=1):Array{
			
			var uvAry:Array = new Array;
			var verterList:Array = new Array;
			
			
			verterList.push(Vector.<Number>([-offsetX*width,height-offsetY*height,0,1]));
			verterList.push(Vector.<Number>([width-offsetX*width,height-offsetY*height,0,1])); 
			verterList.push(Vector.<Number>([width-offsetX*width,-offsetY*height,0,1]));
			verterList.push(Vector.<Number>([-offsetX*width,-offsetY*height,0,1]));
			
			var ary:Array = new Array;
			ary.push(new Point(0,0));
			ary.push(new Point(0,1/animRow));
			ary.push(new Point(1/animLine,1/animRow));
			ary.push(new Point(1/animLine,0));
			
			if(isU){
				for(var i:int=0;i<ary.length;i++){
					ary[i].x = - ary[i].x;
				}
			}
			
			if(isV){
				for(i=0;i<ary.length;i++){
					ary[i].y = - ary[i].y;
				}
			}
			
			if(isUV){
				ary.push(ary.shift());
			}
			
			for(i=0;i<ary.length;i++){
				verterList.push(Vector.<Number>([ary[i].x,ary[i].y,0,0]));
			}
			
			return verterList;
			
		}
		
		override protected function setVa() : void {
			_context3D.setVertexBufferAt(0, particleData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			//_context3D.setTextureAt(1, particleData.texture);
			this.setMaterialTexture();
			_context3D.drawTriangles(particleData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
		}
		
		override protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
//			_context3D.setTextureAt(1,null);
//			_context3D.setTextureAt(2,null);
			resetMaterialTexture();
		}
		
		override protected function setVaBatch() : void {
			_context3D.setVertexBufferAt(0, particleData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context3D.drawTriangles(particleData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			if(particleData.indexs){
				Scene_data.drawTriangle += int(particleData.indexs.length/3);
			}else{
			}
		}
		
		override protected function resetVaBatch() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setTextureAt(2,null);
		}
		private var _timeVec:Vector.<Number>;
		private var _resultUvVec:Vector.<Number>;
		private var _colorVec:Vector.<Number>;
		private var _colorVecNews:Vector.<Number> = Vector.<Number>([1,1,1,1]);
		override protected function setVc() : void {
			this.updateMatrix();
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, modeRotationMatrix, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 24, modeZiZhuanMatrix3D, true);// 传入整个粒子的旋转 
			
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,12,getTimeVector()); 
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,13,getResultUV()); //UV移动
			
			for(var i:int;i<_verterBufferVc.length;i++){
				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,30 + i,_verterBufferVc[i]); //顶点数据
			}
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1,getColor());
			
			setMaterialVc();
			
			if(!_isCycle && _timer/Scene_data.frameTime > (_life-2)){
				this.visible = false;
			}
			
		}
		
		public function getTimeVector():Vector.<Number>{
			_timeVec[0] = _gpuTime/Scene_data.frameTime/_life;
			_timeVec[1] = int(_gpuTime/Scene_data.frameTime);
			return _timeVec;
		}
		public function getResultColor():Vector.<Number>{
			if(_colorChange){
				_colorVec[0] = 1+_colorChange.rValue*_colorChange.num;
				_colorVec[1] = 1+_colorChange.gValue*_colorChange.num;
				_colorVec[2] = 1+_colorChange.bValue*_colorChange.num;
				_colorVec[3] = (1+_colorChange.aValue*_colorChange.num) * _alpha;
			}else{
				_colorVec[3] = _alpha;
			}
			return _colorVec;
		}
		
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
			
			var currentFrame:int = _gpuTime/Scene_data.frameTime;
			currentFrame = currentFrame > _maxAnimTime ? _maxAnimTime : currentFrame;
			currentFrame = (currentFrame/_animInterval)%(_animLine*_animRow);
			
			_resultUvVec[0] = int(currentFrame%_animLine)/_animLine + _gpuTime/Scene_data.frameTime*_uSpeed;
			_resultUvVec[1] = int(currentFrame/_animLine)/_animRow + _gpuTime/Scene_data.frameTime*_vSpeed;
			
			return _resultUvVec;
		}
		public function getColor():Vector.<Number>{
			if(!_textureColorAry){
				return Vector.<Number>([1,1,1,1]);
			}
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
		
		public  function  get modeRotationMatrix():Matrix3D
		{
			_rotationMatrix.identity();
			if(!_watchEye){
				return _rotationMatrix;
			}
			if(_axisRotaion){
				_rotationMatrix.prependRotation(-_axisRotaion.num,_axisRotaion.axis);
			}
			
			if(!_locky && !_lockx){
				inverBind();
			}
			
			if(!_locky){
				_rotationMatrix.prependRotation(-Scene_data.cam3D.angle_y , Vector3D.Y_AXIS);
			}
			if(!_lockx){
				_rotationMatrix.prependRotation(-Scene_data.cam3D.angle_x , Vector3D.X_AXIS);
			}
			
			
			return _rotationMatrix;
		}
		
		public function get modeZiZhuanMatrix3D():Matrix3D
		{
			_rotationMatrix.identity();
			if(_ziZhuanAngly.x==_ziZhuanAngly.y&&_ziZhuanAngly.y==_ziZhuanAngly.z&&_ziZhuanAngly.z==0){
				
			}else{
				if(_selfRotaion){
					_rotationMatrix.prependRotation(_selfRotaion.num,_ziZhuanAngly);
				}
			}
			//if(_scaleChange)
			//	_rotationMatrix.prependScale(_widthFixed?1:_scaleChange.num,_heightFixed?1:_scaleChange.num,_scaleChange.num);
	
			return _rotationMatrix;
		}
		
		
		//override protected function processScale():void{
			
		//}
		
		public function setDynamicVc():void{
			
		}
		
		override public function getAllInfo():Object{
			var obj:Object = super.getAllInfo();
			obj.maxAnimTime = _maxAnimTime;
			obj.isCycle = _isCycle;
			obj.lockx = _lockx;
			obj.locky = _locky;
			return obj;
		}
		
		override public function setAllInfo(obj:Object,isClone:Boolean=false):void{
			this._maxAnimTime = obj.maxAnimTime;
			
			if(obj.hasOwnProperty("isCycle")){
				this._isCycle = obj.isCycle;
			}
			
			this._lockx = obj.lockx;
			this._locky = obj.locky;
			
			super.setAllInfo(obj,isClone);
			
			_timeVec = Vector.<Number>( [0,0,_animInterval,_maxAnimTime]);
			_resultUvVec = Vector.<Number>( [ _animLine,_animRow,_uSpeed,_vSpeed ]);
			_colorVec = Vector.<Number>( [1,1,1,1]);
			
			uplodToGpu();
		}
		
		
		override public function clone():Display3DParticle{
			var display:Display3DFacetPartilce = new Display3DFacetPartilce(_context3D);
			display.setProgram3D(this._program);
			display.setAllInfo(_data,true);
			display.particleData = particleData;
			display._verterBufferVc = _verterBufferVc;
			display._textureColor = _textureColor;
			display._textureColorAry = _textureColorAry;
			return display;
		}
		
		override public function reload():void{
			super.reload();
			_program = Program3DManager.getInstance().getProgram(Display3DPartilceShader.DISPLAY3DPARTILCESHADER);
			uplodToGpu();
		}
		override public function getBufferNum():int{
			return 0;
		}
		
		override public function unloadBuffer():void{
			return;
		}
		
		override public function uploadBuffer():void{
			return;
			
		}
		
		override public function regShader():void{
			materialParam.program = Program3DManager.getInstance().getMaterialProgram(Display3DPartilceShader.DISPLAY3DPARTILCESHADER,Display3DPartilceShader,materialParam.material);
		}
		
		override public function dispose():void{
			super.dispose();
			
			 _bitmapdata = null;
			_baseMatrix = null;
			
			_verterBufferVc = null;
			
		}
		
		override public function clear():void{
			super.clear();
			
			_timeVec = null;
			_resultUvVec = null;
			_colorVec = null;
			
			_bitmapdata = null;
			_baseMatrix = null;
			
			_verterBufferVc = null;
		}
		
	}
}