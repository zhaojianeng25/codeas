package view.ridepos
{
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.program.shaders.Md5MatrialShader;
	import _Pan3D.program.shaders.Md5Shader;
	import _Pan3D.role.AnimDataManager;
	import _Pan3D.role.MeshDataManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.utils.MaterialManager;
	import _Pan3D.vo.anim.BoneSocketData;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import materials.MaterialTree;
	
	import renderLevel.Display3DMovieLocal;
	
	import view.meshSort.BoneImportSort;
	import view.meshSort.MeshImportSort;

	public class RidePosUtils
	{
		private var _ride:Display3DMovieLocal;
		private var _data:Object;
		private var _boneAry:Array;
		private var _meshAry:Array;
		private var _loadlAllNum:Object;
		private var _loadFlag:int;
		private var meshImportUtils:MeshImportSort; 
		
		public function RidePosUtils(data:Object)
		{
			this._data = data;
			_boneAry = data.bone;
			_meshAry = data.mesh;
			_ride = new Display3DMovieLocal(Scene_data.context3D);
			loadBone();
			
			var ary:Array = data.socket.socket;
			for(var i:int;i<ary.length;i++){
				var boneSocket:BoneSocketData = new BoneSocketData;
				boneSocket.setObj(ary[i]);
				_ride.addSocket(boneSocket);
			}
			
		}
		public function getRide():Display3DMovieLocal{
			return _ride;
		}
		private function loadBone():void{
			_loadlAllNum = _boneAry.length;
			for(var i:int;i<_boneAry.length;i++){
				addLocalAnim(_boneAry[i]);
			}
		}
		public function addLocalAnim(obj:Object):void{
			AnimDataManager.getInstance().addAnim(Scene_data.md5Root + obj.url,onLocalAnimLoad,obj);
			_ride.play(obj.fileName);
		}
		private var _boneImportSort:BoneImportSort = new BoneImportSort;
		private function onLocalAnimLoad(ary:Array,obj:Object):void{
			
			var prePorcessInfo:Object = _boneImportSort.processBoneNew(obj.hierarchy,obj);
			var ary:Array = obj.data = prePorcessInfo.animAry;
			
			obj.source = prePorcessInfo.source;
			obj.strAry = prePorcessInfo.strAry;
			obj.hierarchy = prePorcessInfo.hierarchy;
			obj.str = prePorcessInfo.str;
			
			obj.data = ary;
			_ride.addAnimLocal(obj.fileName,ary);
			
			_loadFlag++;
			if(_loadFlag == _loadlAllNum){
				loadMesh();
			}
		}
		
		private function loadMesh():void{
			for(var i:int;i<_meshAry.length;i++){
				var obj:Object = _meshAry[i];
				MeshDataManager.getInstance().addMesh(Scene_data.md5Root + obj.url,onMeshFileLoad,obj);
			}
		}
		
		private function onMeshFileLoad(meshData:MeshData,obj:Object):void{
			if(!meshImportUtils){
				meshImportUtils = new MeshImportSort;
			}
			meshImportUtils.processMesh(meshData);
			
			obj.data = meshData;
			obj.data.visible = obj.check;
			
			
			MaterialManager.getInstance().getMaterial(Scene_data.fileRoot + obj.textureUrl,addMaterial,obj,true,Md5MatrialShader.MD5_MATRIAL_SHADER,Md5MatrialShader);
			
//			if(obj.particleList){
//				_ride.addMeshParticle(obj.fileName,obj.particleList);
//			}
		}
		
		private function addMaterial($mt:MaterialTree,info:Object):void{
			info.data.material = $mt;
			_ride.addMeshData(info.fileName,info.data);
		}
		
		private function addFileTexture(obj:Object):void{
			TextureManager.getInstance().addTexture(Scene_data.md5Root + obj.textureUrl,onTextureLoad,obj,0);
		}
		
		private function onTextureLoad(textureVo:TextureVo,obj:Object):void{
			obj.texture = textureVo;
			_ride.addTextureLocal(obj.fileName,textureVo.texture);
			addFileMesh(obj);
		}
		
		public function addFileMesh(obj:Object):void{
			MeshDataManager.getInstance().addMesh(Scene_data.md5Root + obj.url,onMeshFileLoad,obj,0);
		}
		
		
		
		
		
	}
}