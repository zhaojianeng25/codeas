package _Pan3D.particle.bone
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjData;
	import _Pan3D.batch.IBatch;
	import _Pan3D.core.Quaternion;
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.role.AnimDataManager;
	import _Pan3D.role.MeshDataManager;
	import _Pan3D.utils.MeshToObjUtils;
	import _Pan3D.utils.editorutils.BoneImportSortUtil;
	import _Pan3D.utils.editorutils.MeshImportSortUtil;
	import _Pan3D.vo.anim.AnimVo;
	import _Pan3D.vo.anim.BoneLoadVo;
	import _Pan3D.vo.mesh.MeshVo;
	
	import _me.Scene_data;
	
	

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DBonePartilce extends Display3DParticle implements IBatch
	{
		//protected var _closeGround:Boolean;//紧贴地面
		//protected var _gormalsGround:Boolean;//使用地面法线
		//		
		//protected var _bitmapdata:BitmapData;
		//protected var _baseMatrix:Matrix3D;
		
		protected var _maxAnimTime:int;
		protected var _objUrl:String;
		
		private var _objData:ObjData;
		private var _isComplete:Boolean;
		private var _objScale:Number=1;
		private var _depthMode:int;
		
		private var _meshUrl:String;
		private var _animUrl:String;
		
		//private var _meshData:MeshData;
//		private var _animBoneAry:Array;
//		private var _animVo:AnimVo;
		
		/**
		 * 播放速度 
		 */		
		private var _playSpeed:Number = 1;
		
		public function Display3DBonePartilce(context:Context3D)
		{
			super(context);
			particleData = new ParticleBoneData;
			this.particleType = 13;
			useTextureColor = false;
		}
		
		override protected function setVa():void{

			if(boneObjData){
			
	
			

			_context3D.setVertexBufferAt(0,boneObjData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1,boneObjData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			
			_context3D.setVertexBufferAt(2,ParticleBoneData(_particleData).meshData.boneWeightBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context3D.setVertexBufferAt(3,ParticleBoneData(_particleData).meshData.boneIdBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			
			setMaterialTexture();
			_context3D.drawTriangles(boneObjData.indexBuffer, 0, -1);

			}
		}
		
		override protected function resetVa() : void {
			_context3D.setVertexBufferAt(0,null, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1,null, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context3D.setVertexBufferAt(2,null, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context3D.setVertexBufferAt(3,null, 0, Context3DVertexBufferFormat.FLOAT_4);

			resetMaterialTexture();
		}
		

		private var _timeVec:Vector.<Number>;
		private var _resultUvVec:Vector.<Number>;
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
			if(_scaleChange){
				_rotationMatrix.prependScale(_widthFixed?1:_scaleChange.num,_heightFixed?1:_scaleChange.num,_scaleChange.num);
			}
			_rotationMatrix.prependScale(_objScale,_objScale,_objScale);
	
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
			
			obj.meshUrl = _meshUrl;
			obj.animUrl = _animUrl;
			obj.playSpeed = _playSpeed;
			
			trace(ParticleBoneData(_particleData).meshData)
			if(ParticleBoneData(_particleData).meshData){
				obj.vecData=getBoneMeshData();
			}
		
			return obj;
		}
		//由于修改过矩阵索引。所以在这里要特别注意

		
		private function getBoneMeshData():Object
		{
			
			var $obj:Object=new Object

				ParticleBoneData(_particleData).meshData.bonetIDAry=meshImportUtils.bonetIDAryMakeNew
				$obj.meshData= ParticleBoneData(_particleData).meshData;
				if(ParticleBoneData(_particleData).animVo){
					$obj.frames= ParticleBoneData(_particleData).animVo.frames;
				}
				$obj.boneObjData=boneObjData;
				$obj.boneAnimMatrxItem=boneAnimMatrxItem;
	



			return $obj;
				
		}

		
		override public function setAllInfo(obj:Object,isClone:Boolean=false):void{
			this._maxAnimTime = obj.maxAnimTime;
			this._meshUrl = obj.meshUrl;
			this._animUrl = obj.animUrl;
			this._objScale = obj.objScale;
			this._depthMode = obj.depthMode;
			this.boneObjData=null
			if(!isClone){
				meshUrl = obj.meshUrl;
				animUrl = obj.animUrl;
			}
			
			super.setAllInfo(obj,isClone);
			
			_timeVec = Vector.<Number>( [0,0,1,_maxAnimTime]);
			_resultUvVec = Vector.<Number>( [1,1,_uSpeed,_vSpeed]);
			_colorVec = Vector.<Number>( [1,1,1,1]);
			
			_playSpeed = obj.playSpeed;
		}
		
		public function set meshUrl(value:String):void{
			var meshVo:MeshVo = new MeshVo();
			MeshDataManager.getInstance().addMesh(Scene_data.fileRoot + value,onMeshCom,meshVo,0,false);
		}
		private  var boneObjData:ObjData;
		private function onMeshCom(meshData:MeshData,info:MeshVo):void{
			if(!meshImportUtils){
				meshImportUtils = new MeshImportSortUtil;
			}
			meshImportUtils.processMesh(meshData);
			boneObjData = new MeshToObjUtils().getObj(meshData);
		    ParticleBoneData(_particleData).meshData = meshData;

			meshData.useNum++;
			sourceLoadCom();
			this.meshFrameBone()
		}
		private var boneAnimMatrxItem:Vector.<Vector.<Matrix3D>>
		private function meshFrameBone():void
		{
		
			if(boneObjData&&ParticleBoneData(_particleData).meshData&&ParticleBoneData(_particleData).animVo){
				boneAnimMatrxItem=new Vector.<Vector.<Matrix3D>>;
				var _animBoneAry:Array = ParticleBoneData(_particleData).animVo.frames;
				for(var i:Number=0;i<_animBoneAry.length;i++){
			
					var $tempBaseArr:Array=_animBoneAry[i]
					var $frameArr:Vector.<Matrix3D>=new Vector.<Matrix3D>
					for(var j:Number=0;j<$tempBaseArr.length;j++){
					
						var baseMa:Matrix3D =$tempBaseArr[j].matrix;
						var bindPosMa:Matrix3D = boneObjData.bindPosAry[j];
						baseMa = baseMa.clone();
						baseMa.prepend(bindPosMa);
						
						$frameArr.push(baseMa)
					}
					boneAnimMatrxItem.push($frameArr);
				}

				
			}
			

		}
		private var baseMatrixItem:Vector.<Matrix3D>;
		override protected function setVc() : void {
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, getResultMatrix(), true);
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, getResultUV());
			

			var frame:int = (_timer/Scene_data.frameTime/2*_playSpeed)%boneAnimMatrxItem.length;
			//frame=1
			var newAry:Vector.<Matrix3D> = boneAnimMatrxItem[frame];
			var boneIDary:Array=ParticleBoneData(_particleData).meshData.boneNewIDAry
			baseMatrixItem=new Vector.<Matrix3D>;
			var qstr:Array=new Array;
			var dstr:Array=new Array;
			
			for(var i:Number = 0;i<boneIDary.length;i++){
				if(true&&newAry.length){
					var baseM:Matrix3D=Matrix3D(newAry[boneIDary[i]]).clone()
					baseMatrixItem.push(baseM.clone())
						
						
					baseM.appendScale(-1,1,1)
			
					var q:Quaternion=new Quaternion();
					q.fromMatrix(baseM);
					var p:Vector3D=baseM.position;
					
					var vcid:uint=20+i*2
					_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,vcid+0,Vector.<Number>( [q.x,q.y,q.z,q.w]));   //等用  20
					_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,vcid+1,Vector.<Number>( [p.x,p.y,p.z,p.w]));   //等用21
					
					qstr.push(q.x,q.y,q.z,q.w)
					dstr.push(p.x,p.y,p.z,p.w)
					
				
				}else{
					//	_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 20+i*4, newAry[boneIDary[i]], true);
				}
				
				
			}
			//trace(qstr)
			//trace(dstr)
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,15,Vector.<Number>( [1,1,1,1]));   //用于给双四元数位移用
	
			setMaterialVc();
		}
		private var _animUrlStr:String
		private var meshImportUtils:MeshImportSortUtil;
		public function set animUrl(value:String):void{
			var obj:BoneLoadVo = new BoneLoadVo(name,Scene_data.fileRoot + value);
			_animUrlStr=Scene_data.fileRoot + value
			//AnimDataManager.getInstance().addAnim(_animUrlStr,onAnimCom,obj,0,null,false);
			
			AnimDataManager.getInstance().addAnim(_animUrlStr,onLocalAnimLoad,obj);
		}
		private var _boneImportSort:BoneImportSortUtil = new BoneImportSortUtil;
		protected function onLocalAnimLoad(ary:Array,obj:Object,$animVo:AnimVo=null):void{
			
		
			var prePorcessInfo:Object = _boneImportSort.processBoneNew(obj.hierarchy,obj);
			var ary:Array = obj.data = prePorcessInfo.animAry;
			obj.source = prePorcessInfo.source;
			obj.strAry = prePorcessInfo.strAry;
			obj.hierarchy = prePorcessInfo.hierarchy;
			obj.str = prePorcessInfo.str;
			obj.data = ary;
			
			
			$animVo=new AnimVo;
			$animVo.frames=ary

			if($animVo && !hasDispose){
				$animVo.useNum++;
				ParticleBoneData(_particleData).animVo = $animVo;
			}
			
			sourceLoadCom();
			this.meshFrameBone()
		}
		
		override public function update():void{
			if(!ParticleBoneData(_particleData).meshData || !ParticleBoneData(_particleData).animVo){
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
			if(!ParticleBoneData(_particleData).meshData || !ParticleBoneData(_particleData).animVo){
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
			var display:Display3DBonePartilce = new Display3DBonePartilce(_context3D);
			display.setProgram3D(this._program);
			display.setAllInfo(_data,true);
			display.particleData = particleData;
			display._textureColor = _textureColor;
			display._textureColorAry = _textureColorAry;
			return display;
		}
		
		override public function clear():void{
			super.clear();
			
			_objUrl = null;
			
			_objData = null;
		
			_meshUrl = null;
			_animUrl = null;
			
			_timeVec = null;
			_resultUvVec = null;
			_colorVec = null;
			
			_resultMatrix = null;
			
		}
		
		override public function get loadNum():int{
			return 3;
		}
		
		override public function reload():void{
			super.reload();
			_program = Program3DManager.getInstance().getProgram(Display3DBoneShader.DISPLAY3D_BONE_SHADER);
		}
		
		override public function getBufferNum():int{
			if(Scene_data.compressBuffer){
				return 1;
			}else{
				return 7;
			}
		}
		
		override public function regShader():void{
			materialParam.program = Program3DManager.getInstance().getMaterialProgram(Display3DBoneShader.DISPLAY3D_BONE_SHADER,Display3DBoneShader,materialParam.material);
		}
		
		
	}
}