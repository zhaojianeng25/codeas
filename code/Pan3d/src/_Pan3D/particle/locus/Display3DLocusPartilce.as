package _Pan3D.particle.locus
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Object3D;
	import _Pan3D.core.BezierClass;
	import _Pan3D.core.MathClass;
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Display3DLocusPartilce extends Display3DParticle
	{
		protected var _speed:Number=1;   //粒子运动数字
		protected var _isLoop:Boolean=false;  //是否循环
		
		protected var _speedUV:Number=1;
		public var beginVector3D:Vector3D;
		public var endVector3D:Vector3D;
		public var density:uint;
		public var pointArr:Array;
		public var fun:Function
		public var changeFun:Function;
		
		public var isEnd:Boolean;
		public function Display3DLocusPartilce(context:Context3D)
		{
			super(context);
			this._particleType = 3;
			_particleData=new GpuLocusData;
		}
		override protected function setVa() : void {
			_context3D.setVertexBufferAt(0, gpuLocusData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, gpuLocusData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			if(_watchEye){
				_context3D.setVertexBufferAt(2, gpuLocusData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			}
			//_context3D.setTextureAt(1,particleData.texture);
			setMaterialTexture();
			//_context3D.setTextureAt(0,_textureColor);
			_context3D.drawTriangles(gpuLocusData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(gpuLocusData.indexs.length/3);
		}
		override protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
//			_context3D.setTextureAt(0,null);
//			_context3D.setTextureAt(1,null);
			resetMaterialTexture();
		}
		override protected function setVaBatch() : void {
			_context3D.setVertexBufferAt(0, gpuLocusData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, gpuLocusData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			//_context3D.setTextureAt(0,_textureColor);
			setMaterialTexture();
			_context3D.drawTriangles(gpuLocusData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			if(gpuLocusData.indexs){
				Scene_data.drawTriangle += int(gpuLocusData.indexs.length/3);
			}else{
				//trace("&&&&&&&&&&error&&&&&&&&&&")
			}
		}
		override protected function resetVaBatch() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setVertexBufferAt(3, null);
			_context3D.setTextureAt(0,null);
		}
		
		private var _killVec:Vector.<Number> = Vector.<Number>( [0,2,1,0]);
		override protected function setVc() : void {
			this.updateMatrix();

			//_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,4,getResultMatrix() , true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,4,modelMatrix , true);
			
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,8,Scene_data.cam3D.cameraMatrix , true);

			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,15,getResultUV()); 
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,16,_uvData); 
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,17,_killVec); 
			
			var tempv3d:Vector3D = new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z);;
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,12, Vector.<Number>([tempv3d.x,tempv3d.y,tempv3d.z,0]));

			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,6, getColor());
			setMaterialVc();

		}
		
		override public function updateMatrix():void{
			modelMatrix.identity();
			//modelMatrix.prepend(Scene_data.cam3D.cameraMatrix);
			//			if(bindRatation){
			modelMatrix.prependTranslation(bindVecter3d.x,bindVecter3d.y,bindVecter3d.z);
			//if(!Scene_data.isDevelop){
			modelMatrix.prependTranslation(_eyeDistanceVec.x,_eyeDistanceVec.y,_eyeDistanceVec.z);
			//}
			
			modelMatrix.prepend(bindMatrix);
			//			}else{
			//				modelMatrix.prependTranslation(bindVecter3d.x,bindVecter3d.y,bindVecter3d.z);	
			//			}
			modelMatrix.prepend(posMatrix);
		}
		
		private var _uvData:Vector.<Number>

		protected var _colorVec:Vector.<Number>;
		public function getColor():Vector.<Number>
		{
			
			if(_colorChange){
				var $a:Number=Math.max(0,1+_colorChange.aValue*_colorChange.num)
				_colorVec[0] = (1+_colorChange.rValue*_colorChange.num)*$a;
				_colorVec[1] = (1+_colorChange.gValue*_colorChange.num)*$a;
				_colorVec[2] = (1+_colorChange.bValue*_colorChange.num)*$a;
				_colorVec[3] = $a * _alpha;
			}else{
				_colorVec[3] = _alpha;
			}
			return _colorVec;
		}
		public function getResultUV():Vector.<Number>
		{
			//$moveUv移动数度    1,开始时间   $lifeRoundNum生命周末 ,-1为结束位置
			var $nowTime:Number=_gpuTime/Scene_data.frameTime;
			var $tatolDensityNum:uint=uint((pointArr.length-1)/3)*density;
			//特别注意100为一个周期, 
			var $lifeRoundNum:Number=(_life/100);
			//用speed存放为uv存放数度
			var $moveUv:Number=_speed*$nowTime/density/10
			if(isEnd){
				$moveUv=Math.min(1,$moveUv)
			}
			var $fcVector:Vector3D;
			if(_isLoop){
				if(_life){
					$moveUv=$moveUv%($lifeRoundNum+1)
					$fcVector=new Vector3D($moveUv,1,$lifeRoundNum,-$lifeRoundNum); 
				}else{
					$moveUv=$moveUv%1
					$fcVector=new Vector3D($moveUv+1,1,99,-2); 
				}
			}else{
				if(_life){
					$fcVector=new Vector3D($moveUv,1,$lifeRoundNum,-1); 
				}else{
					$fcVector=new Vector3D($moveUv,1,99,-1); 
				}
			}
			return Vector.<Number>( [$fcVector.x,$fcVector.y,$fcVector.z,$fcVector.w]);
		}
		override public function getAllInfo():Object{
			var obj:Object = super.getAllInfo();
			obj.density = density;
			obj.beginVector3D = beginVector3D;
			obj.endVector3D = endVector3D;
			obj.tileMode = _tileMode;
			obj.speed = _speed;
			obj.isLoop = _isLoop;
			obj.data = pointArr;
			obj.isEnd = this.isEnd;
			obj.vecData = getDataVec();
			//obj.scaleLocus = _scaleLocus;
			return obj;
		}
		
		public function getDataVec():Object{
			var obj:Object = new Object;
			obj.vec = gpuLocusData.vertices;
			obj.normals = gpuLocusData.normals;
			obj.uvs = gpuLocusData.uvs;
			obj.index = gpuLocusData.indexs;
			return obj;
		}
		
		override public function setAllInfo(obj:Object,isClone:Boolean=false):void{
			this._tileMode = obj.tileMode;
			this._isLoop = obj.isLoop;
			this._speed = obj.speed;
			this.density = obj.density;
			this.beginVector3D = getVector3DByObject(obj.beginVector3D);
			this.endVector3D = getVector3DByObject(obj.endVector3D);
			_colorVec = Vector.<Number>( [1,1,1,1]);
          	this.isEnd = obj.isEnd;
			super.setAllInfo(obj,isClone);
			if(obj.data&&obj.data.length>1){
				pointArr = getObject3DAry(obj.data);
			}else{
				pointArr=new Array;
				pointArr.push(new Object3D(0,0,0))
				pointArr.push(new Object3D(100,0,0))
				pointArr.push(new Object3D(200,0,0))
				pointArr.push(new Object3D(300,0,0))
			}
			changeFun=uplodToGpu;
			if(!isClone){
				uplodToGpu();
			}
			_uvData= Vector.<Number>( [_isU?-1:1,_isV?-1:1,_isUV?0:1,_isUV?1:0]);
			regShader();
		}
		
		protected function getObject3DAry(source:Array):Array{
			var ary:Array = new Array;
			for(var i:int;i<source.length;i++){
				var obj:Object3D;
				if(source[i] is Object3D){
					obj = source[i];
				}else{
					obj = new Object3D;
					obj.setData(source[i]);
				}
				ary.push(obj);
			}
			return ary;
			
		}
		
		override protected function uplodToGpu():void
		{
			makeModeData(this);
		}
		protected function makeModeData(_guijiLizhiVO:Display3DLocusPartilce):void
		{
			
			gpuLocusData.vertices=new Vector.<Number>
			gpuLocusData.uvs=new Vector.<Number>
			gpuLocusData.indexs=new Vector.<uint>
			gpuLocusData.normals=new Vector.<Number>
			
			
			var i:int,j:int,k:int,l:int;
			var $dataArr:Array=pointArr;
			var $angleArr:Array=new Array;
			var $posArr:Array=new Array();
			var tangentArr:Array;
			if(_watchEye){
				tangentArr = new Array;
			}
			
			for( i=0;i<$dataArr.length;i++){
				$angleArr.push(new Vector3D($dataArr[i].angle_x,$dataArr[i].angle_y,$dataArr[i].angle_z)); //存放角度，等会可以转换为贝尔曲线用
			}
			for( i=0;i<($dataArr.length-1)/3;i++)
			{
				var isEnd:Boolean=(i==(($dataArr.length-1)/3-1))
				$posArr=$posArr.concat(BezierClass.getFourPointBezier($dataArr[i*3+0],$dataArr[i*3+1],$dataArr[i*3+2],$dataArr[i*3+3],Math.ceil(density/int($dataArr.length/3)),isEnd,tangentArr))
			}
			//$posArr.push($dataArr[$dataArr.length-1]);
			for( i=0;i<$posArr.length;i++)
			{
				//一次推两组数据进入
				var c:Object3D=Object3D($posArr[i]);
				if(!_watchEye){
					var $pointA:Vector3D=new Vector3D(beginVector3D.x,beginVector3D.y,beginVector3D.z);
					var $pointB:Vector3D=new Vector3D(endVector3D.x,endVector3D.y,endVector3D.z);
					$pointA=MathClass.math_change_point(getSale($pointA,i/$posArr.length),c.angle_x,c.angle_y,c.angle_z);
					$pointB=MathClass.math_change_point(getSale($pointB,i/$posArr.length),c.angle_x,c.angle_y,c.angle_z);
					var s:Vector3D=new Vector3D($pointA.x+c.x,$pointA.y+c.y,$pointA.z+c.z)
					var e:Vector3D=new Vector3D($pointB.x+c.x,$pointB.y+c.y,$pointB.z+c.z)
						
					gpuLocusData.vertices.push(s.x,s.y,s.z);
					gpuLocusData.vertices.push(e.x,e.y,e.z);
				}else{
					var tagenV3d:Vector3D = tangentArr[i];
					
					gpuLocusData.vertices.push(c.x,c.y,c.z);
					gpuLocusData.vertices.push(c.x,c.y,c.z);
					
					gpuLocusData.normals.push(tagenV3d.x,tagenV3d.y,tagenV3d.z,Math.abs(beginVector3D.z));
					gpuLocusData.normals.push(tagenV3d.x,tagenV3d.y,tagenV3d.z,-Math.abs(beginVector3D.z))
				}
				
				
				
				var uvNum:Number=i/($posArr.length-1)
				gpuLocusData.uvs.push(uvNum,0);
				gpuLocusData.uvs.push(uvNum,1);

				
			}
			for( j=0;j<(gpuLocusData.vertices.length/6-1);j++)
			{
				gpuLocusData.indexs.push(0+j*2+0,0+j*2+1,0+j*2+3)
				gpuLocusData.indexs.push(0+j*2+0,0+j*2+3,0+j*2+2)
			}	
			try{
				pushToGpu();
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
		}
		protected function getSale(vc3:Vector3D,num:Number):Vector3D{
			vc3 = vc3.clone();
			return vc3;
		}
		
		
		override public function pushToGpu():void
		{
			
			gpuLocusData.vertexBuffer = this._context3D.createVertexBuffer(gpuLocusData.vertices.length / 3, 3);
			gpuLocusData.vertexBuffer.uploadFromVector(Vector.<Number>(gpuLocusData.vertices), 0, gpuLocusData.vertices.length / 3);
			gpuLocusData.uvBuffer = this._context3D.createVertexBuffer(gpuLocusData.uvs.length / 2, 2);
			gpuLocusData.uvBuffer.uploadFromVector(Vector.<Number>(gpuLocusData.uvs), 0, gpuLocusData.uvs.length / 2);
			if(_watchEye){
				gpuLocusData.normalsBuffer = this._context3D.createVertexBuffer(gpuLocusData.normals.length / 4, 4);
				gpuLocusData.normalsBuffer.uploadFromVector(Vector.<Number>(gpuLocusData.normals), 0, gpuLocusData.normals.length / 4);
			}

			gpuLocusData.indexBuffer = this._context3D.createIndexBuffer(gpuLocusData.indexs.length);
			gpuLocusData.indexBuffer.uploadFromVector(Vector.<uint>(gpuLocusData.indexs), 0, gpuLocusData.indexs.length);
			

			
		}

		override public function clone():Display3DParticle{
			var display:Display3DLocusPartilce = new Display3DLocusPartilce(_context3D);
			display.setProgram3D(this._program);
			display.setAllInfo(_data,true);
			display.particleData = _particleData;
			display._textureColor = _textureColor;
			display._textureColorAry = _textureColorAry;
			return display;
		}
		
		public function get gpuLocusData():GpuLocusData{
			return GpuLocusData(_particleData);
		}
		
		override public function reload():void{
			super.reload();
			_program = Program3DManager.getInstance().getProgram(Display3DLocusShader.DISPLAY3DLOCUSSHADER);
			pushToGpu();
		}
		
		public function getResultMatrix():Matrix3D{
			this.updateMatrix();
			return modelMatrix;
		}
		
		
		
		override public function dispose():void{
			super.dispose();
		}
		
		override public function clear():void{
			super.clear();
			beginVector3D = null;
			endVector3D = null;
			pointArr = null;
			fun = null;
			changeFun = null;
		}
		
		override public function getBufferNum():int{
			return particleData.hasUnload ? 0 : 4;
		}
		
		override public function regShader():void{
			if(!materialParam){
				return;
			}
			var shaderParameAry:Array;
			var isWatchEye:int = _watchEye ? 1 : 0;
			var changeUv:int=0

			if(_isU||_isV||_isUV){
				changeUv=1
			}
			shaderParameAry = [isWatchEye,changeUv];
			materialParam.program = Program3DManager.getInstance().getMaterialProgram(Display3DLocusShader.DISPLAY3DLOCUSSHADER,Display3DLocusShader,materialParam.material,shaderParameAry);
		}
		
	}
}