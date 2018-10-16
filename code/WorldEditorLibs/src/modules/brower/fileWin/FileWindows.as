package modules.brower.fileWin
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.SharedObject;
	
	import mx.containers.Canvas;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FileEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import common.AppData;
	import common.msg.event.brower.MEvent_Brower_Input_Obj;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Build_Group;
	import common.msg.event.materials.MEvent_Material;
	import common.msg.event.prefabs.MEvent_Prefab;
	import common.utils.ui.file.FileNode;
	
	import interfaces.ITile;
	
	import materials.Material;
	import materials.MaterialCubeMap;
	import materials.MaterialReflect;
	
	import modules.brower.BrowerPanel;
	import modules.brower.fileTip.InputWindow;
	import modules.brower.fileWin.see.SeePanel;
	import modules.hierarchy.HierarchyFileNode;
	import modules.prefabs.PrefabManager;
	
	import proxy.top.render.Render;
	
	public class FileWindows extends Canvas
	{
		private var _inFolderModelSprite:InFolderModelSprite;
		private var _fileListCanver:Canvas
		private var _backSprte:FileWindowBack
		public function FileWindows()
		{
			super();
			addBack();
			addFolderPanel();
			addSearch()
			addSeePanel();
			addEvents();
			this.horizontalScrollPolicy="off"
			this.verticalScrollPolicy="off" 
		}
		
		private function addSeePanel():void
		{
		    _seePanel=new SeePanel()
			_seePanel.inFolderModelSprite=_inFolderModelSprite
			if(AppData.type==1){
				this.addChild(_seePanel)
			}
		}
		private var _searchTxt:TextInput
		private function addSearch():void
		{
			_searchTxt=new TextInput
			_searchTxt.height=22
			_searchTxt.y=1

			_searchTxt.setStyle("contentBackgroundColor",0x404040);
			_searchTxt.setStyle("borderVisible",true);
			_searchTxt.setStyle("fontSize",11);
			_searchTxt.setStyle("fontFamily","Microsoft Yahei");
			_searchTxt.setStyle("color",0x9c9c9c);

			this.addChild(_searchTxt)
				
			_searchTxt.addEventListener(FlexEvent.ENTER,onSureTxt);
			_searchTxt.addEventListener(Event.CHANGE,onSecarchTextChange)

		}
		
		protected function onSecarchTextChange(event:Event):void
		{
			var findTxt:String=""
			if(_searchTxt.text.length>0){
				findTxt=_searchTxt.text.toUpperCase()
					
				if(_virtualFileType==1||_virtualFileType==2||_virtualFileType==3||_virtualFileType==4||_virtualFileType==6||_virtualFileType==7) {
					
					_inFolderModelSprite.setItem(getItemByOld())

					chageSize(_w,_h)
				}else{
					if(_fileWinData.file){
						_inFolderModelSprite.setItem(getFileListBB(_fileWinData.file))
						chageSize(_w,_h)
					}
				}

			}else
			{
				sleteFile(_fileWinData.file)
			}
		
			function getItemByOld():Vector.<FileWinData>
			{
				var fileITEM:Vector.<FileWinData>=new Vector.<FileWinData>
				for(var i:uint=0;i<_oldFileItem.length;i++)
				{
					var $itile:ITile=ITile(_oldFileItem[i].data )
					if($itile){
						var $name:String=$itile.getName()
						$name=$name.toUpperCase()
						if($name.search(findTxt)!=-1){
							fileITEM.push(_oldFileItem[i])
						}
					}
					
				
				}
				return fileITEM
			}
			function getFileListBB($tempFile:File):Vector.<FileWinData>
			{
				var $fileItem:Vector.<FileWinData>=new Vector.<FileWinData>
				if($tempFile.exists && $tempFile.isDirectory)
				{
					var arr:Array=$tempFile.getDirectoryListing();
					for each(var $file:File in arr)
					{
						if($file.isHidden)
						{
							continue;
						}else{
							if($file.nativePath.search("_hide")!=-1){
								
							}else{
								var ddd:String=$file.name.replace("."+$file.extension,"")
								ddd=ddd.toUpperCase()
								if(ddd.search(findTxt)!=-1){
									var $nodeFile:FileWinData=new FileWinData
									$nodeFile.file=$file
									$fileItem.push($nodeFile)
								}
								if($file.isDirectory)
								{
						
									if($fileItem.length<100){
										$fileItem=$fileItem.concat(getFileListBB($file))
									}
								}
								
							}
						}
					}
				}
				return $fileItem;
			}
			
			
		}
		
		protected function onSureTxt(event:FlexEvent):void
		{
			var findTxt:String=""
			if(_searchTxt.text.length>0){
				findTxt=_searchTxt.text.toUpperCase()
				if(_fileWinData.file){
					_inFolderModelSprite.setItem(getFileListBB(_fileWinData.file))
				}
				chageSize(_w,_h)
			}
			function getFileListBB($tempFile:File):Vector.<FileWinData>
			{
				var $fileItem:Vector.<FileWinData>=new Vector.<FileWinData>
				if($tempFile.exists && $tempFile.isDirectory)
				{
					var arr:Array=$tempFile.getDirectoryListing();
					for each(var $file:File in arr)
					{
						if($file.isHidden)
						{
							continue;
						}else{
							if($file.nativePath.search("_hide")!=-1){
								
							}else{
								var ddd:String=$file.name.replace("."+$file.extension,"")
								ddd=ddd.toUpperCase()
								if(ddd.search(findTxt)!=-1){
									var $nodeFile:FileWinData=new FileWinData
									$nodeFile.file=$file
									$fileItem.push($nodeFile)
								}
								if($file.isDirectory)
								{
									
									if($fileItem.length<100){
										$fileItem=$fileItem.concat(getFileListBB($file))
									}
								}
								
							}
						}
					}
				}
				return $fileItem;
			}
			
		}
		
		private function addBack():void
		{
			_backSprte=new FileWindowBack
			this.addChild(_backSprte)
			_fileWinTitle=new FileWinTitle
			this.addChild(_fileWinTitle)
				
			_backSprte.resetSize(1,1)
			_backSprte.alpha=0
			
		}
		
		private function addFolderPanel():void
		{
			_fileListCanver=new Canvas
           this.addChild(_fileListCanver)
			   
		   _fileListCanver.setStyle("top",25);
		   _fileListCanver.setStyle("bottom",0);
		   _fileListCanver.setStyle("left",0);
		   _fileListCanver.setStyle("right",0);
		   


		   _fileListCanver.horizontalScrollPolicy="off";
		   //_fileListCanver.verticalScrollPolicy="off" ;

			_inFolderModelSprite=new InFolderModelSprite;
			_inFolderModelSprite.fileWindows=this;
			_inFolderModelSprite.addEventListener(FileEvent.FILE_CHOOSE,onDoubleClik);
			_fileListCanver.addChild(_inFolderModelSprite);
				
			
			
		}
		
		private function addEvents():void
		{
			this.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel)

			_inFolderModelSprite.backMc.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			this.addEventListener(DragEvent.DRAG_ENTER,list_dragEnterHandler)
			this.addEventListener(DragEvent.DRAG_DROP,list_dragDropHandler)

		}
		protected function list_dragDropHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			if(isCanMoveTo($fileNode)){
				
			
				var $evt:MEvent_Hierarchy_Build_Group=new MEvent_Hierarchy_Build_Group(MEvent_Hierarchy_Build_Group.MEVENT_HIERARCHY_BUILD_GROUP)
				$evt.fileNode=$fileNode as HierarchyFileNode
				$evt.fileRoot=_fileWinData.file.url+"/"
				ModuleEventManager.dispatchEvent($evt);
			
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
		
		private function isCanMoveTo($fileNode:FileNode):Boolean
		{

			if(_fileWinData&&_fileWinData.file&&$fileNode as HierarchyFileNode){
				return true
			}
			return false;
		}		
		protected function onRightClick(event:MouseEvent):void
		{
			//FileTreeMenu.getInstance().show(_fileNode);

			_menuFile.display(this.stage,this.stage.mouseX,this.stage.mouseY);
		}
		private var _menuFile:NativeMenu;
		
		
		protected function onRefresh(event:Event):void
		{
			refresh()
		}
		
		protected function onMaterial($str:String):void
		{
			var evt:MEvent_Material = new MEvent_Material(MEvent_Material.MEVENT_MATERIAL_CREATNEW);
			evt.url = _fileWinData.file.url;
			evt.name = $str;
			ModuleEventManager.dispatchEvent(evt);
			refresh();
			
		
		}
		
		protected function onAddStaticMesh($str:String):void
		{
			if(AppData.type == 1){
				var evt:MEvent_Prefab = new MEvent_Prefab(MEvent_Prefab.MEVENT_PREFAB_CREATNEW);
				evt.url = _fileWinData.file.url;
				evt.name = $str;
				ModuleEventManager.dispatchEvent(evt);
			}else{

				Render.creatAmaniFile($str,"Object3D")
				
			}
			refresh();
		}
		

		protected function onNewMap(str:String):void
		{
			if(_fileWinData.file){
				BrowerManage.creatMap(_fileWinData.file,str)
			}
			
			refresh()
		}
		public function refresh():void
		{
			if(_fileWinData.file){
				sleteFile(_fileWinData.file);
			}
		}
		public function slectFolderByFile($file:File):void
		{
			_inFolderModelSprite.slectFolderByFile($file)
		}
		protected function onNewFolder(str:String):void
		{
			if(_fileWinData.file){
				BrowerManage.creaFloder(_fileWinData.file,str)
			}
			refresh()
			
		}
		protected function onMouseWheel(event:MouseEvent):void
		{
//			_inFolderModelSprite.picSize=Math.max(60,_inFolderModelSprite.picSize+event.delta)
//			_inFolderModelSprite.picSize=Math.min(120,_inFolderModelSprite.picSize);
//			_inFolderModelSprite.changeSize()
			
		}
		
		protected function onDoubleClik(event:FileEvent):void
		{
			sleteFile(event.file)
			
		}
		private var menuTypeAmaniAry:Array = [
										{name:"文件夹",key:"folder"},{name:"地图",key:"map"},{name:"Model3D",key:"Model3D"},{name:"Model3DXFile",key:"Model3DXFile"},{name:"Bone",key:"Bone"},
										{name:"Object3D",key:"Object3D"},{name:"Texture2D",key:"Texture2D"},{name:"Texture3D",key:"Texture3D"},
										{name:"TextureCubeMap",key:"TextureCubeMap"},
										{name:"TextureParticle",key:"TextureParticle"},
										{name:"TextureShadow",key:"TextureShadow"},
										{name:"TextureSpecial",key:"TextureSpecial"}
									]
		private var menuTypePanAry:Array = [
										{name:"文件夹",key:"folder"},{name:"地图",key:"map"},
										{name:"Object3D",key:"Object3D"},
										{name:"TextureCubeMap",key:"TextureCubeMap"},
										{name:"Texture3D",key:"Texture3D"}
									
									]
		public function resetMenu():void{
			_menuFile = new NativeMenu;
			
			var newtypefile:NativeMenu = new NativeMenu;
			
			var item:NativeMenuItem;
			var menuAry:Array
			if(AppData.type==0){
				menuAry=menuTypeAmaniAry
			}else{
				menuAry=menuTypePanAry
			}
			
			for(var i:int=0;i<menuAry.length;i++){
				var obj:Object = menuAry[i];

				item = new NativeMenuItem(obj.name)
				item.data = obj.key;
		
				if(AppData.type==0){
					item.enabled = isUseMenu(obj.key);
				}
				
				
			
				newtypefile.addItem(item);
				item.addEventListener(Event.SELECT,onMenuClick);
			}

			_menuFile.addSubmenu(newtypefile,"新建");
			_menuFile.addItem(new NativeMenuItem(null,true));
			
			
			if(_virtualFileType==0 && AppData.type==1){
				item = new NativeMenuItem("导入文件");
				item.addEventListener(Event.SELECT,imputFile);
				_menuFile.addItem(item);
			}
			
			item = new NativeMenuItem("刷新");
			item.addEventListener(Event.SELECT,onRefresh);
			_menuFile.addItem(item);

		}
		
		protected function imputFile(event:Event):void
		{
			if(_fileWinData&&_fileWinData.file){
				var evt:MEvent_Brower_Input_Obj=new MEvent_Brower_Input_Obj(MEvent_Brower_Input_Obj.INPUT_MODEL_OBJ)
				evt.prentFile=_fileWinData.file
				ModuleEventManager.dispatchEvent(evt);
			}
			
			
		}
		
		private function onMenuClick(event:Event):void{
			inputFilePanle(event.target.data);
		}
			
		
		protected function onNewTextureSpecial(event:Event):void
		{
			inputFilePanle("TextureSpecial")
			
		}
		
		protected function onNewTextureCubeMap(event:Event):void
		{
			inputFilePanle("TextureCubeMap")
			
		}
		
		protected function onNewTexture3D(str:String):void
		{
			
		}
		
		protected function onNewTexture2D(event:Event):void
		{
			inputFilePanle("Texture2D")
			
		}
		
		protected function onNewObject3D(event:Event):void
		{
			inputFilePanle("Object3D")
			
		}
		private function inputFilePanle($typeStr:String):void
		{
			InputWindow.getInstance().inputFilePanle($typeStr,winBackFun)
		}
		public function winBackFun($str:String,$typeStr:String):void
		{
		

				switch($typeStr)
				{
					case "map":
					{
						onNewMap($str);
						break;
					}
					case "folder":
					{
						onNewFolder($str);
						break;
					}
					case "Model3D":
					{
						onAddModel3D($str)
						break;
					}
					case "Object3D":
					{
						onAddStaticMesh($str);
						break;
					}
					case "Texture3D":
					{
						onMaterial($str);
						break;
					}
					case "TextureCubeMap":
					{
						onAddTextureCubeMap($str)
						break;
					}
					case "Bone":
					{
						onAddBone($str)
						break;
					}
					case "Model3DXFile":
					{
						onAddModel3DXFile($str)
						break;
					}
					case "TextureParticle":
					{
						onAddTextureParticle($str)
						break;
					}
					case "TextureShadow":
					{
						onAddTextureShadow($str)
						break;
					}
					case "TextureSpecial":
					{
						onAddTextureSpecial($str)
						break;
					}
					case "Texture2D":
					{
						onAddTexture2D($str)
						break;
					}
					
				}
		
		}
		
		private function onAddTexture2D($str:String):void
		{
			Render.creatAmaniFile($str,"Texture2D")
			refresh();
			
		}
		
		private function onAddTextureSpecial($str:String):void
		{
			Render.creatAmaniFile($str,"TextureSpecial")
			refresh();
		}
		
		private function onAddTextureShadow($str:String):void
		{
			Render.creatAmaniFile($str,"TextureShadow")
			refresh();
		}
		
		private function onAddTextureParticle($str:String):void
		{
			
			Render.creatAmaniFile($str,"TextureParticle")
			refresh();
		}
		
		private function onAddBone($str:String):void
		{
			Render.creatAmaniFile($str,"Bone")
			refresh();
			
		}
		private function onAddModel3DXFile($str:String):void
		{
			Render.creatAmaniFile($str,"Model3DXFile")
			refresh();
			
		}
		
		private function onAddTextureCubeMap($str:String):void
		{
			if(AppData.type==1){
				var evt:MEvent_Material = new MEvent_Material(MEvent_Material.MEVENT_TEXTURECUBEMAP_CREATNEW);
				evt.url = _fileWinData.file.url;
				evt.name = $str;
				ModuleEventManager.dispatchEvent(evt);
			}else{
				
				Render.creatAmaniFile($str,"TextureCubeMap")
		
			}
			refresh();
			
		}
		

		
		private function onAddModel3D($str:String):void
		{
			
			Render.creatAmaniFile($str,"Model3D")
			//Render.creatAmaniModel3D(str)
				
			refresh();
			
		}
		
		protected function onNewModel3D(event:Event):void
		{
			
			inputFilePanle("Model3D")
			
			
		}
		private function isUseMenu($str:String):Boolean
		{
//			Model3D
//			Object3D
//			Texture2D
//			Texture3D
//			TextureCubeMap
//			TextureSpecial
//			文件夹
//			地图

			switch($str)
			{
				case "map":
				{
					if(isFolder){
						return true
					}else{
						return false
					}
					
					break;
				}
				case "folder":
				{
					if(isFolder){
						return true
					}else{
						return false
					}
					break;
				}
				case "Model3D":
				{
					
					if(isFolder){
						return false
					}else{
						if(_virtualFileType==VirtualFile.Model3D){
							return true
						}
					}
					break;
				}
				case "Model3DXFile":
				{
					
					if(isFolder){
						return false
					}else{
						if(_virtualFileType==VirtualFile.Model3DXFile){
							return true
						}
					}
					break;
				}
				case "Bone":
				{
					
					if(isFolder){
						return false
					}else{
						if(_virtualFileType==VirtualFile.Bone){
							return true
						}
					}
					break;
				}
				case "Object3D":
				{
					if(isFolder){
						return false
					}else{
						if(_virtualFileType==VirtualFile.Object3D){
							return true
						}
					}
					break;
				}
				case "Texture3D":
				{
					if(isFolder){
						return false
					}else{
						if(_virtualFileType==VirtualFile.Texture3D){
							return true
						}
					}
					
					break;
				}
				case "TextureCubeMap":
				{
					if(isFolder){
						return false
					}else{
						if(_virtualFileType==VirtualFile.TextureCubeMap){

							return true
						}
					}
					
					break;
				}
				case "TextureSpecial":
				{
					if(isFolder){
						return false
					}else{
						if(_virtualFileType==VirtualFile.TextureSpecial){
							return true
						}
					}
					break;
				}
				case "TextureParticle":
				{
					if(isFolder){
						return false
					}else{
						if(_virtualFileType==VirtualFile.TextureParticle){
							return true
						}
					}
					break;
				}
				case "TextureShadow":
				{
					if(isFolder){
						return false
					}else{
						if(_virtualFileType==VirtualFile.TextureShadow){
							return true
						}
					}
					break;
				}
				case "Texture2D":
				{
					if(isFolder){
						return false
					}else{
						if(_virtualFileType==VirtualFile.Texture2D){
							return true
						}
					}
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			return false
		}
		private var _virtualFileType:int=0
		private var _oldFileItem:Vector.<FileWinData>;
		public function sleteFile($file:File):void
		{
			if($file.isDirectory){
				var _soUrl:SharedObject = SharedObject.getLocal("rootFile", "/");
				_soUrl.data.url=$file.url
					
				_fileWinTitle.setFileUrl($file)
				isFolder=true;
				_oldFileItem=(getInFolderFile($file))
				_inFolderModelSprite.setItem(_oldFileItem)
				BrowerPanel(this.parent).openFolder($file);
				chageSize(_w,_h)
				resetMenu()
				_fileWinData=new FileWinData
				_fileWinData.file=$file

			
			}
		}
		private function makeVirtualFileItem($arr:Vector.<File>):Vector.<FileWinData>
		{
			
			var $fileItem:Vector.<FileWinData>=new Vector.<FileWinData>
			for(var i:uint=0;i<$arr.length;i++)
			{
				var $fileData:FileWinData=new FileWinData;
				$fileData.file=$arr[i]
				$fileItem.push($fileData)
			}
			
			return $fileItem
			
		}
		private var isFolder:Boolean=false
		private var tempArr:Vector.<FileWinData>
		private function getCsvDataCopy(type:uint):Vector.<FileWinData>
		{
	
			var eeee:Array=new Array
			var j:uint=0
			var $fileData:FileWinData
			if(type==2){
				if(tempArr)
				{
					return tempArr
				}
				tempArr=new Vector.<FileWinData>
				for( j=0;j<10;j++)
				{
					$fileData=new FileWinData
					var temp:Material=new Material
					$fileData.data=temp
					tempArr.push($fileData);
				}
				return tempArr
				
			}
			if(type==3){
				for( j=0;j<10;j++)
				{
					var temp1:MaterialReflect=new MaterialReflect
					eeee.push(temp1);
				}
			}
			if(type==4){
				for( j=0;j<10;j++)
				{
					var temp2:MaterialCubeMap=new MaterialCubeMap
					eeee.push(temp2);
				}
			}

			var $arr:Vector.<FileWinData>=new Vector.<FileWinData>
			for(var i:uint=0;eeee&&i<eeee.length;i++)
			{
				$fileData=new FileWinData
				$fileData.data=eeee[i]
				$arr.push($fileData)
			}
		
			return $arr
			
		}
		
	
		private function getCsvData(type:uint):Vector.<FileWinData>
		{
	
			var eeee:Array=Render.getTypeList(type);
			var $arr:Vector.<FileWinData>=new Vector.<FileWinData>
			for(var i:uint=0;eeee&&i<eeee.length;i++)
			{
				var $fileData:FileWinData=new FileWinData
				$fileData.data=eeee[i]
				$arr.push($fileData)
			}
	
			return $arr
			
		}
		private function getCsvSelfFile($file:File):Vector.<FileWinData>
		{
			var $fileItem:Vector.<FileWinData>=new Vector.<FileWinData>

	
			var arr:Array=$file.getDirectoryListing();
			for each(var $tempFile:File in arr)
			{
				var $fileData:FileWinData=new FileWinData
				$fileData.file=	$file
				$fileData.data=PrefabManager.getInstance().getPrefabByUrl($tempFile.url);
				$fileItem.push($fileData)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
			}
			
		
			
			return $fileItem
			
		}
		public function showSampleFile($url:String,$listOnly:Boolean,$data:Object):void
		{
	
				var $file:File=new File($url)
				if($listOnly){
					sleteFile($file.parent)
				}else{
					if($file){
						var $fileItem:Vector.<FileWinData>=new Vector.<FileWinData>
						var $fileData:FileWinData=new FileWinData
						if($data is String)
						{
							$fileData.file=	new File(String($url))
							$fileItem.push($fileData)
							_inFolderModelSprite.setItem($fileItem);
							_fileWinTitle.setFileUrl($file.parent)
							
						}else{
							$fileData.data=	$data
							$fileItem.push($fileData)
							_inFolderModelSprite.setItem($fileItem);
							_fileWinTitle.setFileUrl($file.parent)
						}
						
						
					}
					
					
				}
				_inFolderModelSprite.selectFile($data)

	
		}
        private var _w:uint=0
        private var _h:uint=0
		public function chageSize($w:uint,$h:uint):void
		{
			_w=$w
			_h=$h
			_backSprte.resetSize($w,$h)
			_fileWinTitle.resetSize($w,$h)
				
			_inFolderModelSprite.y=24
			_inFolderModelSprite.chageSize($w,$h-24)
				
			var k:int=Math.min($w-_fileWinTitle.width-100)
			
				
            if(k>30){
				_searchTxt.width=Math.min(k-20,$w/2,200)
				_searchTxt.x=$w-_searchTxt.width-10
				_searchTxt.visible=true
			}else{
				_searchTxt.visible=false

			}
			_seePanel.x=_searchTxt.x-101
			_seePanel.visible=_searchTxt.visible
			
		}
	
		//private var _sonFile:File
		private var _fileWinTitle:FileWinTitle;
		private var _fileWinData:FileWinData
		private var _seePanel:SeePanel;
		private function getInFolderFile($sonFile:File):Vector.<FileWinData>
		{
	
			var $fileItem:Vector.<FileWinData>=new Vector.<FileWinData>
			var arrTemp:Array=new Array;
			if($sonFile.exists && $sonFile.isDirectory)
			{
				var arr:Array=$sonFile.getDirectoryListing();
				for each(var $tempFile:File in arr)
				{
					
					if(!AppData.showObjs&&($tempFile.isHidden||$tempFile.extension=="txt"||$tempFile.extension=="obj"))
					{
						continue;
					}else{
						if($tempFile.nativePath.search("_hide")!=-1){
						}else{
							arrTemp.push($tempFile)
						}
					}
				}
			}
			arrTemp=arrTemp.sortOn("isDirectory")
			$fileItem=new Vector.<FileWinData>
			for(var i:uint=0;i<arrTemp.length;i++)
			{
				var $fileData:FileWinData=new FileWinData;
				$fileData.file=arrTemp[arrTemp.length-i-1]
				$fileItem.push($fileData)
			}
			
			return $fileItem
		}
		
	}
}