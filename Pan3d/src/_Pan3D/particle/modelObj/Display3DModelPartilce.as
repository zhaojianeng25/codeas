package _Pan3D.particle.modelObj
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.batch.IBatch;
	import _Pan3D.display3D.analysis.AnalysisServer;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.ParticleData;
	import _Pan3D.particle.crossFacet.Display3DCrossFacetShader;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DModelPartilce extends Display3DParticle implements IBatch
	{
		protected var _maxAnimTime:int;
		protected var _objUrl:String;
		
		private var _objData:ObjData;
		private var _isComplete:Boolean;
		private var _objScale:Number=1;
		private var _depthMode:int;
		public function Display3DModelPartilce(context:Context3D)
		{
			super(context);
			particleData = new ParticleData;
			this.particleType = 9;
			useTextureColor = false;
		}
		
		public function initData():void{
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
			if(!_objData){
				return;
			}
			var scVertices:Vector.<Number> = new Vector.<Number>;
			for(var i:int;i<_objData.vertices.length;i++){
				scVertices.push(_objData.vertices[i]*_objScale*10);
			}
			
			particleData.vertices = scVertices;
			particleData.uvs = _objData.uvs;
			particleData.indexs = _objData.indexs;
			
			
			pushToGpu();
		}
		
		override public function pushToGpu():void{
			
			particleData.vertexBuffer = this._context3D.createVertexBuffer(particleData.vertices.length / 3, 3);
			particleData.vertexBuffer.uploadFromVector(Vector.<Number>(particleData.vertices), 0, particleData.vertices.length / 3);
			
			particleData.uvBuffer = this._context3D.createVertexBuffer(particleData.uvs.length / 2, 2);
			particleData.uvBuffer.uploadFromVector(Vector.<Number>(particleData.uvs), 0, particleData.uvs.length / 2);
			
			particleData.indexBuffer = this._context3D.createIndexBuffer(particleData.indexs.length);
			particleData.indexBuffer.uploadFromVector(Vector.<uint>(particleData.indexs), 0, particleData.indexs.length);
		}
		
		override protected function setVa() : void {
			_context3D.setVertexBufferAt(0, particleData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, particleData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
//			_context3D.setTextureAt(1, particleData.texture);
			setMaterialTexture();
			_context3D.drawTriangles(particleData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(particleData.indexs.length/3);
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
			_context3D.setVertexBufferAt(0, particleData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, particleData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
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
		}
		
		private var _timeVec:Vector.<Number>;
		private var _resultUvVec:Vector.<Number>;
		private var _colorVec:Vector.<Number>;
		
		override protected function setVc() : void {
			super.setVc();
			this.updateMatrix();
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, modeRotationMatrix, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 24, modeZiZhuanMatrix3D, true);// 传入整个粒子的旋转 
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,13,getResultUV()); //UV移动
			
			setMaterialVc();
			
//			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,getTimeVector());
//			
//			
//			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1,getColor());
//			
//			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,3,_resultUvVec); //UV移动

			
		}
		
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
		
		public function getTimeVector():Vector.<Number>{
			_timeVec[0] = _gpuTime/Scene_data.frameTime/_life;
			_timeVec[1] = _gpuTime/Scene_data.frameTime;
			return _timeVec;
		}
		
		protected  function  get modeRotationMatrix():Matrix3D
		{
			_rotationMatrix.identity();
			if(!_watchEye){
				return _rotationMatrix;
			}
			if(_axisRotaion){
				_rotationMatrix.prependRotation(-_axisRotaion.num,_axisRotaion.axis);
			}
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
			var uPos:Number = _timer/Scene_data.frameTime*_uSpeed;
			var vPos:Number = _timer/Scene_data.frameTime*_vSpeed;
			
			_resultUvVec[0] = uPos;
			_resultUvVec[1] = vPos;
			
			return _resultUvVec;
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
			
		}
		
		public function setDynamicVc():void{
			
		}
		
		override public function getAllInfo():Object{
			var obj:Object = super.getAllInfo();
			obj.maxAnimTime = _maxAnimTime;
			obj.objUrl = _objUrl;
			obj.objScale = _objScale;
			obj.depthMode = _depthMode;
			obj.vecData = getVecData();
			return obj;
		}
		
		public function getVecData():Object{
			var obj:Object = new Object;
			obj.ves = particleData.vertices;
			obj.uvs = particleData.uvs;
			obj.indexs = particleData.indexs;
			return obj;
		}
		
		override public function setAllInfo(obj:Object,isClone:Boolean=false):void{
			this._maxAnimTime = obj.maxAnimTime;
			this._objUrl = obj.objUrl;
			this._objScale = obj.objScale;
			this._depthMode = obj.depthMode;
			if(!isClone){
				this.url = obj.objUrl;
			}
			
			super.setAllInfo(obj,isClone);
			
			_timeVec = Vector.<Number>( [0,0,1,_maxAnimTime]);
			_resultUvVec = Vector.<Number>( [1,1,_uSpeed,_vSpeed]);
			_colorVec = Vector.<Number>( [1,1,1,1]);
			
		}
		
		public function set url(value : String) : void {
			var loaderinfo : LoadInfo = new LoadInfo(Scene_data.fileRoot + value, Scene_data.sourceObj ? LoadInfo.XML:LoadInfo.BYTE, onObjLoad,priority);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		
		protected function onObjLoad(str : *) : void {
			_objData = AnalysisServer.getInstance().analysisObj(str);
			try{
				uplodToGpu();
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw new Error("OBJ有问题：" + _data.objUrl);
				}
			}
			_isComplete = true;
			sourceLoadCom();
		}
		
		override public function update():void{
			if(!particleData.indexBuffer){
				return;
			}
			if(_depthMode){
				_context3D.setDepthTest(true, Context3DCompareMode.LESS);
			}
			super.update();
			if(_depthMode){
				_context3D.setDepthTest(false, Context3DCompareMode.LESS);
			}
		}
		
		override public function updateBatch():void{
			if(!particleData.indexBuffer){
				return;
			}
			if(_depthMode){
				_context3D.setDepthTest(true, Context3DCompareMode.LESS);
			}
			super.updateBatch();
			if(_depthMode){
				_context3D.setDepthTest(false, Context3DCompareMode.LESS);
			}
		}
		
		override public function clone():Display3DParticle{
			var display:Display3DModelPartilce = new Display3DModelPartilce(_context3D);
			display.setProgram3D(this._program);
			display.setAllInfo(_data,true);
			display.particleData = particleData;
			display._textureColor = _textureColor;
			display._textureColorAry = _textureColorAry;
			return display;
		}
		
		override public function get loadNum():int{
			return 2;
		}
		
		override public function reload():void{
			super.reload();
			_program = Program3DManager.getInstance().getProgram(Display3DModelShader.DISPLAY3DMODELSHADER);
			uplodToGpu();
		}
		
		override public function clear():void{
			super.clear();
			_objUrl = null;
			
			_objData = null;
			_timeVec = null;
			_resultUvVec = null;
			_colorVec = null;
			_resultMatrix = null;
		}
		
		
		override public function getBufferNum():int{
			return particleData.hasUnload ? 0 : 2;
		}
		
		override public function regShader():void{
			materialParam.program = Program3DManager.getInstance().getMaterialProgram(Display3DModelShader.DISPLAY3DMODELSHADER,Display3DModelShader,materialParam.material);
		}
		
		
	}
}