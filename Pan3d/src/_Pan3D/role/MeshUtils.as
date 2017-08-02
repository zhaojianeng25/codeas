package _Pan3D.role
{
	import _Pan3D.base.MeshData;
	import _Pan3D.display3D.Display3DBindMovie;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.mesh.MeshByteVo;
	import _Pan3D.vo.mesh.MeshVo;
	import _Pan3D.vo.particle.ParticleVo;
	import _Pan3D.vo.pos.PosVo;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import flash.display3D.textures.Texture;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

	/**
	 * 装备（多个Mesh）加载工具类
	 * 负责加载mesh相关的模型数据，贴图，粒子信息 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class MeshUtils
	{
		/**
		 * 加载完成后的回调函数 
		 */		
		private var _fun:Function;
		/**
		 * 加载完成后添加位置的回调函数 
		 */		
		private var _posFun:Function;
		/**
		 * 加载的多mesh信息 
		 */		
		private var _data:Object;
		private var _ridePos:Vector.<PosVo>;
		//private var _preUrl:String = "assets/exp/";
		//private var _preUrl:String = "../res/data/res3d/";
		//private var _equipData:EquipData;
		/**
		 * 唯一标示（加载路径） 
		 */		
		private var _key:String;
		private var _apd:AvatarParamData;
		/**
		 * mesh的缓存池 
		 */		
		public static var dic:Object = new Object;
		/**
		 * 加载的队列字典 
		 */		
		public static var loadDic:Object = new Object;
		/**
		 * 是否用于UI 
		 */		
		private var _isInUI:Boolean;
		
		private var _isInterrupt:Boolean;
		/**
		 * 移除列表的回调函数
		 */		
		private var _removeListFun:Function;
		
		private var _loadNum:int;
		private var _allLoadNum:int;
		
		private var _bindTarget:Display3dGameMovie;
		
		private var _priority:int;
		
		public function MeshUtils()
		{
		}
		/**
		 * 添加一件装备 
		 * @param url 装备路径
		 * @param fun 加载完成后的回调函数
		 * @param posFun 加载完成添加位置信息的回调函数
		 * @param data 此装备的信息
		 * @param isInUI 此装备是否是在ui中显示
		 * 
		 */		
		public function addEquip(url:String,fun:Function,posFun:Function,data:AvatarParamData,removeListFun:Function,bindTarget:Display3dGameMovie,$priority:int,isInUI:Boolean=false):void{
			_key = url;
			_fun = fun;
			_posFun = posFun;
			_apd = data;
			_isInUI = isInUI;
			_removeListFun = removeListFun;
			_bindTarget = bindTarget;
			_priority = $priority;
			
			if(dic[_key]){//如果在缓存中存在已经加载的信息
				//var bytes:ByteArray = dic[_key].byte;
				dic[_key].idleTime = 0;
				//bytes.position=0;
				_data = dic[_key].data;
				if(dic[_key].posData){
					_ridePos = posObjToVo(dic[_key].posData);
					_posFun(_ridePos);
				}
				
				var arr:Vector.<MeshVo> = objToVo(_data as Array);
				_allLoadNum = arr.length;
				for(var j:int;j<arr.length;j++){
					arr[j].equipData = new EquipData();
					arr[j].equipData.data = _apd;
					arr[j].equipData.renderPriority = arr[j].renderPriority;
					MeshDataManager.getInstance().addMesh(_key + "mesh/" + arr[j].meshUrl,onMeshCom,arr[j],_priority);
				}
				
			}else if(loadDic[_key]){//如果正在加载 存入加载队列
				loadDic[_key].push(infoFun);
			}else{
				loadDic[_key] = new Array;
				var loaderinfo : LoadInfo = new LoadInfo(url + "equ.zzw", LoadInfo.BYTE, onInfoCom,_priority);
				LoadManager.getInstance().addSingleLoad(loaderinfo);
			}
			
		}
		
		public function addMesh(url:String,fun:Function):void{
			_fun = fun;
			var loaderinfo : LoadInfo = new LoadInfo(url, LoadInfo.BYTE, onInfoCom,_priority);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		
		/**
		 * zzw信息加载完成 
		 * @param byte 加载的二进制数据
		 * 
		 */		
		private function onInfoCom(byte:ByteArray):void{
			var meshByteVo:MeshByteVo = new MeshByteVo;
			byte.position = 0;
			
			_data = byte.readObject();
			
			meshByteVo.data = _data;
			
			if(byte.bytesAvailable){
				meshByteVo.posData = byte.readObject();
			}
			
			dic[_key] = meshByteVo;
			
			if(loadDic[_key]){
				for(var i:int;i<loadDic[_key].length;i++){
					var fun:Function = loadDic[_key][i];
					//byte.position=0;
					//var bytedata:Object = byte.readObject();
					//if(byte.bytesAvailable)
					//	var bytepos:Object = byte.readObject();
					fun(meshByteVo.data,meshByteVo.posData);
				}
				delete loadDic[_key];
			}
			
			if(isInterrupt){
				return;
			}
			
			if(meshByteVo.posData){
				_ridePos = posObjToVo(meshByteVo.posData);
				_posFun(_ridePos);
			}
			
			
			var arr:Vector.<MeshVo> = objToVo(_data as Array);
			_allLoadNum = arr.length;
			for(var j:int;j<arr.length;j++){
				arr[j].equipData = new EquipData();
				arr[j].equipData.data = _apd;
				arr[j].equipData.renderPriority = arr[j].renderPriority;
				MeshDataManager.getInstance().addMesh(_key + "mesh/" + arr[j].meshUrl,onMeshCom,arr[j],_priority);
			}
			
			//MeshDataManager.getInstance().addMesh(_key + "mesh/" + _data.meshUrl,onMeshCom,_data);
			
		}
		
		public static function writeDataByte(byte:ByteArray,url:String):void{
			var meshByteVo:MeshByteVo = new MeshByteVo;
			byte.position = 0;
			
			var _data:Object = byte.readObject();
			
			meshByteVo.data = _data;
			
			if(byte.bytesAvailable){
				meshByteVo.posData = byte.readObject();
			}
			
			dic[url] = meshByteVo;
		}
		
		/**
		 * 把读取的obj装化成vo模型
		 * @param ary 原始数据
		 * @return vo数据
		 * 
		 */		
		private function objToVo(ary:Array):Vector.<MeshVo>{
			var meshVec:Vector.<MeshVo> = new Vector.<MeshVo>;
			for(var i:int;i<ary.length;i++){
				var meshVo:MeshVo = MeshVo.getVo(ary[i])
				meshVo.renderPriority = i;
				meshVec.push(meshVo);
			}
			return meshVec;
		}
		/**
		 * 把读取的位置obj转化成vo模型 
		 * @param ary 原始数据
		 * @return vo数据
		 * 
		 */		
		private function posObjToVo(ary:Array):Vector.<PosVo>{
			var posVec:Vector.<PosVo> = new Vector.<PosVo>;
			for(var i:int;i<ary.length;i++){
				posVec.push(PosVo.getVo(ary[i]));
			}
			return posVec;
		}
		
		private function infoFun(obj:Object,pos:Object=null):void{
			if(isInterrupt){
				return;
			}
			_data = obj;
			if(pos){
				_ridePos = posObjToVo(pos as Array);
				_posFun(_ridePos);
			}
			var arr:Vector.<MeshVo> = objToVo(_data as Array);
			_allLoadNum = arr.length;
			
			for(var j:int;j<arr.length;j++){
				arr[j].equipData = new EquipData();
				arr[j].equipData.data = _apd;
				arr[j].equipData.renderPriority = arr[j].renderPriority;
				MeshDataManager.getInstance().addMesh(_key + "mesh/" + arr[j].meshUrl,onMeshCom,arr[j],_priority);
			}
			
			//MeshDataManager.getInstance().addMesh(_preUrl + "mesh/" + _data.meshUrl,onMeshCom,_data);
		}
		
		private function onMeshCom(meshData:MeshData,info:MeshVo):void{
			if(isInterrupt){
				info.dispose();
				return;
			}
			//trace(meshData)
//			if(meshData.hasDispose){
//				trace(meshData.hasDispose)
//			}
			//meshData.useNum++;
			info.equipData.meshData = meshData;
			info.equipData.key = _key;
			info.equipData.textureUrl = _key + "texture/" + info.textureUrl;
			TextureManager.getInstance().addTexture(info.equipData.textureUrl,onTextureCom,info,_priority);
		}
		
		private function onTextureCom(textureVo:TextureVo,info:MeshVo):void{
			//info.equipData.meshData.useNum--;
			if(isInterrupt){
				info.dispose();
				return;
			}
			info.equipData.textureVo = textureVo;
			var particleList:Vector.<ParticleVo> = info.particleList;
			var particleList2:Vector.<ParticleVo> = info.particleList2;
			if(particleList){
				info.equipData.particleList = new Vector.<CombineParticle>;
				
				for(var i:int = particleList.length -1 ;i>=0;i--){
					var obj:ParticleVo = particleList[i];
					if(_apd.level != i || (obj.id == 0 && !obj.isList)){
						obj.dispose();
						particleList.splice(i,1);
					}else{
						if(obj.isList){
							for(var j:int=0;j<obj.nextList.length;j++){
								obj.nextList[j].bindTarget = _bindTarget;
								info.equipData.particleList.push(ParticleManager.getInstance().loadParticle(Scene_data.particleRoot + obj.nextList[j].url,obj.nextList[j],_priority,_isInUI,_bindTarget.uiParticleContaniner));
							}
						}else{
							obj.bindTarget = _bindTarget;
							info.equipData.particleList.push(ParticleManager.getInstance().loadParticle(Scene_data.particleRoot + obj.url,obj,_priority,_isInUI,_bindTarget.uiParticleContaniner));
						}
						
					}
				}
				
			}
			
			if(particleList2){
				
				if(!info.equipData.particleList){
					info.equipData.particleList = new Vector.<CombineParticle>;
				}
				
				for(i = particleList2.length -1 ;i>=0;i--){
					obj = particleList2[i];
					if(_apd.secondLevel != i || (obj.id == 0 && !obj.isList)){
						obj.dispose();
						particleList2.splice(i,1);
					}else{
						if(obj.isList){
							for(j=0;j<obj.nextList.length;j++){
								obj.nextList[j].bindTarget = _bindTarget;
								info.equipData.particleList.push(ParticleManager.getInstance().loadParticle(Scene_data.particleRoot + obj.nextList[j].url,obj.nextList[j],_priority,_isInUI,_bindTarget.uiParticleContaniner));
							}
						}else{
							obj.bindTarget = _bindTarget;
							info.equipData.particleList.push(ParticleManager.getInstance().loadParticle(Scene_data.particleRoot + obj.url,obj,_priority,_isInUI,_bindTarget.uiParticleContaniner));
						}
						
					}
				}
			}
			
			_fun(info.equipData);
			_loadNum++;
			if(_loadNum == _allLoadNum){
				_apd.complete = true;
				_removeListFun(this);
			}
			
			info.dispose();
		}
		
		private function objToV3d(obj:Object):Vector3D{
			return new Vector3D(obj.x,obj.y,obj.z)
		}

		/**
		 *  装备信息
		 */
		public function get apd():AvatarParamData
		{
			return _apd;
		}

		public function get isInterrupt():Boolean
		{
			return _isInterrupt;
		}

		public function set isInterrupt(value:Boolean):void
		{
			_isInterrupt = value;
		}
		
		public function dispose():void{
			_fun = null;
			_posFun = null;
			_data = null;
			_ridePos = null;
			_apd = null;
			_removeListFun = null;
			_bindTarget = null;
		}
		
		public static function staticDispose():void{
			//trace(dic);
			//trace(loadDic);
			for(var key:String in dic){
				var meshByteVo:MeshByteVo = dic[key];
				meshByteVo.idleTime++;
				if(meshByteVo.idleTime >= Scene_data.cacheTime){
					delete dic[key]
				}
			}
		}

		
	}
}