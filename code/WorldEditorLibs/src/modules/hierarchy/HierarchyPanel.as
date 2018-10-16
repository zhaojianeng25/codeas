package modules.hierarchy
{
	
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.managers.DragManager;
	
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.hierarchy.MEvent_Hierarchy_MoveNode;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Property_Show;
	import common.msg.event.scene.MEvent_ADD_LightProbe;
	import common.msg.event.scene.MEvent_ADD_Reflection;
	import common.msg.event.scene.MEvent_Add_Capture;
	import common.msg.event.scene.MEvent_Add_Grass;
	import common.msg.event.scene.MEvent_Add_Light;
	import common.msg.event.scene.MEvent_Add_Parallel;
	import common.msg.event.scene.MEvent_Add_Water;
	import common.utils.frame.BasePanel;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	import common.utils.ui.file.FileTreeMenu;
	import common.utils.ui.prefab.PicBut;
	import common.utils.ui.tab.TabPanel;
	import common.vo.editmode.EditModeEnum;
	
	import manager.LayerManager;
	
	import modules.brower.fileWin.BrowerManage;
	import modules.capture.CaptureManager;
	import modules.lightProbe.LightProbeEditorManager;
	import modules.lightProbe.ParallelLightManager;
	import modules.lizhi.LizhiManager;
	import modules.navMesh.NavMeshEvent;
	import modules.navMesh.NavMeshManager;
	import modules.reflection.ReFlectionManager;
	import modules.roles.RoleManager;
	import modules.scene.SceneEditModeManager;
	import modules.water.WaterManager;
	
	import proxy.top.model.IModel;
	import proxy.top.render.Render;
	
	import render.FouceCamMath;
	import render.build.BuildManager;
	import render.grass.GrassManager;
	
	import xyz.draw.TooXyzMoveData;

	public class HierarchyPanel extends BasePanel
	{

		private var _searchTxt:TextInput;
		private var _searchBut:PicBut;
		private var _tree:Tree;
		private var _listBaseArr:ArrayCollection;
		private var _searchArr:ArrayCollection
		private var _outMoveLine:UIComponent;

		public function HierarchyPanel()
		{
			super();

			this.horizontalScrollPolicy = "off";
			

			addInputTxt();
			addButs();
			addList()
			addOut()
			
			initListData();
			initMenuFile()
			addEvents();
			
		}
		
		public function get ctrlSelectArr():Array
		{
			return _ctrlSelectArr;
		}

		public function set ctrlSelectArr(value:Array):void
		{
			_ctrlSelectArr = value;
		}

		private function addOut():void
		{
			_outMoveLine=new UIComponent
			this.addChild(_outMoveLine)
			
		}
		
		public function get tree():Tree
		{
			return _tree;
		}

		public function set tree(value:Tree):void
		{
			_tree = value;
		}

		public function get listBaseArr():ArrayCollection
		{
			return _listBaseArr;
		}

		private function initListData():void
		{
			var rootNode:HierarchyFileNode = new HierarchyFileNode;
			rootNode.name ="name"
			rootNode.url = "url"

			_listBaseArr = new ArrayCollection;
			_listBaseArr.addItem(rootNode);
			_tree.dataProvider = _listBaseArr;
			_tree.invalidateList();
			_tree.validateNow();
			_tree.focusEnabled = false;
			
	
			WaterManager.getInstance().listArr=_listBaseArr;
			GrassManager.getInstance().listArr=_listBaseArr;
			CaptureManager.getInstance().listArr=_listBaseArr;
			BuildManager.getInstance().listArr=_listBaseArr;
			ReFlectionManager.getInstance().listArr=_listBaseArr;
			NavMeshManager.getInstance().listArr=_listBaseArr;
			LightProbeEditorManager.getInstance().listArr=_listBaseArr;
			ParallelLightManager.getInstance().listArr=_listBaseArr;

			LizhiManager.getInstance().listArr=_listBaseArr;
			RoleManager.getInstance().listArr=_listBaseArr;
			
		}
		public function restHierarchyData($fileNode:FileNode):void
		{
			_tree.selectedItems=[$fileNode]   

		}
		
		private var _sceleHierarchyFileNode:HierarchyFileNode;
		protected function onDoubleClik(event:ListEvent):void
		{
	
			trace("onDoubleClik")
			var $selfNode:HierarchyFileNode= event.itemRenderer.data as HierarchyFileNode
			if($selfNode&&$selfNode.iModel){
				FouceCamMath.getInstance().FouceTo(new Vector3D($selfNode.iModel.x,$selfNode.iModel.y,$selfNode.iModel.z))
				xuanQuFileNode([$selfNode],false,true,0)
			}
			
			
		}
		protected function onItemClik(event:ListEvent):void
		{
			trace("onItemClik")
			if(event.itemRenderer){
				_sceleHierarchyFileNode= event.itemRenderer.data as HierarchyFileNode	
				if(_sceleHierarchyFileNode.type==HierarchyNodeType.LightProbe){
					SceneEditModeManager.changeMode(EditModeEnum.EDIT_LIGHTPROBE)
				}else{
					SceneEditModeManager.changeMode(EditModeEnum.EDIT_WORLD)
				}
				if(_ctrlKeyDown){  //单选添加
				
					if(isFileNodeInArr(_ctrlSelectArr,_sceleHierarchyFileNode))
					{
						for(var j:uint=0;j<_ctrlSelectArr.length;j++){
							if(_ctrlSelectArr[j]==_sceleHierarchyFileNode){
								_ctrlSelectArr.splice(j,1)
							}
						}
					}else{
						_ctrlSelectArr.push(_sceleHierarchyFileNode)
					}
					xuanQuFileNode(_ctrlSelectArr)
					
				}else if(_shiftKeyDown){  //复选
					if(!isFileNodeInArr(_shiftSelectArr,_sceleHierarchyFileNode))
					{
						if(_shiftSelectArr.length>1){
							_shiftSelectArr[1]=_sceleHierarchyFileNode
						}else{
							_shiftSelectArr.push(_sceleHierarchyFileNode)
						}
					}
					if(_shiftSelectArr.length==2){
						_ctrlSelectArr=getShiftArr(_shiftSelectArr)
						xuanQuFileNode(_ctrlSelectArr)
					}
				}else{
						_ctrlSelectArr=new Array
						_ctrlSelectArr.push(_sceleHierarchyFileNode)
						_shiftSelectArr=new Array
						_shiftSelectArr.push(_sceleHierarchyFileNode)
							
						var $itemArr:Vector.<FileNode>=FileNodeManage.getChildeFileNode(_sceleHierarchyFileNode)
						var $earr:Array=new Array
						for(var i:uint=0;i<$itemArr.length;i++){
							$earr.push($itemArr[i])
						}
						xuanQuFileNode($earr,false,false,_sceleHierarchyFileNode.type)
						singleSelect=true
				}
			
			}
		}
		public var singleSelect:Boolean=false  //是否为单选
		public function xuanQuFileNode($arr:Array,$shiftKey:Boolean=false,slect:Boolean=true,$selectType:uint=0):void
		{
			singleSelect=false
			var $itemArr:Array=new Array
			if($shiftKey){
				$itemArr=_tree.selectedItems
				for(var j:uint=0;j<$arr.length;j++){
					var $needAdd:Boolean=true
					for(var k:uint=0;k<$itemArr.length;k++){
						if($itemArr[k]==$arr[j]){//已有
							$needAdd=false
						}
					}
					if($needAdd){
						$itemArr.push($arr[j])
					}
				}

			}else{
				$itemArr=$arr
			}
	
			var $iModelArr:Vector.<IModel>=new Vector.<IModel>
			for(var i:uint=0;i<$itemArr.length;i++){
				if(HierarchyFileNode($itemArr[i]) .iModel){
					$iModelArr.push(HierarchyFileNode($itemArr[i]).iModel)
				}
			}
			if($iModelArr.length){
				xyzPosMoveItem($iModelArr,$selectType)
			}
			if(slect){
				_tree.selectedItems=$itemArr
			}
			_ctrlSelectArr=_tree.selectedItems
			
		}
		
		
		
		
		/**
		 *fileNode是否在数组里 
		 * @param $arr
		 * @param $fileNode
		 * @return 
		 * 
		 */
		private function isFileNodeInArr($arr:Array,$fileNode:FileNode):Boolean
		{
			for(var i:uint=0;i<$arr.length;i++){
				if($arr[i]==$fileNode){
					return true
				}
			}
			
			return false
		}
		private function getShiftArr($arr:Array):Array
		{

			var $selectItem:Array=new Array

			if($arr.length==1){
				$selectItem=$arr;
			}
			var $isTure:Boolean=false
			if($arr.length==2){
				var $fileNodeArr:Vector.<HierarchyFileNode>=getListAllFileNode(_listBaseArr)
				for(var i:uint=0;i<$fileNodeArr.length;i++){
					
					for(var j:uint=0;j<$arr.length;j++){
						if($fileNodeArr[i]==$arr[j]){
							$isTure=!$isTure
							if(!$isTure){  //结束的最后一个也要添加
								$selectItem.push($fileNodeArr[i])
							}
						}
					}
					if($isTure){//在范围内的也要添加
						$selectItem.push($fileNodeArr[i])
					}
					
					
				}
			}
			
			return $selectItem
		
				
			
           
		}
		private function getListAllFileNode($childItem:ArrayCollection):Vector.<HierarchyFileNode>
		{
			var $arr:Vector.<HierarchyFileNode>=new Vector.<HierarchyFileNode>
			for(var i:uint=0;$childItem&&i<$childItem.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=$childItem[i] as HierarchyFileNode
				$arr.push($hierarchyFileNode)
				$arr=$arr.concat(getListAllFileNode($hierarchyFileNode.children))
				
			}
			return $arr
		}
		private var _ctrlKeyDown:Boolean=false
		private var _ctrlSelectArr:Array=new Array
		private var _shiftKeyDown:Boolean=false
		private var _shiftSelectArr:Array=new Array

		public function xyzPosMoveItem($iModelArr:Vector.<IModel>,$selectType:uint=0):void
		{
		

			slectImodelTriClear();
			
			for(var i:uint=0;i<$iModelArr.length;i++){
				$iModelArr[i].select=true
			}
	
			var $tooXyzMoveData:TooXyzMoveData=Render.xyzPosMoveItem($iModelArr);
			var $evt:MEvent_Hierarchy_Property_Show=new MEvent_Hierarchy_Property_Show(MEvent_Hierarchy_Property_Show.MEVENT_HIERARCHY_PROPERTY_SHOW)
			$evt.modeItem=$iModelArr;
			$evt.selectType=$selectType
			$evt.tooXyzMoveData=$tooXyzMoveData;
			ModuleEventManager.dispatchEvent($evt);
	
		}
		private function slectImodelTriClear():void
		{
			

			
			var $arr:Vector.<HierarchyFileNode>=getListAllFileNode(_listBaseArr)
			for(var i:uint=0;i<$arr.length;i++){
				if($arr[i].iModel){
					$arr[i].iModel.select=false
				}
				
			}
		}

			
		private function getCentPos($iModelArr:Vector.<IModel>):Vector3D
		{
			var pos:Vector3D=new Vector3D
			for(var i:uint;i<$iModelArr.length;i++){
				pos.x+=$iModelArr[i].x
				pos.y+=$iModelArr[i].y
				pos.z+=$iModelArr[i].z
			}
			pos.scaleBy(1/$iModelArr.length)
			return pos
		}


		private function moveShiftselectArr($willMoveItem:Array,toNode:HierarchyFileNode):void
		{
			var i:uint=0
			if($willMoveItem.length>0){
				//var $willMoveItem:Array=getShiftArr(_shiftSelectArr)
				var $testParentNode:FileNode=toNode
				while($testParentNode){
					if(isFileNodeInArr($willMoveItem,$testParentNode)){
						//如果移到目标在这些里面，将不可以，
						return ;
					}
					$testParentNode=$testParentNode.parentNode
				}
				
				
				if(!isFileNodeInArr($willMoveItem,toNode)){
					var $camMoveItem:Array=new Array;
					for( i=0;i<$willMoveItem.length;i++)
					{
						var $tempNode:HierarchyFileNode=$willMoveItem[i]
						if($tempNode.parentNode&&isFileNodeInArr($willMoveItem,$tempNode.parentNode)){
							//有父亲并也在里面将不添加为可移动，因为它可跟父亲一起移动
						}else{
							$camMoveItem.push($tempNode)
						}
					}
					$camMoveItem.reverse();
					for( i=0;i<$camMoveItem.length;i++)
					{
						var $moveNode:HierarchyFileNode=$camMoveItem[i]
						fileNodeMoveToFileNode($moveNode,toNode)
					}
				}
			}
		}
		
		public function fileNodeMoveToFileNode($moveNode:FileNode,toNode:FileNode):void
		{
		
			
			
			if($moveNode!=toNode){
				var moveParent:FileNode=$moveNode.parentNode
				if(moveParent){
					moveParent.children.removeItem($moveNode)
					if(moveParent.children.length==0){
						moveParent.children=null
					}
				}else{
					_listBaseArr.removeItem($moveNode)
				}
				
				if(toNode){
					if(!toNode.children){
						toNode.children=new ArrayCollection;
					}
					$moveNode.parentNode=toNode;
					toNode.children.addItemAt($moveNode,0);
				}else{
					$moveNode.parentNode=null
					_listBaseArr.addItemAt($moveNode,0)
				}
				
			}
		}

		public function moveFileNodeToFileNode($moveNode:HierarchyFileNode,toNode:HierarchyFileNode):void
		{
			if(!isSearchNow()){
				 if(_ctrlSelectArr.length>1){
					moveShiftselectArr(_ctrlSelectArr,toNode);
				}else{
					fileNodeMoveToFileNode($moveNode,toNode)
				}
			}
		}
		public function isSearchNow():Boolean
		{
			if(_searchTxt.text.length>0){
				return true
			}else{
				return false
			}
	
		}
		
		private function addButs():void
		{
			_searchBut=new PicBut
			_searchBut.setBitmapdata(BrowerManage.getIcon("search"))
			_searchBut.x=220
			_searchBut.y=5
			_searchBut.buttonMode=true
			this.addChild(_searchBut);
			_searchBut.addEventListener(MouseEvent.CLICK,onSearchBtnClick);
			
		}
		
		protected function onSearchBtnClick(event:MouseEvent):void
		{
			var mainTab:TabPanel = LayerManager.getInstance().mainTab;
			
		}		
		
		
		private function addList():void
		{
			_tree = new Tree;
			_tree.setStyle("top",30);
			_tree.setStyle("bottom",5);
			_tree.setStyle("left",5);
			_tree.setStyle("right",5);
			_tree.setStyle("contentBackgroundColor",0x505050);
			_tree.setStyle("color",0x9f9f9f);
			_tree.setStyle("borderVisible",false);
			this.addChild(_tree);
			_tree.labelField="name";
			_tree.itemRenderer = new ClassFactory(HierarchyItemRender);
			FileTreeMenu.getInstance().treeView = _tree;
			
			_tree.iconFunction = tree_iconFunc;
			
			
			
		}
	
		private function tree_iconFunc(item:HierarchyFileNode):Class {  
	
	
				
			if(item.isHide){
				return BrowerManage.getIconClassByName("hideIcon20")
			}
			if(item.type==HierarchyNodeType.Light){
				return BrowerManage.getIconClassByName("light_16")
			}
			if(item.type==HierarchyNodeType.Prefab){
				return BrowerManage.getIconClassByName("profeb_16")
			}
			if(item.type==HierarchyNodeType.Water){
				return BrowerManage.getIconClassByName("water_16")
			}
			if(item.type==HierarchyNodeType.Grass){
				return BrowerManage.getIconClassByName("grass_16")
			}
			if(item.type==HierarchyNodeType.Capture){
				return BrowerManage.getIconClassByName("captureIcon16")
			}
			if(item.type==HierarchyNodeType.Reflection){
				return BrowerManage.getIconClassByName("captureIcon16")
			}
			if(item.type==HierarchyNodeType.LightProbe){
				return BrowerManage.getIconClassByName("lightprobeIco")
			}
			if(item.type==HierarchyNodeType.ParallelLight){
				return BrowerManage.getIconClassByName("icon_class_DirectionalLight18")
			}
			if(item.type==HierarchyNodeType.Particle){
				return BrowerManage.getIconClassByName("Emitter_particle_18p")
			}
			if(item.type==HierarchyNodeType.Role){
				return BrowerManage.getIconClassByName("Emitter_particle_18p")
			}
			
			return BrowerManage.getIconClassByName("icon_folderopen_bright")

		}  
		
		
		private function addInputTxt():void
		{
			_searchTxt = new TextInput;
			_searchTxt.setStyle("contentBackgroundColor",0x404040);
			_searchTxt.setStyle("borderVisible",true);
			_searchTxt.setStyle("color",0x9f9f9f);
			_searchTxt.setStyle("paddingTop",4);
			_searchTxt.x=5
			_searchTxt.y=2
			_searchTxt.width=200
			this.addChild(_searchTxt);
			
		}
		
		private function addEvents():void
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onStage);

			_tree.addEventListener(ListEvent.ITEM_CLICK,onItemClik);
			_tree.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,onDoubleClik)
			_tree.addEventListener(ListEvent.CHANGE,onChuange)
			_tree.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
	
			_searchTxt.addEventListener(Event.CHANGE,onSecarchTextChange)
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp)
			Scene_data.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onStageRightDown)
			Scene_data.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,onStageRightUp)
				
				
			_outMoveLine.addEventListener(DragEvent.DRAG_ENTER,list_dragEnterHandler)
			_outMoveLine.addEventListener(DragEvent.DRAG_DROP,list_dragDropHandler)
				

		}
		private var _isMouseRightDown:Boolean=false
		protected function onStageRightUp(event:MouseEvent):void
		{
			_isMouseRightDown=false
			
		}
		
		protected function onStageRightDown(event:MouseEvent):void
		{
			_isMouseRightDown=true
			
		}		
	
		
		protected function list_dragDropHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			if(isCameMove($fileNode)){
			

				var $evt:MEvent_Hierarchy_MoveNode=new MEvent_Hierarchy_MoveNode(MEvent_Hierarchy_MoveNode.MEVENT_HIERARCHY_MOVENODE)
				$evt.moveNode=$fileNode as HierarchyFileNode
				$evt.toNode=null
				ModuleEventManager.dispatchEvent($evt);
			}
			
		}
		
		protected function list_dragEnterHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
	
			if(isCameMove($fileNode)){
				var ui:UIComponent = event.target as UIComponent;
				DragManager.acceptDragDrop(ui);
			}
			
		}
		private function isCameMove($fileNode:FileNode):Boolean
		{
			
			if($fileNode as HierarchyFileNode)
			{
				return true
			}
			
			return false
			
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			_ctrlKeyDown=false
			_shiftKeyDown=false
		}
		protected function onKeyDown(event:KeyboardEvent):void
		{

			_ctrlKeyDown=event.ctrlKey
			_shiftKeyDown=event.shiftKey
		
				
			if((event.keyCode==27 ) && AppData.editMode==EditModeEnum.EDIT_WORLD&&!_isMouseRightDown){
				_tree.selectedItems=[];
				slectImodelTriClear()
			
				
			}
		
			
			
		}
		
		public function onSecarchTextChange(event:TextOperationEvent=null):void
		{

			if(isSearchNow()){
				var $findTxt:String=_searchTxt.text.toUpperCase()
				_searchArr=new ArrayCollection

				var $arr:Vector.<HierarchyFileNode>=getListAllFileNode(_listBaseArr)
				for(var i:uint=0;i<$arr.length;i++){
					var $hierarchyFileNode:HierarchyFileNode=$arr[i] 
					var ddd:String=$hierarchyFileNode.name
					ddd=ddd.toUpperCase()
					
					if(ddd.search($findTxt)!=-1||$hierarchyFileNode.id==Number($findTxt)){
					//	$hierarchyFileNode.name="<font color='#ffffff' face='宋体'> </font>"
						_searchArr.addItem($hierarchyFileNode)
					}
				}
				
				
				_tree.dataProvider = _searchArr;
				_tree.invalidateList();
				_tree.validateNow();
			}else
			{
				_tree.dataProvider = _listBaseArr;
			}
		}

		protected function onRightClick(event:MouseEvent):void
		{
			if(event.target as ListBaseContentHolder){
				_menuFile.display(this.stage,this.stage.mouseX,this.stage.mouseY);
			}
			
		}
		private var _menuFile:NativeMenu;
		public function initMenuFile():void{
			_menuFile = new NativeMenu;

			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;
			
			item = new NativeMenuItem("新建文件夹")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onNewGroup);
			
			item = new NativeMenuItem("添加点灯")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onAddPointLight);
			
			
			if(AppData.type==1){
				var panpan:NativeMenu = new NativeMenu;
				_menuFile.addSubmenu(panpan,"新建");

				item = new NativeMenuItem("添加草")
				panpan.addItem(item);
				item.addEventListener(Event.SELECT,onAddGrass);
				
				item = new NativeMenuItem("添加水面")
				panpan.addItem(item);
				item.addEventListener(Event.SELECT,onAddWater);
				
				item = new NativeMenuItem("添加NavMesh")
				panpan.addItem(item);
				item.addEventListener(Event.SELECT,onAddNavMesh);
				
				item = new NativeMenuItem("添加cube捕捉器")
				panpan.addItem(item);
				item.addEventListener(Event.SELECT,onAddCapture);
				
				item = new NativeMenuItem("添加反折射器")
				panpan.addItem(item);
				item.addEventListener(Event.SELECT,onAddReflection);
				
				item = new NativeMenuItem("添加LightProbe")
				panpan.addItem(item);
				item.addEventListener(Event.SELECT,onAddLightProbe);
				
				item = new NativeMenuItem("添加平行光")
				panpan.addItem(item);
				item.addEventListener(Event.SELECT,onAddParallel);
			}

			
		}
		
		protected function onAddNavMesh(event:Event):void
		{
			ModuleEventManager.dispatchEvent(new NavMeshEvent(NavMeshEvent.MEVEN_ADD_NAVMESH));
			
		}
		
		protected function onAddParallel(event:Event):void
		{
			ModuleEventManager.dispatchEvent(new MEvent_Add_Parallel(MEvent_Add_Parallel.MEVENT_ADD_PARALLEL));
			
		}
		
		protected function onAddLightProbe(event:Event):void
		{
			ModuleEventManager.dispatchEvent(new MEvent_ADD_LightProbe(MEvent_ADD_LightProbe.MEVENT_ADD_LIGHTPROBE));
			
		}
		protected function onAddReflection(event:Event):void
		{
			ModuleEventManager.dispatchEvent(new MEvent_ADD_Reflection(MEvent_ADD_Reflection.MEVENT_ADD_REFLECTION));
			
		}
		
		protected function onAddGrass(event:Event):void
		{
			ModuleEventManager.dispatchEvent(new MEvent_Add_Grass(MEvent_Add_Grass.MEVENT_ADD_GRASS));
			
		}
		
		protected function onAddWater(event:Event):void
		{
			
			ModuleEventManager.dispatchEvent(new MEvent_Add_Water(MEvent_Add_Water.MEVENT_ADD_WATER));
			
		}
		protected function onAddCapture(event:Event):void
		{
			
			ModuleEventManager.dispatchEvent(new MEvent_Add_Capture(MEvent_Add_Capture.MEVENT_ADD_CAPTURE));
			
		}
		
		protected function onAddPointLight(event:Event):void
		{
			ModuleEventManager.dispatchEvent(new MEvent_Add_Light(MEvent_Add_Light.MEVENT_ADD_LIGHT));
			
			
		}

		
		protected function onNewGroup(event:Event):void
		{
			var rootNode:HierarchyFileNode = new HierarchyFileNode;
			rootNode.name ="新建立文件夹"

			_listBaseArr.addItem(rootNode);
			
		}
		
		protected function onChuange(event:ListEvent):void
		{
			//trace("改变了")
		}
		protected function onStage(event:Event):void
		{
		
		}
		override public function onSize(event:Event= null):void
		{
			  if(this.width>100){
				  _searchBut.x=this.width-25
				  _searchTxt.x=5
				  _searchTxt.width=this.width-30;
				  
		
				  _outMoveLine.y=20
				  _outMoveLine.graphics.clear()
				  _outMoveLine.graphics.beginFill(0xff0000,0.0)
				  _outMoveLine.graphics.drawRect(0,0,this.width,12)
				  _outMoveLine.graphics.endFill();

			  }
		
		}

		override public function show($parent:Sprite):void{
			if(this.parent != $parent){
				$parent.addChild(this);
			}
		}
		
		
	}
}



