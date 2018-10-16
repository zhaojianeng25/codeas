package common.utils.ui.file
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Tree;
	
	import common.AppData;
	import common.GameUIInstance;

	public class FileTreeMenu
	{
		private static var _instance:FileTreeMenu;
		
		
		private var _menuFile:NativeMenu;
		
		private var _treeAry:ArrayCollection;
		
		private var node:FileNode;
		
		public var treeView:Tree;
		
		public var myMenuData:XML = 
			<root>
				<menuitem label="文件">
					<menuitem label="保存场景" id="0"/> 
					<menuitem label="切换工作空间" id="1"/>
				</menuitem> 
				<menuitem label="地形" data="mesh"/> 
				<menuitem label="灯光" data="bone"/>
				<menuitem label="材质" data="action"/>
			</root> 

		public function FileTreeMenu()
		{
			init();
		}
		
		public static function getInstance():FileTreeMenu{
			if(!_instance){
				_instance = new FileTreeMenu;
			}
			
			return _instance;
		}
		
		public function init():void{
			//_menuFile = Menu.createMenu(null,myMenuData,false);
			_menuFile = new NativeMenu;
			
			
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;
			
			item = new NativeMenuItem("文件夹")
			newtypefile.addItem(item);
			item.addEventListener(Event.SELECT,onNewFolder);
			item = new NativeMenuItem("地图");
			item.addEventListener(Event.SELECT,onNewMap);
			newtypefile.addItem(item);
			item = new NativeMenuItem("材质");
			newtypefile.addItem(item);
			
			_menuFile.addSubmenu(newtypefile,"新建");
			
			item = new NativeMenuItem("重命名")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onRename);
			
			item = new NativeMenuItem("删除")
			_menuFile.addItem(item);
			_menuFile.addItem(new NativeMenuItem(null,true));
			item = new NativeMenuItem("刷新");
			item.addEventListener(Event.SELECT,onRefresh);
			_menuFile.addItem(item);

		}
		
		protected function onNewMap(event:Event):void
		{
			
			var pNode:FileNode;
			if(node.children){
				pNode = node;
			}else{
				pNode = node.parentNode;
			}
			
			var obj:Object = new Object;
			var file:File = new File(pNode.url + "/newmap.lmap");
			if(file.exists){
				file = new File(pNode.url + "/newmap1.lmap"); 
			}
			if(file.exists){
				Alert.show("创建失败！");
				return;
			}
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.WRITE);
			fs.writeObject(obj);
			fs.close();
			refreshNode(pNode);
		}
		
		protected function onNewFolder(event:Event):void
		{
			var pNode:FileNode;
			if(node.children){
				pNode = node;
			}else{
				pNode = node.parentNode;
			}
			
			var url:String = pNode.url + "/新建文件夹";
			var file:File = new File(url);
			file.createDirectory();
			
			FileTreeMenu.getInstance().refreshNode(pNode);
		}
		
		protected function onRename(event:Event):void
		{
//			if(node.children){
//				Alert.show("文件夹不能重命名");
//				return;
//			}
			node.rename = true;
		}
		
		protected function onRefresh(event:Event):void
		{
			refreshNode(node);
//			var ary:ArrayCollection = new ArrayCollection;
//			var file:File = new File(node.url);
//			if(file.isDirectory){
//				getNodeFile(file,ary,null);
//				node.children = ary[0].children;
//				treeView.invalidateList();
//				treeView.validateNow();
//				treeView.expandItem(treeView.selectedItem,false);
//				treeView.expandItem(treeView.selectedItem,true);
//			}
			
		}
		
		public function refreshNode($selNode:FileNode):void{
			var ary:ArrayCollection = new ArrayCollection;
			var file:File = new File($selNode.url);
			if(file.isDirectory){
				getNodeFile(file,ary,$selNode.parentNode);
				$selNode.children = ary[0].children;
				for(var i:int;i<$selNode.children.length;i++){
					FileNode($selNode.children[i]).parentNode = $selNode;
				}
				treeView.invalidateList();
				treeView.validateNow();
				treeView.expandItem($selNode,false);
				treeView.expandItem($selNode,true);
			}
		}
		public function show($node:FileNode):void{
			node = $node;
			_menuFile.display(GameUIInstance.stage,GameUIInstance.stage.mouseX,GameUIInstance.stage.mouseY);
		}
		
		public function getNodeFile(file:File,ary:ArrayCollection,parentNode:FileNode):void{
			if(file.name.indexOf("_hide") != -1||file.extension=="svn"){
				return;
			}
			if(!file.isDirectory){
				return;	
			}
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
		
		
	}
}