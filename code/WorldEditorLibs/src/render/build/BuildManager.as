package render.build
{
	import mx.collections.ArrayCollection;
	
	import _Pan3D.display3D.Display3DMaterialSprite;
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.scene.SceneContext;
	
	import _me.Scene_data;
	
	import capture.CaptureStaticMesh;
	
	import common.AppData;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	import modules.materials.view.MaterialTreeManager;
	import modules.prefabs.PrefabManager;
	
	import pack.BuildMesh;
	import pack.PrefabStaticMesh;
	
	import proxy.pan3d.model.ProxyPan3dModel;
	import proxy.top.model.IModel;
	import proxy.top.render.Render;

	public class BuildManager
	{
		private static var instance:BuildManager;
		public function BuildManager()
		{
		}
		public static function getInstance():BuildManager{
			if(!instance){
				instance = new BuildManager();
			}
			return instance;
		}

		private function objToPreFab($obj:Object):PrefabStaticMesh
		{
			var prefab:PrefabStaticMesh = new PrefabStaticMesh();
			for(var i:String in $obj) {
				prefab[i]=$obj[i]
			}
			return prefab
		}
		public function addddd($id:uint,preUrl:String):HierarchyFileNode
		{
			var $buildMesh:BuildMesh=new BuildMesh
			$buildMesh.url=preUrl.replace(AppData.workSpaceUrl,"")

			$buildMesh.prefabStaticMesh=PrefabManager.getInstance().getPrefabByUrl(AppData.workSpaceUrl+$buildMesh.url)
			var $modelSprite:Display3DModelSprite=SceneContext.creatModel()
			var $proxyPan3dModel:ProxyPan3dModel = new ProxyPan3dModel;
			$proxyPan3dModel.sprite=Display3DMaterialSprite($modelSprite)
			$proxyPan3dModel.prefab=$buildMesh.prefabStaticMesh
				
				
			var $imode:IModel=$proxyPan3dModel
			$imode.x=Scene_data.focus3D.x
			$imode.y=Scene_data.focus3D.y
			$imode.z=Scene_data.focus3D.z
			$imode.uid="build"+$id;
			
			var $hierarchyFileNode:HierarchyFileNode=new HierarchyFileNode;	
			$hierarchyFileNode.id=$id
			$hierarchyFileNode.name=FileNodeManage.getFileName(decodeURI(AppData.workSpaceUrl+$buildMesh.url))
			
			$hierarchyFileNode.iModel=$imode;
			$hierarchyFileNode.type=HierarchyNodeType.Prefab
			$hierarchyFileNode.data=$buildMesh;
			
			
			$buildMesh.lightMapSize=128
			$buildMesh.isGround=false
			$buildMesh.isNotCook=true
			$buildMesh.lightBlur=3
			$buildMesh.captureId=0
			
			
			listArr.addItem($hierarchyFileNode)
			
			return $hierarchyFileNode
				
		}
		public function addBuildModel($id:uint,preUrl:String):HierarchyFileNode
		{
		
				
			var $buildMesh:BuildMesh=new BuildMesh
			$buildMesh.url=preUrl.replace(AppData.workSpaceUrl,"")
				
				
			$buildMesh.prefabStaticMesh=PrefabManager.getInstance().getPrefabByUrl(AppData.workSpaceUrl+$buildMesh.url)

				
			var $imode:IModel=Render.creatDisplay3DModel($buildMesh.prefabStaticMesh,$id)
			$imode.x=Scene_data.focus3D.x
			$imode.y=Scene_data.focus3D.y
			$imode.z=Scene_data.focus3D.z
			
			var $hierarchyFileNode:HierarchyFileNode=new HierarchyFileNode;	
			$hierarchyFileNode.id=$id
			$hierarchyFileNode.name=FileNodeManage.getFileName(decodeURI(AppData.workSpaceUrl+$buildMesh.url))
				
			$hierarchyFileNode.iModel=$imode;
			$hierarchyFileNode.type=HierarchyNodeType.Prefab
			$hierarchyFileNode.data=$buildMesh;
			
			
			$buildMesh.lightMapSize=128
			$buildMesh.isGround=false
			$buildMesh.isNotCook=true
			$buildMesh.lightBlur=3
			$buildMesh.captureId=0
				
			
			listArr.addItem($hierarchyFileNode)
			
			return $hierarchyFileNode
			
		}
		private var onlyshowTri:Boolean=false
		public function showBuildModelLine():void
		{
			onlyshowTri=!onlyshowTri
			var $item:Vector.<FileNode>=FileNodeManage.getListAllFileNode(BuildManager.getInstance().listArr)
			for(var i:uint=0;i<$item.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=$item[i] as HierarchyFileNode ;
				if($hierarchyFileNode.type==HierarchyNodeType.Prefab){
					
					var $buildMesh:BuildMesh=$hierarchyFileNode.data as BuildMesh
					if($buildMesh){
						var $proxyPan3dModel:ProxyPan3dModel=$hierarchyFileNode.iModel as ProxyPan3dModel
						if($proxyPan3dModel&&$proxyPan3dModel.sprite){
							$proxyPan3dModel.sprite.showOnlyModelLine(onlyshowTri)
								
						}
					}
					
				}
			}
		
		}
	
		public var listArr:ArrayCollection
		public function objToBuildMesh($obj:Object):BuildMesh
		{

			var $buildMesh:BuildMesh = new BuildMesh();
			if($obj&&$obj.url){
				$buildMesh.url=$obj.url
				$buildMesh.prefabStaticMesh=PrefabManager.getInstance().getPrefabByUrl(AppData.workSpaceUrl+$buildMesh.url)
					
				
				$buildMesh.groupMaterialId=int($obj.groupMaterialId)	
			
					
				if($obj.lightMapSize){
					$buildMesh.lightMapSize=$obj.lightMapSize
			
					$buildMesh.isNotCook=$obj.isNotCook
					$buildMesh.lightBlur=$obj.lightBlur
					$buildMesh.captureId=$obj.captureId
					$buildMesh.lightProbe=$obj.lightProbe
					$buildMesh.isGround=$obj.isGround
					$buildMesh.isPerspective=$obj.isPerspective
				}else{
					$buildMesh.lightMapSize=128

					$buildMesh.isNotCook=false
					$buildMesh.lightBlur=3
					$buildMesh.captureId=0
					$buildMesh.lightProbe=false
				}
				if($buildMesh.prefabStaticMesh&&$buildMesh.prefabStaticMesh.materialUrl&&AppData.workSpaceUrl){
					$buildMesh.prefabStaticMesh.material = MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$buildMesh.prefabStaticMesh.materialUrl);
				}
			}
			
			return $buildMesh
		}

		
	}
}