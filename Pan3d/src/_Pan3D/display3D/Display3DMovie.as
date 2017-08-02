package _Pan3D.display3D {
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.core.Quaternion;
	import _Pan3D.display3D.interfaces.IDisplay3DMovie;
	import _Pan3D.event.PlayEvent;
	import _Pan3D.program.shaders.Md5MatrialShader;
	import _Pan3D.role.BoneLoadUtils;
	import _Pan3D.role.MeshDataManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.anim.AnimVo;
	import _Pan3D.vo.anim.BoneSocketData;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;

	// import _Pan3D.anim.Md5Analysis.Md5Analysis;
	
	/**
	 * @author liuyanfei  QQ: 421537900
	 */
	public class Display3DMovie extends Display3DMaterialSprite implements IDisplay3DMovie
	{
		protected var _meshDic:Object;
		protected var _textureDic:Object;
		//protected var _context:Context3D;
		/**
		 * 动作数据字典 
		 */		
		protected var _animDic:Object;
		/**
		 * 动作循环关键帧字典 
		 */		
		protected var _loopDic:Object;
		/**
		 * 动作源数据字典 
		 */		
		protected var _animSouceDataDic:Object;
		/**
		 * 包围盒信息字典 
		 */		
		protected var _boundsDic:Object;
		/**
		 * 名字高度信息字典 
		 */		
		protected var _nameHeightDic:Object;
		
		protected var _posDic:Object;
		
		protected var _curentAction:String;
		protected var _curentFrame:int;
		protected var _isLoop:Boolean;
		protected var _pause:Boolean;
		protected var _time:int;
		
		private var _modelMatirx:Matrix3D;
		
		public var frameRate:Number = 1;//播放速率
		
		protected var _playSpeed:Number;
		protected var _completeState:int;
		/**
		 * 播放速度的信息字典 
		 */		
		private var _playSpeedDic:Object;
		/**
		 * 骨骼正在加载中的工具列表 
		 */		
		protected var _boneUtilList:Vector.<BoneLoadUtils>;
		/**
		 * 动作名--路径名 存储字典
		 */		
		protected var preLoadActionDic:Object;
		/**
		 * 等待动作加载的字典 
		 */		
		protected var waitLoadActionDic:Object;
		/**
		 * 是否已经释放 
		 */		
		public var hasDispose:Boolean;
		
		/**
		 * 资源加载优先级
		 */	
		public var loadPriority:int = 0;
		
		protected var _socketDic:Object;
		
		public var actionPos:Vector3D = new Vector3D();
		
		protected var _defaultAction:String = "stand";
		public function Display3DMovie(context:Context3D)
		{
			super(context);
			_meshDic = new Object;
			_textureDic = new Object;
			_socketDic = new Object;
			this._context = context;
			_animDic = new Object;
			_loopDic = new Object;
			_animSouceDataDic = new Object;
			_boundsDic = new Object;
			_nameHeightDic = new Object;
			_boneUtilList = new Vector.<BoneLoadUtils>;
			_playSpeedDic = new Object;
			preLoadActionDic = new Object;
			waitLoadActionDic = new Object;
			_posDic = new Object;
		}
		
		public function get posDic():Object
		{
			return _posDic;
		}

		public function get animDic():Object
		{
			return _animDic;
		}

		public function set animDic(value:Object):void
		{
			_animDic = value;
		}

		public function get curentAction():String
		{
			return _curentAction;
		}

//		public function set curentAction(value:String):void
//		{
//			_curentAction = value;
//		}
		
		public function addSocket($sockeData:BoneSocketData):void{
			_socketDic[$sockeData.name] = $sockeData;
		}
		
		public function removeSocket($key:String):void{
			delete _socketDic[$key];
		}
		
		
		
		public function addAnim(url:String,name:String):void{
			waitLoadActionDic[name] = true;
			var boneLoadUtil:BoneLoadUtils = new BoneLoadUtils();
			_boneUtilList.push(boneLoadUtil);
			boneLoadUtil.addAnim(url,name,onAnimLoad2,loadPriority,removeBoneUtil);
		}
		protected function removeBoneUtil(boneUtil:BoneLoadUtils):void{
			var index:int = _boneUtilList.indexOf(boneUtil);
			if(index != -1){
				_boneUtilList.splice(index,1);
			}
		}
		protected function removeAllBoneUtil():void{
			for(var i:int;i<_boneUtilList.length;i++){
				_boneUtilList[i].isInterrupt = true;
				_boneUtilList[i].dispose();
			}
			_boneUtilList.length = 0;
		}
		protected function onAnimLoad2(ary:Array,info:Object,animVo:AnimVo,boneUtil:BoneLoadUtils):void{
			if(hasDispose){
				return;
			}
			_animDic[info.name] = ary;
			_animSouceDataDic[info.name] = animVo;
			
			if(!hasDispose){
				animVo.useNum++;
			}
			
			if(animVo.bounds){
				_boundsDic[info.name] = animVo.bounds;
			}
			if(animVo.inLoop){
				_loopDic[info.name] = int(animVo.inLoop);
			}else{
				delete _loopDic[info.name]
			}
			
			if(animVo.nameHeight){
				_nameHeightDic[info.name] = Number(animVo.nameHeight);
			}
			
			if(animVo.pos){
				_posDic[info.name] = animVo.pos;
			}
			
			setFileScale(animVo.scale);
			
			updataPos();
			
			removeBoneUtil(boneUtil);
			if(!_playSpeedDic.hasOwnProperty(info.name)){
				_playSpeedDic[info.name] = 1;
			}
			
			if(_completeState == 4 && info.name == curentAction){
				gotoAndPlay(_loopDic[info.name]);
			}
			
			delete waitLoadActionDic[info.name];
			//_curentAction = info.name;
			calculateFrame();
			
			setIsUpdate();
			if(info.name == defaultAction){
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function setFileScale(value:Number):void{
			
		}
		
		public function calculateFrame():void{
			
		}
		/**
		 * 设置是否渲染更新 
		 * 
		 */		
		public function setIsUpdate():void{
			
		}
		
		public function addMeshData($key:String,$mesh:MeshData):void{
			_meshDic[$key] = $mesh;
			
			this.lightProbe = $mesh.material.lightProbe;
		}
		
		public function setMeshDataMaterialParam($key:String,$ary:Array):void{
		
		}
		
		public function addMesh(place:String,url:String):void{
			var obj:Object = {"place":place,"url":url};
			TextureManager.getInstance().addTexture(Scene_data.fileRoot+"move/"+url+".jpg",addTexture,obj,loadPriority);
		}
		
		
		
		public function removeMesh(place:String):void{
			_textureDic[place] = null;
			delete _textureDic[place];
			_meshDic[place] = null;
			delete _meshDic[place];
		}
		
		override protected function addTexture(textureVo:TextureVo,info:Object):void{
			/*_objData.texture=texture;
			uplodToGpu();*/
			_textureDic[info.place] = textureVo.texture;//bitmap.bitmapData;
			MeshDataManager.getInstance().addMesh(Scene_data.fileRoot+"move/"+ info.url + ".md5mesh",onMeshLoad2,info,loadPriority);
			//loadMeshData(info.place,info.url);
		}
		protected function onMeshLoad2(meshData:MeshData,info:Object):void{
			meshData.texture = _textureDic[info.place];
			_meshDic[info.place] = meshData;
		}
		
		
		override public function update():void{
			if(!this._visible){
				return;
			}
			
			if(!_animDic.hasOwnProperty(_curentAction)){
				return;
			}

			_context.setProgram(this.program);
			this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, Vector.<Number>([1, 1, 1, 0.8]));
			
			//setVc();
			for each(var meshData:MeshData in _meshDic){
				setMeshVc(meshData);
				setMeshVa(meshData);
			}
			
			setFrame();
			
			resetVa();
		}
		
		public function updateMaterila():void{
			this.updateMatrix();
			
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
			
			for each(var meshData:MeshData in _meshDic){
				updateMaterialMesh(meshData);
			}
			
		}
		
		public function updateMaterialMesh($mesh:MeshData):void{
			if(!$mesh.material || !$mesh.visible){
				return;
			}
			setMaterialConfig($mesh.material);
			setMaterialMeshVc($mesh);
			setMaterialMeshVa($mesh);
			resetVa();
			reSetMaterialTexture($mesh.material);
		}
		
		protected function setMaterialMeshVc($mesh:MeshData):void{
			
			setBaseMaterialVc($mesh.material);//基础变量
			setMaterialVc($mesh.material,$mesh.materialParam);//动态参数
			setMeshVc($mesh);//骨骼数据
			
		}
		
		protected function setMaterialMeshVa($mesh:MeshData):void{
			setMeshVa($mesh);
			
			setMaterialTexture($mesh.material,$mesh.materialParam);
			_context.drawTriangles($mesh.indexBuffer, 0, -1);
			
			Scene_data.drawTriangle+=$mesh.indexAry.length
			Scene_data.drawNum++
		}
		
		public function setFrame():void{
			if(_pause){
				return;
			}
			if(_curentAction && _animDic.hasOwnProperty(_curentAction)){
				if(frames>=frameRate){
					_curentFrame++;
					frames = 0;
				}else{
					frames++;
				}
				
				if(_curentFrame >= _animDic[_curentAction].length){
					_curentFrame = 0;
					playOver();
					this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_COMPLETE_EVENT));
				}
			}else if(_animDic.hasOwnProperty("stand")){
				if(frames>=frameRate){
					_curentFrame++;
					frames = 0;
				}else{
					frames++;
				}
				if(_curentFrame >= _animDic["stand"].length){
					_curentFrame = 0;
					playOver();
					this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_COMPLETE_EVENT));
				}
				
			}
			
		}
		
		public function updateForScanning(scaningProgram:Program3D):void{
			
		}
		public function updataAndScanning():void
		{
			
		}
		
		/**
		 * 播放指定动作 
		 * @param action 动作名称
		 * @param completeState 播放完成后状态  0表示循环播放,1表示播放完毕停在最后一帧，2表示播放完毕返回默认动作，3表示循环播放
		 * @return 
		 * 
		 */		
		public function play(action:String,completeState:int=0):Boolean{
			_completeState = completeState;
			_pause = false;
			this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_START_EVENT));

			_curentAction = action;
			
			_curentFrame = 0;
			_time = 0;
			
			blinkFrame();
			
			updateBind();

			updataPos();
			
			if(completeState == 4){
				if(_animDic[action]){
					gotoAndPlay(_loopDic[_curentAction]);
				}
			}
			
			if(_playSpeedDic.hasOwnProperty(action)){
				playSpeed = _playSpeedDic[action];
			}else{
				playSpeed = 1;
			}
			
			setIsUpdate();
			
			calculateFrame();
			
			if(_animDic.hasOwnProperty(action)){
				return true;
			}else{
				if(!waitLoadActionDic[action] && preLoadActionDic[action]){
					addAnim(preLoadActionDic[action],action);
				}
				return false;
			}
		}
		
		public function updateBind():void{
			
		}
		
		public function blinkFrame():void{
			
		}
		
		public function stop():void{
			_pause = true;
		}
		
		public function gotoAndStop(value:int):void{
			if(_curentAction && _animDic.hasOwnProperty(_curentAction)){
				if(value < _animDic[_curentAction].length){
					_curentFrame = value;
				}else{
					_curentFrame = _animDic[_curentAction].length - 1;
				}
			}
			_pause = true;
		}
		
		public function gotoAndPlay(value:int):void{
			if(_curentAction && _animDic.hasOwnProperty(_curentAction)){
				if(value < _animDic[_curentAction].length){
					_curentFrame = value;
				}else{
					_curentFrame = _animDic[_curentAction].length - 1;
				}
			}
			_pause = false;
		}
		
		
		
		protected function setMeshVa(meshData:MeshData):void{
			_context.setVertexBufferAt(0,meshData.vertexBuffer1, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1,meshData.vertexBuffer2, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(2,meshData.vertexBuffer3, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(3,meshData.vertexBuffer4, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(4,meshData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setVertexBufferAt(5,meshData.boneWeightBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context.setVertexBufferAt(6,meshData.boneIdBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context.setTextureAt(1,meshData.texture);
			_context.drawTriangles(meshData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(meshData.faceNum);
		}
		
		override protected function resetVa():void{
			_context.setVertexBufferAt(0,null, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1,null, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(2,null, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(3,null, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(4,null, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setVertexBufferAt(5,null, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context.setVertexBufferAt(6,null, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context.setTextureAt(1,null);
		}
		protected var frames:int; 
		public function setMeshVc(meshData:MeshData):void{
			var ary:Array;
			if(_animDic[_curentAction]){
				ary = _animDic[_curentAction][_curentFrame];
			}else{
				ary = _animDic[_defaultAction][_curentFrame];
			}
			
			var boneIDary:Array = meshData.boneNewIDAry;
			
			for(var i:int = 0;i<boneIDary.length;i++){ 
				_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12+i*4,  ary[boneIDary[i]], true);
			}
		}
		
		public function getCurrentMatrixList():Array{
			
			if(!_curentAction){
				return null
			}
			var ary:Array;
			if(_animDic[_curentAction]){
				ary = _animDic[_curentAction][_curentFrame];
			}else{
				ary = _animDic[_defaultAction][_curentFrame];
			}
			return ary;
		}
		
		public function playOver():void{
			
		}
		
		/*private function setFrameToMatrix(frameAry:Array):void{
			for(var j:int=0;j<frameAry.length;j++){
				var boneAry:Array = frameAry[j];
				
				var Q0:Quaternion=new Quaternion();
				var Q1:Quaternion=new Quaternion();
				var OldQ:Quaternion=new Quaternion();
				var OldM:Matrix3D=new Matrix3D();
				var newM:Matrix3D=new Matrix3D();
				var tempM:Matrix3D=new Matrix3D;
				var tempObj:ObjectBone=new ObjectBone;
				
				for(var i:int=0;i<boneAry.length;i++){
					
					var _M1:Matrix3D=new Matrix3D;
					
					var xyzfarme0:ObjectBone= boneAry[i];
					Q0=new Quaternion(xyzfarme0.qx,xyzfarme0.qy,xyzfarme0.qz);
					Q0.w= getW(Q0.x,Q0.y,Q0.z);
					var sonBone:ObjectBone=xyzfarme0;
					
					if(xyzfarme0.father==-1){
						OldQ=new Quaternion(xyzfarme0.qx,xyzfarme0.qy,xyzfarme0.qz);
						OldQ.w= getW(OldQ.x,OldQ.y,OldQ.z);
						newM=Q0.toMatrix3D();
						newM.appendTranslation(xyzfarme0.tx,xyzfarme0.ty,xyzfarme0.tz);
						//tempM=newM;
						
						xyzfarme0.qw=OldQ.w;
						xyzfarme0.matrix = newM;
						
					}else {
						var fatherBone:ObjectBone=boneAry[xyzfarme0.father];
						OldQ=new Quaternion(fatherBone.qx,fatherBone.qy,fatherBone.qz,fatherBone.qw);
						OldM=OldQ.toMatrix3D();
						OldM.appendTranslation(fatherBone.tx,fatherBone.ty,fatherBone.tz);
						var  tempV:Vector3D=OldM.transformVector(new Vector3D(sonBone.tx,sonBone.ty,sonBone.tz));
						_M1.appendTranslation(tempV.x,tempV.y,tempV.z);
						
						Q1.multiply(OldQ,Q0);
						newM=Q1.toMatrix3D();
						newM.append(_M1);
						tempM=newM;
						
						xyzfarme0.qx=Q1.x;
						xyzfarme0.qy=Q1.y;
						xyzfarme0.qz=Q1.z;
						xyzfarme0.qw=Q1.w;
						
						xyzfarme0.tx=tempV.x;
						xyzfarme0.ty=tempV.y;
						xyzfarme0.tz=tempV.z;
						xyzfarme0.tw=tempV.w;
						
						xyzfarme0.matrix = tempM;
						
					}
					//context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12+i*4,  tempM, true);
				}
			}
		}
		
		private function getW(x:Number,y:Number,z:Number):Number{
			var t:Number = 1-(x*x + y*y + z*z);
			if(t<0){
				t=0
			}else{
				t = -Math.sqrt(t);
			}
			return t;
		}*/

		public function get curentFrame():int
		{
			return _curentFrame;
		}

		public function set curentFrame(value:int):void
		{
			_curentFrame = value;
		}
		
		override public function updatePosMatrix():void{
//			var temp:Matrix3D=new Matrix3D;
//			temp.prependRotation(90, Vector3D.X_AXIS);
//			temp.prependScale(-1,1,1);
			posMatrix.identity();
			
			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
			posMatrix.prependScale(this._scale,this._scale,this._scale);
			posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
//			posMatrix.prependRotation(-90, Vector3D.X_AXIS);
//			posMatrix.prependScale(-1,1,1);
			
		}
		
		public function clone():Display3DMovie{
			var dis:Display3DMovie = new Display3DMovie(this._context);
			
			for(var key:String in _meshDic){
				dis._meshDic[key] = _meshDic[key];
			}
			
			for(key in _textureDic){
				dis._textureDic[key] = _textureDic[key];
			}
			
			for(key in _animDic){
				dis._animDic[key] = _animDic[key];
			}
			
			dis._curentAction = _curentAction
			
			return dis;
		}

		private function get playSpeed():Number
		{
			return _playSpeed;
		}

		private function set playSpeed(value:Number):void
		{
			_playSpeed = value;
			frameRate = 1/value;
		}
		/**
		 * 设置动作的播放速度 
		 * @param action 动作名称
		 * @param speed 速度
		 * 
		 */		
		public function setPlaySpeed(action:String,speed:Number):void{
			_playSpeedDic[action] = speed;
			if(_curentAction == action){
				playSpeed = _playSpeedDic[action];
			}
		}
		/**
		 * 获取动作播放速度 
		 * @param action 动作名称
		 * @return 速度Number
		 * 
		 */
		public function getPlaySpeed(action:String):Number{
			return _playSpeedDic[action];
		}
		
		public function get defaultAction():String
		{
			return _defaultAction;
		}

		public function set defaultAction(value:String):void
		{
			_defaultAction = value;
			setIsUpdate();
		}
		
		override public function dispose():void{
			super.dispose();
			_meshDic = null;
			_textureDic = null;
					
			for(var key:String in _animDic){
				delete _animDic[key];
			}
			_animDic = null;
				
			_loopDic = null;
			
			
			_boundsDic = null;
					
			_nameHeightDic = null;
			
			_posDic = null;
			
			_curentAction = null;
			
			_modelMatirx = null;
			
			_playSpeedDic = null;
			
			if(_boneUtilList){
				removeAllBoneUtil();
			}
			
			_boneUtilList = null;
				
			preLoadActionDic = null;
			
			waitLoadActionDic = null;
			
			
		}
		public function setBoneMatixt(meshData:MeshData,bindPosAry:Array):void
		{
			var ary:Array;
			if(_animDic.hasOwnProperty(_curentAction)){
				ary = _animDic[_curentAction][_curentFrame];
			}else{
				ary = _animDic[_defaultAction][_curentFrame];
			}

			
			var newAry:Array = new Array;
			
			for(var i:int=0;ary&&i<ary.length;i++){
				var baseMa:Matrix3D = ary[i].matrix;
				var bindPosMa:Matrix3D = bindPosAry[i];
				//		
				
				
				
				baseMa = baseMa.clone();
				baseMa.prepend(bindPosMa);
				newAry.push(baseMa);
			}
			
			/*if(!ary){
			return;
			}*/
			
			/*for(var i:int;i<ary.length;i++){
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12+i*4,  ary[i].matrix, true);
			}*/
			
			var boneIDary:Array = meshData.boneNewIDAry;
			//trace("vc num:" + boneIDary.length)
			for(i = 0;i<boneIDary.length;i++){
				
			
				if(true&&newAry.length){
					var baseM:Matrix3D=Matrix3D(newAry[boneIDary[i]]).clone()
					baseM.appendScale(-1,1,1)
					var q:Quaternion=new Quaternion();
					q.fromMatrix(baseM);
					var p:Vector3D=baseM.position;
					
					var vcid:uint=20+i*2
					_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,vcid+0,Vector.<Number>( [q.x,q.y,q.z,q.w]));   //等用  20
					_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,vcid+1,Vector.<Number>( [p.x,p.y,p.z,p.w]));   //等用21
					
				}else{
				//	_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 20+i*4, newAry[boneIDary[i]], true);
				}
				
				
			}
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,15,Vector.<Number>( [1,1,1,1]));   //用于给双四元数位移用
			
			
		}

		
	}
}