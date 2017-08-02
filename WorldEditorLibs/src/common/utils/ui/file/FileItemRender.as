package common.utils.ui.file
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Alert;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	import mx.core.DragSource;
	import mx.events.FlexEvent;
	import mx.events.ToolTipEvent;
	import mx.managers.DragManager;
	
	import spark.components.TextInput;
	
	import common.AppData;
	import common.msg.event.projectSave.MEvent_ProjectData;
	import common.utils.ui.img.ImgToolTip;
	
	public class FileItemRender extends TreeItemRenderer
	{
		private var _txt:TextInput;	
		public function FileItemRender()
		{
			super();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreat);
			
			this.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			
			this.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
			
			this.doubleClickEnabled = true;
			
			BindingUtils.bindSetter(SetLab,this,"listData");
			
		}
		
		
		protected function onDoubleClick(event:MouseEvent):void
		{
			var node:FileNode = this.data as FileNode;
			if(node.extension == "lmap"){
				AppData.mapUrl = node.url.replace(AppData.workSpaceUrl,"");
				ModuleEventManager.dispatchEvent(new MEvent_ProjectData(MEvent_ProjectData.PROJECT_OPEN));
			}
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
			
			var node:FileNode = this.data as FileNode;
			
			var file:File = new File(node.url);
			
			var newUrl:String;
			
			var needRefresh:Boolean = false;
			
			if(file.isDirectory){
				newUrl = file.parent.url + "/" + _txt.text;
				needRefresh = true;
			}else{
				newUrl = file.parent.url + "/" + _txt.text + "." +node.extension;
			}
			
			var newFile:File = new File(newUrl);
			if(newFile.exists){
				Alert.show("文件夹下已存在同名文件，重命名失败！");
				node.rename = false;
				return;
			}
			
			var flag:Boolean = false;
			var mapFile:File;
			var newMapFile:File;
			if(node.extension == "lmap"){
				if(AppData.mapUrl == file.url.replace(AppData.workSpaceUrl,"")){
					flag=true;
				}
				
				mapFile = new File(file.parent.url + "/" + file.name.split(".")[0] + "_hide");
				newMapFile = new File(file.parent.url + "/" + _txt.text + "_hide");
				if(mapFile.exists){
					mapFile.moveTo(newMapFile,true);
				}
			}
			
			file.moveTo(newFile,true);
			
			
			node.name = newFile.name;
			node.url = newFile.url;
			node.path = newFile.nativePath;
			node.rename = false;
			
			if(flag){
				AppData.mapUrl = newFile.url.replace(AppData.workSpaceUrl,"");
				ModuleEventManager.dispatchEvent(new MEvent_ProjectData(MEvent_ProjectData.PROJECT_SAVE_CONFIG));
			}
			
			if(needRefresh){
				FileTreeMenu.getInstance().refreshNode(node.parentNode);
			}
			
		}
		
		public function moveMapFile():void{
			
		}
		
		public function refreshParentNode():void{
//			var ary:ArrayCollection = new ArrayCollection;
//			var file:File = new File(node.url);
//			if(file.isDirectory){
//				getNodeFile(file,ary);
//				node.children = ary[0].children;
//			}
		
		}
		/*
		public function getNodeFile(file:File,ary:ArrayCollection,parentNode:FileNode):void{
			var node:FileNode = new FileNode;
			node.name = file.name;
			node.path = file.nativePath;
			node.url = file.url;
			node.parentNode = parentNode;
			if(file.extension)
				node.extension = file.extension.toLowerCase();
			if(file.isDirectory){
				node.children = new ArrayCollection;
				
				var fileAry:Array = file.getDirectoryListing();
				for(var i:int=0;i<fileAry.length;i++){
					getNodeFile(fileAry[i],node.children,node);
				}
				
			}
			ary.addItem(node);
		}
		*/
		private function changefolder():void{
			var node:FileNode = this.data as FileNode;
			
			var file:File = new File(node.url);
			
			var newUrl:String = file.parent.url + "/" + _txt.text;
			
			
		}
		
		protected function onRightClick(event:MouseEvent):void
		{
			FileTreeMenu.getInstance().show(this.data as FileNode);
		}
		
		protected function onCreat(event:FlexEvent):void
		{
			var node:FileNode = this.data as FileNode;
			if(!node.children && (node.extension == "jpg" || node.extension == "png")){
				this.label.toolTip = "a";
			}
			
			this.label.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,onCreatTip);
			this.label.addEventListener(ToolTipEvent.TOOL_TIP_SHOW,onShowTip);
		}
		
		protected function onShowTip(event:ToolTipEvent):void
		{
			
		}
		
		protected function onCreatTip(event:ToolTipEvent):void
		{
			
			var node:FileNode = this.data as FileNode;
			
			if(!node.children && (node.extension == "jpg" || node.extension == "png")){
				var tip:ImgToolTip=new ImgToolTip();
				tip.url = node.url;
				event.toolTip = tip;
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			
			var dsragSource:DragSource = new DragSource();
			
			var node:FileNode = this.data as FileNode;
			
			if(!node.children && (node.extension == "jpg" || node.extension == "png")){
				dsragSource.addData(node, FileNode.FILE_NODE);
				DragManager.doDrag(this, dsragSource, event);
			}
			
			
		}
		
	}
}