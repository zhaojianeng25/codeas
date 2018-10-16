package view.mesh
{
	import flash.filesystem.File;
	
	import mx.controls.treeClasses.TreeListData;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.program.shaders.Md5MatrialShader;
	import _Pan3D.utils.MaterialManager;
	
	import _me.Scene_data;
	
	import away3d.entities.Mesh;
	
	import common.AppData;
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	
	import materials.MaterialTree;
	
	import modules.materials.view.MaterialTreeManager;
	
	import utils.FileConfigUtils;
	
	public class MeshBoneMaterialMeshPanel extends BaseReflectionView
	{
		public function MeshBoneMaterialMeshPanel()
		{
			super();
			
			this.creat(getView());
		}
		
		public function get materialInfoArr():Array
		{
			return listData.item.materialInfoArr;
		}

		public function set materialInfoArr(value:Array):void
		{
			listData.item.materialInfoArr = value;
			//bfun()
			
			MeshData(listData.item.data).setParamData(value);
		}

		private function getView():Array
		{
			var ary:Array =
				[
					{Type:ReflectionData.MaterialImg,Label:"材质:",key:"materialUrl",extensinonStr:"material",donotDubleClik:"3",closeBut:1,target:this,Category:"材质"},
				]
			return ary;
		}
	
		private var bfun:Function
		public function setData($TreeListData:TreeListData,$bfun:Function):void
		{
			listData=$TreeListData;
	
			bfun=$bfun

			this.refreshView();
		}

		private var listData:TreeListData
		public function get materialUrl():Object
		{

			if(TreeListData(listData).item&&TreeListData(listData).item.data){
				return TreeListData(listData).item.data.material
			
			}else{
			   return null
			}
		
		}
		
		public function set materialUrl(value:Object):void
		{
			var $url:String=String(value)
			//TreeListData(listData).item.data.material=MaterialTree(MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$url))
			this.changeUrl(new File(AppData.workSpaceUrl+$url))
		}
		private function changeUrl($file:File):void
		{
			var url:String=$file.url
				
		
			MeshPanel.getInstance().lastFileImgUrl = url;
			FileConfigUtils.writeConfig("meshImgUrl",$file.parent.url);
			
			url = url.substring(Scene_data.md5Root.length);
			
			TreeListData(listData).item.textureUrl = url;
			TreeListData(listData).item.texturePath =$file.nativePath;
			TreeListData(listData).item.textureName = $file.name;
			

			
			MaterialManager.getInstance().getMaterial(Scene_data.fileRoot + url,addMaterial,TreeListData(listData).item,true,Md5MatrialShader.MD5_MATRIAL_SHADER,Md5MatrialShader);

		}
		private function addMaterial($mt:MaterialTree,info:Object):void{
			

			TreeListData(listData).item.data.material = $mt;
	
			AppDataBone.role.addMeshData(TreeListData(listData).item.fileName,TreeListData(listData).item.data);
			
			this.refreshView()
		}
			
	}
}