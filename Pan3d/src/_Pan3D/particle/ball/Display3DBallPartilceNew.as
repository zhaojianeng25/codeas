package _Pan3D.particle.ball
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.Quaternion;
	import _Pan3D.particle.Display3DEllipsoidParticle;
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;


	public class Display3DBallPartilceNew extends Display3DEllipsoidParticle
	{
		protected var _islixinAngly:Boolean;
		protected var _particleRandomScale:Vector3D;
		protected var _playSpeed:Number = 1;
		
		
		protected var _needRandomColor:Boolean;
		protected var _needSelfRotation:Boolean;
		
		protected var _beginScale:Number = 0;
		
		public var facez:Boolean;
		
		protected var _allRotationMatrix:Matrix3D;
		
		public function Display3DBallPartilceNew(context:Context3D)
		{
			super(context);
			_particleData = new GpuTuoQiuData;
			_particleType = 18;
			_allRotationMatrix = new Matrix3D;
		}
		override protected function setVa() : void {
			if(Scene_data.compressBuffer){
				_context3D.setVertexBufferAt(0, gpuTuoQiuData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(1, gpuTuoQiuData.vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_4);
				_context3D.setVertexBufferAt(2, gpuTuoQiuData.vertexBuffer, 7, Context3DVertexBufferFormat.FLOAT_4);
				_context3D.setVertexBufferAt(3, gpuTuoQiuData.vertexBuffer, 11, Context3DVertexBufferFormat.FLOAT_4);
				
			}else{
				_context3D.setVertexBufferAt(0, gpuTuoQiuData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(1, gpuTuoQiuData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
				_context3D.setVertexBufferAt(2, gpuTuoQiuData.basePosBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
				_context3D.setVertexBufferAt(3, gpuTuoQiuData.beMoveBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			
				if (this._needSelfRotation && !_is3Dlizi)
				{
					_context3D.setVertexBufferAt(5, gpuTuoQiuData.baseRotationBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				}
			}
			
			this.setMaterialTexture();
			//_context3D.setTextureAt(1, particleData.texture);
			//_context3D.setTextureAt(0, _textureColor);
			_context3D.drawTriangles(gpuTuoQiuData.indexBuffer, 0, -1);
			
		}
		
		protected function getIndexVcId(_num:uint):uint
		{
			return 28+_num
		}
		override protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setVertexBufferAt(3, null);
			_context3D.setVertexBufferAt(4, null);
			_context3D.setVertexBufferAt(5, null);
			_context3D.setTextureAt(0,null);
			_context3D.setTextureAt(1,null);
			_context3D.setTextureAt(2,null);
		}
		
		override protected function setVaBatch() : void {
			if(Scene_data.compressBuffer){
				_context3D.setVertexBufferAt(0, gpuTuoQiuData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(1, gpuTuoQiuData.vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_4);
				_context3D.setVertexBufferAt(2, gpuTuoQiuData.vertexBuffer, 7, Context3DVertexBufferFormat.FLOAT_4);
				_context3D.setVertexBufferAt(3, gpuTuoQiuData.vertexBuffer, 11, Context3DVertexBufferFormat.FLOAT_4);
				
			}else{
				_context3D.setVertexBufferAt(0, gpuTuoQiuData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(1, gpuTuoQiuData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
				_context3D.setVertexBufferAt(2, gpuTuoQiuData.basePosBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
				_context3D.setVertexBufferAt(3, gpuTuoQiuData.beMoveBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
		
				if (this._needSelfRotation && !_is3Dlizi)
				{
					_context3D.setVertexBufferAt(5, gpuTuoQiuData.baseRotationBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				}
			}
			
			_context3D.setTextureAt(0, _textureColor);
			_context3D.drawTriangles(gpuTuoQiuData.indexBuffer, 0, -1);
		}
		override protected function resetVaBatch() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setVertexBufferAt(3, null);
			_context3D.setVertexBufferAt(4, null);
			_context3D.setVertexBufferAt(5, null);
			_context3D.setTextureAt(0,null);
		}
		
		protected var _vc4:Vector.<Number> = Vector.<Number>( [1,2,3,4]);
		protected var _vc13:Vector.<Number> = Vector.<Number>( [100000,0,0,1]);
		protected var _vc5:Vector.<Number> = Vector.<Number>( [16,12,0,0.5]);
		protected var _fc1:Vector.<Number> = Vector.<Number>([8,12*16,0.02,0.02]);
		override protected function setVc() : void {
			
			this.updateMatrix();
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,12, getTimeVector());   
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,8, _vc5);   
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,9, _heightFixedVec);
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,10, _resultUvVec);
			
			_vc13[2] = _acceleration;
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,13, _vc13);   
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,14, _addForceVec); 
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,15, _restrictScaleVec);
			
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,16, getModeRotationMatrix(), true);
			
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,20, _allRotationMatrix, true);
			
			this.setBindPosVc();
			
			var tempv3d:Vector3D = new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z);
			//tempv3d.normalize();
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,11, Vector.<Number>([tempv3d.x,tempv3d.y,tempv3d.z,_beginScale]));
			
			setMaterialVc();
			
			
		}
		
		public function setBindPosVc():void{
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,24, Vector.<Number>([bindVecter3d.x,bindVecter3d.y,bindVecter3d.z,0]));
		}
		
		override public function updateMatrix():void{
			_allRotationMatrix.identity();
			
			_allRotationMatrix.prependScale(overAllScale*_scaleX*0.1,overAllScale*_scaleY*0.1,overAllScale*_scaleZ*0.1);
			
			if(_axisRotaion){
				_allRotationMatrix.appendRotation(_axisRotaion.num,_axisRotaion.axis,_axisRotaion.axisPos);
			}

			if(isInGroup){
				_allRotationMatrix.appendRotation(groupRotation.x , Vector3D.X_AXIS);
				_allRotationMatrix.appendRotation(groupRotation.y , Vector3D.Y_AXIS); 
				_allRotationMatrix.appendRotation(groupRotation.z , Vector3D.Z_AXIS);
			}
			

			_allRotationMatrix.append(bindMatrix);
			
			super.updateMatrix();
			
		}
		
		

		override protected function processScaleAnim():void{
			if(_scaleAnim.num != 0)
				posMatrix.prependScale(_scaleAnim.num,_scaleAnim.num,_scaleAnim.num);
		}

