package  renderLevel
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.base.MeshDataSelect;
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DBindMovie;
	import _Pan3D.display3D.analysis.TBNUtils;
	import _Pan3D.event.PlayEvent;
	import _Pan3D.role.BonePrototypeManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.utils.MeshToObjUtils;
	
	import _me.Scene_data;
	
	public class Display3DMovieLocal extends Display3DBindMovie
	{
		//private var _pause:Boolean;
		private var _lineMeshData:Object;
		private var _showLineBone:Boolean;
		private var _hasLineData:Boolean;
		private var _showMesh:Boolean = true;
		private var _skillMode:Boolean;
		private var _textureLightDic:Object;
		
		public var fileScale:Number = 1;
		
		public function Display3DMovieLocal(context:Context3D)
		{
			super(context);
			beginTime = getTimer();
			
			_textureLightDic = new Object;
		}
		public function addAnimLocal(name:String,ary:Array,bounds:Object=null,posAry:Vector.<Vector3D> = null):void{
			_animDic[name] = ary;
			//_curentAction = name;
			_curentFrame = 0;
			if(bounds){
				_boundsDic[name] = bounds;
			}
			
			if(posAry){
				_posDic[name] = posAry;
			}
		}
		
		public function getAnimNameList():Array{
			var ary:Array = new Array;
			for(var key:String in _animDic){
				ary.push(key);
			}
			return ary;
		}
		
		public function addTextureLocal(place:String,texture:Texture):void{
			_textureDic[place] = texture;
		}
		
		public function addTextureLightLocal(place:String,texture:Texture):void{
			_textureLightDic[place] = texture;
		}
		
		public function addMeshLocal(place:String,meshData:MeshData):void{
			meshData.texture = _textureDic[place];
			_meshDic[place] = meshData;
		}
		
		public function addMeshLightLocal(place:String,meshData:MeshData):void{
			meshData.lightTexture = _textureLightDic[place];
			//_meshDic[place] = meshData;
		}
		
		public function addMeshLineLocal(place:String,meshData:MeshData):void{
			meshData.texture = _textureDic[place];
			_lineMeshData[place] = meshData;
		}
		
		public function removeMeshLocal(place:String):Object{
			delete _meshDic[place];
			return _meshDic;
		}
		public function removeAllMesh():void{
			
		}
		public function addPrototype():void{
			if(_lineMeshData){
				_showLineBone = !_showLineBone;
			}else{
				_lineMeshData = new Object;
				_showLineBone = true;
			}
			
			if(_hasLineData){
				return;
			}
			//_meshDic = new Object;
			var boneLength:int = -1;
			var boneAry:Array;
			for(var key:String in _animDic){
				boneLength = _animDic[key][0].length;
				boneAry = _animDic[key][0];
				break;
			}
			
			var bitmapdata:BitmapData = new BitmapData(128,128,true,0xff00ff00);
			var texture:Texture = TextureManager.getInstance().bitmapToTexture(bitmapdata)//_context.createTexture(bitmapdata.width,bitmapdata.height,Context3DTextureFormat.BGRA, true);
			//texture.uploadFromBitmapData(bitmapdata);
			
			bitmapdata = new BitmapData(128,128,true,0xffff0000);
			var texture2:Texture = TextureManager.getInstance().bitmapToTexture(bitmapdata)//_context.createTexture(bitmapdata.width,bitmapdata.height,Context3DTextureFormat.BGRA, true);
			//texture2.uploadFromBitmapData(bitmapdata);
			
			bitmapdata = new BitmapData(128,128,true,0xffffff00);
			var seletTexture:Texture = TextureManager.getInstance().bitmapToTexture(bitmapdata)//_context.createTexture(bitmapdata.width,bitmapdata.height,Context3DTextureFormat.BGRA, true);
			//seletTexture.uploadFromBitmapData(bitmapdata);
			
			if(boneLength != -1){
				for(var i:int=0;i<boneLength;i++){
					var mesh:MeshData = BonePrototypeManager.getInstance().getLineMeshData(i,boneAry[i].father);
					addTextureLocal("$bone" + i,texture);
					addMeshLineLocal("$bone" + i,mesh);
					
					mesh = BonePrototypeManager.getInstance().getKeyMeshData(i);
					MeshDataSelect(mesh).selectedTexture = seletTexture;
					addTextureLocal("#bone" + i,texture2);
					addMeshLineLocal("#bone" + i,mesh);
				}
			}
			
			_hasLineData = true;
			
		}
		
		public function addBounds():void{
			
		}
		
		public function setSelectIndex(index:int,tf:Boolean):void{
			if(!_lineMeshData){
				return;
			}
			var meshdataSel:MeshDataSelect = _lineMeshData["#bone" + index] as MeshDataSelect;
			if(meshdataSel){
				meshdataSel.selected = tf;
			}
		}
		
		public function showMesh():void{
			_showMesh = !_showMesh;
		}
		
		public var beginTime:int;
		
		
		private var lightTime:int;
		
		override public function update():void{
			if(!this._visible){
				return;
			}
			if(!_animDic.hasOwnProperty(_curentAction)){
				return;
			}
			
			var t:int = getTimer();
			
			updateFrame(t - beginTime);
			beginTime = t;
			
			this.updatePosMatrix();
			
			_context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			if(_showMesh){
				updateMaterila();
			}
			
			_context.setDepthTest(true,Context3DCompareMode.ALWAYS);
			if(_showLineBone){
				updateLine();
				_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, Scene_data.cam3D.cameraMatrix, true);
			}
			_context.setDepthTest(true,Context3DCompareMode.LESS);
			
		}
		
		public function getMeshDic():Object{
			return this._meshDic;
		}
		
		public function getObjDic():Dictionary{
			return this._objDic;
		}
		
		public function getParticleDic():Object{
			return this._particleList;
		}
		
		public function getSocketDic():Object{
			return this._socketDic;
		}
		
		public function updateLine():void{
			_context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			_context.setProgram(this.program);
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, Vector.<Number>([1, 1, 1, 0.5]));
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,8,Vector.<Number>([10, -1, 0, 0]));
			
			
			for each(var meshData:MeshData in _lineMeshData){
				setLineVc(meshData);
				setLineVa(meshData);
			}
			
			resetLineVa();
			
		}
		
		override public function setProgram3D(value:Program3D):void{
			program = value;
		}
		
		
		public function setMaterialMesh(meshData:MeshData):void{
			
		}
		
		
		
		public function updataFrame(t:Number):void{
			_curentFrame = t/Scene_data.frameTime/2;
			if(_curentAction && _animDic.hasOwnProperty(_curentAction)){
				if(_curentFrame >= _animDic[_curentAction].length){
					if(_isLoop){
						_curentFrame = _curentFrame%_animDic[_curentAction].length;
					}else{
						_curentFrame = 0;
					}
				}
			}
		}
		
		private var _objDic:Dictionary = new Dictionary;
		
		override public function setMeshVc(meshData:MeshData):void{
			var obj:ObjData = _objDic[meshData];
			if(!obj){
				obj = new MeshToObjUtils().getObj(meshData);
				TBNUtils.processTBN(obj,true);
				
				obj.tangentsBuffer = this._context.createVertexBuffer(obj.tangents.length / 4, 4);
				obj.tangentsBuffer.uploadFromVector(Vector.<Number>(obj.tangents), 0, obj.tangents.length / 4);
				
				obj.bitangentsBuffer = this._context.createVertexBuffer(obj.bitangents.length / 4, 4);
				obj.bitangentsBuffer.uploadFromVector(Vector.<Number>(obj.bitangents), 0, obj.bitangents.length / 4);
				
				_objDic[meshData] = obj;
			}
			
			setStaticVc(meshData,obj.bindPosAry);
			
		}
		
		public function setLineVc(meshData:MeshData):void{
			var ary:Array;
			if(_animDic[_curentAction]){
				ary = _animDic[_curentAction][_curentFrame];
			}else{
				ary = _animDic[_defaultAction][_curentFrame];
			}
			
			var boneIDary:Array = meshData.boneNewIDAry;
			
			for(var i:int = 0;i<boneIDary.length;i++){ 
				_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 20+i*4,  ary[boneIDary[i]].matrix, true);
			}
		}
		
		public function setLineVa(meshData:MeshData):void{
			
			_context.setVertexBufferAt(0,meshData.vertexBuffer1, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1,meshData.vertexBuffer2, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(2,meshData.vertexBuffer3, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(3,meshData.vertexBuffer4, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(4,meshData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setVertexBufferAt(5,meshData.boneWeightBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context.setVertexBufferAt(6,meshData.boneIdBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context.setTextureAt(1,meshData.texture);
			_context.drawTriangles(meshData.indexBuffer, 0, -1);
			
		}
		
		public function resetLineVa():void{
			_context.setVertexBufferAt(0,null);
			_context.setVertexBufferAt(1,null);
			_context.setVertexBufferAt(2,null);
			_context.setVertexBufferAt(3,null);
			_context.setVertexBufferAt(4,null);
			_context.setVertexBufferAt(5,null);
			_context.setVertexBufferAt(6,null);
			
			_context.setTextureAt(1,null);
			
		}
		
		override protected function setMeshVa(meshData:MeshData):void{
			var obj:ObjData = _objDic[meshData];
			
			_context.setVertexBufferAt(0,obj.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1,obj.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setVertexBufferAt(2,meshData.boneWeightBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context.setVertexBufferAt(3,meshData.boneIdBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			
			if(meshData.material.directLight || meshData.material.usePbr){
				_context.setVertexBufferAt(4,obj.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
				
				if(meshData.material.useNormal){
					_context.setVertexBufferAt(5,obj.tangentsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
					_context.setVertexBufferAt(6,obj.bitangentsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
				}
			}
			
			
			
		}
		
		override protected function resetVa():void{
			_context.setVertexBufferAt(0,null);
			_context.setVertexBufferAt(1,null);
			_context.setVertexBufferAt(2,null);
			_context.setVertexBufferAt(3,null);
			_context.setVertexBufferAt(4,null);
			_context.setVertexBufferAt(5,null);
			_context.setVertexBufferAt(6,null);
		}
		
		public function setStaticVc(meshData:MeshData,bindPosAry:Array):void{
			
			this.setBoneMatixt(meshData,bindPosAry)
		}
		
		override public function setFrame():void{
			//			if(_skillMode){
			//				
			//			}else{
			if(pause){
				
			}else{
				super.setFrame();
			}
			//			}
			//AppData.boundsLevel.refreshData(_boundsDic[_curentAction][_curentFrame]);
		}
		
		public function updateFrame(t:int):void{
			this.updateMatrix();
			if(_pause){
				return;
			}
			_time += t;
			calculateFrame();
		}
		
		override public function calculateFrame():void{
			if(_curentAction && _animDic.hasOwnProperty(_curentAction)){
				_curentFrame = _time/(frameRate*Scene_data.frameTime*2);
				if(_curentFrame >= _animDic[_curentAction].length){
					if(_completeState == 0){
						//trace("动作用时：" + _time)
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
		
		
		public function nextFrame():void{
			if(_curentAction && _animDic.hasOwnProperty(_curentAction)){
				_time += (frameRate*Scene_data.frameTime*2)
				calculateFrame();
				/*_curentFrame++;
				
				if(_curentFrame >= _animDic[_curentAction].length){
				_curentFrame = 0;
				playOver();
				}*/
				
			}
		}
		public function perFrame():void{
			if(_curentAction && _animDic.hasOwnProperty(_curentAction)){
				_time -= (frameRate*Scene_data.frameTime*2)
				calculateFrame();
				/*_curentFrame--;
				
				if(_curentFrame < 0){
				_curentFrame = _animDic[_curentAction].length-1;
				}*/
			}  
		}
		
		override public function gotoAndStop(value:int):void{
			if(_curentAction && _animDic.hasOwnProperty(_curentAction)){
				if(value < _animDic[_curentAction].length){
					_curentFrame = value;
				}else{
					_curentFrame = _animDic[_curentAction].length-1;
				}
				_time = (frameRate*Scene_data.frameTime*2) * _curentFrame;
				calculateFrame();
			}
			_pause = true;
		}
		
		public function get pause():Boolean
		{
			return _pause;
		}
		
		public function set pause(value:Boolean):void
		{
			_pause = value;
		}
		
		public function clearData():void{
			trace("clear");
			_animDic = new Object;
			_textureDic = new Object;
			_meshDic = new Object;
			/*for(var key:String in _animDic){
			delete _animDic[key];
			}
			for(key in _textureDic){
			delete _textureDic[key];
			}
			for(key in _meshDic){
			delete _meshDic[key];
			}*/
			
		}
		
		//public var bindParticle:CombineParticle;
		
		
		public function get skillMode():Boolean
		{
			return _skillMode;
		}
		
		public function set skillMode(value:Boolean):void
		{
			_skillMode = value;
		}
		
		//		override public function updataPos():void{
		//		//	return;
		//			//super.updataPos();
		//			if(AppData.is3d){
		//				super.updataPos();
		//				return;
		//			}
		////			var xpos:Number;
		////			var ypos:Number;
		////			if(this.parent){
		////				xpos = this._x + this.parent.x;
		////				ypos = this._y + this.parent.y;
		////			}else{
		////				xpos = this._x;
		////				ypos = this._y;
		////			}
		////			_absoluteX=(Scene_data.tx2D+Scene_data.cam3D.fovw/2*2/Scene_data.mainScale)*Scene_data.sw2D;
		////			_absoluteY=0;
		////			_absoluteZ=(Scene_data.ty2D-Scene_data.cam3D.fovh/2*(2/Scene_data.mainScale/Scene_data.sinAngle2D))*Scene_data.sw2D;
		//			updatePosMatrix();
		//		}
		
		override public function updatePosMatrix():void{
			//this._scale = Scene_data.mainScale/2;
			this._scale = fileScale;
			//			this._scale *= 5;
			super.updatePosMatrix();
			
		}
		
		override public function set rotationY(value:Number):void{
			super.rotationY = value;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 获取骨骼挂点在世界中的绝对位置
		 *  <b>被绑定接口</b>
		 * @param index 骨骼号
		 * @return 位置
		 * 
		 */
		override public function getPosV3d(index:int,resultV3d:Vector3D):void{
			var _posVec:Vector.<Number> = Vector.<Number>( [0,0,0]);
			var _posMatrix:Matrix3D = new Matrix3D;
			var testmatix:Matrix3D;
			if(index == -1){
				setTo(_posVec,0,0,0);
			}else{
				if(_animDic[_curentAction]){
					testmatix = _animDic[_curentAction][_curentFrame][index].matrix;
					setTo(_posVec,testmatix.position.x,testmatix.position.y,testmatix.position.z);
				}else if(_animDic[_defaultAction]){
					testmatix = _animDic[_defaultAction][_curentFrame][index].matrix;
					setTo(_posVec,testmatix.position.x,testmatix.position.y,testmatix.position.z);
				}else{
					setTo(_posVec,0,0,0);
				}
			}
			
			if(bindTarget){
				_posMatrix.identity();
				_posMatrix.prependScale(this.scale,this.scale,this.scale);
				_posMatrix.transformVectors(_posVec,_posVec);
				
				testmatix = bindMatrix;
				
				testmatix.transformVectors(_posVec,_posVec);
				_posVec[0] += this.bindVecter3d.x;
				_posVec[1] += this.bindVecter3d.y;
				_posVec[2] += this.bindVecter3d.z;
				
			}else{
				_posMatrix.identity();
				_posMatrix.appendScale(_scale,_scale,_scale);
				_posMatrix.appendRotation(this.rotationY,Vector3D.Y_AXIS);
				
				_posMatrix.transformVectors(_posVec,_posVec);
				_posVec[0] += this._absoluteX
				_posVec[1] += this._absoluteY;
				_posVec[2] += this._absoluteZ;
			}
			
			resultV3d.setTo(_posVec[0],_posVec[1],_posVec[2]);
		}
		
		/**
		 * 距离骨骼点指定偏移量 在世界中的绝对位置
		 * <b>被绑定接口</b>
		 * @param v3d 指定偏移
		 * @param index 骨骼序列号
		 * @return 位置
		 * 
		 */
		override public function getOffsetPos(v3d:Vector3D,index:int):Vector3D{
			var testmatix:Matrix3D;
			var result3D:Vector3D;
			if(index == -1){
				if(bindTarget){
					testmatix = bindMatrix;
					testmatix.prependScale(this.scale,this.scale,this.scale);
					result3D = testmatix.transformVector(v3d);
					result3D.x += this.bindVecter3d.x;
					result3D.y += this.bindVecter3d.y;
					result3D.z += this.bindVecter3d.z;
				}else{
					testmatix = new Matrix3D; 
					testmatix.appendScale(_scale,_scale,_scale);
					testmatix.appendRotation(this.rotationY,Vector3D.Y_AXIS);
					result3D = testmatix.transformVector(v3d);
					result3D.x += this._absoluteX;
					result3D.y += this._absoluteY;
					result3D.z += this._absoluteZ; 
				}
			}else{
				if(_animDic[_curentAction]){
					testmatix = _animDic[_curentAction][_curentFrame][index].matrix;
				}else if(_animDic["stand"]){
					testmatix = _animDic["stand"][_curentFrame][index].matrix;
				}else{
					testmatix = new Matrix3D;
				}
				result3D = testmatix.transformVector(v3d);
				
				if(bindTarget){
					var selfMatrix:Matrix3D = new Matrix3D;
					selfMatrix.prependScale(this.scale,this.scale,this.scale);
					result3D = selfMatrix.transformVector(result3D);
					testmatix = bindMatrix;
					result3D = testmatix.transformVector(result3D);
					result3D.x += this.bindVecter3d.x;
					result3D.y += this.bindVecter3d.y;
					result3D.z += this.bindVecter3d.z;
				}else{
					testmatix = new Matrix3D;
					testmatix.appendScale(_scale,_scale,_scale);
					testmatix.appendRotation(this.rotationY,Vector3D.Y_AXIS);
					result3D = testmatix.transformVector(result3D);
					
					result3D.x += this._absoluteX;
					result3D.y += this._absoluteY;
					result3D.z += this._absoluteZ;
				}
				
			}
			
			
			return result3D;
		}
		/**
		 * 骨骼点的旋转矩阵 
		 * <b>被绑定接口</b>
		 * @param index 骨骼序列号
		 * @return 旋转矩阵（仅包含旋转）
		 * 
		 */
		override public function getPosMatrix(index:int):Matrix3D{
			var testmatix:Matrix3D;
			var temp:Matrix3D;
			if(index == -1){
				if(bindTarget){
					temp = bindMatrix;
				}else{
					temp = new Matrix3D;
					temp.appendRotation(this.rotationY,Vector3D.Y_AXIS);
				}
			}else{
				if(_animDic[_curentAction]){
					testmatix = _animDic[_curentAction][_curentFrame][index].matrix;
				}else if(_animDic["stand"]){
					testmatix = _animDic["stand"][_curentFrame][index].matrix;
				}else{
					testmatix = new Matrix3D;
				}
				temp = testmatix.clone();
				temp.appendTranslation(-testmatix.position.x,-testmatix.position.y,-testmatix.position.z);
				if(bindTarget){
					temp.append(bindMatrix);
					//temp.prependScale(bindTarget.getScale(),bindTarget.getScale(),bindTarget.getScale());
				}else{
					temp.appendRotation(this.rotationY,Vector3D.Y_AXIS);
				}
			}
			return temp;
		}
		
		public function get showLineBone():Boolean
		{
			return _showLineBone;
		}
		
		override protected function getFrameMatrix(index:int):Matrix3D{
			if(_animDic){
				if(_animDic[_curentAction] && _animDic[_curentAction][_curentFrame] && _animDic[_curentAction][_curentFrame][index]){
					return _animDic[_curentAction][_curentFrame][index].matrix;
				}else if(_animDic[_defaultAction] && _animDic[_defaultAction][_curentFrame] && _animDic[_defaultAction][_curentFrame][index]){
					return _animDic[_defaultAction][_curentFrame][index].matrix;
				}
			}
			return null;
		}
		
		
	}
}