package _Pan3D.batch
{
	import _Pan3D.base.Focus3D;
	import _Pan3D.base.MeshData;
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.program.shaders.Md5LightShader;
	import _Pan3D.program.shaders.Md5LightSwimShader;
	import _Pan3D.program.shaders.Md5SelectShader;
	import _Pan3D.program.shaders.Md5Shader;
	import _Pan3D.program.shaders.Md5SwimShader;
	import _Pan3D.role.EquipData;
	import _Pan3D.shadow.dynamicShadow.Display3DynamicShadow;
	import _Pan3D.shadow.dynamicShadow.DynamicShadowUtilShader;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;

	/**
	 * 角色批处理渲染类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class RoleBatch
	{
		/**
		 * 所有数据列表 
		 */		
		private var _defaultDic:Object;
		private var _swimDic:Object;
		
		private var _context3D:Context3D;
		/**
		 * 游泳shader 
		 */		
		private var _swimProgram:Program3D;
		/**
		 * 默认shader 
		 */		
		private var _defaultProgram:Program3D;
		
		private var _lightProgram:Program3D;
		
		private var _lightSwimProgram:Program3D;
		/**
		 * 选中shader 
		 */		
		private var _selectProgram:Program3D;
		/**
		 * 关系字典 （key:EquipData——value:role）
		 */		
		private var _relationDic:Dictionary;
		/**
		 * 贴图字典（key:textureUrl——value:texture） 
		 */		
		private var _textDic:Object;
		/**
		 * 装备数据字典（key:equipUrl——value:meshData） 
		 */		
		private var _meshDataDic:Object;
		
		/**
		 * 角色的选中列表 
		 */		
		private var _selectList:Vector.<Display3dGameMovie>;
		
		private var _texturePriority:Vector.<Vector.<String>>;
		private var _meshPriority:Object;
		
		private var _equDataDic:Object;
		
		private static var _instance:RoleBatch;
		
		public function RoleBatch()
		{
			_defaultDic = new Object;
			_swimDic = new Object;
			
			_textDic = new Object;
			_relationDic = new Dictionary;
			_meshDataDic = new Object;
			
			_equDataDic = new Object;
			
			initPriority();
			
			_selectList = new Vector.<Display3dGameMovie>;
			
			_context3D = Scene_data.context3D;
			
			_swimProgram = Program3DManager.getInstance().getProgram(Md5SwimShader.MD5SWIMSHADER);
			_defaultProgram = Program3DManager.getInstance().getProgram(Md5Shader.MD5SHADER);
			Program3DManager.getInstance().registe(DynamicShadowUtilShader.DYNAMIC_SHADOW_SHADER,DynamicShadowUtilShader);
			_selectProgram = Program3DManager.getInstance().getProgram(Md5SelectShader.MD5_SELECT_SHADER);
			
			_lightProgram = Program3DManager.getInstance().getProgram(Md5LightShader.MD5_LIGHT_SHADER);
			_lightSwimProgram = Program3DManager.getInstance().getProgram(Md5LightSwimShader.MD5LIGHTSWIMSHADER);
			
		}
		
		public static function getInstance():RoleBatch{
			if(!_instance){
				_instance = new RoleBatch;
			}
			return _instance;
		}
		
		private function initPriority():void{
			_texturePriority = new Vector.<Vector.<String>>;
			_meshPriority = new Object;
			
			for(var i:int;i<10;i++){
				_texturePriority.push(new Vector.<String>);
			}
			
		}
		
		/**
		 * 刷帧渲染 
		 * 
		 */		
		public function update():void{
			roleDrawNum = 0;
			updateSelect();
			updateEquDic();
			resetVa();
			//trace("角色渲染次数" + roleDrawNum)
			//trace(" ******************************************分割线**************************************")
		}
		/**
		 * 共享贴图层的渲染 
		 * @param dic
		 * 
		 */		
		public function updateEquDic():void{
//			for(var key:String in dic){
//				_context3D.setTextureAt(1,_textDic[key]);
//				updateEquip(dic[key]);
//				//updateEquipList(dic[key]);
//			}
			for(var i:int;i<_texturePriority.length;i++){
				for(var j:int=0;j<_texturePriority[i].length;j++){
					_context3D.setTextureAt(1,_textDic[_texturePriority[i][j]].texture);
					updateEquip(_texturePriority[i][j]);
				}
			}
		}
		/**
		 * 共享装备数据的渲染 
		 * @param equDic
		 * 
		 */		
		private function updateEquip(key:String):void{
//			for(var key:String in equDic){
//				setVa(_meshDataDic[key]);
//				updateEquipList(equDic[key]);
//			}
			var vec:Vector.<MeshPriority> = _meshPriority[key];
			for(var i:int;i<vec.length;i++){
				setVa(_meshDataDic[vec[i].key]);
				updateEquipList(_equDataDic[vec[i].key],vec[i].key);
			}
		}
		private var _vc8:Vector.<Number> = Vector.<Number>( [1,-1,0,0.2]);
		private var _fc5:Vector.<Number> = Vector.<Number>( [1,1,1,1]);
		private var _fc2:Vector.<Number> = Vector.<Number>( [1,1,1,1]);
		/**
		 * 渲染具体的这件装备 
		 * @param equVec
		 * 
		 */		
		public function updateEquipList(equVec:Vector.<EquipData>,key:String):void{
//			resetSame(key);
			for(var i:int;i<equVec.length;i++){
				var role:Display3dGameMovie = _relationDic[equVec[i]];
				if(!role.updateAble){
					continue;
				}
				
//				if(getSameAction(role)){
//					addSame(key,equVec[i],role);
//					continue;
//				}
				
				_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, role.modelMatrix, true);
				
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,8,Vector.<Number>([role.levHeight, -1, 0, 0.2]));
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, Vector.<Number>([role.color.x,role.color.y,role.color.z, role._alpha]));
				
				setVcFc(role);
				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,8,_vc8);
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, _fc5);
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, _fc2);
				
				setVc(role,equVec[i].meshData);
				
				draw(equVec[i].meshData);
			}
			
