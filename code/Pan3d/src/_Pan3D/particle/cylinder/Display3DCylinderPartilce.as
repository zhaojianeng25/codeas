package _Pan3D.particle.cylinder
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.Display3DPartilceShader;
	import _Pan3D.particle.ParticleData;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DCylinderPartilce extends Display3DParticle
	{
		protected var _fenduanshu:uint;//分段数
		protected var _tiltAngle:Number;//倾斜角度
		protected var _isCenter:Boolean;
		
		public function Display3DCylinderPartilce(context:Context3D)
		{
			super(context);
			particleData = new ParticleData;
			this._particleType = 4;
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
			
			makeRectangleDataNew(this._width,this._height,_animLine,_animRow);
			
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
		private function makeRectangleDataNew(width:Number,height:Number,animLine:int=1,animRow:int=1):void{
			var testAngle:Number = Math.atan(width/height)*180/Math.PI;
			if(_tiltAngle < -testAngle){
				_tiltAngle = -testAngle;
			}else if(_tiltAngle > testAngle){
				_tiltAngle = testAngle;
			}
			
			var upR:Number;
			var downR:Number;
			var addR:Number = height/2*Math.tan(_tiltAngle*Math.PI/180);
			upR = width/2 - addR;
			downR = width/2 + addR;
			
			var vItem:Array=new Array;
			
			var uvAry:Vector.<Number> = particleData.uvs = new Vector.<Number>;
			var indexAry:Vector.<uint> = particleData.indexs = new Vector.<uint>;
			var verterList:Vector.<Number> = particleData.vertices = new Vector.<Number>;
			var vadataList:Vector.<Number> = particleData.vaData = new Vector.<Number>;
			
			for(var k:int=0;k<_fenduanshu+1;k++)
			{
				var angle:Number = 2 * Math.PI / _fenduanshu * k;
				var xpos:Number = Math.cos(angle);
				var zpos:Number = Math.sin(angle);
				if(_isCenter){
					vItem.push(new Vector3D(xpos*upR,height/2,zpos*upR,upR));
					vItem.push(new Vector3D(xpos*downR,-height/2,zpos*downR,downR));
				}else{
					vItem.push(new Vector3D(xpos*upR,height,zpos*upR,upR))
					vItem.push(new Vector3D(xpos*downR,0,zpos*downR,downR))
				}
			}
			
			for(var i:int=0;i<vItem.length;i++){
				verterList.push(vItem[i].x,vItem[i].y,vItem[i].z);
				var point:Point = new Point(int(i/2)/int(vItem.length/2-1)/1,i%2/1==0?0.01:0.99)
				if(_isU){
					point.x = -point.x;
				}
				if(_isV){
					point.y = -point.y;
				}
				
				if(_isUV){
					uvAry.push(point.y,point.x);
				}else{
					uvAry.push(point.x,point.y);
				}
				
				vadataList.push(vItem[i].w);
			}
			
			for(var j:int=0;j<(vItem.length/2-1);j++){
				var num:int=j*2
				indexAry.push(0+num,1+num,2+num,2+num,1+num,3+num);
			}
			
		}
		override protected function setVa() : void {
			_context3D.setVertexBufferAt(0, particleData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, particleData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			this.setMaterialTexture();
			//_context3D.setTextureAt(1, particleData.texture);
			_context3D.drawTriangles(particleData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(particleData.indexs.length/3);
		}
		
		override protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
//			_context3D.setTextureAt(1,null);
//			_context3D.setTextureAt(2,null);
			resetMaterialTexture();
		}
		
		override protected function setVaBatch() : void {
			_context3D.setVertexBufferAt(0, particleData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, particleData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
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
			_context3D.setTextureAt(2,null);
		}
		private var _resultUvVec:Vector.<Number>;
		override protected function setVc() : void {
			this.updateMatrix();
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, modeRotationMatrix, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 24, modeZiZhuanMatrix3D, true);// 传入整个粒子的旋转 
			
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>( [_gpuTime/Scene_data.frameTime/_life,_gpuTime/Scene_data.frameTime,0,1])); 
			
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1,getColor());
			
//			if(_scaleChange && _scaleNosie){
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,16,Vector.<Number>( [_widthFixed?1:(_scaleChange.num + _scaleNosie.num),_heightFixed?1:(_scaleChange.num + _scaleNosie.num),1,1])); 
//			}else 
				
//			if(_scaleChange){
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,16,Vector.<Number>( [_widthFixed?1:_scaleChange.num,_heightFixed?1:_scaleChange.num,1,1])); 
//			}else if(_scaleNosie){
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,16,Vector.<Number>( [_widthFixed?1:(this._scale + _scaleNosie.num),_heightFixed?1:(this._scale + _scaleNosie.num),1,1])); 
//			}else{
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,16,Vector.<Number>( [1,1,1,1])); 
//			}
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,17,getResultUV()); 
			
			setMaterialVc();
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,3,Vector.<Number>( [ _animLine,_animRow,_uSpeed,_vSpeed ])); //UV移动
			
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
		
//		override protected function processScale():void{
//			//posMatrix.prependScale(_widthFixed?1:_scaleChange.num,_heightFixed?1:_scaleChange.num,_scaleChange.num);
//		}
//		override protected function processNosie():void{
//			
//		}
		
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
		
		public function setDynamicVc():void{
			
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, baseColor); 
		}
		
		override public function getAllInfo():Object{
			var obj:Object = super.getAllInfo();
			//obj.closeGround = _closeGround;//紧贴地面
			//obj.gormalsGround = _gormalsGround;//使用地面法线
			obj.fenduanshu = _fenduanshu;//使用分段数
			obj.qingxiejiaodu = _tiltAngle;//使用分段数
			obj.isCenter = _isCenter;
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
			this._fenduanshu = obj.fenduanshu;
			this._tiltAngle = obj.qingxiejiaodu;
			this._isCenter = obj.isCenter;
			_colorVec = Vector.<Number>( [1,1,1,1]);
			_resultUvVec = Vector.<Number>( [ _animLine,_animRow,_uSpeed,_vSpeed ]);
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
		
		override public function clone():Display3DParticle{
			var display:Display3DCylinderPartilce = new Display3DCylinderPartilce(_context3D);
			display.setProgram3D(this._program);
			display.setAllInfo(_data,true);
			display.particleData = particleData;
			display._textureColor = _textureColor;
			display._textureColorAry = _textureColorAry;
			return display;
		}
		
		override public function clear():void{
			//_bitmapdata = null;
			//_baseMatrix = null;
			super.clear();
			_colorVec = null;
			_resultMatrix = null;
		}
		
		override public function reload():void{
			super.reload();
			_program = Program3DManager.getInstance().getProgram(Display3DCylinderShader.DISPLAY3DCYLINDERSHADER);
			pushToGpu();
		}
		
		override public function getBufferNum():int{
			return particleData.hasUnload ? 0 : 2;
		}
		
		override public function regShader():void{
			materialParam.program = Program3DManager.getInstance().getMaterialProgram(Display3DCylinderShader.DISPLAY3DCYLINDERSHADER,Display3DCylinderShader,materialParam.material);
		}
		
		
		
	}
}