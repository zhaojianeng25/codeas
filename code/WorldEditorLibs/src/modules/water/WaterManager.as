package modules.water
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import mx.collections.ArrayCollection;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.texture.TextureCubeMapVo;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	
	import modules.capture.CaptureManager;
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	import modules.materials.view.MaterialTreeManager;
	import modules.reflection.ReFlectionManager;
	
	import proxy.top.model.IWater;
	import proxy.top.render.Render;
	
	import water.WaterStaticMesh;
	

	public class WaterManager
	{
		private static var instance:WaterManager;
		public function WaterManager()
		{
		}
		public var listArr:ArrayCollection
		public static function getInstance():WaterManager{
			if(!instance){
				instance = new WaterManager();
			}
			return instance;
		}
		public function objToWateMesh($obj:Object):WaterStaticMesh
		{
			var $waterStaticMesh:WaterStaticMesh = new WaterStaticMesh();
			for(var i:String in $obj) {
				$waterStaticMesh[i]=$obj[i]
			}
			$waterStaticMesh.materialUrl=$waterStaticMesh.materialUrl.replace(AppData.workSpaceUrl,"")
			$waterStaticMesh.material=MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$waterStaticMesh.materialUrl);
			$waterStaticMesh.addEventListener(Event.CHANGE,onMeshChange)
			return $waterStaticMesh
		}
		
		protected function onMeshChange(event:Event):void
		{
			var $waterStaticMesh:WaterStaticMesh=	WaterStaticMesh(event.target);
			var $arr:Vector.<FileNode>=FileNodeManage.getListAllFileNode(listArr)
			for(var i:uint=0;i<$arr.length;i++)
			{
				if(HierarchyFileNode($arr[i]).data==$waterStaticMesh){
					changeWaterBmp(HierarchyFileNode($arr[i]))
					
					IWater(HierarchyFileNode($arr[i]).iModel).reflectionTextureVo=ReFlectionManager.getInstance().getReFlectionVoById($waterStaticMesh.reFlectionId)
					
					CaptureManager.getInstance().getCaptureVoById($waterStaticMesh.captureId,function ($textureCubeMapVo:TextureCubeMapVo):void{
						HierarchyFileNode($arr[i]).iModel.setEnvCubeMap($textureCubeMapVo)
						
					})
				}
			}
			
		}
		private function changeWaterBmp($hierarchyFileNode:HierarchyFileNode):void
		{

			var $iWater:IWater=$hierarchyFileNode.iModel as IWater
			$iWater.reset()
				
		
	
			
		}
		public function addWaterModel($id:uint):void
		{
			var $waterStaticMesh:WaterStaticMesh=new WaterStaticMesh
			$waterStaticMesh.textureSize=10
			$waterStaticMesh.depht=200
			$waterStaticMesh.materialUrl=AppData.defaultMaterialUrl
			$waterStaticMesh.material=MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$waterStaticMesh.materialUrl);
			$waterStaticMesh.dephtBmp=new BitmapData(100,100,false,0x000000)
			$waterStaticMesh.color=MathCore.vecToHex(new Vector3D(255,0,0))
			
			var $iWater:IWater=Render.creatWaterModel($waterStaticMesh,$id)
			$iWater.x=Scene_data.focus3D.x
			$iWater.y=Scene_data.focus3D.y
			$iWater.z=Scene_data.focus3D.z
			
			var $hierarchyFileNode:HierarchyFileNode=new HierarchyFileNode;	
			$hierarchyFileNode.id=$id
			$hierarchyFileNode.name="水面"
			$hierarchyFileNode.iModel=$iWater;
			$hierarchyFileNode.type=HierarchyNodeType.Water
			$hierarchyFileNode.data=$waterStaticMesh;
			listArr.addItem($hierarchyFileNode)
			$waterStaticMesh.addEventListener(Event.CHANGE,onMeshChange)
				
		}

	}
}