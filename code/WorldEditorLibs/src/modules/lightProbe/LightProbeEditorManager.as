package modules.lightProbe
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import _Pan3D.display3D.lightProbe.LightProbeManager;
	
	import common.AppData;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	
	import light.LightProbeStaticMesh;
	import light.LightProbeTempStaticMesh;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	import modules.materials.view.MaterialTreeManager;
	
	import proxy.pan3d.light.ProxyPan3DTempLightProbe;
	import proxy.top.model.ILightProbe;
	import proxy.top.render.Render;
	

	public class LightProbeEditorManager
	{
		private static var instance:LightProbeEditorManager;
		public function LightProbeEditorManager()
		{
		}
		public static function getInstance():LightProbeEditorManager{
			if(!instance){
				instance = new LightProbeEditorManager();
			}
			return instance;
		}
		public function objToMesh($obj:Object):LightProbeStaticMesh
		{
	
			
			var $lightProbeMesh:LightProbeStaticMesh = new LightProbeStaticMesh();
			$lightProbeMesh.lightModelScal=$obj.lightModelScal
			$lightProbeMesh.cubeSize=new Vector3D($obj.cubeSize.x,$obj.cubeSize.y,$obj.cubeSize.z)
				
			$lightProbeMesh.cubeSize.x=uint(Math.max(2,$lightProbeMesh.cubeSize.x))
			$lightProbeMesh.cubeSize.z=uint(Math.max(2,$lightProbeMesh.cubeSize.z))
			$lightProbeMesh.cubeSize.y=uint(Math.max(1,$lightProbeMesh.cubeSize.y))
	
			
			$lightProbeMesh.seeAll=$obj.seeAll
			$lightProbeMesh.betweenNum=$obj.betweenNum
			$lightProbeMesh.lastBetweenNum=$lightProbeMesh.betweenNum

			$lightProbeMesh.modelUrl=$obj.modelUrl
			$lightProbeMesh.materialUrl=$obj.materialUrl
			$lightProbeMesh.material=MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$lightProbeMesh.materialUrl);
			
			$lightProbeMesh.posItem=$obj.posItem
			for(var i:uint=0;i<$obj.posItem.length;i++){
				for(var j:uint=0;j<$obj.posItem[i].length;j++){
					for(var k:uint=0;k<$obj.posItem[i][j].length;k++){
						$lightProbeMesh.posItem[i][j][k]=$obj.posItem[i][j][k]

						var kkkk:LightProbeTempStaticMesh=new LightProbeTempStaticMesh
						kkkk.postion=new Vector3D
						kkkk.isUse=true
						kkkk.objToMesh($obj.posItem[i][j][k])
						$lightProbeMesh.posItem[i][j][k]=kkkk
					}	
				}	
			}
			
		
			$lightProbeMesh.addEventListener(Event.CHANGE,onMeshChange)
			return $lightProbeMesh
			
		}

		protected function onMeshChange(event:Event):void
		{
			var $lightProbeMesh:LightProbeStaticMesh =LightProbeStaticMesh(event.target)
				
            if($lightProbeMesh.posItem){
				if($lightProbeMesh.needChangePosItem){
					resetLightProbeDisplay3d($lightProbeMesh)
					$lightProbeMesh.needChangePosItem=false
				}else{
					$lightProbeMesh.seeAll

				}
			}

		}
		private function resetLightProbeDisplay3d($lightProbeMesh:LightProbeStaticMesh):void
		{
			var $arr:Vector.<FileNode>=FileNodeManage.getListAllFileNode(listArr)
			for(var i:uint=0;i<$arr.length;i++)
			{
				if(HierarchyFileNode($arr[i]).data==$lightProbeMesh){
				
					makeNewPosItem($lightProbeMesh)
					$lightProbeMesh.lastBetweenNum=$lightProbeMesh.betweenNum
					ILightProbe(HierarchyFileNode($arr[i]).iModel).lightProbeMesh=$lightProbeMesh
				}
			}
			
		}
		public var listArr:ArrayCollection
		
		public function addLightProbe($id:uint):void
		{
			
			var $canAdd:Boolean=true
			var $arr:Vector.<FileNode>=FileNodeManage.getListAllFileNode(listArr)
			for(var i:uint=0;i<$arr.length;i++)
			{
				if(HierarchyFileNode($arr[i]).type==HierarchyNodeType.LightProbe){
				//	$canAdd=false
				}
			}
			
			if($canAdd){
				var $lightProbeMesh:LightProbeStaticMesh=new LightProbeStaticMesh
				$lightProbeMesh.modelUrl="xFile/moba_dae/Block4_0.objs";
				$lightProbeMesh.cubeSize=new Vector3D(5,2,5)
				$lightProbeMesh.betweenNum=50
				$lightProbeMesh.lastBetweenNum=50
				$lightProbeMesh.lightModelScal=0.2
				$lightProbeMesh.postion=new Vector3D(0,0,0);
				
				$lightProbeMesh.materialUrl=AppData.defaultMaterialUrl
				$lightProbeMesh.material=MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$lightProbeMesh.materialUrl);
				makeNewPosItem($lightProbeMesh)
				var $hierarchyFileNode:HierarchyFileNode=new HierarchyFileNode;	
				$hierarchyFileNode.id=$id
				$hierarchyFileNode.name="LightProbe"
				
				$hierarchyFileNode.iModel=Render.resetLightProbel($lightProbeMesh)
				$hierarchyFileNode.type=HierarchyNodeType.LightProbe
				$hierarchyFileNode.data=$lightProbeMesh;
				
				listArr.addItem($hierarchyFileNode)
				$lightProbeMesh.addEventListener(Event.CHANGE,onMeshChange)
			}else{
				Alert.show("本场景已有LightProbe")
			}
			mathLightProbeData()
			
			
		}
		public function changeLightProbItemTempVec($uid:int,pos:Vector3D,data:Vector.<Vector3D>):void
		{
			
			var $arr:Vector.<FileNode>=FileNodeManage.getListAllFileNode(listArr)
			for(var i:uint=0;i<$arr.length;i++)
			{
				if(HierarchyFileNode($arr[i]).id==$uid){
					LightProbeStaticMesh(HierarchyFileNode($arr[i]).data)
					var lightProbeTempItem:Vector.<ProxyPan3DTempLightProbe>=ILightProbe(HierarchyFileNode($arr[i]).iModel).lightProbeTempItem
					for(var j:uint=0;j<lightProbeTempItem.length;j++)
					{
						var spriteIdPos:Vector3D=lightProbeTempItem[j].idPos
						if(spriteIdPos.x==pos.x&&spriteIdPos.y==pos.y&&spriteIdPos.z==pos.z){
							
							lightProbeTempItem[j].setSH(data)
						}
					}
					
				}
			}
			
			mathLightProbeData()
		}
		
		/**
		 *统计总数据 
		 * 
		 */
	    public function mathLightProbeData():void
		{
			var $item:Array=new Array
			var $arr:Vector.<FileNode>=FileNodeManage.getListAllFileNode(listArr)
			for(var u:uint=0;u<$arr.length;u++){
				var $hierarchyFileNode:HierarchyFileNode=$arr[u] as HierarchyFileNode ;
				if($hierarchyFileNode.type==HierarchyNodeType.LightProbe){
					var $LightProbeStaticMesh:LightProbeStaticMesh=	LightProbeStaticMesh($hierarchyFileNode.data)
					var $obj:Object=new Object
					$obj.cubeVec=$LightProbeStaticMesh.cubeSize;
					$obj.postion=$LightProbeStaticMesh.postion;
					$obj.betweenNum=$LightProbeStaticMesh.betweenNum
					$obj.posItem=new Array
					var $posItem:Array=$LightProbeStaticMesh.posItem
					for(var i:uint=0;i<$posItem.length;i++){
						$obj.posItem[i]=new Array
						for(var j:uint=0;j<$posItem[i].length;j++){
							$obj.posItem[i][j]=new Array
							for(var k:uint=0;k<$posItem[i][j].length;k++){
								var $LightProbeTempStaticMesh:LightProbeTempStaticMesh=LightProbeTempStaticMesh($LightProbeStaticMesh.posItem[i][j][k])
								$obj.posItem[i][j][k]=new Object
								$obj.posItem[i][j][k].x=$LightProbeTempStaticMesh.postion.x
								$obj.posItem[i][j][k].y=$LightProbeTempStaticMesh.postion.y
								$obj.posItem[i][j][k].z=$LightProbeTempStaticMesh.postion.z
								$obj.posItem[i][j][k].resultSHVec=$LightProbeTempStaticMesh.resultSHVec
							}
						}
					}
					$item.push($obj)
					
				}
			}
			
			LightProbeManager.getInstance().setLightProbeData($item)
		
		}
		private function getResultSHvec():Vector.<Vector3D>
		{
			var $arr:Vector.<Vector3D>=new Vector.<Vector3D>
			for(var i:uint=0;i<9;i++){
				$arr.push(new Vector3D(0,0,0));
			}
			return $arr;
		}
		private function makeNewPosItem($lightProbeMesh:LightProbeStaticMesh):void
		{
			if(!$lightProbeMesh.posItem){
				$lightProbeMesh.posItem=new Array
			}
			var posItem:Array=$lightProbeMesh.posItem
			for(var i:uint=0;i<$lightProbeMesh.cubeSize.x;i++){
				if(!posItem[i]){
					posItem[i]=new Array
				}
				if(posItem.length>$lightProbeMesh.cubeSize.x){
					posItem.length=$lightProbeMesh.cubeSize.x
				}
				for(var j:uint=0;j<$lightProbeMesh.cubeSize.z;j++){
					if(!posItem[i][j]){
						posItem[i][j]=new Array
					}
					if(posItem[i].length>$lightProbeMesh.cubeSize.z){
						posItem[i].length=$lightProbeMesh.cubeSize.z
					}
					for(var k:uint=0;k<$lightProbeMesh.cubeSize.y;k++){
						var $tempProbeMesh:LightProbeTempStaticMesh=new LightProbeTempStaticMesh
						$tempProbeMesh.postion.y=k*$lightProbeMesh.betweenNum
						$tempProbeMesh.postion.x=i*$lightProbeMesh.betweenNum
						$tempProbeMesh.postion.z=j*$lightProbeMesh.betweenNum
						$tempProbeMesh.isUse=true
						if(!posItem[i][j][k]){
							$tempProbeMesh.resultSHVec=getResultSHvec()
							posItem[i][j][k]=$tempProbeMesh
						}else{
							var $loastPos:LightProbeTempStaticMesh=new LightProbeTempStaticMesh
							$loastPos.postion=new Vector3D
							$loastPos.postion.y=k*$lightProbeMesh.lastBetweenNum
							$loastPos.postion.x=i*$lightProbeMesh.lastBetweenNum
							$loastPos.postion.z=j*$lightProbeMesh.lastBetweenNum
							
							var $nowPos:LightProbeTempStaticMesh=posItem[i][j][k]
								
							$nowPos.postion.x=($nowPos.postion.x-$loastPos.postion.x)+$tempProbeMesh.postion.x
							$nowPos.postion.y=($nowPos.postion.y-$loastPos.postion.y)+$tempProbeMesh.postion.y
							$nowPos.postion.z=($nowPos.postion.z-$loastPos.postion.z)+$tempProbeMesh.postion.z
						}
						if(posItem[i][j].length>$lightProbeMesh.cubeSize.y){
							posItem[i][j].length=$lightProbeMesh.cubeSize.y
						}
						
					}
				}
			}

			
		}
	
	}
}