/***********显卡数据创建阶段*********************************************************/
		
		override protected function uplodToGpu() : void {
			
			initBaseData();
			initBasePos();
			initSpeed();
			initBaseColor();
			initSelfRotaion();
			
			if(Scene_data.compressBuffer){
				compressBuffer();
			}
			
			pushToGpu();
			
		}
		
		private function initBaseData():void{
			var verterList:Vector.<Number> = new Vector.<Number>;
			var uvAry:Vector.<Number> = new Vector.<Number>; 
			var indexs:Vector.<uint> = new Vector.<uint>;
			for(var i:int=0;i<_totalNum;i++){
				makeRectangleData(verterList,uvAry,_width,_height,_originWidthScale,_originHeightScale,_isUV,_isU,_isV,_animLine,_animRow,i);
				indexs.push(0 + i * 4,1 + i * 4,2 + i * 4,0 + i * 4,2 + i * 4,3 + i * 4);
			}
			gpuTuoQiuData.vertices = verterList;
			gpuTuoQiuData.uvs = uvAry;
			gpuTuoQiuData.indexs = indexs;
		}
		
		public function initBaseColor():void{
	
			

			
		}
		
		public function initSelfRotaion() : void
		{
			var _baseRotationAngle:Number = 0;
			var _baseRotationSpeed:Number = 0;
			if (_ziZhuanAngly.x == 0 && _ziZhuanAngly.y == 0 && _ziZhuanAngly.z == 0 && _ziZhuanAngly.w == 0)
			{
				this._needSelfRotation = false;
				return;
			}
			this._needSelfRotation = true;
			var vecs:Vector.<Number> = new Vector.<Number>;
			var flag:int = 0;
			while (flag < _totalNum)
			{
				
				_baseRotationAngle = _ziZhuanAngly.x;
				if (_ziZhuanAngly.y == 1)
				{
					_baseRotationAngle = _baseRotationAngle * Math.random();
				}
				_baseRotationSpeed = _ziZhuanAngly.z;
				if (_ziZhuanAngly.w == 1)
				{
					_baseRotationSpeed = _baseRotationSpeed * Math.random();
				}
				else if (_ziZhuanAngly.w == -1)
				{
					_baseRotationSpeed = _baseRotationSpeed * (Math.random() * 2 - 1);
				}
				vecs.push(_baseRotationAngle, _baseRotationSpeed);
				vecs.push(_baseRotationAngle, _baseRotationSpeed);
				vecs.push(_baseRotationAngle, _baseRotationSpeed);
				vecs.push(_baseRotationAngle, _baseRotationSpeed);
				flag++;
			}
			this.gpuTuoQiuData.baseRotation = vecs;
		}// end function
		
		public function initBasePos():void{
			var basePos:Vector.<Number> = new Vector.<Number>;
			
			for(var i:int=0;i<_totalNum;i++){
				var v3d:Vector3D;
				var ma:Matrix3D;
				if(_isRandom){
					var roundv3d:Vector3D = new Vector3D(_round.x*_round.w,_round.y*_round.w,_round.z*_round.w);
					if(_isEven){//圆柱
						if(_closeSurface){//紧贴表面
							v3d = new Vector3D(0,0,roundv3d.z);
							ma = new Matrix3D;
							ma.appendRotation(Math.random() * 360,Vector3D.Y_AXIS);
							v3d = ma.transformVector(v3d);
							v3d.y = roundv3d.y * Math.random() * 2 - roundv3d.y;
						}else{
							v3d = new Vector3D(0,0,roundv3d.z * Math.random() * 2 - roundv3d.z);
							ma = new Matrix3D;
							ma.appendRotation(Math.random() * 360,Vector3D.Y_AXIS);
							v3d = ma.transformVector(v3d);
							v3d.y = roundv3d.y * Math.random() * 2 - roundv3d.y;
						}
						
					}else{//圆球
						if(_closeSurface){//只有xyz相等时候才能紧贴表面
							v3d = new Vector3D(0,0,roundv3d.z);
							ma = new Matrix3D;
							
							if(_halfCircle){
								ma.appendRotation(- Math.random() * 180,Vector3D.X_AXIS);
							}else{
								ma.appendRotation(Math.random() * 360,Vector3D.X_AXIS);
							}
							
							ma.appendRotation(Math.random() * 360,Vector3D.Y_AXIS);
							v3d = ma.transformVector(v3d);
						}else{
							if(_halfCircle){
								v3d = new Vector3D(roundv3d.x * Math.random() * 2 - roundv3d.x,roundv3d.y * Math.random(),roundv3d.z * Math.random() * 2 - roundv3d.z);
							}else{
								v3d = new Vector3D(roundv3d.x * Math.random() * 2 - roundv3d.x,roundv3d.y * Math.random() * 2 - roundv3d.y,roundv3d.z * Math.random() * 2 - roundv3d.z);
							}
							
						}
					}
					
					
				}else{
					v3d = new Vector3D();
				}
				
				v3d = v3d.add(_basePositon);
				
				for(var j:int=0;j<4;j++){
					basePos.push(v3d.x,v3d.y,v3d.z,i*_shootSpeed);
				}
			}
			
			gpuTuoQiuData.basePos = basePos;
		}
		
		public function initSpeed():void{
			var beMove:Vector.<Number> = new Vector.<Number>;
			
			for(var i:int=0;i<_totalNum;i++){
				
				var resultv3d:Vector3D = new Vector3D;
				var v3d:Vector3D = new Vector3D;
				
				if(_shootAngly.x != 0 || _shootAngly.y != 0 || _shootAngly.z != 0){//锥形速度
					var r:Number = Math.tan(_shootAngly.w * Math.PI /180 * Math.random());
					var a:Number = 360 * Math.PI /180 * Math.random();
					v3d = new Vector3D(Math.sin(a) * r,Math.cos(a) * r,1);
					var ma:Matrix3D = moveMatrix3D(new Vector3D(0.0000001,0.0000001,1),new Vector3D(_shootAngly.x + 0.0000001,_shootAngly.y + 0.0000001,_shootAngly.z + 0.0000001));
					v3d = ma.transformVector(v3d);
					v3d.normalize();
					resultv3d = resultv3d.add(v3d);
				}
				
				if(_lixinForce.x != 0 || _lixinForce.y != 0 || _lixinForce.z != 0){
					v3d = new Vector3D(Math.random() > 0.5 ? -_lixinForce.x:_lixinForce.x,Math.random() > 0.5 ? -_lixinForce.y:_lixinForce.y,Math.random() > 0.5 ? -_lixinForce.z:_lixinForce.z);
					v3d.normalize();
					resultv3d = resultv3d.add(v3d);
				}
				
				if(_islixinAngly){
					if(_isEven){
						v3d = new Vector3D(gpuTuoQiuData.basePos[i*16],0,gpuTuoQiuData.basePos[i*16 + 2]);
					}else{
						v3d = new Vector3D(gpuTuoQiuData.basePos[i*16],gpuTuoQiuData.basePos[i*16 + 1],gpuTuoQiuData.basePos[i*16 + 2]);
					}
					
					v3d.normalize();
					resultv3d = resultv3d.add(v3d);
				}
				
				resultv3d.normalize();
				
				
				if(_isSendRandom){
					resultv3d.scaleBy(_speed * Math.random());
				}else{
					resultv3d.scaleBy(_speed);
				}
				
				var ranAngle:Number = _baseRandomAngle * Math.random() * Math.PI / 180;
				
				for(var j:int=0;j<4;j++){
					beMove.push(resultv3d.x,resultv3d.y,resultv3d.z,ranAngle);
				}
			}
			
			gpuTuoQiuData.beMove = beMove;
		}
		
		private function moveMatrix3D($basePos:Vector3D,$newPos:Vector3D):Matrix3D{
			var $ma:Matrix3D=new Matrix3D;
			var $mb:Matrix3D=new Matrix3D;
			$ma.pointAt($basePos,Vector3D.X_AXIS, Vector3D.Y_AXIS);
			$mb.pointAt($newPos,Vector3D.X_AXIS, Vector3D.Y_AXIS);
			$ma.append($mb);
			
			$basePos.normalize();
			$newPos.normalize();
			
			var axis:Vector3D = $basePos.crossProduct($newPos);
			axis.normalize();
			var angle:Number = Math.acos($basePos.dotProduct($newPos));
			var q:Quaternion = new Quaternion();
			q.fromAxisAngle(axis,angle);
			return q.toMatrix3D();
			
			//return $ma;
		}
		
		public function makeRectangleData(verterList:Vector.<Number>,uvAry:Vector.<Number>,width:Number,height:Number,offsetX:Number=0.5,offsetY:Number=0.5,
										  isUV:Boolean=false,isU:Boolean=false,isV:Boolean=false,
										  animLine:int=1,animRow:int=1,indexid:int=0):void{
			var ranScale:Number = Math.random() * (_particleRandomScale.x - _particleRandomScale.y) + _particleRandomScale.y;
			
			verterList.push((-offsetX*width)*ranScale,(height-offsetY*height)*ranScale,0);
			verterList.push((width-offsetX*width)*ranScale,(height-offsetY*height)*ranScale,0);
			verterList.push((width-offsetX*width)*ranScale,(-offsetY*height)*ranScale,0);
			verterList.push((-offsetX*width)*ranScale,(-offsetY*height)*ranScale,0);
			
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
			var ran:Number = Math.random();
			for(i=0;i<ary.length;i++){
				uvAry.push(ary[i].x,ary[i].y,ran,getIndexVcId(indexid));
			}
			
		}

