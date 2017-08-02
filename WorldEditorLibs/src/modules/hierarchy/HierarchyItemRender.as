package modules.hierarchy
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Alert;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.managers.DragManager;
	
	import spark.components.TextInput;
	
	import common.AppData;
	import common.msg.event.brower.MEvent_BrowerShowFile;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Add;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Build_Group;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Dele;
	import common.msg.event.hierarchy.MEvent_Hierarchy_MoveNode;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Reset;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	import common.utils.ui.prefab.PicBut;
	
	import modules.brower.fileWin.BrowerManage;
	import modules.hierarchy.h5.ExpPrefabToH5;

	public class HierarchyItemRender extends TreeItemRenderer
	{
		private var _txt:TextInput;	
		private var _lockBut:PicBut
		public function HierarchyItemRender()
		{
			super();
	
	
			
			addButs();
			addEvents();
		
			
		}
		
		private function addButs():void
		{
			_lockBut=new PicBut
			_lockBut.setBitmapdata(BrowerManage.getIcon("lockbutton_b"),15,15)
			_lockBut.y=4
			_lockBut.buttonMode=true
			this.addChild(_lockBut)
			
		}
		
		private function addEvents():void
		{
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);

			this.addEventListener(DragEvent.DRAG_ENTER,list_dragEnterHandler)
			this.addEventListener(DragEvent.DRAG_DROP,list_dragDropHandler)
			this.addEventListener(Event.RESIZE,onResize)
			this.addEventListener(FlexEvent.DATA_CHANGE,dataChange)

		}
		protected function dataChange(event:FlexEvent):void
		{
			var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
			if($selfNode){
				$selfNode.addEventListener(Event.CHANGE,onNodeChange)
				_lockBut.visible=$selfNode.lock
				initMenuFile();
			}
		}
		
		protected function onNodeChange(event:Event):void
		{
			var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
			if($selfNode){
				_lockBut.visible=$selfNode.lock
			}
			
		
		}	

	
		
		protected function onResize(event:ResizeEvent):void
		{
			_lockBut.x=Math.max(this.width-30,100)
			
		}
		protected function list_dragDropHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			if(isCanMoveTo($fileNode)){
				var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
				if($fileNode&&$selfNode){
					
					if($fileNode as HierarchyFileNode){
						var $evt:MEvent_Hierarchy_MoveNode=new MEvent_Hierarchy_MoveNode(MEvent_Hierarchy_MoveNode.MEVENT_HIERARCHY_MOVENODE)
						$evt.moveNode=$fileNode as HierarchyFileNode
						$evt.toNode=$selfNode as HierarchyFileNode
						ModuleEventManager.dispatchEvent($evt);
					}else if($fileNode as FileNode){
						
	
						if($fileNode.extension=="group" ||$fileNode.extension=="prefab"){
							var $groupEvt:MEvent_Hierarchy_Add=new MEvent_Hierarchy_Add(MEvent_Hierarchy_Add.MEVENT_HIERARCHY_ADD);
							$groupEvt.fileNode=$fileNode
							$groupEvt.toFileNode=$selfNode
							ModuleEventManager.dispatchEvent($groupEvt);
							
						}
					
					}
					
				
				}

			}
		}
		protected function list_dragEnterHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			if(isCanMoveTo($fileNode)){
				var ui:UIComponent = event.target as UIComponent;
				DragManager.acceptDragDrop(ui);
			}
		}
		private function  isCanMoveTo($moveNode:FileNode ):Boolean
		{
			if(!$moveNode){
				return false
			}
			if($moveNode.extension=="group"||$moveNode.extension=="prefab")
			{
				return true
			}
			if($moveNode is HierarchyFileNode ){
				var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
				var $parentNode:FileNode=$selfNode
				while($parentNode){
					if($parentNode == $moveNode){
						return false
					}
					$parentNode=$parentNode.parentNode
				}
				return true
			}
			return false
		}

		private function SetLab(value:TreeListData):void{
			if(!value){
				return;
			}
			var node:FileNode = value.item as FileNode;
			if(node.rename){
				if(!_txt){
					_txt = new TextInput;
					
				}
				_txt.width = this.label.width;
				_txt.height = this.label.height;
				_txt.x = this.label.x;
				_txt.y = this.label.y;
				this.addChild(_txt);
				
				_txt.text = node.name.split(".")[0];
				_txt.addEventListener(FlexEvent.ENTER,onSureTxt);
				_txt.addEventListener(FocusEvent.FOCUS_OUT,onSureTxt);
			}else{
				if(_txt && _txt.parent){
					_txt.parent.removeChild(_txt);
				}
				if(_txt){
					_txt.removeEventListener(FlexEvent.ENTER,onSureTxt);
					_txt.removeEventListener(FocusEvent.FOCUS_OUT,onSureTxt);
				}
			}
		}
		
		protected function onSureTxt(event:Event):void
		{
			_txt.removeEventListener(FlexEvent.ENTER,onSureTxt);
			_txt.removeEventListener(FocusEvent.FOCUS_OUT,onSureTxt);
			var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
			
			if($selfNode&&_txt.text.length>0){
				$selfNode.name=_txt.text
				$selfNode.rename=false
	
				this.data=$selfNode
				BindingUtils.bindSetter(SetLab,this,"listData");
				
				var $evt:MEvent_Hierarchy_Reset=new MEvent_Hierarchy_Reset(MEvent_Hierarchy_Reset.MEVENT_HIERARCHY_RESET)
				$evt.fileNode=$selfNode
				ModuleEventManager.dispatchEvent($evt);
			
			}
			
		}


		
		protected function onRightClick(event:MouseEvent):void
		{
			_menuFile.display(this.stage,this.stage.mouseX,this.stage.mouseY);
		}
		private var _menuFile:NativeMenu;
		public function initMenuFile():void{
			
			var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
			
			_menuFile = new NativeMenu;
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;
			
			item = new NativeMenuItem("组合")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onGroup);
			
			item = new NativeMenuItem("重命名")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onRename);
			
			item = new NativeMenuItem($selfNode.lock?"解锁":"锁住")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onLockDown);
			
			if($selfNode.children){
				isTreeSelect=getTreeSelect()
				item = new NativeMenuItem(isTreeSelect?"散开目录":"包装目录")
				_menuFile.addItem(item);
				item.addEventListener(Event.SELECT,onChangeTreeSelect);
			}
			item = new NativeMenuItem("删除")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,deleGrop);
			
			item = new NativeMenuItem("查找原文件")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onFind);
			
			item = new NativeMenuItem("提示ID")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onFindModelId);
			
			if($selfNode.type==HierarchyNodeType.Prefab&&false){
				item = new NativeMenuItem("导出H5文件")
				_menuFile.addItem(item);
				item.addEventListener(Event.SELECT,outH5file);
			}
		

		}
		
		protected function onFindModelId(event:Event):void
		{
			var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
			
			Alert.show($selfNode.name+" id=>" +$selfNode.id)
			
		}
		
		protected function outH5file(event:Event):void
		{
			var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
			if($selfNode){
				ExpPrefabToH5.getInstance().expToH5($selfNode)
			}
	
			
		}
		private var isTreeSelect:Boolean
		private function getTreeSelect():Boolean
		{
			//有一个需要选 上一组的，将都认为这个组为需要
			var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
			if($selfNode){
				var arr:Vector.<FileNode>=FileNodeManage.getChildeFileNode($selfNode)
				for(var i:uint=1;i<arr.length;i++){
					var $hierarchyFileNode:HierarchyFileNode=arr[i] as HierarchyFileNode
					if($hierarchyFileNode.treeSelect){
						return true
					}
				}
			}
			return false
		}
		protected function onChangeTreeSelect(event:Event):void
		{
			var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
			if($selfNode){
				$selfNode.treeSelect=false//将自己取消包装
				var arr:Vector.<FileNode>=FileNodeManage.getChildeFileNode($selfNode)
				for(var i:uint=1;i<arr.length;i++){
					var $hierarchyFileNode:HierarchyFileNode=arr[i] as HierarchyFileNode
					$hierarchyFileNode.treeSelect=!isTreeSelect;
				}
			}
			
			
		}
		
		protected function onLockDown(event:Event=null):void
		{
			var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
			if($selfNode){
				$selfNode.lock=!$selfNode.lock
				dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
			}
			
		}
		private var _listOnly:Boolean=false
		protected function onFind(event:Event):void
		{
			var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
			
				
			if($selfNode.type==HierarchyNodeType.Prefab||$selfNode.type==HierarchyNodeType.Particle||$selfNode.type==HierarchyNodeType.Role){
				var evt:MEvent_BrowerShowFile=new MEvent_BrowerShowFile(MEvent_BrowerShowFile.BROWER_SHOW_SAMPE_FILE)
				evt.listOnly=_listOnly;
				_listOnly=!_listOnly
				evt.data=$selfNode.data.url
				ModuleEventManager.dispatchEvent(evt);
				
			}
			
		}
	
		
		protected function onGroup(event:Event):void
		{
			var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
			
			if($selfNode){
				var $evt:MEvent_Hierarchy_Build_Group=new MEvent_Hierarchy_Build_Group(MEvent_Hierarchy_Build_Group.MEVENT_HIERARCHY_BUILD_GROUP)
				$evt.fileNode=$selfNode
				$evt.fileRoot=AppData.workSpaceUrl+"CSV/group/"
				ModuleEventManager.dispatchEvent($evt);
			}
			
		}
		
		protected function deleGrop(event:Event):void
		{
			
			var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
			
			if($selfNode){
				var $evt:MEvent_Hierarchy_Dele=new MEvent_Hierarchy_Dele(MEvent_Hierarchy_Dele.MEVENT_HIERARCHY_DELE)
				$evt.fileNode=$selfNode
				ModuleEventManager.dispatchEvent($evt);
			}
			
			
		}
		
		protected function onRename(event:Event):void
		{
			var $selfNode:HierarchyFileNode = this.data as HierarchyFileNode;
			if($selfNode){
				$selfNode.rename=true
					
				BindingUtils.bindSetter(SetLab,this,"listData");
			}


			
		}


		protected function onMouseDown(event:MouseEvent):void
		{
			
			var dsragSource:DragSource = new DragSource();
			var node:HierarchyFileNode = this.data as HierarchyFileNode;
			if(true){
				dsragSource.addData(node, FileNode.FILE_NODE);
				DragManager.doDrag(this, dsragSource, event);
			}
			
			
		}
		
	}
}


