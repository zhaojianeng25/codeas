package modules.scene.sceneSave
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	
	import _Pan3D.particle.bone.Display3DBonePartilce;
	import _Pan3D.particle.ctrl.TimeLine;
	import _Pan3D.particle.modelObj.Display3DModelPartilce;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.utils.ui.file.FileNode;
	
	import materials.MaterialCubeMap;
	import materials.MaterialTree;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	import modules.materials.CubeMapManager;
	import modules.materials.view.MaterialTreeManager;
	import modules.water.WaterManager;
	
	import pack.BuildMesh;
	
	import particle.ParticleStaticMesh;
	
	import proxy.pan3d.particle.ProxyPan3DParticle;
	
	import render.ground.TerrainEditorData;
	
	import water.WaterStaticMesh;
	

	public class SceneSaveAsModel
	{
		private static var instance:SceneSaveAsModel;
		private var _fileNodeItem:Vector.<FileNode>;
		private var _saveTourl:String;

		public function SceneSaveAsModel()
		{
		}
		public static function getInstance():SceneSaveAsModel{
			if(!instance){
				instance = new SceneSaveAsModel();
			}
			return instance;
		}
		
		public function setRenderItem($arr:Vector.<FileNode>):void
		{
			_fileNodeItem=$arr
			var file:File = new File;
			file.addEventListener(Event.SELECT,onFileWorkChg);
			file.browseForDirectory("选择文件夹");
			
		
			
		}
		
		protected function onFileWorkChg(event:Event):void
		{
			var file:File = event.target as File;
			_saveTourl=file.url+"/"
				
			makeGrounds(_fileNodeItem);
			makeObjData(_fileNodeItem); //主材质
			makeParticle(_fileNodeItem);
			moveMaterialTree(AppData.defaultMaterialUrl);
			makeWarte(_fileNodeItem);

			Alert.show("另存为完成");
			
		}
		private function moveMaterialTree($url:String):void
		{
			var $materialTree:MaterialTree=MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$url)
			if($materialTree){
				var picArr:Array=$materialTree.getTxtList();
				for(var j:uint=0;j<picArr.length;j++)
				{
					copyFile(picArr[j]);
				}
				copyFile($url);
 
				copyFile($url.replace(".material",".txt"));
				copyFile($url.replace(".material","_byte.txt"))
	 
			}
			
		}
		
		private function makeWarte(_fileNodeItem:Vector.<FileNode>):void
		{
			var $hierarchyFileNode:HierarchyFileNode
			var $item:Vector.<HierarchyFileNode>=new Vector.<HierarchyFileNode>
			
			for(var i:uint=0;i<_fileNodeItem.length;i++){
				$hierarchyFileNode=_fileNodeItem[i] as HierarchyFileNode ;
				if($hierarchyFileNode.type==HierarchyNodeType.Water){
					var $waterStaticMesh:WaterStaticMesh=WaterStaticMesh($hierarchyFileNode.data)
					copyFile($waterStaticMesh.modeUrl);
					moveMaterialTree($waterStaticMesh.materialUrl)
				}
			}
			
		}
		
		private function makeParticle($arr:Vector.<FileNode>):void
		{
			for(var i:uint=0;i<$arr.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=$arr[i] as HierarchyFileNode
				if($hierarchyFileNode.data as ParticleStaticMesh)	{
					
			
					var $ParticleStaticMesh:ParticleStaticMesh=$hierarchyFileNode.data as ParticleStaticMesh;
					var $ProxyPan3DParticle:ProxyPan3DParticle=$hierarchyFileNode.iModel as ProxyPan3DParticle
					var a:Array=$ProxyPan3DParticle.particleSprite.getMaterialTexUrlAry()
				
			
					var b:Array=$ProxyPan3DParticle.particleSprite.getMaterialAry();
					for(var materialTreeId:uint=0;materialTreeId<b.length;materialTreeId++){
						var $MaterialTree:MaterialTree=MaterialTree(b[materialTreeId])
						var materialUrl:String=$MaterialTree.url.replace(AppData.workSpaceUrl,"")
						copyFile(materialUrl)
						
						moveMaterialTree(materialUrl)
					}
					for(var j:uint=0;j<a.length;j++){
						copyFile(a[j])
					}
					copyFile($ParticleStaticMesh.url)
					copyFile($ParticleStaticMesh.url.replace(".lyf","_byte.txt"))
				
			
					for(var u:uint=0;u<	$ProxyPan3DParticle.particleSprite.timeLineAry.length;u++){
						var dis:TimeLine= $ProxyPan3DParticle.particleSprite.timeLineAry[u] 
						if(dis.display3D as Display3DBonePartilce){
							var $bone:Display3DBonePartilce=Display3DBonePartilce(dis.display3D);
							var $eee:Object=$bone.getAllInfo();
							copyFile($eee.animUrl)
							copyFile($eee.meshUrl)
						}
						if(dis.display3D as Display3DModelPartilce){
							var $model:Display3DModelPartilce=Display3DModelPartilce(dis.display3D);
							var $modeEEE:Object=$model.getAllInfo();
							copyFile($modeEEE.objUrl)
							
						}
					}
					
				}
			}
			
		}
		
		private function makeGrounds($arr:Vector.<FileNode>):void
		{
			copyFile(AppData.mapUrl);
			var hideUrl:String=AppData.mapUrl.replace(".lmap","_hide/");
			copyFile(hideUrl);
			
			var $materialCubeMap:MaterialCubeMap=	CubeMapManager.getInstance().getCubeMapByUrl(AppData.workSpaceUrl+Scene_data.light.SkyBoxUrl)	
			
			if($materialCubeMap){
				copyFile($materialCubeMap.url);
				copyFile($materialCubeMap.textureName0);
				copyFile($materialCubeMap.textureName1);
				copyFile($materialCubeMap.textureName2);
				copyFile($materialCubeMap.textureName3);
				copyFile($materialCubeMap.textureName4);
				copyFile($materialCubeMap.textureName5);
			}
			
			
			
			for(var i:uint=0;i<TerrainEditorData.sixTeenFileNodeArr.length;i++)
			{
				copyFile(TerrainEditorData.sixTeenFileNodeArr[i]);
			}
			
		}
		/**
		 *创建立建筑物模型字节 
		 * @param $arr
		 * 
		 */
		private function makeObjData($arr:Vector.<FileNode>):void
		{
			var $hierarchyFileNode:HierarchyFileNode
			var $item:Vector.<HierarchyFileNode>=new Vector.<HierarchyFileNode>

			for(var i:uint=0;i<$arr.length;i++){
				$hierarchyFileNode=$arr[i] as HierarchyFileNode ;
				if($hierarchyFileNode.type==HierarchyNodeType.Prefab){
					var $buildMesh:BuildMesh=BuildMesh($hierarchyFileNode.data)
					
				
					copyFile($buildMesh.url);
					copyFile($buildMesh.prefabStaticMesh.axoFileName);
					moveMaterialTree($buildMesh.prefabStaticMesh.materialUrl)
					
					for(var j:Number=0;$buildMesh.prefabStaticMesh.materialInfoArr&&j<$buildMesh.prefabStaticMesh.materialInfoArr.length;j++){
					     var infoObj:Object=$buildMesh.prefabStaticMesh.materialInfoArr[j];
						 if(infoObj&&infoObj.type==0&&infoObj.url){
							 copyFile(infoObj.url);
						 }
					}
					
				}
			}

			
		}

		

		private function copyFile($url:String):void
		{
			var $file:File=new File(AppData.workSpaceUrl+$url)
			if($file.exists){
				var $tourl:String=_saveTourl+$url
				var destination:File = File.documentsDirectory;
				destination = destination.resolvePath($tourl);
				$file.copyTo(destination, true);
				trace($tourl)
			}else{

				if($url&&$url!="null"){
					Alert.show("文件不存在",$file.url)
				}
			  
	
			   
			}
	
		}
		
	}
}