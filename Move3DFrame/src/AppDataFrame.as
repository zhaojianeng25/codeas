package
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	
	import _Pan3D.display3D.Display3DMaterialSprite;
	import _Pan3D.program.Program3DManager;
	
	import common.AppData;
	
	import materials.MaterialTree;
	
	import modules.lizhi.LizhiManager;
	import modules.materials.view.MaterialTreeManager;
	import modules.prefabs.PrefabManager;
	import modules.roles.RoleManager;
	
	import mvc.frame.view.FrameFileNode;
	
	import pack.PrefabStaticMesh;
	
	import particle.ParticleStaticMesh;
	
	import proxy.pan3d.model.ProxyPan3dModel;
	import proxy.pan3d.particle.ProxyPan3DParticle;
	import proxy.pan3d.roles.ProxyPan3DRole;
	import proxy.top.model.IModel;
	import proxy.top.render.Render;
	
	import roles.RoleStaticMesh;

	public class AppDataFrame
	{
		public function AppDataFrame()
		{
		}
		public static var editMode:uint=0 ///0是切割1为ui2为图片
		public static var sceneColor:uint;

		public static var url:String

		

		
		public static var  frameNum:Number=-1;
		public static var frameSpeed:Number=30;
		
		public static var selectNode:FrameFileNode
		public static var  numW8:Number=8
			
		public static var aotuPlayFrame:Boolean=false
			
		public static var fileUrl:String="ccav.3dmove"
		
			
			
		public static function getSharedObject():SharedObject
		{
			return SharedObject.getLocal("anima3dmove","/"); 
		
		}
	

		
		public static function saveConfigProject():void
		{
			var file:File = new File(File.documentsDirectory.url + "/move3dframe.config");
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.WRITE);
			var obj:Object = new Object;
			obj.workSpaceUrl = AppData.workSpaceUrl;
			fs.writeObject(obj);
			fs.close();
		}
	
		
		public static function addModel($prefabUrl:String):IModel
		{
			var $url:String=AppData.workSpaceUrl+$prefabUrl;
			if($prefabUrl.search(".prefab")!=-1){
				var _prefab:PrefabStaticMesh=PrefabManager.getInstance().getPrefabByUrl($url);
				var $buildModel:ProxyPan3dModel=Render.creatDisplay3DModel(_prefab,0) as ProxyPan3dModel;
				var $dd:MaterialTree= MaterialTreeManager.getMaterial(AppData.workSpaceUrl+_prefab.materialUrl);
				if($dd){
					Program3DManager.getInstance().regMaterial($dd);
					Display3DMaterialSprite($buildModel.sprite).material  = $dd
					Display3DMaterialSprite($buildModel.sprite).setMaterialParam(_prefab.materialInfoArr);
				}
				return $buildModel
			}
			if($prefabUrl.search(".lyf")!=-1){
				var $particleMesh:ParticleStaticMesh=LizhiManager.getInstance().objToMesh({url:$prefabUrl})
				var $proxyPan3DParticle:ProxyPan3DParticle=	Render.creatParticle($particleMesh) as ProxyPan3DParticle;
				return $proxyPan3DParticle
			}
			if($prefabUrl.search(".zzw")!=-1){
				var $roleStaticMesh:RoleStaticMesh=RoleManager.getInstance().objToMesh({url:$prefabUrl})
				var $proxyPan3DRole:ProxyPan3DRole=	 Render.creatRole($roleStaticMesh)  as ProxyPan3DRole;
				return $proxyPan3DRole
			}
			return null
			
		}
		


	}
}