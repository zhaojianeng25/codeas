package renderLevel.levels
{
	import _Pan3D.base.MeshData;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.program.shaders.Md5Shader;
	import _Pan3D.role.AnimDataManager;
	import _Pan3D.role.MeshDataManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import com.zcp.events.EventDispatchCenter;
	
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	
	import renderLevel.Display3DMovieLocal;
	
	import view.meshSort.BoneImportSort;
	import view.meshSort.MeshImportSort;

	public class RoleUtils extends EventDispatchCenter
	{
		private var _ride:Display3DMovieLocal;
		private var _data:Object;
		private var _boneAry:Array;
		private var _meshAry:Array;
		private var _loadlAllNum:Object;
		private var _loadFlag:int;
		
		public function RoleUtils(data:Object)
		{
			this._data = data;
			_boneAry = data.bone;
			_meshAry = data.mesh;
			_ride = new Display3DMovieLocal(Scene_data.context3D);
			var tmpeProgram3d:Program3D = Program3DManager.getInstance().getProgram(Md5Shader.MD5SHADER);
			_ride.setProgram3D(tmpeProgram3d);
			loadBone();
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
			AnimDataManager.getInstance().addAnim(Scene_data.md5Root + obj.url,onLocalAnimLoad,obj,0);
		}
		private var _boneImportSort:BoneImportSort = new BoneImportSort;
		private function onLocalAnimLoad(ary:Array,_info:Object):void{
			
			var prePorcessInfo:Object = _boneImportSort.processBoneNew(_info.hierarchy,_info);
			var ary:Array = _info.data = prePorcessInfo.animAry;
			
			_info.source = prePorcessInfo.source;
			_info.strAry = prePorcessInfo.strAry;
			_info.hierarchy = prePorcessInfo.hierarchy;
			_info.str = prePorcessInfo.str;
			
			var frameNum:int = ary.length;
			var boneNum:int = ary[0].length;
			var info:Object = new Object;
			info.frameNum = frameNum;
			info.boneNum = boneNum;
			info.data = ary;
			info.source = _info.source;
			info.str = _info.str;
			info.strAry = _info.strAry;
			ary = getPureMatrix(ary);
			_ride.addAnimLocal(_info.fileName,ary);
			
//			obj.data = ary;
//			_ride.addAnimLocal(obj.fileName,ary);
			
			_loadFlag++;
			if(_loadFlag == _loadlAllNum){
				loadMesh();
				_ride.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function getPureMatrix(ary:Array):Array{
			var newAry:Array = new Array(ary.length)
			for(var i:int;i<ary.length;i++){
				newAry[i] = new Array(ary[i].length);
				for(var j:int=0;j<ary[i].length;j++){
					newAry[i][j] = ary[i][j].matrix;
				}
			}
			return newAry;
		}
		
		private function loadMesh():void{
			for(var i:int;i<_meshAry.length;i++){
				addFileTexture(_meshAry[i]);
				var obj:Array = _meshAry[i].particleList;
				if(obj){
					for(var h:int=0;h<obj.length;h++){
						obj[h].bindTarget = _ride;
						var pariticle:CombineParticle = ParticleManager.getInstance().loadParticle(Scene_data.particleRoot + obj[h].particleUrl,obj[h],0);
						_ride.bindParticleAry.push(pariticle);
						pariticle.addToRender();
						ParticleManager.getInstance().addParticle(pariticle);
					}
				}
			}
		}
		
		private function addFileTexture(obj:Object):void{
			TextureManager.getInstance().addTexture(Scene_data.md5Root + obj.textureUrl,onTextureLoad,obj,0);
		}
		
		private function onTextureLoad(textureVo:TextureVo,obj:Object):void{
			obj.texture = textureVo.texture;
			_ride.addTextureLocal(obj.fileName,textureVo.texture);
			addFileMesh(obj);
		}
		
		public function addFileMesh(obj:Object):void{
			MeshDataManager.getInstance().addMesh(Scene_data.md5Root + obj.url,onMeshFileLoad,obj,0);
		}
		
		private function onMeshFileLoad(meshData:MeshData,obj:Object):void{
			
			var meshImportUtils:MeshImportSort = new MeshImportSort;
			meshImportUtils.processMesh(meshData);
			
			obj.data = meshData;
			obj.data.visible = obj.check;
			_ride.addMeshLocal(obj.fileName,meshData);
		}
		
		
		
	}
}