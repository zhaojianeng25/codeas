package modules.brower
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.events.ListEvent;
	
	import common.AppData;
	import common.utils.frame.BasePanel;
	import common.utils.ui.btn.LButton;
	import common.utils.ui.file.FileItemRender;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileTreeMenu;
	
	import modules.brower.fileWin.BrowerManage;
	import modules.brower.fileWin.FileWindowBack;
	import modules.brower.fileWin.FileWindows;
	import modules.brower.fileWin.VirtualFile;
	
	public class BrowerPanel extends BasePanel
	{
		private var _tree:Tree;
		private var _btn:LButton;
		private var _rootUrl:String;
		[Bindable]
		private var treeAry:ArrayCollection;
		
		private var _postionNum:Number=0.2
		public function BrowerPanel()
		{
			super();
			addList();
			addButs();
			addFileWin();
			addEvents();

		}

		private function addFileWin():void
		{
			_fileWindow=new FileWindows
			_fileWindow.setStyle("top",0);
			_fileWindow.setStyle("bottom",0);
			_fileWindow.setStyle("left",0);
			_fileWindow.setStyle("right",0);
			this.addChild(_fileWindow)
		}
		public function refresh():void
		{
			_fileWindow.refresh();
		}
		public function slectFolderByFile($file:File):void
		{
			_fileWindow.slectFolderByFile($file)
		}
		
		private function addButs():void
		{
			_btn = new LButton();
			_btn.label = "选择工作空间文件夹"
			this.addChild(_btn);
			
			_topLeftLine=new FileWindowBack();
			this.addChild(_topLeftLine);
			
			_cutLineBack=new FileWindowBack();
			this.addChild(_cutLineBack);
			
		}
		
		private function addList():void
		{
			_tree = new Tree;
			_tree.setStyle("top",0);
			_tree.setStyle("bottom",0);
			_tree.setStyle("left",0);
			_tree.setStyle("right",0);
			_tree.setStyle("contentBackgroundColor",0x404040);
			_tree.setStyle("color",0x9f9f9f);
			_tree.setStyle("borderVisible",false);
			this.addChild(_tree);
			_tree.labelField="name";
			_tree.itemRenderer = new ClassFactory(FileItemRender);
			
			FileTreeMenu.getInstance().treeView = _tree;
			
			_tree.iconFunction = tree_iconFunc;
		}
		
		[Embed(source="assets/coins_16.png")]
		private var database:Class;
		[Embed(source="assets/table_16.png")]
		private var page:Class;

		
		private function tree_iconFunc(item:Object):Class {  
			return BrowerManage.getIconClassByName("icon_FolderOpen_dark");
			var iconClass:Class;
			var type:int = VirtualFile.getCreatType(item.url);
			if(type == -1 || type == -2){
				return database;
			}else if(type == 0){
				 	return BrowerManage.getIconClassByName("icon_FolderOpen_dark");
			}else if(type > 0){
				return page;
			}
			return iconClass;
		}  
		
		private function addEvents():void
		{
			_tree.addEventListener(ListEvent.ITEM_CLICK,onItemClik);
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			this.addEventListener(Event.ADDED_TO_STAGE,onStage);
			this.addEventListener(MouseEvent.CLICK,onPanelClik)
			
		}
		
		protected function onPanelClik(event:MouseEvent):void
		{

			
		}		
		public function showSampleFile($url:String,$listOnly:Boolean,$data:Object):void
		{
			var $file:File=new File($url);
			if($file.extension=="objs"){
				BrowerManage.changeObjsShow($file,true)
			}
			_fileWindow.showSampleFile($url,$listOnly,$data)
		}
		
		public function set postionNum(value:Number):void
		{
			_postionNum = value;
		}

		public function get cutLineBack():FileWindowBack
		{
			return _cutLineBack;
		}
		public function openFolder($file:File):void
		{
			var filenode:FileNode = getFileNodeByUrl($file.url,treeAry[0]);
			if(!filenode){
				return;
			}else{
				if(filenode.url&&!filenode.children){
					getFolderIteByFile(new File(filenode.url),filenode);
				}
			}
			_tree.invalidateList();
			_tree.validateNow();
			openFileNode(filenode);
		}
		
		public function openFileNode(filenode:FileNode):void{
			_tree.expandItem(filenode,true);
			if(filenode.parentNode){
				openFileNode(filenode.parentNode);
			}
		}
		
		public function getFileNodeByUrl($url:String,fileNode:FileNode):FileNode{
			if(fileNode.url == $url){
				return fileNode;
			}else if(fileNode.children){
				for(var i:int;i<fileNode.children.length;i++){
					var getfileNode:FileNode = getFileNodeByUrl($url,fileNode.children[i]);
					if(getfileNode != null){
						return getfileNode;
					}
				}
			}
			
			return null;
		}

		protected function onItemClik(event:ListEvent):void
		{
			
	
			if(event.itemRenderer){
				var $file:File = new File(FileNode(event.itemRenderer.data).url);
				if($file&&$file.isDirectory){
					if(!$file.isHidden){
						_fileWindow.sleteFile($file)
						onSize()

					}
				
				}
				var $fileNode:FileNode=FileNode(event.itemRenderer.data)
				if($fileNode.url&&!$fileNode.children){
					getFolderIteByFile(new File($fileNode.url),$fileNode)
					_tree.expandItem($fileNode,true);
				}
				
			}
			

			
		}
		override public function onSize(event:Event= null):void
		{

			
			if(this.width*_postionNum<50&&this.width>60){
				_postionNum=50/this.width
		
			}
			
			_tree.setStyle("right",(this.width*(1-_postionNum))+5);
			_fileWindow.setStyle("left",this.width*(_postionNum));
			_fileWindow.chageSize(this.width*(1-_postionNum),this.height)
				
				
			_cutLineBack.resetSize(3,this.height)
			_cutLineBack.x=this.width*(_postionNum)-3


			_topLeftLine.resetSize(_postionNum*this.width+3,3)


		}
		private var _fileWindow:FileWindows
		private var _cutLineBack:FileWindowBack;
		private var _topLeftLine:FileWindowBack;
		

		protected function onStage(event:Event):void
		{
			onSize()
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var file:File = new File;
			file.browseForDirectory("选择工作空间文件夹");
			file.addEventListener(Event.SELECT,onSel);
		}		
		
		protected function onSel(event:Event):void
		{
			rootUrl = File(event.target).url;
		}
		
		private function readFile():void{
			
			var $file:File = new File(_rootUrl);
			
			treeAry = new ArrayCollection;
			
			_tree.dataProvider = treeAry;
			
			
			
			
	
			readRootFileNode();
			_fileWindow.sleteFile($file)
				

		}
		
		private function readRootFileNode():void{
			var file:File = new File(AppData.workSpaceUrl);
			/*
			var rootNode:FileNode = new FileNode;
			rootNode.name = file.name;
			rootNode.path = file.nativePath;
			rootNode.url = file.url;
			
			var childAry:ArrayCollection = new ArrayCollection;
			var virtulaNode:FileNode = readVirtualNode(rootNode);
			var resourceNode:FileNode = readWorkSpaceNode(rootNode);
			
			childAry.addItem(virtulaNode);
			childAry.addItem(resourceNode);
			rootNode.children = childAry;
			treeAry.addItem(rootNode);
			
			var childVecFile:Vector.<File> = new Vector.<File>;
			childVecFile.push(new File(virtulaNode.url));
			childVecFile.push(new File(resourceNode.url));
			VirtualFile.addVirtualChildFile(file.url,childVecFile);
			
			*/
			
			FileTreeMenu.getInstance().getNodeFile(file,treeAry,null);
		
			
			
			
		}
		
		private function readVirtualNode(parentNode:FileNode):FileNode{
			var ary:Array = VirtualFile.getRootByType(1);
			var file:File = ary[0];
			
			var virtualAry:ArrayCollection = new ArrayCollection;
			
			FileTreeMenu.getInstance().getNodeFile(file,virtualAry,null);
			
			return virtualAry[0];
		}
		private function getFolderIteByFile($file:File,prentFileNode:FileNode):void
		{
			var fileAry:Array = $file.getDirectoryListing();
			var childAry:ArrayCollection = new ArrayCollection;
			if(fileAry&&fileAry.length>0){
				for(var i:int=0;i<fileAry.length;i++){
					var $kkkfile:File=  File(fileAry[i])
					if($kkkfile.isDirectory){
						var node:FileNode = new FileNode;
						node.name = $kkkfile.name;
						node.path = $kkkfile.nativePath;
						node.url = $kkkfile.url;
						node.extension=$kkkfile.extension
						node.parentNode = prentFileNode;
						
						if(node.name.indexOf("_hide") != -1||node.extension=="svn")
						{
							
						}else{
							childAry.addItem(node)
						}
						
					}
					
				}
				if(childAry.length){
					prentFileNode.children = childAry;
				}
				
			}
			
		}
		
		private function readWorkSpaceNode(parentNode:FileNode):FileNode{
			var ary:Array = VirtualFile.getRootByType(2);
			var resourceFile:File = ary[0];
			
			var $fileNode:FileNode = new FileNode;
			$fileNode.name = resourceFile.name;
			$fileNode.path = resourceFile.nativePath;
			$fileNode.url = resourceFile.url;
			$fileNode.parentNode = parentNode;
			
			ary = VirtualFile.getRootByType(3);
			
			var listAry:ArrayCollection = new ArrayCollection;
			
			for(var i:int;i<ary.length;i++){
				var $file:File = ary[i];
				var $node:FileNode = new FileNode;
				$node.name = $file.name;
				$node.path = $file.nativePath;
				$node.url = $file.url;
				$node.parentNode = $fileNode;
				listAry.addItem($node)
			}
			
			$fileNode.children = listAry;
			
			var childVecFile:Vector.<File> = new Vector.<File>;
			for(i = 0;i<listAry.length;i++){
				childVecFile.push(new File(listAry[i].url));
			}
			
			VirtualFile.addVirtualChildFile($fileNode.url,childVecFile);
			
			return $fileNode;
		}


		public function get rootUrl():String
		{
			return _rootUrl;
		}

		public function set rootUrl(value:String):void
		{
			_rootUrl = value;
			readFile();
			
			if(_btn.parent){
				_btn.parent.removeChild(_btn);
			}
		}
		
		
	}
}
