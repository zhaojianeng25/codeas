package common.utils.ui.prefab
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.TextInput;
	
	import common.AppData;
	import common.utils.frame.BasePanel;
	import common.utils.ui.btn.LButton;
	import common.utils.ui.file.FileItemRender;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileTreeMenu;
	import common.utils.ui.tab.TabButton;
	
	import modules.brower.fileWin.BrowerManage;
	import modules.brower.fileWin.VirtualFile;
	
	public class PreFabMovePanel extends BasePanel
	{
		private var _btnVec:Vector.<TabButton>;
		private var _panelVec:Vector.<BasePanel>;
		private var _bg:UIComponent;
		private var _shape:UIComponent;
		
	
		private var _searchBut:PicBut;
		private var _enterBut:LButton;
		public function PreFabMovePanel()
		{
			super();
			//this.setStyle("backgroundColor",0x404040);
			this.setStyle("borderColor",0x151515);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";
			
			
			addBack()
			addLabels();
			addList();
			addInputTxt();
			addButs();
			addEvents();
			
		}
		private function addInputTxt():void
		{
			_inputTxt = new TextInput;
			//_txt.setStyle("top",0);
			//_txt.setStyle("bottom",0);
			_inputTxt.setStyle("contentBackgroundColor",0x404040);
			_inputTxt.setStyle("borderVisible",true);
			_inputTxt.setStyle("color",0x9f9f9f);
			//_inputTxt.setStyle("textDecoration","underline");
			_inputTxt.setStyle("paddingTop",4);
			
			_inputTxt.x=50
			_inputTxt.y=360
			_inputTxt.width=250
			
			this.addChild(_inputTxt);
			
		}
		
		public function set url(value:String):void
		{
			_url = value;
			
	
			treeAry = new ArrayCollection;
			_tree.dataProvider = treeAry;

			
			
			readRootbase();
			
			
			_tree.invalidateList();
			_tree.validateNow();
			
			
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
		
		private function readRootbase():void{
			var file:File = new File(AppData.workSpaceUrl+"Resource");
			
			var rootNode:FileNode = new FileNode;
			rootNode.name = file.name;
			rootNode.path = file.nativePath;
			rootNode.url = file.url;
			
			var childAry:ArrayCollection = new ArrayCollection;
			var vec:Vector.<File> = VirtualFile.getVirtualChildFile(file.url);
			for (var i:uint=0;i<vec.length;i++)
			{
				var $kkkfile:File=vec[i]
				var node:FileNode = new FileNode;
				node.name = $kkkfile.name;
				node.path = $kkkfile.nativePath;
				node.url = $kkkfile.url;
				node.parentNode = rootNode;
				childAry.addItem(node)
			}
			rootNode.children = childAry;
			treeAry.addItem(rootNode);
	
			
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
		[Bindable]
		private var treeAry:ArrayCollection;


		private function addList():void
		{
			_tree = new Tree;
			_tree.setStyle("top",85);
			_tree.setStyle("bottom",50);
			_tree.setStyle("left",50);
			_tree.setStyle("right",50);
			_tree.setStyle("contentBackgroundColor",0x606060);
			_tree.setStyle("color",0x9f9f9f);
			_tree.setStyle("borderVisible",false);
			this.addChild(_tree);
			_tree.labelField="name";
			_tree.itemRenderer = new ClassFactory(FileItemRender);
			
			FileTreeMenu.getInstance().treeView = _tree;
			
			_tree.iconFunction = tree_iconFunc;
			
			_tree.addEventListener(ListEvent.ITEM_CLICK,onItemClik);
			
		}
		private var selectRootFile:File
		protected function onItemClik(event:ListEvent):void
		{
			if(event.itemRenderer){
				var $file:File = new File(FileNode(event.itemRenderer.data).url);
				if($file&&$file.isDirectory){

					selectRootFile=$file
				}
				var $fileNode:FileNode=FileNode(event.itemRenderer.data)
				if($fileNode.url&&!$fileNode.children){
					
				
						getFolderIteByFile(new File($fileNode.url),$fileNode)
						_tree.expandItem($fileNode,true);
				
				}
				
			}
		}

		
		[Embed(source="assets/coins_16.png")]
		private var database:Class;
		[Embed(source="assets/table_16.png")]
		private var page:Class;
//		[Embed(source="assets/folder_16.png")]
//		private var folder:Class;
		private function tree_iconFunc(item:Object):Class {  
			var iconClass:Class;
			var type:int = VirtualFile.getCreatType(item.url);
			if(type == -1 || type == -2){
				return database;
			}else if(type == 0){
				return BrowerManage.getIconClassByName("icon_folderopen_bright");
			}else if(type > 0){
				return page;
			}
			return iconClass;
		}  
		
		private function addButs():void
		{

			_enterBut= new LButton;
			_enterBut.label ="确定提交"
			_enterBut.setStyle("left",230);
			_enterBut.y=360
			this.addChild(_enterBut)
			
			
		}
		private function getBitmapFilter():BitmapFilter {
			var color:Number = 0x000000;
			var angle:Number = 45;
			var alpha:Number = 0.8;
			var blurX:Number = 8;
			var blurY:Number = 8;
			var distance:Number = 5;
			var strength:Number = 0.65;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			return new DropShadowFilter(distance,
				angle,
				color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
		}
		
		

		
		private function addLabels():void
		{
			_urlLbel=new Label
			_urlLbel.setStyle("color",0x9f9f9f);
			_urlLbel.setStyle("paddingTop",4);
			_urlLbel.y=25
			_urlLbel.x=50
			this.addChild(_urlLbel)

			
			var _labelTxt:Label=new Label
			_labelTxt.setStyle("color",0x9f9f9f);
			_labelTxt.setStyle("paddingTop",4);
			_labelTxt.y=50
			_labelTxt.x=50
			_labelTxt.text="请选择存放目录:";
			this.addChild(_labelTxt)
			
		}
		public var bFun:Function
		private  var _url:String
		private var _urlLbel:Label;
		private var _tree:Tree;
		private var _inputTxt:TextInput;
		private function addEvents():void
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onStage);
			this.addEventListener(ResizeEvent.RESIZE,onStage);
			_enterBut.addEventListener(MouseEvent.CLICK,_enterButClik)
		}
		protected function _enterButClik(event:MouseEvent):void
		{
			var $sonFile:File=new File(_url)
			var $toURL:String;
			if(selectRootFile&&selectRootFile.isDirectory&&$sonFile){

				var destination:File = File.documentsDirectory;
				if(_inputTxt.text.length>0){
					destination = destination.resolvePath(selectRootFile.url+"/"+_inputTxt.text+"/"+$sonFile.name);
					
				}else{
					destination = destination.resolvePath(selectRootFile.url+"/"+$sonFile.name);
				}

				try 
				{
					trace(destination.url)
					$toURL=destination.url
					$sonFile.copyTo(destination, true);
				}
				catch (error:Error)
				{
					trace("Error:", error.message);
				}

				
			}else{
				Alert.show("请选择正确的文件夹!");
			}
			if(Boolean(bFun)){
				bFun(_url,$toURL)
			}
		}
		
		private function addBack():void
		{
			_bg = new UIComponent;
			this.addChild(_bg);
			_shape = new UIComponent;
			this.addChild(_shape);
			
		}
		
		protected function onStage(event:Event):void
		{
			drawback();
		}
		
		private function drawback():void{
			_shape.graphics.clear();
			_shape.graphics.beginFill(0x303030,1);
			_shape.graphics.lineStyle(1,0x151515);
			
			_shape.graphics.drawRect(0,0,this.width,20);
			_shape.graphics.endFill();
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x404040,1);
			_bg.graphics.drawRect(0,0,this.width,this.height);
			_bg.graphics.endFill();
			
			
			_urlLbel.text=_url
		}
		
		override public function set width(value:Number):void{
			super.width = value;
			drawback();
		}
		
		override public function changeSize():void{
			drawback();
			
		}
		override public function show($parent:Sprite):void{
			if(this.parent != $parent){
				$parent.addChild(this);
			}
		}
		
		
	}
}



