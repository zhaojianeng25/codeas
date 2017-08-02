package utils.ai
{
	import flash.display3D.Program3D;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.program.shaders.Md5Shader;
	import _Pan3D.role.AnimDataManager;
	import _Pan3D.role.MeshDataManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import renderLevel.Display3DMovieLocal;

	public class AssetsRoleUtils
	{
		private var _ride:Display3DMovieLocal;
		private var _data:Object;
		private var _boneAry:Array;
		private var _meshAry:Array;
		private var _loadlAllNum:Object;
		private var _loadFlag:int;
		
		public function AssetsRoleUtils()
		{
			_boneAry = [{fileName:"stand",url:"stand"},{fileName:"walk",url:"walk"}];
			_meshAry = [{textureUrl:"taihuliumang.png",fileName:"zid346/shenti",url:"shenti"},{textureUrl:"taihuliumang.png",fileName:"zid346/wuqing",url:"wuqing"}];
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
			AnimDataManager.getInstance().addAnim("assets/testRole/aid343/" + obj.url + ".md5anim",onLocalAnimLoad,obj,0);
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
			}
		}
		
		private function addFileTexture(obj:Object):void{
			TextureManager.getInstance().addTexture("assets/testRole/zid346/texture/" + obj.textureUrl,onTextureLoad,obj,0);
		}
		
		private function onTextureLoad(textureVo:TextureVo,obj:Object):void{
			obj.texture = textureVo.texture;
			_ride.addTextureLocal(obj.fileName,textureVo.texture);
			addFileMesh(obj);
		}
		
		public function addFileMesh(obj:Object):void{
			MeshDataManager.getInstance().addMesh("assets/testRole/zid346/mesh/" + obj.url + ".md5mesh",onMeshFileLoad,obj,0);
		}
		
		private function onMeshFileLoad(meshData:MeshData,obj:Object):void{
			obj.data = meshData;
			_ride.addMeshLocal(obj.fileName,meshData);
		}
		
		
		
		
	}
}