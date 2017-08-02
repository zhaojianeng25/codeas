package modules.hierarchy
{
	import com.zcp.frame.Module;
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.scene.SceneContext;
	import _Pan3D.texture.TextureCubeMapVo;
	import _Pan3D.utils.editorutils.Display3DEditorMovie;
	import _Pan3D.utils.editorutils.RoleLoadUtils;
	
	import _me.Scene_data;
	
	import capture.CaptureStaticMesh;
	
	import common.AppData;
	import common.msg.event.brower.MEvent_Brower_Refresh;
	import common.msg.event.hierarchy.MEvent_Hierarchy;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Add;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Build_Group;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Dele;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Group_Model_hide;
	import common.msg.event.hierarchy.MEvent_Hierarchy_MoveNode;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Property_Show;
	import common.msg.event.hierarchy.MEvent_Hierarchy_ReFileName;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Reset;
	import common.msg.event.projectSave.MEvent_ProjectData;
	import common.msg.event.scene.MEvent_ADD_Reflection;
	import common.msg.event.scene.MEvent_Add_Capture;
	import common.msg.event.scene.MEvent_Add_Grass;
	import common.msg.event.scene.MEvent_Add_Light;
	import common.msg.event.scene.MEvent_Add_Parallel;
	import common.msg.event.scene.MEvent_Add_Water;
	import common.msg.event.scene.MEvent_EditMode;
	import common.msg.event.scene.MEvent_Radiosity_To_C;
	import common.msg.event.scene.MEvent_Scene_SaveAs;
	import common.msg.event.scene.MEvent_Show_Imodel;
	import common.msg.event.scene.Mevent_ExpToH5_Event;
	import common.msg.event.scene.Mevent_Reader_Scene;
	import common.utils.frame.BaseProcessor;
	import common.utils.frame.CombineReflectionView;
	import common.utils.frame.MetaDataView;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	import common.vo.editmode.EditModeEnum;
	
	import grass.GrassStaticMesh;
	
	import light.LightProbeStaticMesh;
	import light.LightStaticMesh;
	import light.ParallelLightStaticMesh;
	import light.ReflectionStaticMesh;
	
	import manager.LayerManager;
	
	import modules.capture.CaptureManager;
	import modules.hierarchy.h5.ExpToH5Copy;
	import modules.hierarchy.node.SceneQuadTree;
	import modules.hierarchy.radiosity.RadiosityModel;
	import modules.lightProbe.LightProbeEditorManager;
	import modules.lightProbe.ParallelLightManager;
	import modules.lizhi.LizhiManager;
	import modules.menu.MenuTempEvent;
	import modules.navMesh.NavMeshEvent;
	import modules.navMesh.NavMeshManager;
	import modules.reflection.ReFlectionManager;
	import modules.roles.RoleManager;
	import modules.scene.SceneEditModeManager;
	import modules.scene.sceneSave.SceneSaveAsModel;
	import modules.water.WaterManager;
	
	import navMesh.NavMeshStaticMesh;
	
	import pack.BuildMesh;
	import pack.HierarchyGroupMesh;
	import pack.ModePropertyMesh;
	import pack.PrefabStaticMesh;
	
	import particle.ParticleStaticMesh;
	
	import proxy.top.model.ILight;
	import proxy.top.model.IModel;
	import proxy.top.model.IReflection;
	import proxy.top.model.IWater;
	import proxy.top.render.Render;
	
	import render.build.BuildManager;
	import render.grass.GrassManager;
	import render.ground.GroundManager;
	
	import roles.RoleStaticMesh;
	
	import terrain.GroundData;
	
	import water.WaterStaticMesh;
	
	import xyz.draw.TooXyzMoveData;
	
	public class HierarchyProcessor extends BaseProcessor
	{
		private var _hierarchyPanel:HierarchyPanel;
		private var _quadTree:SceneQuadTree = new SceneQuadTree();
		public function HierarchyProcessor($module:Module)
		{
			super($module);
			addEvents();
		}
		private function addEvents():void
		{
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onStageKeyDown)

		}
		
		private var _willCopyItem:Vector.<HierarchyFileNode>
		protected function onStageKeyDown(event:KeyboardEvent):void
		{
			if(AppData.editMode!=EditModeEnum.EDIT_WORLD)
			{
				return;
			}

			if(event.ctrlKey==true && event.keyCode==Keyboard.C){
				_willCopyItem=new Vector.<HierarchyFileNode>
				if(_hierarchyPanel.singleSelect&&_hierarchyPanel.ctrlSelectArr.length==1)
				{
					getSingleCopyData()
				}else{
					getSelectNodeData()
				}
			}
		    if(event.keyCode==Keyboard.DELETE){
				deleSceneModel()
			}
		    if(event.keyCode==Keyboard.F){
		
			}
			if(event.ctrlKey==true && event.keyCode==Keyboard.V){
				makeCopyData()
			}
		}

		private function deleSceneModel():void
		{
			if(AppData.editMode!=EditModeEnum.EDIT_WORLD){
				return 
			}
			var $arr:Array=_hierarchyPanel.ctrlSelectArr
			for(var i:uint=0;i<$arr.length;i++){
				var tempHie:HierarchyFileNode=$arr[i]as HierarchyFileNode;
				deleFileNode(tempHie )
			}
			
		}
		
		private function makeCopyData():void
		{
			if(_willCopyItem&&_willCopyItem.length){
				var $newItem:Array=new Array
				var $copyNextId:uint=FileNodeManage.getFileNodeNextId(_hierarchyPanel.listBaseArr)
				for(var i:uint=0;i<_willCopyItem.length;i++)
				{
					var $hierarchyFileNode:HierarchyFileNode=_willCopyItem[i].clone($copyNextId+i)
					//$hierarchyFileNode.id=$copyNextId+i
					var $fatherNum:int= findFatherId(_willCopyItem[i].parentNode)
					$newItem.push({node:$hierarchyFileNode,fatherId:$fatherNum})
				}
				pushCopyItemToTree($newItem)
			}
			function findFatherId($defe:HierarchyFileNode):int
			{
				for(var j:uint=0;j<_willCopyItem.length;j++)
				{
					if(_willCopyItem[j]==$defe){
						return j
					}
				}
				return -1
			}
		}
		private function pushCopyItemToTree($arr:Array):void
		{
			var $selectNode:FileNode=_hierarchyPanel.tree.selectedItem as HierarchyFileNode
			if($arr&&$arr.length&&$selectNode){
				
				for(var i:uint=0;i<$arr.length;i++)
				{
					var $fatherId:int=$arr[i].fatherId
					var $hierarchyFileNode:HierarchyFileNode=$arr[i].node
					if($fatherId==-1){
				
						var perentArr:ArrayCollection
						
						if($selectNode.parentNode){
							perentArr=$selectNode.parentNode.children
							$hierarchyFileNode.parentNode=$selectNode.parentNode
						}else{
							perentArr=_hierarchyPanel.listBaseArr
						}
						var toIndex:uint=0
						for(var j:uint=0;j<perentArr.length;j++){
							if(perentArr[j]==$selectNode){
								toIndex=j+1
							}
						}
						perentArr.addItemAt($hierarchyFileNode,toIndex)
	
					}else{
						var prentNode:HierarchyFileNode=$arr[$fatherId].node
						_hierarchyPanel.fileNodeMoveToFileNode($hierarchyFileNode,prentNode)
					}
				}
			}
		}
		

		
		private function getSelectNodeData():void
		{
			var $arr:Array=_hierarchyPanel.ctrlSelectArr
			for(var i:uint=0;i<$arr.length;i++){
				var tempHie:HierarchyFileNode=$arr[i]as HierarchyFileNode;
				_willCopyItem.push(tempHie);
				
			}
			
		}
		private function getSingleCopyData():void
		{
			var $selectNode:FileNode=_hierarchyPanel.tree.selectedItem as HierarchyFileNode
			var $arr:Vector.<FileNode>=FileNodeManage.getChildeFileNode($selectNode)
			for(var i:uint=0;i<$arr.length;i++){
				var tempHie:HierarchyFileNode=$arr[i] as HierarchyFileNode;
				_willCopyItem.push(tempHie);
				
			}
				
				
		}
		
		
		override protected function listenModuleEvents():Array 
		{
			return [
				Mevent_ExpToH5_Event,
				Mevent_Reader_Scene,
				MEvent_ProjectData,
				MEvent_Show_Imodel,
				MEvent_Hierarchy_Property_Show,
				MEvent_Hierarchy_ReFileName,
				MEvent_Hierarchy_Build_Group,
				MEvent_Hierarchy_Dele,
				MEvent_Hierarchy_MoveNode,
				MEvent_Hierarchy_Add,
				MEvent_Hierarchy_Reset,
				MEvent_Add_Light,
				MEvent_Add_Parallel,
				MEvent_Add_Water,
				MEvent_Add_Capture,
				NavMeshEvent,
				MEvent_Hierarchy_Group_Model_hide,
				MEvent_ADD_Reflection,
				MEvent_Add_Grass,
				MEvent_EditMode,
				MEvent_Radiosity_To_C,
				MEvent_Scene_SaveAs,
				MEvent_Hierarchy
			]
		}
		private var testBoolean:Boolean=false
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case Mevent_ExpToH5_Event:
				
					if($me.action == Mevent_ExpToH5_Event.MEVENT_EXPTOH5_EVENT){
						ExpToH5Copy.getInstance().setHierarchy(FileNodeManage.getListAllFileNode(_hierarchyPanel.listBaseArr))
					}else if($me.action == Mevent_ExpToH5_Event.CANCEL_MERGE_SCENE){
						GroupMaterialMath.getInstance().cancelMerge(_hierarchyPanel.listBaseArr)
					}else if($me.action == Mevent_ExpToH5_Event.EVENT_COMBINE_LIGHT_H5){
						Mevent_ExpToH5_Event($me).data.setList(FileNodeManage.getListAllFileNode(_hierarchyPanel.listBaseArr));
					}
				
				
					break;
				
				case MEvent_Hierarchy:
					if($me.action == MEvent_Hierarchy.MEVENT_HIERARCHY_SHOW){
						if(!_hierarchyPanel){
							_hierarchyPanel = new HierarchyPanel;
							_hierarchyPanel.init(this,"视图",3);
							LayerManager.getInstance().addPanel(_hierarchyPanel);
						}
					}
					if($me.action == MEvent_Hierarchy.GET_SCENE_TO_C_FILE_DATA){
						
						Render.xyzPosMoveItem(null)
						var $item:Vector.<FileNode>=FileNodeManage.getListAllFileNode(_hierarchyPanel.listBaseArr);
						var $byte:ByteArray=RadiosityModel.getInstance().makeRenderByteArrayData($item);
						trace("GET_SCENE_TO_C_FILE_DATA",$byte.length)
						
					//	Alert.show("场景文件字节 "+String($byte.length),"c++文件")
						
						var menuEvent:MenuTempEvent=new MenuTempEvent(MenuTempEvent.SET_C_DATA_RENDER_FILE)
						menuEvent.byte=$byte;
						ModuleEventManager.dispatchEvent(menuEvent);
						
					}
					break;
				case MEvent_Hierarchy_Add:
					var $mEvent_Hierarchy_Add:MEvent_Hierarchy_Add=$me as MEvent_Hierarchy_Add
					if($mEvent_Hierarchy_Add.action == MEvent_Hierarchy_Add.MEVENT_HIERARCHY_ADD){
							addModel($mEvent_Hierarchy_Add.fileNode,$mEvent_Hierarchy_Add.toFileNode)
					}
					break;
				case MEvent_Hierarchy_Group_Model_hide:
					var $MEvent_Hierarchy_Group_Model_hide:MEvent_Hierarchy_Group_Model_hide=$me as MEvent_Hierarchy_Group_Model_hide
					if($MEvent_Hierarchy_Group_Model_hide.action == MEvent_Hierarchy_Group_Model_hide.MEVENT_HIERARCHY_GROUP_MODEL_HIDE){

						changeGroupModelHide($MEvent_Hierarchy_Group_Model_hide.hierarchyGroupMesh)
					}
					break;
				case MEvent_Hierarchy_Reset:
					var $mEvent_Hierarchy_Reset:MEvent_Hierarchy_Reset=$me as MEvent_Hierarchy_Reset
					if($mEvent_Hierarchy_Reset.action == MEvent_Hierarchy_Reset.MEVENT_HIERARCHY_RESET){
							//addModel($mEvent_Hierarchy_Add.fileNode,$mEvent_Hierarchy_Add.toFileNode)
						_hierarchyPanel.restHierarchyData($mEvent_Hierarchy_Reset.fileNode)
						
					}
					break;
				case MEvent_Hierarchy_MoveNode:
					var $mEvent_Hierarchy_MoveNode:MEvent_Hierarchy_MoveNode=$me as MEvent_Hierarchy_MoveNode
					if($mEvent_Hierarchy_MoveNode.action == MEvent_Hierarchy_MoveNode.MEVENT_HIERARCHY_MOVENODE){
						_hierarchyPanel.moveFileNodeToFileNode($mEvent_Hierarchy_MoveNode.moveNode,$mEvent_Hierarchy_MoveNode.toNode)
					
					}
					break;
				case MEvent_Hierarchy_Dele:
					var $mEvent_Hierarchy_Dele:MEvent_Hierarchy_Dele=$me as MEvent_Hierarchy_Dele
					if($mEvent_Hierarchy_Dele.action == MEvent_Hierarchy_Dele.MEVENT_HIERARCHY_DELE){
						deleFileNode($mEvent_Hierarchy_Dele.fileNode as HierarchyFileNode )
					}
					break;
				case MEvent_Hierarchy_Build_Group:
					var $mEvent_Hierarchy_OnGroup:MEvent_Hierarchy_Build_Group=$me as MEvent_Hierarchy_Build_Group
					if($mEvent_Hierarchy_OnGroup.action == MEvent_Hierarchy_Build_Group.MEVENT_HIERARCHY_BUILD_GROUP){
						onBuildGroup($mEvent_Hierarchy_OnGroup.fileNode as HierarchyFileNode ,$mEvent_Hierarchy_OnGroup.fileRoot)
					}
					break;
				case MEvent_Hierarchy_ReFileName:
					var $MEvent_Hierarchy_ReFileName:MEvent_Hierarchy_ReFileName=$me as MEvent_Hierarchy_ReFileName
					if($MEvent_Hierarchy_ReFileName.action==MEvent_Hierarchy_ReFileName.MEVENT_HIERARCHY_REFILENAME){
						reFileName($MEvent_Hierarchy_ReFileName.file)
					}
			
					break;
				case MEvent_Hierarchy_Property_Show:
					var $evt:MEvent_Hierarchy_Property_Show=$me as MEvent_Hierarchy_Property_Show
					if($evt.action==MEvent_Hierarchy_Property_Show.MEVENT_HIERARCHY_PROPERTY_SHOW){
						showPropertyModel($evt.tooXyzMoveData,$evt.modeItem,$evt.selectType)
					}
					break;
				case MEvent_Show_Imodel:
					var $MEvent_Show_Imodel:MEvent_Show_Imodel=$me as MEvent_Show_Imodel
					if($MEvent_Show_Imodel.action==MEvent_Show_Imodel.MEVENT_SHOW_IMODEL){
						selectImodelClik($MEvent_Show_Imodel)
					}
					if($MEvent_Show_Imodel.action==MEvent_Show_Imodel.MEVENT_SELECT_ITEM_IMODEL){
						selectItemImodelClik($MEvent_Show_Imodel)
					}
					break;
				case MEvent_Add_Light:
					var $MEvent_Add_Light:MEvent_Add_Light=$me as MEvent_Add_Light
					if($MEvent_Add_Light.action==MEvent_Add_Light.MEVENT_ADD_LIGHT){
						addLightModel()
					}
					break;
				case MEvent_Add_Water:
					var $MEvent_Add_Water:MEvent_Add_Water=$me as MEvent_Add_Water
					if($MEvent_Add_Water.action==MEvent_Add_Water.MEVENT_ADD_WATER){
						var $waterId:uint=FileNodeManage.getFileNodeNextId(_hierarchyPanel.listBaseArr)
						WaterManager.getInstance().addWaterModel($waterId)
					}
					break;
				case NavMeshEvent:
					var $NavMeshEvent:NavMeshEvent=$me as NavMeshEvent;
					if($NavMeshEvent.action==NavMeshEvent.MEVEN_ADD_NAVMESH){
						var $navMeshId:uint=FileNodeManage.getFileNodeNextId(_hierarchyPanel.listBaseArr);
						NavMeshManager.getInstance().addNavMesh($navMeshId);
					}
					
					
					break;
				case MEvent_Add_Capture:
					var $mEvent_Add_Capture:MEvent_Add_Capture=$me as MEvent_Add_Capture
					if($mEvent_Add_Capture.action==MEvent_Add_Capture.MEVENT_ADD_CAPTURE){
						var $captureId:uint=FileNodeManage.getFileNodeNextId(_hierarchyPanel.listBaseArr)
						CaptureManager.getInstance().addCaptureModel($captureId)
					}
					break;
				case MEvent_Add_Grass:
					var $MEvent_Add_Grass:MEvent_Add_Grass=$me as MEvent_Add_Grass;
					if($MEvent_Add_Grass.action==MEvent_Add_Grass.MEVENT_ADD_GRASS)
					{
						var $grassId:uint=FileNodeManage.getFileNodeNextId(_hierarchyPanel.listBaseArr);
						GrassManager.getInstance().addGrassModel($grassId);
					}
					break;
				case MEvent_ADD_Reflection:
					var $mEvent_Add_Reflection:MEvent_ADD_Reflection=$me as MEvent_ADD_Reflection;
					if($mEvent_Add_Reflection.action==MEvent_ADD_Reflection.MEVENT_ADD_REFLECTION)
					{
						var $reFlectionId:uint=FileNodeManage.getFileNodeNextId(_hierarchyPanel.listBaseArr);
						ReFlectionManager.getInstance().addCaptureModel($reFlectionId)
					}
					break;
		
				case MEvent_Add_Parallel:
					var $MEvent_Add_Parallel:MEvent_Add_Parallel=$me as MEvent_Add_Parallel;
					if($MEvent_Add_Parallel.action==MEvent_Add_Parallel.MEVENT_ADD_PARALLEL)
					{
						var $parallelId:uint=FileNodeManage.getFileNodeNextId(_hierarchyPanel.listBaseArr);
						ParallelLightManager.getInstance().addParallelLight($parallelId)
						trace("$parallelId",$parallelId)
					}
					break;

				case MEvent_ProjectData:
					var $MEvent_ProjectData:MEvent_ProjectData=$me as MEvent_ProjectData
					if($MEvent_ProjectData.action == MEvent_ProjectData.PROJECT_SAVE_GET_DATA){
						resetHierarchy();
					}
					if($MEvent_ProjectData.action == MEvent_ProjectData.PROJECT_SAVE_SET_DATA){
						
						useIdArr=new Array()
						trace("检测物伯列表:",testIdRight(_hierarchyPanel.listBaseArr))
						AppData.hierarchyList ={item:wirteItem(_hierarchyPanel.listBaseArr,new Vector3D,true)}
			
					}
					break;
				case MEvent_EditMode:
					var $mEvent_EditMode:MEvent_EditMode=$me as MEvent_EditMode
					if($mEvent_EditMode.action == MEvent_EditMode.MEVENT_EDITMODE_CHANGE){
						if($mEvent_EditMode.mode!=EditModeEnum.EDIT_WORLD){
							Render.xyzPosMoveItem(null)
						}
					}
					break;
				case Mevent_Reader_Scene:
					if($me.action==Mevent_Reader_Scene.MEVENT_READER_SCENE){
							toReaderScene()
					}
					break;
				case MEvent_Radiosity_To_C:
					if($me.action==MEvent_Radiosity_To_C.MEVENT_RADIOSITY_TO_C){
						toRadiosityModel();
					}
				case MEvent_Scene_SaveAs:
					if($me.action==MEvent_Scene_SaveAs.MEVENT_SCENE_SAVEAS){
						sceneSaveAs()
					
					}
					break;
			}
		}
		
		private function selectItemImodelClik($MEvent_Show_Imodel:MEvent_Show_Imodel):void
		{
			var $earr:Array=new Array
			for(var i:uint=0;i<$MEvent_Show_Imodel.item.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=findfileNodeFromListByImodel(_hierarchyPanel.listBaseArr,$MEvent_Show_Imodel.item[i]);
				
				
				if(!testIsLock($hierarchyFileNode)&&!$hierarchyFileNode.isHide){
					openFileNode($hierarchyFileNode)
					
					var $canSelectNode:HierarchyFileNode=$hierarchyFileNode
					while($canSelectNode.treeSelect){
						if($canSelectNode.parentNode){
							$canSelectNode=$canSelectNode.parentNode as HierarchyFileNode
						}else{
							break;
						}
					}
					
					$earr.push($hierarchyFileNode)
				}
			
			
			}

			_hierarchyPanel.xuanQuFileNode($earr,$MEvent_Show_Imodel.shiftKey,true)
		}
		
		private function changeGroupModelHide($hierarchyGroupMesh:HierarchyGroupMesh):void
		{
	
			for(var i:Number=0;i<$hierarchyGroupMesh.item.length;i++)
			{
				var idome:IModel=$hierarchyGroupMesh.item[i]
				var $hierarchyFileNode:HierarchyFileNode=findfileNodeFromListByImodel(_hierarchyPanel.listBaseArr,idome)
					
				if($hierarchyFileNode){
					$hierarchyFileNode.isHide=$hierarchyGroupMesh.isHide
					$hierarchyFileNode.showOrHide();
				}
				
				_hierarchyPanel.restHierarchyData(null)
	
	
					
			}
			
			
		}
		private function  sceneSaveAs():void
		{
			var $item:Vector.<FileNode>=FileNodeManage.getListAllFileNode(_hierarchyPanel.listBaseArr)
			SceneSaveAsModel.getInstance().setRenderItem($item)
		}
		private var _LightProbePropertyView:MetaDataView;

		
		private function resetHierarchy():void
		{
			clearHierarchy()
			if(AppData.hierarchyList){
			
				if(AppData.type==1){
					makeReadFileNode(AppData.hierarchyList.item);
					LightProbeEditorManager.getInstance().mathLightProbeData()
				}else{
				
				}

			}
			
		}
		private function clearHierarchy():void
		{
			var $item:Vector.<FileNode>=FileNodeManage.getListAllFileNode(_hierarchyPanel.listBaseArr)
			for(var i:uint=0;i<$item.length;i++)
			{
				var $tempFileNode:HierarchyFileNode=$item[i] as HierarchyFileNode
				if($tempFileNode.iModel){
					Render.deleDisplay3DModel($tempFileNode.iModel)
				}
			}
			_hierarchyPanel.listBaseArr.removeAll();
		}

		private function toReaderScene():void
		{
		
		
			if(AppData.type==1){
				Render.xyzPosMoveItem(null)
				setTimeout(	function ():void
				{
					var $item:Vector.<FileNode>=FileNodeManage.getListAllFileNode(_hierarchyPanel.listBaseArr)
					if(RenderModel.getInstance().isRadiosity){
						RenderModel.getInstance().setRenderItem($item)
					}
					
				},100)
			}
		
		}
		private function toRadiosityModel():void
		{
			Render.xyzPosMoveItem(null)
			var $item:Vector.<FileNode>=FileNodeManage.getListAllFileNode(_hierarchyPanel.listBaseArr)
			RadiosityModel.getInstance().setRenderItem($item)
		
		}
		
		private function addLightModel():void
		{
		
			var $lightStaticMesh:LightStaticMesh=new LightStaticMesh
			$lightStaticMesh.distance=100
			$lightStaticMesh.color=MathCore.vecToHex(new Vector3D(255,0,0))
			$lightStaticMesh.cutoff=0.1
			$lightStaticMesh.strong=1
			var iLight:ILight=Render.creatLightModel($lightStaticMesh)
				
				
				
			var $p:Vector3D=getLookAtPos()
			iLight.x=$p.x
			iLight.y=$p.y
			iLight.z=$p.z
			
			var $hierarchyFileNode:HierarchyFileNode=new HierarchyFileNode;	
			var $lightId:uint=FileNodeManage.getFileNodeNextId(_hierarchyPanel.listBaseArr)
			$hierarchyFileNode.id=$lightId;
			$hierarchyFileNode.name="点灯";
			$hierarchyFileNode.iModel=iLight;
			$hierarchyFileNode.type=HierarchyNodeType.Light
			$hierarchyFileNode.data=$lightStaticMesh;
			_hierarchyPanel.listBaseArr.addItem($hierarchyFileNode)
			
		}
		private function getLookAtPos():Vector3D
		{
			var $p:Vector3D=new Vector3D(0,0,Scene_data.cam3D.distance);
			var $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-Scene_data.cam3D.rotationX,Vector3D.X_AXIS);
			$m.appendRotation(-Scene_data.cam3D.rotationY,Vector3D.Y_AXIS);
			$p=$m.transformVector($p);
			
			var $pos:Vector3D=new Vector3D
			$pos.x=Scene_data.cam3D.x+$p.x
			$pos.y=Scene_data.cam3D.y+$p.y
			$pos.z=Scene_data.cam3D.z+$p.z
		
				return $pos
		}
		private function testIsLock($hierarchyFileNode:HierarchyFileNode):Boolean
		{
			if($hierarchyFileNode.lock){
				return true
			}else{
			    if($hierarchyFileNode.parentNode as HierarchyFileNode ){
					return testIsLock($hierarchyFileNode.parentNode as HierarchyFileNode)
				}
			}
			return false
		}
		private function selectImodelClik($MEvent_Show_Imodel:MEvent_Show_Imodel):void
		{
			
			var $hierarchyFileNode:HierarchyFileNode=findfileNodeFromListByImodel(_hierarchyPanel.listBaseArr,$MEvent_Show_Imodel.iModel)

			if($hierarchyFileNode&&!_hierarchyPanel.isSearchNow()){
				if(testIsLock($hierarchyFileNode)){
					return ;
				}
				var $canSelectNode:HierarchyFileNode=$hierarchyFileNode
				while($canSelectNode.treeSelect){
					if($canSelectNode.parentNode){
						$canSelectNode=$canSelectNode.parentNode as HierarchyFileNode
					}else{
						break;
					}
				}
				if($hierarchyFileNode.treeSelect){
					openFileNode($canSelectNode)
					var $itemArr:Vector.<FileNode>=FileNodeManage.getChildeFileNode($canSelectNode)
					var $earr:Array=new Array
					for(var i:uint=0;i<$itemArr.length;i++){
						$earr.push($itemArr[i])
					}
					_hierarchyPanel.xuanQuFileNode($earr,$MEvent_Show_Imodel.shiftKey,true)
				}else{
					openFileNode($hierarchyFileNode)
					_hierarchyPanel.xuanQuFileNode([$hierarchyFileNode],$MEvent_Show_Imodel.shiftKey,true)
				}
				var $selectTreeId:uint= FileNodeManage.getFileNodeInOpenId($hierarchyFileNode,_hierarchyPanel.listBaseArr,_hierarchyPanel.tree)
				_hierarchyPanel.tree.scrollToIndex($selectTreeId)
			}
			
		}
		public function openFileNode(filenode:FileNode):void{
			_hierarchyPanel.tree.expandItem(filenode,true);
			if(filenode.parentNode){
				openFileNode(filenode.parentNode);
			}
		}
		private function findfileNodeFromListByImodel($childItem:ArrayCollection,$iModel:IModel):HierarchyFileNode{
			for(var i:uint=0;$childItem&&i<$childItem.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=$childItem[i] as HierarchyFileNode
				if($hierarchyFileNode.iModel==$iModel){
					return $hierarchyFileNode
				}
				var $childFileNode:HierarchyFileNode=findfileNodeFromListByImodel($hierarchyFileNode.children,$iModel)
				if($childFileNode){
					return $childFileNode
				}
			}
			return null
		}
		
		private var _hierarchyGroupPropertyView:MetaDataView;
		private var _lightPropertyView:MetaDataView;
		private var _waterPropertyView:MetaDataView;
		private var _grassPropertyView:MetaDataView;
		private var _capturePropertyView:MetaDataView;
		private var _reflectionPropertyView:MetaDataView;
		private var _parallelLightPropertyView:MetaDataView;
		private var _particlePropertyView:MetaDataView;
		private var _rolePropertyView:MetaDataView;
		private var _navMeshPropertyView:MetaDataView;

		protected function onGroupMeshChange(event:Event):void
		{
			var $HierarchyGroupMesh:HierarchyGroupMesh=HierarchyGroupMesh(event.target)
			if($HierarchyGroupMesh){
		
				GroupMaterialMath.getInstance().conutMaterialArr(_hierarchyPanel.listBaseArr,$HierarchyGroupMesh.item);
				
				//var minGroupId:Number=GroupMaterialMath.getInstance().getHierarchyGroupMaterialID(_hierarchyPanel.listBaseArr,$HierarchyGroupMesh.item);

				//GroupMaterialMath.getInstance().changeHierarchyGroupMaterialId(_hierarchyPanel.listBaseArr,$HierarchyGroupMesh.item,minGroupId)
				
				//$HierarchyGroupMesh.groupMaterialId=minGroupId;
				_hierarchyGroupPropertyView.refreshView()
			}
			
		}
		

	


		private function showPropertyModel(tooXyzMoveData:TooXyzMoveData,$modeItem:Vector.<IModel>,$selectType:uint=0):void
		{
			if(tooXyzMoveData){
				var $hierarchyFileNode:HierarchyFileNode=findfileNodeFromListByImodel(_hierarchyPanel.listBaseArr,$modeItem[0])
				if(!$hierarchyFileNode){
					return 
				}
				var $modePropertyMesh:ModePropertyMesh
				if($hierarchyFileNode.type==HierarchyNodeType.Prefab &&AppData.type==1&&$modeItem.length==1){  //特殊处理
					$modePropertyMesh=showBuildMesh($hierarchyFileNode)
				}else
				if($hierarchyFileNode.type==HierarchyNodeType.Prefab||($selectType==HierarchyNodeType.Folder&&$modeItem.length>1) ){
		
					var $hierarchyGroupMesh:HierarchyGroupMesh=new HierarchyGroupMesh
				
					
					$hierarchyGroupMesh.item=$modeItem
					$hierarchyGroupMesh.groupMaterialId=0
					$modePropertyMesh=$hierarchyGroupMesh
					if(!_hierarchyGroupPropertyView){
						_hierarchyGroupPropertyView = new MetaDataView();
						_hierarchyGroupPropertyView.init(this,"属性",2);
						_hierarchyGroupPropertyView.creatByClass(HierarchyGroupMesh);
					}
					LayerManager.getInstance().showPropPanle(_hierarchyGroupPropertyView);
					$modePropertyMesh.nodeName="组合"
					$modePropertyMesh.fileNode=$hierarchyFileNode
					_hierarchyGroupPropertyView.setTarget($modePropertyMesh);
					
					$hierarchyGroupMesh.addEventListener(Event.COMPLETE,onGroupMeshChange)
					
				}else 
				if($hierarchyFileNode.type==HierarchyNodeType.Light){
					
					$modePropertyMesh= $hierarchyFileNode.data as  LightStaticMesh
					if(!_lightPropertyView){
						_lightPropertyView = new MetaDataView();
						_lightPropertyView.init(this,"属性",2);
						_lightPropertyView.creatByClass(LightStaticMesh);
					}
					LayerManager.getInstance().showPropPanle(_lightPropertyView);
					$modePropertyMesh.nodeName=$hierarchyFileNode.name
					$modePropertyMesh.fileNode=$hierarchyFileNode
					_lightPropertyView.setTarget($modePropertyMesh);
				
				}else 
				if($hierarchyFileNode.type==HierarchyNodeType.Grass){
					
					$modePropertyMesh= $hierarchyFileNode.data as  GrassStaticMesh
					if(!_grassPropertyView){
						_grassPropertyView = new MetaDataView();
						_grassPropertyView.init(this,"属性",2);
						_grassPropertyView.creatByClass(GrassStaticMesh);
					}
					LayerManager.getInstance().showPropPanle(_grassPropertyView);
					$modePropertyMesh.nodeName=$hierarchyFileNode.name
					$modePropertyMesh.fileNode=$hierarchyFileNode
					_grassPropertyView.setTarget($modePropertyMesh);
					
					GrassManager.getInstance().setSelectGrassFileNode($hierarchyFileNode)
					
					SceneEditModeManager.changeMode(EditModeEnum.EDIT_GRASS)
					GroundData.showShaderHitPos=true
					
				}else 
				if($hierarchyFileNode.type==HierarchyNodeType.Water){
					$modePropertyMesh= $hierarchyFileNode.data as  WaterStaticMesh
					if(!_waterPropertyView){
						_waterPropertyView = new MetaDataView();
						_waterPropertyView.init(this,"属性",2);
						_waterPropertyView.creatByClass(WaterStaticMesh);
						
					}
					LayerManager.getInstance().showPropPanle(_waterPropertyView);
					$modePropertyMesh.nodeName=$hierarchyFileNode.name
					$modePropertyMesh.fileNode=$hierarchyFileNode
					_waterPropertyView.setTarget($modePropertyMesh);
				}else
				if($hierarchyFileNode.type==HierarchyNodeType.Capture){
					$modePropertyMesh= $hierarchyFileNode.data as  CaptureStaticMesh
					if(!_capturePropertyView){
						_capturePropertyView = new MetaDataView();
						_capturePropertyView.init(this,"属性",2);
						_capturePropertyView.creatByClass(CaptureStaticMesh);
						
					}
					LayerManager.getInstance().showPropPanle(_capturePropertyView);
					$modePropertyMesh.nodeName=$hierarchyFileNode.name
					$modePropertyMesh.fileNode=$hierarchyFileNode
					_capturePropertyView.setTarget($modePropertyMesh);
				}else
				if($hierarchyFileNode.type==HierarchyNodeType.Reflection){
					$modePropertyMesh= $hierarchyFileNode.data as  ReflectionStaticMesh
					if(!_reflectionPropertyView){
						_reflectionPropertyView = new MetaDataView();
						_reflectionPropertyView.init(this,"属性",2);
						_reflectionPropertyView.creatByClass(ReflectionStaticMesh);
						
					}
					LayerManager.getInstance().showPropPanle(_reflectionPropertyView);
					$modePropertyMesh.nodeName=$hierarchyFileNode.name
					$modePropertyMesh.fileNode=$hierarchyFileNode
					_reflectionPropertyView.setTarget($modePropertyMesh);
				}else
				if($hierarchyFileNode.type==HierarchyNodeType.LightProbe){
					$modePropertyMesh= $hierarchyFileNode.data as  LightProbeStaticMesh
					if(!_LightProbePropertyView){
						_LightProbePropertyView = new MetaDataView();
						_LightProbePropertyView.init(this,"属性",2);
						_LightProbePropertyView.creatByClass(LightProbeStaticMesh);
					}
					LayerManager.getInstance().showPropPanle(_LightProbePropertyView);
					$modePropertyMesh.nodeName=$hierarchyFileNode.name
					$modePropertyMesh.fileNode=$hierarchyFileNode
					_LightProbePropertyView.setTarget($modePropertyMesh);
				}else
				if($hierarchyFileNode.type==HierarchyNodeType.ParallelLight){
					$modePropertyMesh= $hierarchyFileNode.data as  ParallelLightStaticMesh
					if(!_parallelLightPropertyView){
						_parallelLightPropertyView = new MetaDataView();
						_parallelLightPropertyView.init(this,"属性",2);
						_parallelLightPropertyView.creatByClass(ParallelLightStaticMesh);
					}
					LayerManager.getInstance().showPropPanle(_parallelLightPropertyView);
					$modePropertyMesh.nodeName=$hierarchyFileNode.name
					$modePropertyMesh.fileNode=$hierarchyFileNode
					_parallelLightPropertyView.setTarget($modePropertyMesh);
				}else
				if($hierarchyFileNode.type==HierarchyNodeType.Particle){
					$modePropertyMesh= $hierarchyFileNode.data as  ParticleStaticMesh
					if(!_particlePropertyView){
						_particlePropertyView = new MetaDataView();
						_particlePropertyView.init(this,"属性",2);
						_particlePropertyView.creatByClass(ParticleStaticMesh);
					}
					LayerManager.getInstance().showPropPanle(_particlePropertyView);
					$modePropertyMesh.nodeName=$hierarchyFileNode.name
					$modePropertyMesh.fileNode=$hierarchyFileNode
					_particlePropertyView.setTarget($modePropertyMesh);
			
				}else
				if($hierarchyFileNode.type==HierarchyNodeType.Role){
					$modePropertyMesh= $hierarchyFileNode.data as  RoleStaticMesh
					if(!_rolePropertyView){
						_rolePropertyView = new MetaDataView();
						_rolePropertyView.init(this,"属性",2);
						_rolePropertyView.creatByClass(RoleStaticMesh);
					}
					LayerManager.getInstance().showPropPanle(_rolePropertyView);
					$modePropertyMesh.nodeName=$hierarchyFileNode.name
					$modePropertyMesh.fileNode=$hierarchyFileNode
					_rolePropertyView.setTarget($modePropertyMesh);
					
				}
				if($hierarchyFileNode.type==HierarchyNodeType.NavMesh){
					$modePropertyMesh= $hierarchyFileNode.data as  NavMeshStaticMesh
					if(!_navMeshPropertyView){
						_navMeshPropertyView = new MetaDataView();
						_navMeshPropertyView.init(this,"属性",2);
						_navMeshPropertyView.creatByClass(NavMeshStaticMesh);
					}
					LayerManager.getInstance().showPropPanle(_navMeshPropertyView);
					$modePropertyMesh.nodeName=$hierarchyFileNode.name
					$modePropertyMesh.fileNode=$hierarchyFileNode
					_navMeshPropertyView.setTarget($modePropertyMesh);
					
			
					var $NavMeshEvent:NavMeshEvent=new NavMeshEvent(NavMeshEvent.SELECT_NAVMESH_NODE)
		
					$NavMeshEvent.hierarchyFileNode=$hierarchyFileNode;
						
					ModuleEventManager.dispatchEvent($NavMeshEvent);
					
					
				}
				
				$modePropertyMesh.taget=$hierarchyFileNode.data
	
				xyzMoveDataChange()
				$modePropertyMesh.removeEventListener(Event.CHANGE,onMeshChange)
				$modePropertyMesh.addEventListener(Event.CHANGE,onMeshChange)
					
				tooXyzMoveData.dataChangeFun=xyzMoveDataChange
				function xyzMoveDataChange():void
				{
					$modePropertyMesh.postion=new Vector3D(tooXyzMoveData.x,tooXyzMoveData.y,tooXyzMoveData.z)
					$modePropertyMesh.rotationVec=new Vector3D(tooXyzMoveData.angle_x,tooXyzMoveData.angle_y,tooXyzMoveData.angle_z)
					$modePropertyMesh.scaleVec=new Vector3D(tooXyzMoveData.scale_x,tooXyzMoveData.scale_y,tooXyzMoveData.scale_z)
				}
				function onMeshChange(event:Event):void
				{

					tooXyzMoveData.x=$modePropertyMesh.postion.x
					tooXyzMoveData.y=$modePropertyMesh.postion.y
					tooXyzMoveData.z=$modePropertyMesh.postion.z

					tooXyzMoveData.angle_x=$modePropertyMesh.rotationVec.x
					tooXyzMoveData.angle_y=$modePropertyMesh.rotationVec.y
					tooXyzMoveData.angle_z=$modePropertyMesh.rotationVec.z
						
					tooXyzMoveData.scale_x=$modePropertyMesh.scaleVec.x
					tooXyzMoveData.scale_y=$modePropertyMesh.scaleVec.y
					tooXyzMoveData.scale_z=$modePropertyMesh.scaleVec.z
					if(Boolean(tooXyzMoveData.dataUpDate)){
						tooXyzMoveData.dataUpDate()
						if(Boolean(tooXyzMoveData.fun)){
							tooXyzMoveData.fun(tooXyzMoveData);
						}
					}
				}
			}
			
		}
		

		
		private var _buildPropertyView:MetaDataView;
		private var _prefabMeshView:MetaDataView;
		private var _combineReflectionView:CombineReflectionView
		private function showBuildMesh($hierarchyFileNode:HierarchyFileNode):BuildMesh
		{
			var $buildMesh:BuildMesh=BuildMesh($hierarchyFileNode.data)

			if(!_buildPropertyView){
				_buildPropertyView = new MetaDataView();
				_buildPropertyView.init(this,"属性",2);
				_buildPropertyView.creatByClass(BuildMesh);
			}
			if(!_prefabMeshView){
				_prefabMeshView = new MetaDataView();
				_prefabMeshView.init(this,"属性",2);
				_prefabMeshView.creatByClass(PrefabStaticMesh);
			}
			if(!_combineReflectionView){
				_combineReflectionView = new CombineReflectionView();
				_combineReflectionView.init(this,"属性",2);
				_combineReflectionView.addView(_buildPropertyView)
				_combineReflectionView.addView(_prefabMeshView)
			}
			LayerManager.getInstance().showPropPanle(_combineReflectionView);
			
			
		
			_buildPropertyView.setTarget($buildMesh);
			_prefabMeshView.setTarget(PrefabStaticMesh($buildMesh.prefabStaticMesh));
			_combineReflectionView.setTarget($hierarchyFileNode)

			$buildMesh.addEventListener(Event.CHANGE,onMeshChange)
			function onMeshChange(event:Event):void
			{
				if($hierarchyFileNode.iModel){
					CaptureManager.getInstance().getCaptureVoById($buildMesh.captureId,function ($textureCubeMapVo:TextureCubeMapVo):void{
						$hierarchyFileNode.iModel.setEnvCubeMap($textureCubeMapVo)
						
					})
				}
			}
			return $buildMesh
		}
		
	
	
		private function reFileName($file:File):void
		{
			if($file){
				var $fs:FileStream = new FileStream;
				$fs.open($file,FileMode.READ);
				var $obj:Object = $fs.readObject();
				if($obj.item&&$obj.item[0]){
					var $fileName:String=$file.name
					$fileName=$fileName.replace("."+$file.extension,"")
					$obj.item[0].name=$fileName
				}
				$fs.open($file,FileMode.WRITE);
				$fs.writeObject($obj);
				$fs.close();
			}
		}
		
		private var onGroupCentenPos:Vector3D;
		private var onGroupItemNum:uint=0
		private function getGroupCenten(childItem:ArrayCollection):Vector3D
		{
			for(var i:uint=0;childItem&&i<childItem.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=childItem[i] as HierarchyFileNode
				getGroupCenten($hierarchyFileNode.children)
				if($hierarchyFileNode.iModel){
					onGroupCentenPos.x+=$hierarchyFileNode.iModel.x;
					onGroupCentenPos.y+=$hierarchyFileNode.iModel.y;
					onGroupCentenPos.z+=$hierarchyFileNode.iModel.z;
					onGroupItemNum++;
				}

			}

			return onGroupCentenPos.clone()
		}
		private var minPosVec:Vector3D;
		private function getGroupMinPos(childItem:ArrayCollection):Vector3D
		{
			for(var i:uint=0;childItem&&i<childItem.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=childItem[i] as HierarchyFileNode
				getGroupMinPos($hierarchyFileNode.children)
				if($hierarchyFileNode.iModel){
				
					if(minPosVec){
						minPosVec.x=Math.min($hierarchyFileNode.iModel.x,minPosVec.x);
						minPosVec.y=Math.min($hierarchyFileNode.iModel.y,minPosVec.y);
						minPosVec.z=Math.min($hierarchyFileNode.iModel.z,minPosVec.z);
					}else{
						minPosVec=new Vector3D($hierarchyFileNode.iModel.x,$hierarchyFileNode.iModel.y,$hierarchyFileNode.iModel.z)
					}
					
				}
				
			}
			
			return minPosVec
		}
		private function onBuildGroup($hierarchyFileNode:HierarchyFileNode,$fileRoot:String):void
		{
			if($hierarchyFileNode&&$fileRoot){
				var $arrayCollection:ArrayCollection=new ArrayCollection
				$arrayCollection.addItem($hierarchyFileNode)
				onGroupCentenPos=new Vector3D(0,0,0)
				onGroupItemNum=0
				var $pos:Vector3D=getGroupCenten($arrayCollection)
				if(onGroupItemNum>=1){
					$pos.scaleBy(1/onGroupItemNum)
				}
				
				//最小的坐标
				minPosVec=null
				$pos=getGroupMinPos($arrayCollection)
				if(!$pos){
					$pos=new Vector3D(0,0,0)
				}
				
				
				var $arr:Array=wirteItem($arrayCollection,$pos,false)
	
				var file:File = new File($fileRoot+$hierarchyFileNode.name+".group");
				
				if(file.exists){
					Alert.yesLabel="确定";
					Alert.noLabel="取消";
					Alert.show("是否覆盖原来的组！！","提示",3,null,deleteCallBack)
				}else{
					writeFile()
				}
				function writeFile():void
				{
					
					
					var fs:FileStream = new FileStream;
					fs.open(file,FileMode.WRITE);
					fs.writeObject({item:$arr});
					fs.close();
					ModuleEventManager.dispatchEvent(new MEvent_Brower_Refresh(MEvent_Brower_Refresh.MEVENT_BROWER_REFRESH));
				}
				function deleteCallBack(event:CloseEvent):void
				{
					if(event.detail==Alert.YES)
					{
						writeFile()
					}
					
		
				}
				
			
			
			}
		}
		private function deleFileNode($hierarchyFileNode:HierarchyFileNode):void
		{
			if($hierarchyFileNode)
			{
				var $arr:Vector.<FileNode>=FileNodeManage.getChildeFileNode($hierarchyFileNode)
				for(var i:uint=0;i<$arr.length;i++)
				{
					var $tempFileNode:HierarchyFileNode=$arr[i] as HierarchyFileNode
						
					if($tempFileNode.type==HierarchyNodeType.Prefab){
						var $url:String=Render.lightUvRoot+"build"+$tempFileNode.id+".jpg"
						FileSaveModel.getInstance().deleFile($url)
					}
					if($tempFileNode.iModel){
						Render.deleDisplay3DModel($tempFileNode.iModel)
						$tempFileNode.iModel=null
					}
			
					
					
				}
				var $parentNode:FileNode=$hierarchyFileNode.parentNode
				if($parentNode)
				{
					$parentNode.children.removeItem($hierarchyFileNode)
				}else{
					_hierarchyPanel.listBaseArr.removeItem($hierarchyFileNode)
				}
				_hierarchyPanel.onSecarchTextChange()
				Render.xyzPosMoveItem(null)
			}
			
		}

		private var _gropType0Url:String="file:///C:/Users/Administrator/Desktop/listTree0.group"
		private var _gropType1Url:String="file:///C:/Users/Administrator/Desktop/listTree1.group"

		private var useIdArr:Array=new Array
		private function testIdRight($childItem:ArrayCollection):Boolean
		{
		
			
			for(var i:uint=0;$childItem&&i<$childItem.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=$childItem[i] as HierarchyFileNode;
				trace($hierarchyFileNode.id)
				for(var j:uint=0;j<useIdArr.length;j++)
				{
					if(useIdArr[j]==$hierarchyFileNode.id){
						Alert.show("重复ID:"+$hierarchyFileNode.name)
						$hierarchyFileNode.id=FileNodeManage.getFileNodeNextId(_hierarchyPanel.listBaseArr);
					}
				}
				if($hierarchyFileNode.children){
					testIdRight($hierarchyFileNode.children)
				}
				useIdArr.push($hierarchyFileNode.id)
			}
	
			return true
		}
		private function wirteItem(childItem:ArrayCollection,$pos:Vector3D,$useId:Boolean):Array
		{
	
			
			
			var $item:Array=new Array
			for(var i:uint=0;childItem&&i<childItem.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=childItem[i] as HierarchyFileNode
				var $obj:Object=new Object;
				if($useId){
					$obj.id=$hierarchyFileNode.id
				}
				$obj.children=wirteItem($hierarchyFileNode.children,$pos,$useId)
				$obj.name=$hierarchyFileNode.name
				$obj.type=$hierarchyFileNode.type
				$obj.treeSelect=$hierarchyFileNode.treeSelect
				$obj.lock=$hierarchyFileNode.lock
				$obj.isHide=$hierarchyFileNode.isHide




				if($hierarchyFileNode.type==HierarchyNodeType.Prefab ){
					var $buildMesh:BuildMesh=$hierarchyFileNode.data as BuildMesh
					if($buildMesh){

						$obj.data=$buildMesh.readObject();
					}
					
				}
				if($hierarchyFileNode.type ==HierarchyNodeType.Light){
					var $lightStaticMesh:LightStaticMesh=$hierarchyFileNode.data as LightStaticMesh
					$obj.data=$lightStaticMesh.readObject();
				}
				if($hierarchyFileNode.type ==HierarchyNodeType.Reflection){
					var $reflectionMesh:ReflectionStaticMesh=$hierarchyFileNode.data as ReflectionStaticMesh
					$obj.data=$reflectionMesh.readObject();
				}
				if($hierarchyFileNode.type ==HierarchyNodeType.Grass){
					var $grassStaticMesh:GrassStaticMesh=$hierarchyFileNode.data as GrassStaticMesh
					$obj.data=$grassStaticMesh.readObject();
				}
				if($hierarchyFileNode.type ==HierarchyNodeType.Capture){
					var $captureStaticMesh:CaptureStaticMesh=$hierarchyFileNode.data as CaptureStaticMesh
					CaptureManager.getInstance().saveCubeBmp($captureStaticMesh,$hierarchyFileNode.id)
					$obj.data=$captureStaticMesh.readObject();
				}
				if($hierarchyFileNode.type ==HierarchyNodeType.LightProbe){
					var $lightProbeStaticMesh:LightProbeStaticMesh=$hierarchyFileNode.data as LightProbeStaticMesh
					$obj.data=$lightProbeStaticMesh.readObject();
				}
				if($hierarchyFileNode.type ==HierarchyNodeType.Particle){
					var $particleStaticMesh:ParticleStaticMesh=$hierarchyFileNode.data as ParticleStaticMesh
					$obj.data=$particleStaticMesh.readObject();
				}
				if($hierarchyFileNode.type ==HierarchyNodeType.Role){
					var $roleStaticMesh:RoleStaticMesh=$hierarchyFileNode.data as RoleStaticMesh
					$obj.data=$roleStaticMesh.readObject();
				}
				if($hierarchyFileNode.type ==HierarchyNodeType.ParallelLight){
					var $parallelLightStaticMesh:ParallelLightStaticMesh=$hierarchyFileNode.data as ParallelLightStaticMesh
					$obj.data=$parallelLightStaticMesh.readObject();
				}
				if($hierarchyFileNode.type ==HierarchyNodeType.NavMesh){
					
					var $navMeshStaticMesh:NavMeshStaticMesh=$hierarchyFileNode.data as NavMeshStaticMesh
					$obj.data=$navMeshStaticMesh.readObject();
				}
				if($hierarchyFileNode.type ==HierarchyNodeType.Water){
					var $waterStaticMesh:WaterStaticMesh=$hierarchyFileNode.data as WaterStaticMesh
					var $waterBmpUrl:String=(AppData.workSpaceUrl + AppData.mapUrl).replace(".lmap","") + "_hide/water/"+$hierarchyFileNode.id+".jpg"
					if($waterStaticMesh.dephtBmp){
						FileSaveModel.getInstance().saveBitmapdataToJpg($waterStaticMesh.dephtBmp,$waterBmpUrl)
					}
					$obj.data=$waterStaticMesh.readObject();
				}
				
				if($hierarchyFileNode.iModel){
					$obj.x=$hierarchyFileNode.iModel.x-$pos.x
					$obj.y=$hierarchyFileNode.iModel.y-$pos.y
					$obj.z=$hierarchyFileNode.iModel.z-$pos.z
					$obj.scaleX=$hierarchyFileNode.iModel.scaleX
					$obj.scaleY=$hierarchyFileNode.iModel.scaleY
					$obj.scaleZ=$hierarchyFileNode.iModel.scaleZ
					$obj.rotationX=$hierarchyFileNode.iModel.rotationX
					$obj.rotationY=$hierarchyFileNode.iModel.rotationY
					$obj.rotationZ=$hierarchyFileNode.iModel.rotationZ
				}
				$item.push($obj)
			}
			if($item.length){
				return $item
			}
			return null
		}
	

		private function objToPreFab($obj:Object):PrefabStaticMesh
		{
			var prefab:PrefabStaticMesh = new PrefabStaticMesh();
			for(var i:String in $obj) {
				prefab[i]=$obj[i]
			}
			return prefab
		}
		private function makeReadFileNode($arr:Array,$parent:HierarchyFileNode=null,$centenpos:Vector3D=null,isAddGruop:Boolean=false):void
		{
		
			if(AppData.type==0||false){
				return ;
			}

		
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

				if($arr[i].id){
					$tempNode.id=$arr[i].id
				}else{
					$tempNode.id=FileNodeManage.getFileNodeNextId(_hierarchyPanel.listBaseArr)
				}

				//$tempNode.name="id"+String($tempNode.id)
				if(!$tempNode.type){  //兼容原来没有type，可以以后删除
					if($arr[i].data)
					{
						$tempNode.type=HierarchyNodeType.Prefab
					}
				}
				if($tempNode.type==HierarchyNodeType.Prefab){
		

					
						var $buildMesh:BuildMesh=BuildManager.getInstance().objToBuildMesh($arr[i].data)
						if(isAddGruop){
							$buildMesh.isNotCook=true
						}
						$buildMesh.nodeName=$tempNode.name
						if($buildMesh.prefabStaticMesh){
							var $buildModel:IModel=Render.creatDisplay3DModel($buildMesh.prefabStaticMesh,$tempNode.id)
							$tempNode.iModel=$buildModel
							$tempNode.data=$buildMesh
							CaptureManager.getInstance().getCaptureVoById($buildMesh.captureId,function ($textureCubeMapVo:TextureCubeMapVo):void{
								$buildModel.setEnvCubeMap($textureCubeMapVo)
								
							})
						}
			
				
				}
				if($tempNode.type==HierarchyNodeType.Water){
					
					var $waterMesh:WaterStaticMesh=WaterManager.getInstance().objToWateMesh($arr[i].data)
					$waterMesh.rootUrl=(AppData.workSpaceUrl + AppData.mapUrl).replace(".lmap","") + "_hide/water/"
					var $waterModel:IModel=Render.creatWaterModel($waterMesh,$tempNode.id)
				    
                    IWater($waterModel).reflectionTextureVo=ReFlectionManager.getInstance().getReFlectionVoById($waterMesh.reFlectionId)
					$tempNode.iModel=$waterModel
					CaptureManager.getInstance().getCaptureVoById($waterMesh.captureId,function ($textureCubeMapVo:TextureCubeMapVo):void{
						$waterModel.setEnvCubeMap($textureCubeMapVo)
					})
						
					$tempNode.data=$waterMesh
				
				}
				
				if($tempNode.type==HierarchyNodeType.Light){
					var $lightMesh:LightStaticMesh=objToLightMesh($arr[i].data)
					$tempNode.iModel=Render.creatLightModel($lightMesh)
					$tempNode.data=$lightMesh
				}
				if($tempNode.type==HierarchyNodeType.Reflection){
					var $reflectionMesh:ReflectionStaticMesh=ReFlectionManager.getInstance().objToReflectionMesh($arr[i].data)
					$tempNode.iModel=Render.creatReFlectionModel($reflectionMesh,$tempNode.id)
					if(AppData.type==1){
						IReflection($tempNode.iModel).reflectionTextureVo=ReFlectionManager.getInstance().getReFlectionVoById($tempNode.id)
						$tempNode.data=$reflectionMesh
					}
				
				}
				if($tempNode.type==HierarchyNodeType.NavMesh){
					var $navMeshStaticMesh:NavMeshStaticMesh=NavMeshManager.getInstance().objToNavMesh($arr[i].data)
					$tempNode.iModel=Render.creatNavMeshModel($navMeshStaticMesh,$tempNode.id)
					$tempNode.data=$navMeshStaticMesh
					
				}
				if($tempNode.type==HierarchyNodeType.Grass){
					var $grassMesh:GrassStaticMesh=GrassManager.getInstance().objToGrassMesh($arr[i].data)
					$tempNode.iModel=Render.creatGrassModel($grassMesh)
					$tempNode.data=$grassMesh
				}
				if($tempNode.type==HierarchyNodeType.Particle){
					var $particleMesh:ParticleStaticMesh=LizhiManager.getInstance().objToMesh($arr[i].data)
					$tempNode.iModel=Render.creatParticle($particleMesh)
					$tempNode.data=$particleMesh
				}
				if($tempNode.type==HierarchyNodeType.Role){
					var $roleStaticMesh:RoleStaticMesh=RoleManager.getInstance().objToMesh($arr[i].data)
					$tempNode.iModel=Render.creatRole($roleStaticMesh)
					$tempNode.data=$roleStaticMesh
				}
				if($tempNode.type==HierarchyNodeType.LightProbe){
					var $lightProbeStaticMesh:LightProbeStaticMesh=LightProbeEditorManager.getInstance().objToMesh($arr[i].data)
					$tempNode.iModel=Render.resetLightProbel($lightProbeStaticMesh)
					$tempNode.data=$lightProbeStaticMesh
				}
				if($tempNode.type==HierarchyNodeType.ParallelLight){
					var $parallelLightStaticMesh:ParallelLightStaticMesh=ParallelLightManager.getInstance().objToMesh($arr[i].data)
					$tempNode.iModel=Render.creatParallelLight($parallelLightStaticMesh);
					$tempNode.data=$parallelLightStaticMesh;
				}
				if($tempNode.type==HierarchyNodeType.Capture){
					var $capturesMesh:CaptureStaticMesh=CaptureManager.getInstance().objToCaptureMesh($arr[i].data)
					$tempNode.iModel=Render.creatCaptureModel($capturesMesh,$tempNode.id)
					$tempNode.data=$capturesMesh;
					CaptureManager.getInstance().getCaptureVoById($tempNode.id,function ($textureCubeMapVo:TextureCubeMapVo):void{
						$capturesMesh.textureBaseVo=$textureCubeMapVo
					})
				}
				if($tempNode.iModel){
					
					$tempNode.data.postion=new Vector3D( $arr[i].x,$arr[i].y,$arr[i].z)

					$tempNode.iModel.x=Number($arr[i].x)+$centenpos.x
					$tempNode.iModel.y=Number($arr[i].y)+$centenpos.y
					$tempNode.iModel.z=Number($arr[i].z)+$centenpos.z
					$tempNode.iModel.scaleX=Number($arr[i].scaleX)
					$tempNode.iModel.scaleY=Number($arr[i].scaleY)
					$tempNode.iModel.scaleZ=Number($arr[i].scaleZ)
					$tempNode.iModel.rotationX=Number($arr[i].rotationX)
					$tempNode.iModel.rotationY=Number($arr[i].rotationY)
					$tempNode.iModel.rotationZ=Number($arr[i].rotationZ)
						
					$tempNode.iModel.visible=!$tempNode.isHide
				}
				if($parent){
					$tempNode.parentNode=$parent	
					if(!$parent.children){
						$parent.children=new ArrayCollection
					}
					$parent.children.addItem($tempNode)
				}else{
					_hierarchyPanel.listBaseArr.addItem($tempNode)
				}
				if($arr[i].children){
					$tempNode.children=new ArrayCollection
					makeReadFileNode($arr[i].children,$tempNode,$centenpos,isAddGruop)
				}
					
			}
		}
		private function objToLightMesh($obj:Object):LightStaticMesh
		{
			var prefab:LightStaticMesh = new LightStaticMesh();
			for(var i:String in $obj) {
				prefab[i]=$obj[i]
			}
			return prefab
		}
	

		private function getGroundPos():Vector3D
		{

//			var m:Matrix3D=Scene_data.cam3D.cameraMatrix.clone()
//			m.invert()
//			var k:Vector3D=m.transformVector(new Vector3D(0,0,Scene_data.sceneViewHW/2))
//			return k;
			return GroundManager.getInstance().getMouseHitGroundWorldPos();
	
		}
		private function addModel($fileNode:FileNode,$toFileNode:FileNode):void
		{
			var hitPos:Vector3D=getGroundPos();
			if(AppData.type==1){
				if($fileNode.extension=="group"){
					addGroupFile($fileNode,$toFileNode as HierarchyFileNode)
				}
				if($fileNode.extension=="lyf"){
					var $lizhiId:uint=FileNodeManage.getFileNodeNextId(_hierarchyPanel.listBaseArr)
					var $particeModel:IModel=LizhiManager.getInstance().addParticleModel($lizhiId,$fileNode.url);
					$particeModel.x=hitPos.x
					$particeModel.y=hitPos.y
					$particeModel.z=hitPos.z
				}
				if($fileNode.extension=="prefab"){
					var $buildId:uint=FileNodeManage.getFileNodeNextId(_hierarchyPanel.listBaseArr)
					var ddswwd:HierarchyFileNode=BuildManager.getInstance().addddd($buildId,$fileNode.url)
					ddswwd.iModel.x=hitPos.x
					ddswwd.iModel.y=hitPos.y
					ddswwd.iModel.z=hitPos.z
				}
				if($fileNode.extension=="zzw"){
					//readRole($fileNode.url);
					var $roleId:uint=FileNodeManage.getFileNodeNextId(_hierarchyPanel.listBaseArr)
					var $roleNode:HierarchyFileNode=RoleManager.getInstance().addRoleModel($roleId,$fileNode.url)
					$roleNode.iModel.x=hitPos.x
					$roleNode.iModel.y=hitPos.y
					$roleNode.iModel.z=hitPos.z
				}
				return 
			}

	
		
			
		}
	
		
		private function readRole($url:String):void{
			//
			
			
			var role:Display3DEditorMovie=new Display3DEditorMovie(Scene_data.context3D)
			
			var file:File = new File($url);
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.READ);
			var roleData:Object = fs.readObject();
			fs.close();
			
			var meshAry:Array = new Array;
			
			for(var i:int;i<roleData.mesh.length;i++){
				var children:ArrayCollection = roleData.mesh[i].children;
				for(var j:int=0;j<children.length;j++){
					meshAry.push(children[j]);
				}
			}
			
			var obj:Object = new Object;
			obj.bone = roleData.bone;
			obj.mesh = meshAry;
			obj.socket = roleData.socket;
			
			new RoleLoadUtils(obj).setRoleData(role,obj)

			role.name = file.name;
			role.fileScale = roleData.scale;
			obj.role = role; 
			
//			role.x = 164; 
//			role.y = 275; 
//			role.z = 417;

			
			//role.addEventListener("boneComplete",onLoadCom);
			
			role.play("stand");
			//role.pause = true;
			
			
			role.updatePosMatrix();
			
			SceneContext.sceneRender.modelLevel.addMode(role);
			
		}

		private function addGroupFile($fileNode:FileNode,$toFileNode:HierarchyFileNode):void
		{
			var $pos:Vector3D=new Vector3D()
			if($toFileNode&&$toFileNode.iModel){
				$pos.x=$toFileNode.iModel.x
				$pos.y=$toFileNode.iModel.y
				$pos.z=$toFileNode.iModel.z
			}else{
				$pos=getGroundPos()
			}
			var $file:File=new File($fileNode.url)
			if($file.exists){
				var $fs:FileStream = new FileStream;
				$fs.open($file,FileMode.READ);
				var $obj:Object = $fs.readObject();
				makeReadFileNode($obj.item,$toFileNode,$pos,true)
				_hierarchyPanel.listBaseArr.refresh()
			}

		}
	}
}