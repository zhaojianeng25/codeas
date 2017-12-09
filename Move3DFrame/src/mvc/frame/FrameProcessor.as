package mvc.frame
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.RichEditableText;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.engineConfig.MEventStageResize;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Property_Show;
	import common.msg.event.scene.MEvent_Show_Imodel;
	import common.utils.frame.MetaDataView;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	
	import exph5.ChangObjsNrmModel;
	
	import manager.LayerManager;
	
	import modules.menu.MenuReadyEvent;
	
	import mvc.frame.lightbmp.LightBmpModel;
	import mvc.frame.view.FrameFileNode;
	import mvc.frame.view.FrameGroupMesh;
	import mvc.frame.view.FramePanel;
	import mvc.libray.LibrayFildNode;
	import mvc.mesh.FrameNodeMesh;
	import mvc.mesh.FrameNodeMetaDataView;
	
	import pack.ModePropertyMesh;
	
	import proxy.pan3d.roles.ProxyPan3DRole;
	import proxy.top.model.IModel;
	import proxy.top.render.Render;
	
	import xyz.MoveScaleRotationLevel;
	import xyz.base.TooXyzPosData;
	import xyz.draw.TooXyzMoveData;
	
	public class FrameProcessor extends Processor
	{
		private var _framePanel:FramePanel;
		private var _buildPropertyView:MetaDataView;
		private var _frameNodeMetaDataView:FrameNodeMetaDataView;
		public function FrameProcessor($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				FrameEvent,
				MEvent_Show_Imodel,
				MenuReadyEvent,
				MEvent_Hierarchy_Property_Show,
				
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case FrameEvent:
					var $frameEvent:FrameEvent=$me as FrameEvent
					if($me.action==FrameEvent.SHOW_FRAME_UI){
						showHide()
						this.addEvents()
					}
					if($me.action==FrameEvent.SELECT_FRAME_MODEL){
					
					}
					if($me.action==FrameEvent.DELE_FRAME_MODEL){
						this.deleNode($frameEvent.node)
					}
					if($me.action==FrameEvent.COPY_FRAME_MODEL){
						this.copyFrameNode($frameEvent.node)
					}
					
					if($me.action==FrameEvent.REFRISH_FRAME_LINE_CAVANS){
						this._framePanel.refrishFrameList()
					}
					if($me.action==FrameEvent.MEVENT_FRAME_NODE_MOVENODE){
						this.moveAtoB($frameEvent.moveNode,$frameEvent.toNode)
					}
					if($me.action==FrameEvent.REFRISH_TREE_DATA){
						Scene_data.stage.focus=null;
						FrameModel.getInstance().tree.invalidateList();
						FrameModel.getInstance().tree.validateNow();
					}
					if($me.action==FrameEvent.REFRISH_TREE_NODE_NAME){
						FrameModel.getInstance().tree.selectedItems=[]
						
					}
					if($me.action==FrameEvent.OPEN_FRAME_FILE){
						FrameModel.getInstance().tree.selectedItems=[]
						this.readFileData()
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
					
					Scene_data.stage.focus=Scene_data.stage
					break;
				case MenuReadyEvent:
					var $MenuReadyEvent:MenuReadyEvent=$me as MenuReadyEvent
					if($MenuReadyEvent.action==MenuReadyEvent.MENU_READY_EVENT){
		
					}
					break;

				case MEvent_Hierarchy_Property_Show:
					var $evt:MEvent_Hierarchy_Property_Show=$me as MEvent_Hierarchy_Property_Show
					if($evt.action==MEvent_Hierarchy_Property_Show.MEVENT_HIERARCHY_PROPERTY_SHOW){
						showPropertyModel($evt.tooXyzMoveData,$evt.modeItem,$evt.selectType)
					}
					break;
				default:
				{
					break;
				}
			}
		}
		
		private function selectItemImodelClik($MEvent_Show_Imodel:MEvent_Show_Imodel):void
		{
			var $earr:Array=new Array
			for(var i:uint=0;i<$MEvent_Show_Imodel.item.length;i++){
				var $frameFileNode:FrameFileNode=	FrameModel.getInstance().getNodeByImodel($MEvent_Show_Imodel.item[i])
				if(!testIsLock($frameFileNode)&&!$frameFileNode.hide){
					openFileNode($frameFileNode)
					var $canSelectNode:FrameFileNode=$frameFileNode
					while($canSelectNode.treeSelect){
						if($canSelectNode.parentNode){
							$canSelectNode=$canSelectNode.parentNode as FrameFileNode
						}else{
							break;
						}
					}
					$earr.push($frameFileNode)
				}
			}
			_framePanel.xuanQuFileNode($earr,$MEvent_Show_Imodel.shiftKey,true)
			
		}
		public function openFileNode(filenode:FileNode):void{
			FrameModel.getInstance().tree.expandItem(filenode,true);
			if(filenode.parentNode){
				openFileNode(filenode.parentNode);
			}
		}
		private function testIsLock($hierarchyFileNode:FrameFileNode):Boolean
		{
			if($hierarchyFileNode.lock){
				return true
			}else{
				if($hierarchyFileNode.parentNode as FrameFileNode ){
					return testIsLock($hierarchyFileNode.parentNode as FrameFileNode)
				}
			}
			return false
		}
		
		private function selectImodelClik($MEvent_Show_Imodel:MEvent_Show_Imodel):void
		{
			var $frameFileNode:FrameFileNode=	FrameModel.getInstance().getNodeByImodel($MEvent_Show_Imodel.iModel)
			if($frameFileNode){
				var $canSelectNode:FrameFileNode=$frameFileNode
				while($canSelectNode.treeSelect){
					if($canSelectNode.parentNode){
						$canSelectNode=$canSelectNode.parentNode as FrameFileNode
					}else{
						break;
					}
				}
				if($frameFileNode.treeSelect){
					FrameModel.getInstance().expandPerentNode($canSelectNode)
					var $itemArr:Vector.<FileNode>=FileNodeManage.getChildeFileNode($canSelectNode)
					var $earr:Array=new Array
					for(var i:uint=0;i<$itemArr.length;i++){
						$earr.push($itemArr[i])
					}
					_framePanel.xuanQuFileNode($earr,$MEvent_Show_Imodel.shiftKey,true)
				}else{
					
					FrameModel.getInstance().expandPerentNode($frameFileNode)
					_framePanel.xuanQuFileNode([$frameFileNode],$MEvent_Show_Imodel.shiftKey,true)
				}
				var $selectTreeId:uint= FileNodeManage.getFileNodeInOpenId($frameFileNode,FrameModel.getInstance().ary,FrameModel.getInstance().tree)
				FrameModel.getInstance().tree.scrollToIndex($selectTreeId)
				
				FrameModel.getInstance().framePanel.refrishFrameList()
				
			}
			
		}
		private function copyFrameNode($copyNode:FrameFileNode):void
		{
			var $node:FrameFileNode=new FrameFileNode()
			$node.writeObject($copyNode.getObject())
			$node.id=FileNodeManage.getFileNodeNextId(FrameModel.getInstance().ary);
			$node.parentNode=$copyNode.parentNode;
	
			if($copyNode.parentNode){
				$copyNode.parentNode.children.addItemAt($node,	$copyNode.parentNode.children.getItemIndex($copyNode));
			}else{
				FrameModel.getInstance().ary.addItem($node);
			}
			FrameModel.getInstance().framePanel.refrishFrameList();
		}
		private function findfileNodeFromListByImodel($iModel:IModel):FrameFileNode{
			return FrameModel.getInstance().getNodeByImodel($iModel)

		}
		private var _hierarchyGroupPropertyView:MetaDataView;

		private function showPropertyModel($tooXyzMoveData:TooXyzMoveData, $modeItem:Vector.<IModel>, $selectType:uint):void
		{
			if($tooXyzMoveData){
				this.tooXyzMoveData=$tooXyzMoveData;
				this.tooXyzMoveData.fun=xyzBfun
				this.tooXyzMoveData.dataChangeFun=xyzMoveDataChange
					
				var $modePropertyMesh:ModePropertyMesh
				var $frameFileNode:FrameFileNode=FrameModel.getInstance().getNodeByImodel($modeItem[0])
				if($frameFileNode.type==FrameFileNode.build1&&$modeItem.length==1){
					$modePropertyMesh=this.showFrameFileNode($frameFileNode)
						
						
				}else{
					var $hierarchyGroupMesh:FrameGroupMesh=new FrameGroupMesh
					$hierarchyGroupMesh.item=$modeItem
					$hierarchyGroupMesh.groupMaterialId=0
					$modePropertyMesh=$hierarchyGroupMesh
					if(!_hierarchyGroupPropertyView){
						_hierarchyGroupPropertyView = new MetaDataView();
						_hierarchyGroupPropertyView.init(this,"属性",2);
						_hierarchyGroupPropertyView.creatByClass(FrameGroupMesh);
					}
					$modePropertyMesh.nodeName="组合"
					_hierarchyGroupPropertyView.setTarget($modePropertyMesh);
					LayerManager.getInstance().addPanel(_hierarchyGroupPropertyView);
					
					$hierarchyGroupMesh.addEventListener(Event.ACTIVATE,frameGroupMeshChange)

				}
				this.selectFrameNodeMesh=$modePropertyMesh
				xyzMoveDataChange()
				this.selectFrameNodeMesh.addEventListener(Event.CHANGE,frameNodeMeshChange)
					
			}
		
		}
		
		protected function frameGroupMeshChange(event:Event):void
		{

			for(var i:uint=0;this.tooXyzMoveData.modelItem&&i<this.tooXyzMoveData.modelItem.length;i++){
				var $iModel:IModel=IModel(this.tooXyzMoveData.modelItem[i])
				this._framePanel.addFrameKeyByModelChange($iModel);
			}

		}
		

		
		


		private function moveAtoB($moveNode:FileNode,$toNode:FrameFileNode):void
		{
			if($moveNode is FrameFileNode){
				
				//this.fileNodeMoveToFileNode($moveNode,$toNode)
				var $items:Array=	FrameModel.getInstance().tree.selectedItems;
				var $toNode:FrameFileNode= $toNode;
				if($toNode.type==FrameFileNode.Folder0){
					for(var i:Number=0;i<$items.length;i++){
						var $temp:FrameFileNode= $items[i]
						this.fileNodeMoveToFileNode($temp,$toNode)
					}
					
				}
				
			}
			if($moveNode is LibrayFildNode){
				this.addFrameNewNodeByMove($moveNode as LibrayFildNode ,$toNode)
			}
			this._framePanel.refrishFrameList()
		}
		private function addFrameNewNodeByMove($moveNode:LibrayFildNode,$toNode:FrameFileNode):void
		{
	
			if($moveNode.type==LibrayFildNode.Pefrab_TYPE1){
				 var $tempB:FrameFileNode = new FrameFileNode;
				 $tempB.id=	FileNodeManage.getFileNodeNextId(FrameModel.getInstance().ary)
				 $tempB.url=$moveNode.url.replace(AppData.workSpaceUrl,"")
				 $tempB.iModel=AppDataFrame.addModel($tempB.url)
				 $tempB.parentNode=$toNode
				 $tempB.type=FrameFileNode.build1
				 $tempB.iModel.scaleX=1;
				 $tempB.iModel.scaleY=1;
				 $tempB.iModel.scaleZ=1;
				 $tempB.name=$moveNode.name;
				 
				 $tempB.pointitem[1].time=Math.max(AppDataFrame.frameNum,100)
				 $toNode.children.addItem($tempB)
			}
			
		}
		
		private function fileNodeMoveToFileNode($moveNode:FileNode,$toNode:FileNode):void
		{
			if($moveNode!=$toNode){
				var moveParent:FileNode=$moveNode.parentNode
				if(moveParent){
					moveParent.children.removeItem($moveNode)
					if(moveParent.children.length==0){
						moveParent.children=null
					}
				}else{
					FrameModel.getInstance().ary.removeItem($moveNode)	
				}
				
				if($toNode){
					if(!$toNode.children){
						$toNode.children=new ArrayCollection;
					}
					$moveNode.parentNode=$toNode;
					$toNode.children.addItemAt($moveNode,0);
				}else{
					$moveNode.parentNode=null
					FrameModel.getInstance().ary.addItemAt($moveNode,0)
				}
				
			}
		}

		private function readFileData():void
		{
			
			FrameModel.getInstance().clearScene();
			
			

			var file:File = new File(AppData.workSpaceUrl +AppDataFrame.fileUrl);
		

			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.READ);
			var obj:Object = fs.readObject();
			fs.close();
			
			
			AppData.appTitle="Frame3d--"+decodeURI(AppDataFrame.fileUrl)
			
	
			
			this.showSceneTreeData(obj.ary,FrameModel.getInstance().ary);
			
			FrameModel.getInstance().framePanel.playFrameTo(AppDataFrame.frameNum,true)
				
			LightBmpModel.getInstance().resetLightNodel()
		
		}
		private function showSceneTreeData($arr:Array,$perent:ArrayCollection):void
		{
		
			if($arr){
				for(var i:Number=0;i<$arr.length;i++){
					var $node:FrameFileNode=new FrameFileNode()
					$node.writeObject($arr[i])
				
					$perent.addItem($node);
				}
				ModuleEventManager.dispatchEvent( new FrameEvent(FrameEvent.REFRISH_FRAME_LINE_CAVANS));
			}
		
		}
		
		private function deleNode(node:FrameFileNode):void
		{
		

			if(node)
			{
				var $arr:Vector.<FileNode>=FileNodeManage.getChildeFileNode(node)
				for(var i:uint=0;i<$arr.length;i++)
				{
					var $tempFileNode:FrameFileNode=$arr[i] as FrameFileNode
					if($tempFileNode.iModel){
						Render.deleDisplay3DModel($tempFileNode.iModel)
						$tempFileNode.iModel=null
						if($tempFileNode.frameLineMc.parent){
							$tempFileNode.frameLineMc.parent.removeChild($tempFileNode.frameLineMc)
						}
					}
				}
				var $parentNode:FileNode=node.parentNode
				if($parentNode)
				{
					$parentNode.children.removeItem(node)
				}else{
					FrameModel.getInstance().ary.removeItem(node)
				}
				Render.xyzPosMoveItem(null);
				ModuleEventManager.dispatchEvent( new FrameEvent(FrameEvent.REFRISH_FRAME_LINE_CAVANS));
			}
			
		}

		private var tooXyzMoveData:TooXyzMoveData
		private function showFrameFileNode($frameFileNode:FrameFileNode):ModePropertyMesh
		{
			if(!_frameNodeMetaDataView){
				_frameNodeMetaDataView = new FrameNodeMetaDataView();
				_frameNodeMetaDataView.init(this,"属性",2);
				_frameNodeMetaDataView.creatByClass(FrameNodeMesh);
				
			}
			var $frameNodeMesh:FrameNodeMesh=new FrameNodeMesh
			$frameNodeMesh.frameFileNode=$frameFileNode
			_frameNodeMetaDataView.setTarget($frameNodeMesh);
			LayerManager.getInstance().addPanel(_frameNodeMetaDataView);
			ChangObjsNrmModel.getInstance().selectNode=$frameFileNode //用于。。。
			return $frameNodeMesh
		}
		private function xyzMoveDataChange():void
		{
			selectFrameNodeMesh.postion=new Vector3D(tooXyzMoveData.x,tooXyzMoveData.y,tooXyzMoveData.z)
			selectFrameNodeMesh.rotationVec=new Vector3D(tooXyzMoveData.angle_x,tooXyzMoveData.angle_y,tooXyzMoveData.angle_z)
			selectFrameNodeMesh.scaleVec=new Vector3D(tooXyzMoveData.scale_x,tooXyzMoveData.scale_y,tooXyzMoveData.scale_z)

		}
		private var selectFrameNodeMesh:ModePropertyMesh
		
		protected function frameNodeMeshChange(event:Event):void
		{
			var $H5UIFileMesh:ModePropertyMesh=ModePropertyMesh(event.target);
			tooXyzMoveData.x=$H5UIFileMesh.postion.x
			tooXyzMoveData.y=$H5UIFileMesh.postion.y
			tooXyzMoveData.z=$H5UIFileMesh.postion.z
			
			tooXyzMoveData.angle_x=$H5UIFileMesh.rotationVec.x
			tooXyzMoveData.angle_y=$H5UIFileMesh.rotationVec.y
			tooXyzMoveData.angle_z=$H5UIFileMesh.rotationVec.z
			
			tooXyzMoveData.scale_x=$H5UIFileMesh.scaleVec.x
			tooXyzMoveData.scale_y=$H5UIFileMesh.scaleVec.y
			tooXyzMoveData.scale_z=$H5UIFileMesh.scaleVec.z
			if(Boolean(tooXyzMoveData.dataUpDate)){
				tooXyzMoveData.dataUpDate()
				if(Boolean(tooXyzMoveData.fun)){
					tooXyzMoveData.fun(tooXyzMoveData);
				}
			}
			
		}
		private  function xyzBfun($XyzMoveData:xyz.draw.TooXyzMoveData):void
		{
			for(var i:uint=0;i<$XyzMoveData.modelItem.length;i++){
				var $iModel:IModel=IModel($XyzMoveData.modelItem[i])
				var $dataPos:TooXyzPosData=$XyzMoveData.dataItem[i]
				
				$iModel.x=$dataPos.x
				$iModel.y=$dataPos.y
				$iModel.z=$dataPos.z
			
				$iModel.rotationX=$dataPos.angle_x
				$iModel.rotationY=$dataPos.angle_y
				$iModel.rotationZ=$dataPos.angle_z
				
				$iModel.scaleX=$dataPos.scale_x
				$iModel.scaleY=$dataPos.scale_y
				$iModel.scaleZ=$dataPos.scale_z
					
				if($iModel as ProxyPan3DRole){  //特殊处理
					ProxyPan3DRole($iModel).sprite.fileScale=($dataPos.scale_x+$dataPos.scale_y+$dataPos.scale_z)/3;
				}
				this._framePanel.addFrameKeyByModelChange($iModel);
				
			}


		}
		private function addEvents():void
		{

			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,selectCtrlMouseDown);
			
			Scene_data.stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		private var lastKeySpaceTM:Number=-1
		protected function onKeyDown(event:KeyboardEvent):void
		{


			if(event.keyCode==Keyboard.F5){
				FrameModel.getInstance().insetF5(event.shiftKey)
			}
			if(event.keyCode==Keyboard.F6){
				FrameModel.getInstance().insetF6()
			}
			if(event.shiftKey ){
				if( event.keyCode==Keyboard.UP){
					trace("向上")
					FrameModel.getInstance().moveFrameNodeUpOrDown(true)
				}
				if( event.keyCode==Keyboard.DOWN){
					trace("向下")
					FrameModel.getInstance().moveFrameNodeUpOrDown(false)
				}
				
			}
			
			if(event.target is RichEditableText){
				return
			}
			
			if(! (event.target is Stage)){
				trace(event.target)
				if(event.keyCode==Keyboard.SPACE){
		          if(getTimer()-lastKeySpaceTM<200){
				     Scene_data.stage.focus=Scene_data.stage;
				  }
				  lastKeySpaceTM=getTimer()
				}
			
			}

			if(event.keyCode==Keyboard.Q){
				MoveScaleRotationLevel.getInstance().xyzMoveData=null
				FrameModel.getInstance().slectImodelTriClear()
			}

			AppDataFrame.frameNum=Math.floor(AppDataFrame.frameNum);
			switch(event.keyCode)
			{
				case 49:
				{
					AppDataFrame.frameNum=0
					AppDataFrame.aotuPlayFrame=true
					break;
				}
				case 32:
				{
					AppDataFrame.aotuPlayFrame=!AppDataFrame.aotuPlayFrame
					break;
				}
				case Keyboard.F:
				{
					FrameModel.getInstance().framePanel.downKeyBoardF()
					break;
				}
				case Keyboard.LEFT:
				{
					AppDataFrame.aotuPlayFrame=false
					FrameModel.getInstance().framePanel.playFrameTo(Math.max(AppDataFrame.frameNum-1,0),true)
					break;
				}
				case  Keyboard.RIGHT:
				{
					AppDataFrame.aotuPlayFrame=false
					FrameModel.getInstance().framePanel.playFrameTo(AppDataFrame.frameNum+1,true)
					break;
				}
				default:
				{
					break;
				}
			}
	

		}
		
		private var lastTime:Number=-1
		protected function onEnterFrame(event:Event):void
		{
			if(AppDataFrame.aotuPlayFrame){
	
				var dt:Number= getTimer()-this.lastTime;
				AppDataFrame.frameNum+=dt/(1000/AppDataFrame.frameSpeed)
				AppDataFrame.frameNum=AppDataFrame.frameNum%FrameModel.getInstance().getTotalTime();
				FrameModel.getInstance().framePanel.playFrameTo(AppDataFrame.frameNum,true);
			}
			this.lastTime = getTimer();
		
			
		}
		
		private function get mouseInStage3D():Boolean
		{
			var $rect:Rectangle=new Rectangle(0,0,Scene_data.stage3DVO.width,Scene_data.stage3DVO.height)
			return $rect.containsPoint(new Point(Scene_data.stage3DVO.mouseX,Scene_data.stage3DVO.mouseY));
		}
		private function selectCtrlMouseDown(event:MouseEvent):void
		{
			
			if((event.ctrlKey||event.shiftKey) &&mouseInStage3D){
				var $iModel:IModel=Render.getMouseHitModel(new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY))
				if($iModel){
					var evt:MEvent_Show_Imodel=new MEvent_Show_Imodel(MEvent_Show_Imodel.MEVENT_SHOW_IMODEL);
					evt.iModel=$iModel;
					evt.shiftKey=event.shiftKey
					ModuleEventManager.dispatchEvent(evt);
				
				}

			
			}
		}
		private function resize(evt:MEventStageResize):void
		{
			if(_framePanel){
				_framePanel.onSize()
			}
		}		
		
		public function showHide():void
		{
			if(!_framePanel){
				_framePanel = new FramePanel;
				
			}
			//_centenPanel.init(this,"分割(E)",1);
			_framePanel.init(this,"frame",6);
			LayerManager.getInstance().addPanel(_framePanel);
			
		}
	}
}


