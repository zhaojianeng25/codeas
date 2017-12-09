package mvc.libray
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import spark.components.TextInput;
	
	import common.utils.ui.file.FileNode;
	

	
	public class LibrayItemRender extends TreeItemRenderer
	{
		public function LibrayItemRender()
		{
			super();
			
			addEvents();
			
			
		}
		

		
		private function addEvents():void
		{
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			
			this.addEventListener(DragEvent.DRAG_ENTER,list_dragEnterHandler)
			this.addEventListener(DragEvent.DRAG_DROP,list_dragDropHandler)

			this.addEventListener(FlexEvent.DATA_CHANGE,dataChange)
			
		}
		protected function dataChange(event:FlexEvent):void
		{
			var $selfNode:LibrayFildNode = this.data as LibrayFildNode;
			if($selfNode){
				$selfNode.addEventListener(Event.CHANGE,onNodeChange)
				initMenuFile();
			}
		}
		protected function onNodeChange(event:Event):void
		{
			var $selfNode:LibrayFildNode = this.data as LibrayFildNode;
			if($selfNode){
	
			}
		}	


		protected function list_dragDropHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			if(isCanMoveTo($fileNode)){
				var $selfNode:LibrayFildNode = this.data as LibrayFildNode;
				if($fileNode&&$selfNode){
					if($fileNode as LibrayFildNode){
						var $evt:LibraryEvent=new LibraryEvent(LibraryEvent.MEVENT_LIBRAY_MOVENODE)
						$evt.moveNode=$fileNode as LibrayFildNode
						$evt.toNode=$selfNode as LibrayFildNode
						ModuleEventManager.dispatchEvent($evt);
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
	
			if($moveNode is LibrayFildNode ){
				var $selfNode:LibrayFildNode = this.data as LibrayFildNode;
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
			var $selfNode:LibrayFildNode = this.data as LibrayFildNode;
			
			if($selfNode&&_txt.text.length>0){
				$selfNode.name=_txt.text
				$selfNode.rename=false
				
				this.data=$selfNode
				BindingUtils.bindSetter(SetLab,this,"listData");
				
				var $evt:LibraryEvent=new LibraryEvent(LibraryEvent.MEVENT_LIBRAY_REFRISHNAME)
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
			
			var $selfNode:LibrayFildNode = this.data as LibrayFildNode;
			
			_menuFile = new NativeMenu;
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;
			

			item = new NativeMenuItem("重命名")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onRename);
			
			item = new NativeMenuItem("删除")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,deleGrop);
			
			item = new NativeMenuItem("查找原文件")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onFind);
			
		}

		private var _txt:TextInput;
		protected function onFind(event:Event):void
		{
			var $selfNode:LibrayFildNode = this.data as LibrayFildNode;
		}
		protected function deleGrop(event:Event):void
		{
			
			var $selfNode:LibrayFildNode = this.data as LibrayFildNode;
			if($selfNode){
				var $evt:LibraryEvent=new LibraryEvent(LibraryEvent.MEVENT_LIBRAY_DELENODE)
				$evt.fileNode=$selfNode
				ModuleEventManager.dispatchEvent($evt);
			}
			
		}
		
		protected function onRename(event:Event):void
		{
			var $selfNode:LibrayFildNode = this.data as LibrayFildNode;
			if($selfNode){
				$selfNode.rename=true
				
				BindingUtils.bindSetter(SetLab,this,"listData");
			}
			
			
			
		}
		
		
		protected function onMouseDown(event:MouseEvent):void
		{
			
			var dsragSource:DragSource = new DragSource();
			var node:LibrayFildNode = this.data as LibrayFildNode;
			if(true){
				dsragSource.addData(node, FileNode.FILE_NODE);
				DragManager.doDrag(this, dsragSource, event);
			}
			
			
		}
		
	}
}

