package mvc.top
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Vector3D;
	import flash.net.FileFilter;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import _Pan3D.display3D.Display3D;
	import _Pan3D.light.LightVo;
	import _Pan3D.texture.TextureCubeMapVo;
	
	import _me.Scene_data;
	
	import capture.CaptureStaticMesh;
	
	import common.AppData;
	import common.utils.ui.file.FileNodeManage;
	
	import grass.GrassStaticMesh;
	
	import light.LightProbeStaticMesh;
	import light.LightStaticMesh;
	import light.ParallelLightStaticMesh;
	import light.ReflectionStaticMesh;
	
	import modules.capture.CaptureManager;
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	import modules.lightProbe.LightProbeEditorManager;
	import modules.lightProbe.ParallelLightManager;
	import modules.lizhi.LizhiManager;
	import modules.navMesh.NavMeshManager;
	import modules.reflection.ReFlectionManager;
	import modules.roles.RoleManager;
	import modules.scene.EnvironmentVo;
	import modules.scene.sceneSave.FilePathManager;
	import modules.water.WaterManager;
	
	import mvc.frame.view.FrameFileNode;
	import mvc.frame.FrameModel;
	import mvc.frame.line.FrameLinePointVo;
	import mvc.project.ProjectEvent;
	
	import navMesh.NavMeshStaticMesh;
	
	import pack.BuildMesh;
	
	import particle.ParticleStaticMesh;
	
	import proxy.top.model.IModel;
	import proxy.top.model.IReflection;
	import proxy.top.model.IWater;
	import proxy.top.render.Render;
	
	import render.build.BuildManager;
	import render.grass.GrassManager;
	
	import roles.RoleStaticMesh;
	
	import water.WaterStaticMesh;
	

	public class InputSceneMap
	{
		private static var instance:InputSceneMap;
		public function InputSceneMap()
		{
		}
		public static function getInstance():InputSceneMap{
			if(!instance){
				instance = new InputSceneMap();
			}
			return instance;
		}
		
		
		public function inputLightVo():void
		{
			
			var $file:File=new File(FilePathManager.getInstance().getPathByUid("lmapurl"))
			var txtFilter:FileFilter = new FileFilter("Text", ".lmap;*.lmap;");
			$file.browseForOpen("打开工程文件 ",[txtFilter]);
			$file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				var fs:FileStream = new FileStream;
				fs.open($file,FileMode.READ);
				var obj:Object = fs.readObject();
				fs.close();
				AppData.writeObject(obj);

				Scene_data.light = new LightVo();
				Scene_data.light.writeObject(AppData.light);
				EnvironmentVo.getInstance().objToEnvironment(AppData.environment)
				
				Alert.show("导入完成场景参数")
	

			} 
		}
		public function inputFile():void
		{
		
			var $file:File=new File(FilePathManager.getInstance().getPathByUid("lmapurl"))
			var txtFilter:FileFilter = new FileFilter("Text", ".lmap;*.lmap;");
			
			
			$file.browseForOpen("打开工程文件 ",[txtFilter]);
			$file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				
				
			
				openMapLmapFile($file.url)
				
				FilePathManager.getInstance().setPathByUid("lmapurl",$file.url)
				
			} 
		}
		
		public function openMapLmapFile($url:String):void	
		{
			

			
			
			
			
			var file:File=new File($url);
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.READ);
			var obj:Object = fs.readObject();
			fs.close();
			AppData.hierarchyList=obj.hierarchyList
				
			this.sceneNode = new FrameFileNode;
			this.sceneNode.type=FrameFileNode.Folder0
			this.sceneNode.children=new ArrayCollection;
			this.sceneNode.name = file.name;
			this.sceneNode.id= FileNodeManage.getFileNodeNextId(FrameModel.getInstance().ary)
			FrameModel.getInstance().ary.addItem(this.sceneNode);
		
				
				
			makeReadFileNode(AppData.hierarchyList.item);
		}
		private var sceneNode:FrameFileNode
		private function makeReadFileNode($arr:Array,$parent:HierarchyFileNode=null,$centenpos:Vector3D=null,isAddGruop:Boolean=false):void
		{
			
			if(!$centenpos){
				$centenpos=new Vector3D
			}
			for(var i:uint=0;$arr&&i<$arr.length;i++){
				var $tempNode:HierarchyFileNode = new HierarchyFileNode;
				$tempNode.name=$arr[i].name
				
				$tempNode.type=$arr[i].type
				$tempNode.treeSelect=$arr[i].treeSelect
				$tempNode.lock=$arr[i].lock
				$tempNode.isHide=$arr[i].isHide
				
			
				$tempNode.id=$arr[i].id
			

		
				if($tempNode.type==HierarchyNodeType.Prefab){
					var $buildMesh:BuildMesh=BuildManager.getInstance().objToBuildMesh($arr[i].data)
					if(isAddGruop){
						$buildMesh.isNotCook=true
					}
					$buildMesh.nodeName=$tempNode.name
					if($buildMesh.prefabStaticMesh){
						
						
						
						var $basePos:Display3D=new Display3D()
						$basePos.x=Number($arr[i].x)+$centenpos.x
						$basePos.y=Number($arr[i].y)+$centenpos.y
						$basePos.z=Number($arr[i].z)+$centenpos.z
					
						$basePos.x=Number($arr[i].x)+$centenpos.x
						$basePos.y=Number($arr[i].y)+$centenpos.y
						$basePos.z=Number($arr[i].z)+$centenpos.z
						$basePos.scale_x=Number($arr[i].scaleX)
						$basePos.scale_y=Number($arr[i].scaleY)
						$basePos.scale_z=Number($arr[i].scaleZ)
						$basePos.rotationX=Number($arr[i].rotationX)
						$basePos.rotationY=Number($arr[i].rotationY)
						$basePos.rotationZ=Number($arr[i].rotationZ)
						
		
						
						var $axofile:String=$buildMesh.prefabStaticMesh.url
				
						var $tempB:FrameFileNode = new FrameFileNode;
						
						$tempB.id=	FileNodeManage.getFileNodeNextId(FrameModel.getInstance().ary)
						$tempB.pointitem=new Vector.<FrameLinePointVo>;
			
						for(var k:Number=0;k<2;k++){
							var $obj:FrameLinePointVo=new FrameLinePointVo ;
							$obj.scale_x=$basePos.scale_x;
							$obj.scale_y=$basePos.scale_y;
							$obj.scale_z=$basePos.scale_z;
							$obj.x=$basePos.x
							$obj.y=$basePos.y
							$obj.z=$basePos.z
							$obj.rotationX=$basePos.rotationX
							$obj.rotationY=$basePos.rotationY
							$obj.rotationZ=$basePos.rotationZ
								
							if(k==0){
								$obj.time=0;
								$obj.iskeyFrame=true;
							}else{
								$obj.time=100
								$obj.iskeyFrame=false;
							}
							$tempB.pointitem.push($obj);
						}
						$tempB.url=$axofile
						$tempB.iModel=AppDataFrame.addModel($tempB.url)
						$tempB.type=FrameFileNode.build1
						$tempB.iModel.scaleX=$basePos.scale_x
						$tempB.iModel.scaleY=$basePos.scale_y
						$tempB.iModel.scaleZ=$basePos.scale_z
							
						$tempB.iModel.x=$basePos.x
						$tempB.iModel.y=$basePos.y
						$tempB.iModel.z=$basePos.z
							
						$tempB.iModel.rotationX=$basePos.rotationX
						$tempB.iModel.rotationY=$basePos.rotationY
						$tempB.iModel.rotationZ=$basePos.rotationZ
							
							
							
						$tempB.name=$buildMesh.nodeName
						
						//FrameModel.getInstance().ary.addItem($tempB)
						this.sceneNode.children.addItem($tempB)
					}

				}

	
				if($arr[i].children){
					$tempNode.children=new ArrayCollection
					makeReadFileNode($arr[i].children,$tempNode,$centenpos,isAddGruop)
				}
			
				
			}
		}
	}
}