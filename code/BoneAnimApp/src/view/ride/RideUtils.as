package view.ride
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
	
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	
	import renderLevel.Display3DMovieLocal;

	public class RideUtils
	{
		private var _ride:Display3DMovieLocal;
		private var _data:Object;
		private var _boneAry:Array;
		private var _meshAry:Array;
		private var _loadlAllNum:Object;
		private var _loadFlag:int;
		
		public function RideUtils(data:Object)
		{
			this._data = data;
			_boneAry = data.bone;
			_meshAry = data.mesh;
			_ride = new Display3DMovieLocal(Scene_data.context3D);
			//_ride = AppData.ride;
			//_ride.y = 100;
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
			AnimDataManager.getInstance().addAnim(Scene_data.md5Root + obj.url,onLocalAnimLoad,obj);
		}
		private function onLocalAnimLoad(ary:Array,obj:Object):void{
			obj.data = ary;
			_ride.addAnimLocal(obj.fileName,ary);
			
			_loadFlag++;
			if(_loadFlag == _loadlAllNum){
				loadMesh();
			}
		}
		
		private function loadMesh():void{
			for(var i:int;i<_meshAry.length;i++){
				addFileTexture(_meshAry[i]);
				var obj:Array = _meshAry[i].particleList;
				if(obj){
					for(var h:int=0;h<obj.length;h++){
						obj[h].bindTarget = _ride;
						var pariticle:CombineParticle = ParticleManager.getInstance().loadParticle(obj[h].particleUrl,obj[h]);
						_ride.bindParticleAry.push(pariticle);
					}
				}
			}
		}
		
		private function addFileTexture(obj:Object):void{
			TextureManager.getInstance().addTexture(Scene_data.md5Root + obj.textureUrl,onTextureLoad,obj);
		}
		
		private function onTextureLoad(textureVo:TextureVo,obj:Object):void{
			obj.texture = textureVo.texture;
			_ride.addTextureLocal(obj.fileName,textureVo.texture);
			addFileMesh(obj);
		}
		
		public function addFileMesh(obj:Object):void{
			MeshDataManager.getInstance().addMesh(Scene_data.md5Root + obj.url,onMeshFileLoad,obj);
		}
		
		private function onMeshFileLoad(meshData:MeshData,obj:Object):void{
			obj.data = meshData;
			obj.data.visible = obj.check;
			_ride.addMeshLocal(obj.fileName,meshData);
		}
		
		
		
	}
}