/***********end显卡数据创建完成*********************************************************/
		
		/**
		 * 装载数据到显卡 
		 * 
		 */	
		
		public function compressBuffer():void{
			var vertices:Vector.<Number> = new Vector.<Number>;
			
			for(var i:int=0;i<_totalNum*4;i++){
				vertices.push(gpuTuoQiuData.vertices[i * 3],gpuTuoQiuData.vertices[i * 3 + 1],gpuTuoQiuData.vertices[i * 3 + 2]);
				vertices.push(gpuTuoQiuData.uvs[i * 4],gpuTuoQiuData.uvs[i * 4 + 1],gpuTuoQiuData.uvs[i * 4 + 2],gpuTuoQiuData.uvs[i * 4 + 3]);
				vertices.push(gpuTuoQiuData.basePos[i * 4],gpuTuoQiuData.basePos[i * 4 + 1],gpuTuoQiuData.basePos[i * 4 + 2],gpuTuoQiuData.basePos[i * 4 + 3]);
				vertices.push(gpuTuoQiuData.beMove[i * 4],gpuTuoQiuData.beMove[i * 4 + 1],gpuTuoQiuData.beMove[i * 4 + 2],gpuTuoQiuData.beMove[i * 4 + 3]);
			}
			
			gpuTuoQiuData.vertices = vertices;
		}
		
		override public function pushToGpu() : void {
			
			if(Scene_data.compressBuffer){
				gpuTuoQiuData.vertexBuffer =_context3D.createVertexBuffer(gpuTuoQiuData.vertices.length/ 15, 15);
				gpuTuoQiuData.vertexBuffer.uploadFromVector(Vector.<Number>(gpuTuoQiuData.vertices), 0, gpuTuoQiuData.vertices.length / 15);
			}else{
				gpuTuoQiuData.vertexBuffer =_context3D.createVertexBuffer(gpuTuoQiuData.vertices.length/ 3, 3);
				gpuTuoQiuData.vertexBuffer.uploadFromVector(Vector.<Number>(gpuTuoQiuData.vertices), 0, gpuTuoQiuData.vertices.length / 3);
				
				gpuTuoQiuData.basePosBuffer =_context3D.createVertexBuffer(gpuTuoQiuData.basePos.length/ 4, 4);
				gpuTuoQiuData.basePosBuffer.uploadFromVector(Vector.<Number>(gpuTuoQiuData.basePos), 0, gpuTuoQiuData.basePos.length / 4);
				
				gpuTuoQiuData.beMoveBuffer =_context3D.createVertexBuffer(gpuTuoQiuData.beMove.length/ 4, 4);
				gpuTuoQiuData.beMoveBuffer.uploadFromVector(Vector.<Number>(gpuTuoQiuData.beMove), 0, gpuTuoQiuData.beMove.length / 4);
				
				gpuTuoQiuData.uvBuffer =_context3D.createVertexBuffer(gpuTuoQiuData.uvs.length/ 4, 4);
				gpuTuoQiuData.uvBuffer.uploadFromVector(Vector.<Number>(gpuTuoQiuData.uvs), 0, gpuTuoQiuData.uvs.length / 4);
				
	
				
				if (this._needSelfRotation){
					this.gpuTuoQiuData.baseRotationBuffer = _context3D.createVertexBuffer(this.gpuTuoQiuData.baseRotation.length / 2, 2);
					this.gpuTuoQiuData.baseRotationBuffer.uploadFromVector(Vector.<Number>(this.gpuTuoQiuData.baseRotation), 0, this.gpuTuoQiuData.baseRotation.length / 2);
				}
				
			}
			
			gpuTuoQiuData.indexBuffer =_context3D.createIndexBuffer(gpuTuoQiuData.indexs.length);
			gpuTuoQiuData.indexBuffer.uploadFromVector(Vector.<uint>(gpuTuoQiuData.indexs), 0, gpuTuoQiuData.indexs.length);
		}

		override public function clone():Display3DParticle{
			var display:Display3DBallPartilceNew = new Display3DBallPartilceNew(_context3D);
			display.setProgram3D(this._program);
			display.setAllInfo(_data,true);
			display.particleData = particleData;
			display._textureColor = _textureColor;
			return display;
		}
		
		override public function reload():void{
			super.reload();
			_program = Program3DManager.getInstance().getProgram(Display3DBallNewShader.Display3DBallNewShader);	
			pushToGpu();
			
		}
		
		public function get gpuTuoQiuData():GpuTuoQiuData{
			return GpuTuoQiuData(_particleData);
		}
		public function getModeRotationMatrix():Matrix3D
		{
			_rotationMatrix.identity();
			
			if (this.facez)
			{
				_rotationMatrix.prependRotation(90, Vector3D.X_AXIS);
			}else if(_is3Dlizi){
				if(_axisRotaion){
					_rotationMatrix.prependRotation(-_axisRotaion.num,_axisRotaion.axis);
				}
				inverBind();
			}else if(_watchEye){
				if(_axisRotaion){
					_rotationMatrix.prependRotation(-_axisRotaion.num,_axisRotaion.axis);
				}
				inverBind();
				
				if(!_lockY){
					_rotationMatrix.prependRotation(-Scene_data.cam3D.angle_y , Vector3D.Y_AXIS);
				}
				if(!_lockX){
					_rotationMatrix.prependRotation(-Scene_data.cam3D.angle_x , Vector3D.X_AXIS);
				}

			}
			
			return _rotationMatrix;
		}
		protected var _linxinForceVec:Vector.<Number>;
		protected var _addForceVec:Vector.<Number>;
		protected var _heightFixedVec:Vector.<Number>;
		protected var _timeVec:Vector.<Number>;
		protected var _resultUvVec:Vector.<Number>;
		protected var _colorVec:Vector.<Number>;
		protected var _restrictScaleVec:Vector.<Number>;
		override public function setAllInfo(obj:Object, isClone:Boolean=false):void{
			_islixinAngly = obj.islixinAngly;
			
			_particleRandomScale = getVector3DByObject(obj.particleRandomScale);
			if(!_particleRandomScale){
				_particleRandomScale = new Vector3D(1,1,0);
			}
			
			_playSpeed = obj.playSpeed;
			facez = obj.facez;
			_beginScale = obj.beginScale;
			
			super.setAllInfo(obj,isClone);
			
			_linxinForceVec = Vector.<Number>( [_lixinForce.x,_lixinForce.y,_lixinForce.z,_lixinForce.w]);
			_addForceVec = Vector.<Number>( [_addforce.x * _addforce.w,_addforce.y*_addforce.w,_addforce.z*_addforce.w,2]);
			_heightFixedVec =  Vector.<Number>( [_waveform.x,_waveform.y,_uSpeed,_vSpeed]);
			_restrictScaleVec =  Vector.<Number>( [!_widthFixed,!_heightFixed,_paticleMaxScale-1,_paticleMinScale-1]);
			_timeVec = Vector.<Number>( [_gpuTime/Scene_data.frameTime,_life,_toscale,_acceleration]);
			_resultUvVec = Vector.<Number>( [_animLine,_animRow,_totalNum,_animInterval]);
			_colorVec = Vector.<Number>( [1,1,1,1]);
			
			
			
			

			//_vc5[3]=_isLoop?1:0;  //不循环
			if(_isLoop){
				_vc5[0] = 1;
				_vc5[1] = 0;
			}else{
				_vc5[0] = 0;
				_vc5[1] = 1;
			}
			
//			if(!isClone){
//				setTextureColor();
//			}
			
			regShader();
		}
		
		override public function getAllInfo():Object{
			var obj:Object = super.getAllInfo();
			obj.islixinAngly = _islixinAngly;
			
			obj.particleRandomScale = _particleRandomScale;
			
			obj.playSpeed = _playSpeed;
			obj.facez = facez;
			obj.beginScale = _beginScale;
			
			
			return obj;
		}
		
		override protected function set textureColor(colorInfo:Object):void{
			_textureColorInfo = colorInfo;
		}
		
		private function setTextureColor():void{
			var num:int = 64;
			
			var matr:Matrix = new Matrix();
			matr.createGradientBox(num, 20, 0, 0, 0);
			
			var bitmapdata:BitmapData = new BitmapData(num,2,true,0);
			
			var shape:Shape = new Shape;
			shape.graphics.clear();
			shape.graphics.beginGradientFill(GradientType.LINEAR, _textureColorInfo.color, _textureColorInfo.alpha, _textureColorInfo.pos, matr, SpreadMethod.PAD);  
			shape.graphics.drawRect(0,0,num,1);
			bitmapdata.draw(shape);
			
			shape.graphics.clear();
			shape.graphics.beginGradientFill(GradientType.LINEAR, _textureRandomColorInfo.color, _textureRandomColorInfo.alpha, _textureRandomColorInfo.pos, matr, SpreadMethod.PAD);  
			shape.graphics.drawRect(0,0,num,1);
			var bitmapdata2:BitmapData = new BitmapData(num,1,true,0);
			bitmapdata2.draw(shape);
			
			for(var i:int;i<num;i++){
				bitmapdata.setPixel32(i,1,bitmapdata2.getPixel32(Math.random()*num,0));
			}
			
			//Scene_data.stage.addChild(new Bitmap(bitmapdata));
			
			try{
				_textureColor = _context3D.createTexture(num,2,Context3DTextureFormat.BGRA,true);
				_textureColor.uploadFromBitmapData(bitmapdata);
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
			
		}
		
		
		public function getColor():Vector.<Number>{
			if(_colorChange){
				var $a:Number=Math.max(0,1+_colorChange.aValue*_colorChange.num)* _alpha
				_colorVec[0] = (1+_colorChange.rValue*_colorChange.num)*$a;
				_colorVec[1] = (1+_colorChange.gValue*_colorChange.num)*$a;
				_colorVec[2] = (1+_colorChange.bValue*_colorChange.num)*$a;
				_colorVec[3] = $a;
			}else{
				_colorVec[0] = _colorVec[1] = _colorVec[2] = _colorVec[3] = _alpha;
			}
			
			return _colorVec;
		}
		public function getlixinForce():Vector.<Number>
		{
			return _linxinForceVec;
		}
		public function getaddforce():Vector.<Number>
		{
			return _addForceVec;
		}
		public function getheightFixed():Vector.<Number>
		{
			return _heightFixedVec;
		}
		public function getTimeVector():Vector.<Number>
		{
			_timeVec[0] = _gpuTime/Scene_data.frameTime * _playSpeed;
			return _timeVec;
		}

		public function getResultUV():Vector.<Number>
		{
			
			return _resultUvVec;
		}
		
		override public function dispose():void{
			super.dispose();
		}
		
		override public function clear():void{
			super.clear();
			
			_linxinForceVec = null;
			_addForceVec = null;
			_heightFixedVec = null;
			_timeVec = null;
			_resultUvVec = null;
			_colorVec = null;
				
			_vc4 = null;
			_vc5 = null;
			_fc1 = null;
		}
		
		override public function getBufferNum():int{
			return particleData.hasUnload ? 0 : 6;
		}
		
		override public function regShader():void{
			if(!materialParam){
				return;
			}
			var hasParticleColor:Boolean = materialParam.material.hasParticleColor();
			_needRandomColor = materialParam.material.hasVertexColor;
			 
			var shaderParameAry:Array;
			
			var hasParticle:int;
			if(hasParticleColor){
				hasParticle = 1;
			}else{
				hasParticle = 0;
			}
			
			var hasRandomClolr:int = _needRandomColor ? 1 : 0;
			
			var isMul:int = _is3Dlizi ? 1 : 0;
			
			var needRotation:int = this._needSelfRotation ? 1 : 0;
			
			shaderParameAry = [hasParticle,hasRandomClolr,isMul,needRotation];
			
			materialParam.program = Program3DManager.getInstance().getMaterialProgram(Display3DBallNewShader.Display3DBallNewShader,Display3DBallNewShader,materialParam.material,shaderParameAry);
			
		}
		
		
	}
}