//			renderSame(key);
		}
		
		public function renderSame(key:String):void{
			for each(var actionAry:Array in sameDic[key]){
				renderSameAry(actionAry);
			}
		}
		
		public function renderSameAry(ary:Array):void{
			for(var i:int;i<ary.length;i++){
				if(ary[i] && ary[i].length){
					var role:Display3dGameMovie = _relationDic[ary[i][0]];
					_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,8,_vc8);
					_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, _fc5);
					setVc(role,ary[i][0].meshData);
					for(var j:int=0;j<ary[i].length;j++){
						role = _relationDic[ary[i][j]];
						
						_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, role.modelMatrix, true);
						setVcFc(role);
						
						draw(ary[i][j].meshData);
					}
				}
			}
		}
		
//		public function getSameAction(role:Display3dGameMovie):Boolean{
//			return (role.curentAction == "stand" ||
//			role.curentAction == "walk"  ||
//			role.curentAction == "sit"   ||
//			role.curentAction == "stand_mount" ||
//			role.curentAction == "walk_mount"  ||
//			role.curentAction == "stand_swim"  ||
//			role.curentAction == "walk_swim");
//		}
		
		public var sameDic:Object = new Object;
		public function addSame(key:String,equipData:EquipData,role:Display3dGameMovie):Boolean{
			
			if(!sameDic[key]){
				sameDic[key] = new Object;
			}
			
			var ary:Array;
			
			if(!sameDic[key][role.curentAction]){
				sameDic[key][role.curentAction] = new Array;
			}
			
			ary = sameDic[key][role.curentAction];
			
			if(!ary[role.curentFrame]){
				ary[role.curentFrame] = new Array;
			}
			
			ary[role.curentFrame].push(equipData);
			
			return true;
		}
		
		public function resetSame(key:String):void{
			var obj:Object = sameDic[key]
			for(var newKey:String in obj){
				var ary:Array = obj[newKey];
				for(var i:int=0;i<ary.length;i++){
					if(ary[i]){
						ary[i].length = 0;
					}
				}
			}
		}
		
		public function setVcFc(role:Display3dGameMovie):void{
			_vc8[0] = role.levHeight;
			_fc5[0] = role.color.x;
			_fc5[1] = role.color.y;
			_fc5[2] = role.color.z;
			_fc5[3] = role._alpha;
			
			_fc2[0] = -role.allRunTime * 0.001 / 16;
			_fc2[1] = -role.allRunTime * 0.004 / 16;
			
		}
		
		private function getEqu(equVec:Vector.<EquipData>):void{
			var ary:Array = new Array(80);
			for(var i:int;i<equVec.length;i++){
				var role:Display3dGameMovie = _relationDic[equVec[i]];
				if(ary[role.curentFrame] == null){
					ary[role.curentFrame] = 0;
				}
				ary[role.curentFrame]++;
			}
			var flag:int;
			for(i=0;i<ary.length;i++){
				if(ary[i] > 1){
					trace(i + ":" + ary[i])
					flag++;
				}
			}
			trace("---------------------------- " + int(flag/equVec.length*100) + "%")
		}
		/**
		 * 刷入va数据 
		 * @param meshData
		 * 
		 */		
		protected function setVa(meshData:MeshData):void{
			if(Scene_data.compressBuffer){
				_context3D.setVertexBufferAt(0,meshData.vertexBuffer1, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(1,meshData.vertexBuffer1, 3, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(2,meshData.vertexBuffer1, 6, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(3,meshData.vertexBuffer1, 9, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(4,meshData.vertexBuffer1, 12, Context3DVertexBufferFormat.FLOAT_2);
				_context3D.setVertexBufferAt(5,meshData.vertexBuffer1, 14, Context3DVertexBufferFormat.FLOAT_4);
				_context3D.setVertexBufferAt(6,meshData.vertexBuffer1, 18, Context3DVertexBufferFormat.FLOAT_4);	
			}else{
				_context3D.setVertexBufferAt(0,meshData.vertexBuffer1, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(1,meshData.vertexBuffer2, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(2,meshData.vertexBuffer3, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(3,meshData.vertexBuffer4, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(4,meshData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				_context3D.setVertexBufferAt(5,meshData.boneWeightBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
				_context3D.setVertexBufferAt(6,meshData.boneIdBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			}
		}
		/**
		 * draw 
		 * @param meshData
		 * 
		 */	
		private var roleDrawNum:int;
		private function draw(meshData:MeshData):void{
			_context3D.drawTriangles(meshData.indexBuffer, 0, -1);
			roleDrawNum++;
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(meshData.faceNum);
		}
		/**
		 * 设置vc数据 
		 * @param role
		 * @param meshData
		 * 
		 */		
		protected function setVc(role:Display3dGameMovie,meshData:MeshData):void{
			role.setMeshVc(meshData);
			if(role.islight){
				if(role.isSwim){
					_context3D.setProgram(this._lightSwimProgram);
				}else{
					_context3D.setProgram(this._lightProgram);
				}
				_context3D.setTextureAt(2,role.lightTextureVo.texture);
			}else{
				if(role.isSwim){
					_context3D.setProgram(this._swimProgram);
				}else{
					_context3D.setProgram(this._defaultProgram);
				}
				_context3D.setTextureAt(2,null);
			}
			
			
		}
		
		protected function resetVa():void{
			_context3D.setVertexBufferAt(0,null, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1,null, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(2,null, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(3,null, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(4,null, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context3D.setVertexBufferAt(5,null, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context3D.setVertexBufferAt(6,null, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context3D.setTextureAt(1,null);
			_context3D.setTextureAt(2,null);
		}
		
//		public function addEquip(equip:EquipData,role:Display3dGameMovie,isSwim:Boolean = false):void{
//			if(isSwim){
//				if(!_swimDic.hasOwnProperty(equip.textureUrl)){
//					_swimDic[equip.textureUrl] = new Vector.<EquipData>;
//				}
//				_swimDic[equip.textureUrl].push(equip);
//			}else{
//				if(!_defaultDic.hasOwnProperty(equip.textureUrl)){
//					_defaultDic[equip.textureUrl] = new Vector.<EquipData>;
//				}
//				_defaultDic[equip.textureUrl].push(equip);
//			}
//			_textDic[equip.textureUrl] = equip.texture;
//			_relationDic[equip] = role;
//		}
		
		/**
		 * 添加一件装备到角色渲染机 
		 * @param equip 装备
		 * @param role 隶属的角色
		 * 
		 * ----textureUrl贴图路径
		 * -------meshDataDic装备数据列表
		 * 
		 */		
		public function addEquip(equip:EquipData,role:Display3dGameMovie):void{
			//return;
			if(role.isInUI || role.is3D){
				return;
			}
//			if(equip.meshData.key == null){
//				trace(equip.meshData.hasDispose)
//				trace(123);
//			}
			//初始化装备列表
			if(!_equDataDic.hasOwnProperty(equip.meshData.key)){
				_equDataDic[equip.meshData.key] = new Vector.<EquipData>;
			}
			
			_equDataDic[equip.meshData.key].push(equip);
			
			if(!_textDic[equip.textureUrl]){
				if(equip.textureUrl.indexOf("super") != -1){//带有super字符名称的贴图都是比较特殊的透贴 保证后渲染
					_texturePriority[_texturePriority.length-1].push(equip.textureUrl);
				}else{
					_texturePriority[equip.renderPriority].push(equip.textureUrl);
				}
				
			}
			
			//将贴图写入字典
			_textDic[equip.textureUrl] = equip.textureVo;
			//关系列表
			_relationDic[equip] = role;
			//将装备数据写入字典
			_meshDataDic[equip.meshData.key] = equip.meshData;
			
			
			if(!_meshPriority[equip.textureUrl]){
				_meshPriority[equip.textureUrl] = new Vector.<MeshPriority>;
			}
			var equKeyList:Vector.<MeshPriority> = _meshPriority[equip.textureUrl];
			if(!hasMeshKey(equip.meshData.key,equKeyList)){
				equKeyList.push(new MeshPriority(equip.meshData.key,equip.renderPriority));
				equKeyList.sort(sortEquipList);
			}
			
		}
		
		private function hasMeshKey(key:String,vec:Vector.<MeshPriority>):Boolean{
			for(var i:int;i<vec.length;i++){
				if(vec[i].key == key){
					return true;
				}
			}
			return false;
		}
		
		public function sortEquipList(a:MeshPriority,b:MeshPriority):int{
			return a.priority - b.priority;
		}
		
		
		/**
		 * 移除一件装备 
		 * @param equip 装备数据
		 * @param role 隶属角色
		 * 
		 */		
		public function removeEquip(equip:EquipData,role:Display3dGameMovie):void{
			if(role.isInUI){
				return;
			}
			//找到这件装备存储的节点
			var list:Vector.<EquipData> = _equDataDic[equip.meshData.key];
			if(!list){//装备已经被移除
				return;
			}
			var index:int = list.indexOf(equip);
			if(index != -1){
				list.splice(index,1);
			}
			//若该装备路径下的列表为空则删除该列表
			if(list.length == 0){
				delete _equDataDic[equip.meshData.key];
				delete _meshDataDic[equip.meshData.key];
				
				var vec:Vector.<MeshPriority> = _meshPriority[equip.textureUrl];
				for(index = 0;index<vec.length;index++){
					if(vec[index].key == equip.meshData.key){
						vec.splice(index,1);
						break;
					}
				}
				
				if(vec.length == 0){
					delete _meshPriority[equip.textureUrl];
					delete _textDic[equip.textureUrl];
					
					for(var i:int=0;i<_texturePriority.length;i++){
						for(var j:int=0;j<_texturePriority[i].length;j++){
							if(_texturePriority[i][j] == equip.textureUrl){
								_texturePriority[i].splice(j,1);
								break;
							}
						}
					}
					
				}
					
			}
			delete _relationDic[equip];

		}
		
		//角度X
		public var shadowAnglX:Number=-35;
		//角度y
		public var shadowAngleY:Number=30;

		public var _projMatrix:Matrix3D=new Matrix3D();
		public function updateShadow(ary:Array):void
		{
//			_context3D.setRenderToTexture(Display3DynamicShadow.npcShadowText,true)
//			_context3D.clear(0, 0, 0, 0);
//			var focus3D:Focus3D= Scene_data.focus3D.cloneFocus3D()
//			focus3D.angle_y=Scene_data.focus3D.angle_y+shadowAngleY
//			focus3D.angle_x=shadowAnglX;
//			MathCore.catch_shadow_cam(Scene_data.cam3D,focus3D);
			_context3D.setProgram(Program3DManager.getInstance().getProgram(DynamicShadowUtilShader.DYNAMIC_SHADOW_SHADER));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([0,0,0,0.5]));
			
			_projMatrix.identity();
			_projMatrix.appendScale(0.001,0.001,0.00025);
			_projMatrix.appendTranslation(0,0,0.1);
			
			_projMatrix.prepend(Scene_data.cam3D.cameraMatrix);
			
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _projMatrix, true);
			
			
//			for(var i:int;i<ary.length;i++){
//				ary[i].updateMatrix();
//			}
			
			updateShadowEquDic(_defaultDic);
			resetVa();
			
//			_context3D.setRenderToBackBuffer();
//			Display3DynamicShadow.shadowCamMatrix =Scene_data.cam3D.cameraMatrix.clone()
//			MathCore._catch_cam(Scene_data.cam3D, Scene_data.focus3D);
		}
		
		/**
		 * 共享贴图层的影子渲染 
		 * @param dic
		 * 
		 */		
		public function updateShadowEquDic(dic:Object):void{
			for(var key:String in _equDataDic){
				setVaShadow(_meshDataDic[key]);
				updateShadowEquipList(_equDataDic[key]);
			}
		}
		
		/**
		 * 共享装备数据的影子渲染 
		 * @param equDic
		 * 
		 */		
		private function updateShadowEquip(equDic:Object):void{
			for(var key:String in equDic){
				setVaShadow(_meshDataDic[key]);
				updateShadowEquipList(equDic[key]);
			}
		}
		/**
		 * 渲染具体的这件装备 影子
		 * @param equVec
		 * 
		 */		
		public function updateShadowEquipList(equVec:Vector.<EquipData>):void{
			for(var i:int;i<equVec.length;i++){
				var role:Display3dGameMovie = _relationDic[equVec[i]];
				if(!role.updateAble || !role.hasShadow || role.excludShadow){
					continue;
				}
				//role.updateMatrix();
				role.updateShadowMatrix();
				_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, role.modelShadowMatrix, true);
				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,8,Vector.<Number>([0, -1, 0, 2]));
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, Vector.<Number>([1, role.alpha, 0.2, 0.8]));
				setVcShadow(role,equVec[i].meshData);
				draw(equVec[i].meshData);
			}
		}
		
		/**
		 * 刷入va数据 
		 * @param meshData
		 * 
		 */		
		protected function setVaShadow(meshData:MeshData):void{
			
			
			if(Scene_data.compressBuffer){
				_context3D.setVertexBufferAt(0,meshData.vertexBuffer1, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(1,meshData.vertexBuffer1, 3, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(2,meshData.vertexBuffer1, 6, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(3,meshData.vertexBuffer1, 9, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(5,meshData.vertexBuffer1, 14, Context3DVertexBufferFormat.FLOAT_4);
				_context3D.setVertexBufferAt(6,meshData.vertexBuffer1, 18, Context3DVertexBufferFormat.FLOAT_4);	
			}else{
				_context3D.setVertexBufferAt(0,meshData.vertexBuffer1, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(1,meshData.vertexBuffer2, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(2,meshData.vertexBuffer3, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(3,meshData.vertexBuffer4, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(5,meshData.boneWeightBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
				_context3D.setVertexBufferAt(6,meshData.boneIdBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			}
		}
		
		/**
		 * 设置vc数据 
		 * @param role
		 * @param meshData
		 * 
		 */		
		protected function setVcShadow(role:Display3dGameMovie,meshData:MeshData):void{
			role.setMeshVc(meshData);
		}
		
		
		public function addSelect(role:Display3dGameMovie):void{
			var index:int = _selectList.indexOf(role);
			if(index != -1){
				return;
			}
			_selectList.push(role);
		}
		
		public function removeSelect(role:Display3dGameMovie):void{
			var index:int = _selectList.indexOf(role);
			if(index != -1){
				_selectList.splice(index,1);
			}
		}
		
		public function updateSelect():void{
			_context3D.setDepthTest(false,Context3DCompareMode.LESS);
			_context3D.setProgram(this._selectProgram);
			
			for(var i:int;i<_selectList.length;i++){
				_selectList[i].updateSelect();
			}
			
			_context3D.setDepthTest(true,Context3DCompareMode.LESS);
		}
		
		public function reload():void{
			_context3D = Scene_data.context3D;
//			for each(var key:String in _textDic){
//				_textDic[key] = TextureManager.getInstance().reloadTexture(key);
//			}
			_swimProgram = Program3DManager.getInstance().getProgram(Md5SwimShader.MD5SWIMSHADER);
			_defaultProgram = Program3DManager.getInstance().getProgram(Md5Shader.MD5SHADER);
			//Program3DManager.getInstance().registe(DynamicShadowUtilShader.DYNAMIC_SHADOW_SHADER,DynamicShadowUtilShader);
			_selectProgram = Program3DManager.getInstance().getProgram(Md5SelectShader.MD5_SELECT_SHADER);
			
			_lightProgram = Program3DManager.getInstance().getProgram(Md5LightShader.MD5_LIGHT_SHADER);
			_lightSwimProgram = Program3DManager.getInstance().getProgram(Md5LightSwimShader.MD5LIGHTSWIMSHADER);
		}
		
		
	}
	
}

