package  mvc.frame.view
{
	
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import spark.components.TextInput;
	
	import common.utils.ui.file.FileNode;
	import common.utils.ui.prefab.PicBut;
	
	import modules.brower.fileWin.BrowerManage;
	
	import mvc.frame.FrameEvent;
	import mvc.frame.FrameModel;
	import mvc.libray.LibrayFildNode;
	
	
	public class FrameItemRenderer extends TreeItemRenderer
	{
		
		private var _lockBut:PicBut
		private var _hideBut:PicBut
		//	hideeyeicon
		public function FrameItemRenderer()
		{
			super();
			this.addButs()
			this.addEvents()
		}
		
		[Embed(source="assets/icon/eyeopen.png")]
		private static var eyeopen:Class;
		
		
		private function addButs():void
		{
			_lockBut=new PicBut
			_lockBut.setBitmapdata(BrowerManage.getIcon("lockbutton_b"),15,15)
			_lockBut.y=1
			_lockBut.x=150
			_lockBut.width=15
			_lockBut.height=15
			this.addChild(_lockBut)
			
			_hideBut=new PicBut
			_hideBut.setBitmapdata(Bitmap(new eyeopen).bitmapData,16,16)
			_hideBut.width=16
			_hideBut.height=16
			_hideBut.y=0
			_hideBut.x=170
			this.addChild(_hideBut)
			
			
			
			
			
			
		}
		
		protected function _hideButDown(event:MouseEvent):void
		{
			trace("--")
			
		}
		override public function set data(value:Object):void
		{
			super.data=value;
			
			var $selfNode:FrameFileNode = this.data as FrameFileNode;
			if($selfNode&&$selfNode.type==FrameFileNode.Folder0){
				_lockBut.visible=$selfNode.lock;
				_hideBut.visible=$selfNode.hide;
			}else{
				_lockBut.visible=false;
				_hideBut.visible=false;
				
			}
			
			
			
		}
		override protected function measure():void{
			super.measure();
			measuredHeight = 16;
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			this.label.height=18;
		}
		private function addEvents():void
		{
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			this.addEventListener(DragEvent.DRAG_ENTER,list_dragEnterHandler)
			this.addEventListener(DragEvent.DRAG_DROP,list_dragDropHandler)
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			
			
		}
		protected function list_dragDropHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			if(isCanMoveTo($fileNode)){
				var $selfNode:FrameFileNode = this.data as FrameFileNode;
				if($fileNode&&$selfNode){
					var $evt:FrameEvent=new FrameEvent(FrameEvent.MEVENT_FRAME_NODE_MOVENODE)
					$evt.moveNode=$fileNode 
					$evt.toNode=$selfNode
					ModuleEventManager.dispatchEvent($evt);
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
			var $selfNode:FrameFileNode = this.data as FrameFileNode;
			if($moveNode is LibrayFildNode ){
				if($selfNode.type==FrameFileNode.Folder0){
					return true
				}
			}
			if($moveNode is FrameFileNode ){
				var $parentNode:FileNode=$selfNode
				while($parentNode){
					if($parentNode == $moveNode){
						return false
					}
					$parentNode=$parentNode.parentNode
				}
				if($selfNode.type==FrameFileNode.Folder0){
					return true
				}
			}
			return false
		}
		protected function onRightClick(event:MouseEvent):void
		{
			this.initMenuFile()
			_menuFile.display(this.stage,this.stage.mouseX,this.stage.mouseY);
		}
		private var _menuFile:NativeMenu;
		public function initMenuFile():void{
			
			
			
			_menuFile = new NativeMenu;
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;
			
			
			item = new NativeMenuItem("重命名")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onRename);
			
			
			item = new NativeMenuItem("复制")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onCopy);
			
			
			item = new NativeMenuItem("删除")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,deleGrop);
			
			var $selfNode:FrameFileNode = this.data as FrameFileNode;
			if(!$selfNode.hide){
				item = new NativeMenuItem($selfNode.lock?"解锁":"锁住")
				_menuFile.addItem(item);
				item.addEventListener(Event.SELECT,onChangeLock);
			}
			item = new NativeMenuItem($selfNode.hide?"显示":"隐藏")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onChangeHide);

			
		}
		
		protected function onChangeHide(event:Event=null):void
		{
			var $selfNode:FrameFileNode = this.data as FrameFileNode;
			this.changeNodeChildrenHide($selfNode,!$selfNode.hide)
			FrameModel.getInstance().tree.validateNow()
			FrameModel.getInstance().tree.selectedItems=[];
			FrameModel.getInstance().framePanel.playFrameTo(AppDataFrame.frameNum,true)
		}
		private function changeNodeChildrenHide($node:FrameFileNode,$hide:Boolean):void
		{
			$node.hide=$hide
			if(!$node.hide){
				$node.lock=false;
			}
			for(var i:Number=0;$node.children&&i<$node.children.length;i++){
				this.changeNodeChildrenHide($node.children[i],$hide)
			}
		}
		
		protected function onChangeLock(event:Event=null):void
		{
			var $selfNode:FrameFileNode = this.data as FrameFileNode;
			this.changeNodeChildrenLock($selfNode,!$selfNode.lock)
			FrameModel.getInstance().tree.validateNow()
			FrameModel.getInstance().tree.selectedItems=[];
		}
		private function changeNodeChildrenLock($node:FrameFileNode,$lock:Boolean):void
		{
			$node.lock=$lock
			if(!$node.lock){
				$node.hide=false;
			}
			for(var i:Number=0;$node.children&&i<$node.children.length;i++){
				this.changeNodeChildrenLock($node.children[i],$lock)
			}
			
		}
		
		protected function onCopy(event:Event):void
		{
			var node:FrameFileNode = this.data as FrameFileNode;
			var $frameEvent:FrameEvent=new FrameEvent(FrameEvent.COPY_FRAME_MODEL);
			$frameEvent.node=node
			ModuleEventManager.dispatchEvent($frameEvent) ;
		}
		protected function onRename(event:Event):void
		{
			var $selfNode:FileNode = this.data as FileNode;
			if($selfNode){
				$selfNode.rename=true
				BindingUtils.bindSetter(SetLab,this,"listData");
			}
			
		}
		
		protected function deleGrop(event:Event):void
		{
			// TODO Auto-generated method stub
			var node:FrameFileNode = this.data as FrameFileNode;
			var $frameEvent:FrameEvent=new FrameEvent(FrameEvent.DELE_FRAME_MODEL);
			$frameEvent.node=node
			ModuleEventManager.dispatchEvent($frameEvent) ;
			
			
		}
		private var _txt:TextInput;
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
			var $selfNode:FrameFileNode = this.data as FrameFileNode;
			
			if($selfNode&&_txt.text.length>0){
				$selfNode.name=_txt.text
				$selfNode.rename=false
				this.data=$selfNode
				BindingUtils.bindSetter(SetLab,this,"listData");
				
				var $evt:FrameEvent=new FrameEvent(FrameEvent.REFRISH_TREE_NODE_NAME)
				ModuleEventManager.dispatchEvent($evt);
			}
			
		}
		
		private function mouseDownInHideBut(event:MouseEvent):void
		{
			if(this._hideBut.visible &&this.mouseX>this._hideBut.x&&this.mouseX<( this._hideBut.x
				
				+this._hideBut.width)){
				this.onChangeHide()
			}
		}
		private function mouseDownInLockBut(event:MouseEvent):void
		{
			if(this._lockBut.visible &&this.mouseX>this._lockBut.x&&this.mouseX<( this._lockBut.x
				
				+this._lockBut.width)){
				this.onChangeLock()
			}
		}
		protected function onMouseDown(event:MouseEvent):void
		{
			
			this.mouseDownInHideBut(event)
			this.mouseDownInLockBut(event)
			
			
			var dsragSource:DragSource = new DragSource();
			var node:FrameFileNode = this.data as FrameFileNode;
			if(true){
				dsragSource.addData(node, FileNode.FILE_NODE);
				DragManager.doDrag(this, dsragSource, event);
			}
			
			
			
			
		}
		
		
		
		
		
	}
}