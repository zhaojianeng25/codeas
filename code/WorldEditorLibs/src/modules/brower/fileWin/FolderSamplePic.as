package  modules.brower.fileWin
{
	import com.greensock.layout.AlignMode;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.system.IME;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import mx.controls.Alert;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.materials.MEvent_Material;
	import common.msg.event.prefabs.MEvent_Group_Show;
	import common.msg.event.prefabs.MEvent_Objs_Show;
	import common.msg.event.prefabs.MEvent_Prefab;
	import common.msg.event.prefabs.MEvent_XFile_Bone_Show;
	import common.msg.event.prefabs.MEvent_XFile_Model3D_Show;
	import common.msg.event.prefabs.Mevent_Model3D_Show;
	import common.msg.event.projectSave.MEvent_ProjectData;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.prefab.PicBut;
	
	import interfaces.ITile;
	
	import materials.Material;
	import materials.MaterialCubeMap;
	import materials.MaterialReflect;
	import materials.MaterialShadow;
	import materials.Texture2DMesh;
	import materials.TextureParticleMesh;
	
	import mode3d.Model3DStaticMesh;
	import mode3d.XFileBoneStaticMesh;
	import mode3d.XFileMode3DStaticMesh;
	
	import modules.brower.fileTip.InputWindow;
	import modules.expres.ExpTo3dmaxByObjs;
	import modules.hierarchy.h5.ExpGroupToByteModel;
	import modules.hierarchy.h5.ExpGroupToH5Model;
	import modules.materials.CubeMapManager;
	import modules.materials.view.MaterialTreeManager;
	import modules.prefabs.PrefabRenderToBmpModel;
	
	import pack.PrefabStaticMesh;
	
	import proxy.top.render.Render;
	
	public class FolderSamplePic extends UIComponent
	{
		private var _backMc:Sprite;
		private var _overBackMc:Sprite
		private var _picSize:Number=50
		public var fileWindows:FileWindows
		public function FolderSamplePic()
		{
			super();
			adBackBox();
			addPicEgae();
			addBmp();
			addShowObjsBut()
			addText();
			addEvents()
	
			
	
		}
		
		private function addShowObjsBut():void
		{
			_showObjBut=new PicBut();
			_showObjBut.scaleX=0.4
			_showObjBut.scaleY=0.4
			_showObjBut.setBitmapdata(BrowerManage.getIcon("jiantou32"))
			this.addChild(_showObjBut)
			
			
		}		
		

		public function get fileData():FileWinData
		{
			return _fileData;
		}

		private function addPicEgae():void
		{
			_picEgae=new Sprite;
			_picEgae.graphics.beginFill(MathCore.argbToHex16(255,255,255),1)
			_picEgae.graphics.drawRect(0,0,1,1)
			_picEgae.graphics.endFill()
			this.addChild(_picEgae)
			
		}
		
		
		private function addBmp():void
		{
			_fileBitmap=new Bitmap
			addChild(_fileBitmap)
			
		}
		
		private function addText():void
		{
			_fileName=new TextField()
			var _txtform:TextFormat=new TextFormat();
			 _txtform.align=AlignMode.CENTER
			 _txtform.font="Microsoft Yahei"
			 _txtform.color=0x9c9c9c
			 _txtform.size=10
			 _txtform.leading=-5
		
			_fileName.defaultTextFormat=_txtform;
			_fileName.type = TextFieldType.DYNAMIC; 
			_fileName.wordWrap=true
			_fileName.multiline=true
			_fileName.height=15
			_fileName.addEventListener(FocusEvent.FOCUS_IN,onFocusIn)
	
			addChild(_fileName);

		}
	
		
		protected function onFocusIn(event:FocusEvent):void
		{
			IME.enabled=true
			
		}
		private function addEvents():void
		{
			
	
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver)
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut)
			this.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClik)
			_showObjBut.addEventListener(MouseEvent.CLICK,_showObjButClik)
		
		}
		protected function _showObjButClik(event:MouseEvent):void
		{
			if(_fileData.file){
				BrowerManage.changePerFabShow(_fileData.file)
				fileWindows.refresh()
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			_overBackMc.visible=false
			
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{

			if(event.target == _showObjBut){
				return 
			}
			if(!_backMc.visible){
				_overBackMc.visible=true
			}
		}

		public function set select($temp:Boolean):void
		{
			_backMc.visible=$temp
				
			_overBackMc.visible=false
				
				
		}

		protected function onRightClick(event:MouseEvent):void
		{
			if(_fileData.file){
				var index:int = _menuFile.getItemIndex(_creatMaterialInstance);;
				if(_fileData.file.extension=="material"){
					if(index == -1){
						_menuFile.addItem(_creatMaterialInstance);
					}
				}else{
					if(index != -1){
						_menuFile.removeItemAt(index);
					}
				}
			}
			_menuFile.display(this.stage,this.stage.mouseX,this.stage.mouseY);
		}
		
		public function initMenuFile():void{
			_menuFile = new NativeMenu;
			 
			var item:NativeMenuItem;
			
			item = new NativeMenuItem("重命名")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onRename);
			
			item = new NativeMenuItem("删除")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onDele);
			
			item = new NativeMenuItem("刷新Icon")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,resetIconPic);

			if(_fileData&&_fileData.file){
				if(_fileData.file.extension=="prefab"||_fileData.file.extension=="group"||_fileData.file.extension=="lyf"){
					item = new NativeMenuItem("导出H5数据");
					item.addEventListener(Event.SELECT,onExpToH5);
					_menuFile.addItem(item);
					
					if(_fileData.file.extension=="prefab" ){
						item = new NativeMenuItem("导出byte模型");
						item.addEventListener(Event.SELECT,onExpToByte);
						_menuFile.addItem(item);
					}
				 
				}
				
				if(_fileData.file.extension=="objs"){
					item = new NativeMenuItem("导出3dmaxObj");
					item.addEventListener(Event.SELECT,onExp3Dmaxobj);
					_menuFile.addItem(item);
				}
			}

			
			
			item = new NativeMenuItem("查看文件");
			item.addEventListener(Event.SELECT,onWatch);
			_menuFile.addItem(item);
			
			
			
			_creatMaterialInstance = new NativeMenuItem("创建材质实例");
			_creatMaterialInstance.addEventListener(Event.SELECT,onMaterialInstance);
			
		}
		
		protected function onExp3Dmaxobj(event:Event):void
		{
			if(_fileData.file){
				var _sonFile:File=_fileData.file
				ExpTo3dmaxByObjs.getInstance().expByUrl(_sonFile.url)
			}
		}
		protected function onExpToByte(event:Event):void
		{
			if(_fileData.file){
				var _sonFile:File=_fileData.file
				if(_sonFile.exists){
					ExpGroupToByteModel.getInstance().expToH5(_sonFile)
				}
			}
			
		}
		protected function onExpToH5(event:Event):void
		{
			if(_fileData.file){
				var _sonFile:File=_fileData.file
				
				if(_sonFile.exists){
					ExpGroupToH5Model.getInstance().expToH5(_sonFile)
				}
			}
			
		}
		
		protected function resetIconPic(event:Event):void
		{
		//	PrefabRenderToBmpModel.getInstance().scanPrefabToBmpByUrl(_sonFile.url)
			
		}		

		protected function onDele(event:Event):void
		{
		
			if(_fileData.file){
				if(_fileData.file.isDirectory){
					
				}else{
					Alert.yesLabel="确定";
					Alert.noLabel="取消";
					Alert.show("确实要删除"+_fileData.file.name+"么","提示",3,null,	function deleteCallBack(event:CloseEvent):void
					{
						if(event.detail==Alert.YES)
						{
							_fileData.file.deleteFile()
							fileWindows.refresh()
						}
					} )
				}
				
			}else{
		
	
				Render.deleAmaniFile(_fileData.data)
				fileWindows.refresh()
				
			}

			
		}

		

		protected function onMaterialInstance(event:Event):void
		{
			InputWindow.getInstance().inputFilePanle("instance",onSureMaterialInstance);
		}
		
		private function onSureMaterialInstance($str:String,$typeStr:String):void
		{
			var evt:MEvent_Material = new MEvent_Material(MEvent_Material.MEVENT_MATERIAL_CREAT_INSTANCE);
			evt.url = _fileData.file.parent.url;
			evt.name = $str;
			evt.material = MaterialTreeManager.getMaterial(_fileData.file.url);
			ModuleEventManager.dispatchEvent(evt);
			fileWindows.refresh();
		}		

		protected function onWatch(event:Event):void
		{
			if(_fileData.file){
				var _sonFile:File=_fileData.file
				var url:String = _sonFile.parent.url;
				var file:File = new File(url);
				if(file.exists){
					file.openWithDefaultApplication();
				}
			}
			
		}
		
		protected function onNewFolder(event:Event):void
		{
			if(_fileData.file){
				var _sonFile:File=_fileData.file
				BrowerManage.creaFloder(_sonFile,"新建文件夹")
				fileWindows.refresh()
			}
			
		}
		
		protected function onRename(event:Event):void
		{
			_fileName.type = TextFieldType.INPUT; 
		
			var _txtform:TextFormat=new TextFormat();
			_txtform.align=AlignMode.CENTER
			_txtform.color=0x9f9f9f
			_txtform.font="Microsoft Yahei"
			_txtform.size=10
			_txtform.leading=-5
			_fileName.defaultTextFormat=_txtform;
			
			
			_fileName.background=true
			_fileName.backgroundColor=0xffffff
				
			_fileName.mouseEnabled=true
				
			_fileName.addEventListener(FlexEvent.ENTER,onSureTxt);
			_fileName.addEventListener(FocusEvent.FOCUS_OUT,onSureTxt);
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.removeEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver)
			this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut)
			this.removeEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClik)
			
			Scene_data.stage.focus=_fileName
				
	
		}
		
		protected function onSureTxt(event:Event):void
		{
			_fileName.type = TextFieldType.DYNAMIC; 
			_fileName.background=false
			_fileName.mouseEnabled=false
				
			var _txtform:TextFormat=new TextFormat();
			_txtform.align=AlignMode.CENTER
			_txtform.color=0x9f9f9f
			_fileName.defaultTextFormat=_txtform;
		
				
			_fileName.removeEventListener(FlexEvent.ENTER,onSureTxt);
			_fileName.removeEventListener(FocusEvent.FOCUS_OUT,onSureTxt);

			if(_fileData.file){
				var _sonFile:File=_fileData.file
				var isTrue:Boolean=BrowerManage.changeFileName(_sonFile,_fileName.text)
				if(this.parent&&this.parent.parent)
				{
					fileWindows.refresh()
				}
			}
			
			if(_fileData.data is ITile){

	
				if(_fileData.data as PrefabStaticMesh){
					PrefabStaticMesh(_fileData.data).name=_fileName.text
					PrefabStaticMesh(_fileData.data).dispatchEvent(new Event(Event.CHANGE));
				}
				if(_fileData.data as Material){
					Material(_fileData.data).name=_fileName.text
					Material(_fileData.data).dispatchEvent(new Event(Event.CHANGE));
				}
				if(_fileData.data as Model3DStaticMesh){
					Model3DStaticMesh(_fileData.data).modelName=_fileName.text
					Model3DStaticMesh(_fileData.data).dispatchEvent(new Event(Event.CHANGE));
				}
				if(_fileData.data as XFileMode3DStaticMesh){
					XFileMode3DStaticMesh(_fileData.data).name=_fileName.text
					XFileMode3DStaticMesh(_fileData.data).dispatchEvent(new Event(Event.CHANGE));
				}
				
			}
		
			

		
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver)
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut)
			this.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClik)


		}
		
	
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(event.target == _showObjBut){
			   return 
			}
			var dsragSource:DragSource = new DragSource();
			var node:FileNode =new FileNode
			if(_fileData.file){
				var _sonFile:File=_fileData.file
				node.name = _sonFile.name;
				node.path = _sonFile.nativePath;
				node.url = _sonFile.url;
				if(_sonFile.extension)
				{
					node.extension = _sonFile.extension.toLowerCase();
				}
				if(_sonFile.extension=="material"){
					node.data=MaterialTreeManager.getMaterial(node.url)
				}
				if(_sonFile.extension=="cube"){
					node.data=CubeMapManager.getInstance().getCubeMapByUrl(node.url)
				}
				if(!_sonFile.isDirectory){
					dsragSource.addData(node, FileNode.FILE_NODE);
					DragManager.doDrag(this, dsragSource, event);
				}
			}
			InFolderModelSprite(this.parent).mouseClik(this)
				
				
		}

		protected function onDoubleClik(event:MouseEvent):void
		{
			if(event.target == _showObjBut){
				return 
			}

			if(_fileName.mouseEnabled){
				return ;
			}
			if(_fileData.file){
				var _sonFile:File=_fileData.file
				if(_sonFile.isDirectory){
					InFolderModelSprite(parent).doubleClik(_sonFile);
				}else{
					var materilaEvt:MEvent_Material
					switch(_sonFile.extension)
					{
						case "lmap":
						{
							AppData.mapUrl = _sonFile.url.replace(AppData.workSpaceUrl,"");
							ModuleEventManager.dispatchEvent(new MEvent_ProjectData(MEvent_ProjectData.PROJECT_OPEN));
							break;
						}
						case "prefab":
						{
							PrefabRenderToBmpModel.getInstance().scanPrefabToBmpByUrl(_sonFile.url)
				
							var evt:MEvent_Prefab = new MEvent_Prefab(MEvent_Prefab.MEVENT_PREFAB_SHOW);
							evt.url = _sonFile.url
							ModuleEventManager.dispatchEvent(evt);
							
							break;
						}
						case "material":
						{
							materilaEvt = new MEvent_Material(MEvent_Material.MEVENT_MATERIAL_SHOW);
							materilaEvt.url = _sonFile.url
							ModuleEventManager.dispatchEvent(materilaEvt);
							break;
						}
						case "cube":
						{
							materilaEvt = new MEvent_Material(MEvent_Material.MEVENT_MATERIAL_CUBEMAP_SHOW);
							materilaEvt.url= _sonFile.url
							materilaEvt.materialCubemap = CubeMapManager.getInstance().getCubeMapByUrl( _sonFile.url)
							ModuleEventManager.dispatchEvent(materilaEvt);
							break;
						}
							
							
						case "materialins":
						{
							materilaEvt = new MEvent_Material(MEvent_Material.MEVENT_MATERIAL_SHOW_INSTANCE);
							materilaEvt.url = _sonFile.url
							ModuleEventManager.dispatchEvent(materilaEvt);
							break;
						}
						case "group":
						{
							var groupEvent:MEvent_Group_Show = new MEvent_Group_Show(MEvent_Group_Show.MEVENT_GROUP_SHOW);
							groupEvent.url = _sonFile.url
							ModuleEventManager.dispatchEvent(groupEvent);
							break;
						}
						case "objs":
						{

							PrefabRenderToBmpModel.getInstance().scanObjsToBmpByUrl(_sonFile.url)

							var objsEvent:MEvent_Objs_Show = new MEvent_Objs_Show(MEvent_Objs_Show.MEVENT_OBJS_SHOW);
							objsEvent.url = _sonFile.url;
							ModuleEventManager.dispatchEvent(objsEvent);
						
							break;
						}
						case "jpg":
						case "png":
						{
							_sonFile.openWithDefaultApplication();
							break;
						}
							
						default:
						{
							break;
						}
					}	
				}
			}else{
				if(_fileData.data is Material){
					materilaEvt = new MEvent_Material(MEvent_Material.MEVENT_MATERIAL_SHOW_BASE);
					materilaEvt.material = Material(_fileData.data);
					ModuleEventManager.dispatchEvent(materilaEvt);
				}else if(_fileData.data is TextureParticleMesh){
					materilaEvt = new MEvent_Material(MEvent_Material.MEVENT_TEXTUREPARTICLE_SHOW);
					materilaEvt.textureParticleMesh = TextureParticleMesh(_fileData.data);
					ModuleEventManager.dispatchEvent(materilaEvt);
				}else if(_fileData.data is Texture2DMesh){
					materilaEvt = new MEvent_Material(MEvent_Material.MEVENT_TEXTURE2D_SHOW);
					materilaEvt.texture2Dmesh = Texture2DMesh(_fileData.data);
					ModuleEventManager.dispatchEvent(materilaEvt);
			
				}else if(_fileData.data is MaterialReflect){
					materilaEvt = new MEvent_Material(MEvent_Material.MEVENT_MATERIAL_REFLECT_SHOW);
					materilaEvt.materialReflect = MaterialReflect(_fileData.data);
					ModuleEventManager.dispatchEvent(materilaEvt);
				}else if(_fileData.data is MaterialCubeMap){
					materilaEvt = new MEvent_Material(MEvent_Material.MEVENT_MATERIAL_CUBEMAP_SHOW);
					materilaEvt.materialCubemap = MaterialCubeMap(_fileData.data);
					ModuleEventManager.dispatchEvent(materilaEvt);
				}else if(_fileData.data is MaterialShadow){
					materilaEvt = new MEvent_Material(MEvent_Material.MEVENT_MATERIAL_SHADOW_SHOW);
					materilaEvt.materialShadow = MaterialShadow(_fileData.data);
					ModuleEventManager.dispatchEvent(materilaEvt);
				}else if(_fileData.data is XFileBoneStaticMesh){
					var $mEvent_XFile_Bone_Show:MEvent_XFile_Bone_Show = new MEvent_XFile_Bone_Show(MEvent_XFile_Bone_Show.MEVENT_XFILE_BONE_SHOW);
					$mEvent_XFile_Bone_Show.xFileBoneStaticMesh=XFileBoneStaticMesh(_fileData.data)
					ModuleEventManager.dispatchEvent($mEvent_XFile_Bone_Show);
				}else if(_fileData.data is XFileMode3DStaticMesh){
					var $mEvent_Model3D_XFile_Show:MEvent_XFile_Model3D_Show = new MEvent_XFile_Model3D_Show(MEvent_XFile_Model3D_Show.MEVENT_XFILE_MODEL3D_SHOW);
					$mEvent_Model3D_XFile_Show.xFileMode3DStaticMesh = XFileMode3DStaticMesh(_fileData.data);
					ModuleEventManager.dispatchEvent($mEvent_Model3D_XFile_Show);
				}else if(_fileData.data is Model3DStaticMesh){
					var $mevent_Model3D_Show:Mevent_Model3D_Show = new Mevent_Model3D_Show(Mevent_Model3D_Show.MEVENT_MODEL3D_SHOW);
					$mevent_Model3D_Show.model3DStaticMesh = Model3DStaticMesh(_fileData.data);
					ModuleEventManager.dispatchEvent($mevent_Model3D_Show);
				}else if(_fileData.data is PrefabStaticMesh){
					var $mEvent_Prefab:MEvent_Prefab = new MEvent_Prefab(MEvent_Prefab.MEVENT_PREFAB_SHOW);
					$mEvent_Prefab.prefabStaticMesh = PrefabStaticMesh(_fileData.data);
					ModuleEventManager.dispatchEvent($mEvent_Prefab);
				}
				
			}
		
		}
		

		public function set picSize(value:Number):void
		{
			_picSize = value;
			changeSize()
		}
		private function changeSize():void
		{
			_picEgae.graphics.clear()
			if(_fileBitmap&&_fileBitmap.bitmapData){
				
				var $kscale:Number=1
				var $wNum:Number=_picSize-15
				var $sw:Number=_fileBitmap.bitmapData.width
				var $sh:Number=_fileBitmap.bitmapData.height*(5/4)
				if($sw>$sh){
					$kscale=$wNum/_fileBitmap.bitmapData.width
				}else{
					$kscale=$wNum/_fileBitmap.bitmapData.height*(4/5)
				}
				_fileBitmap.scaleX=_fileBitmap.scaleY=$kscale
				_fileBitmap.x=(_picSize-_fileBitmap.width)/2
				_fileBitmap.y=(_picSize-15-_fileBitmap.height)/2
				
					
				_picEgae.graphics.beginFill(MathCore.argbToHex16(128,128,128),1)
				_picEgae.graphics.drawRect(_fileBitmap.x-1,_fileBitmap.y-1,_fileBitmap.width+2,_fileBitmap.height+2)
					
				_picEgae.graphics.endFill()	
					

			}
			_backMc.width=_picSize
			_backMc.height=_picSize
			_overBackMc.width=_picSize
			_overBackMc.height=_picSize
		
			if(this._fileData.file&&this._fileData.file.extension=="prefab"){
				_showObjBut.scaleX=_fileBitmap.scaleX*2.5;
				_showObjBut.scaleY=_fileBitmap.scaleY*2.5;
				_showObjBut.x=_picSize-20*_showObjBut.scaleX;
				_showObjBut.y=_picSize/2-15*_showObjBut.scaleY;
				_showObjBut.bmp.smoothing=true
				if(!BrowerManage.isPerfabCanShow(this._fileData.file)){
					_showObjBut.bmp.x=_showObjBut.bmp.bitmapData.width;
					_showObjBut.bmp.scaleX=-1
				}else{
					_showObjBut.bmp.x=0
					_showObjBut.bmp.scaleX=1
				}
			}
		
		
				
			
			_fileName.x=5
			_fileName.width=_picSize-8
				
			if(_fileName.textHeight>15){
				_fileName.y=_picSize-30
				_fileName.height=35
			}else{
				_fileName.y=_picSize-20
				_fileName.height=20
			}

		}
		private function adBackBox():void
		{
			_backMc=new Sprite;
			_backMc.graphics.beginFill(MathCore.argbToHex16(200,100,0),1)
			_backMc.graphics.drawRect(0,0,50,50)
			_backMc.graphics.endFill()
			this.addChild(_backMc)
			_backMc.mouseChildren=false
			_backMc.mouseEnabled=false
			_backMc.visible=false
				
			_overBackMc=new Sprite;
			_overBackMc.graphics.beginFill(MathCore.argbToHex16(0,255,255),0.1)
			_overBackMc.graphics.drawRect(0,0,50,50)
			_overBackMc.graphics.endFill()
			this.addChild(_overBackMc)
			_overBackMc.mouseChildren=false
			_overBackMc.mouseEnabled=false
			_overBackMc.visible=false
			
		}
		private var _fileBitmap:Bitmap;
		protected var _fileData:FileWinData
		private var _fileName:TextField;
		private var _picEgae:Sprite;
		private var _menuFile:NativeMenu;
		private var _creatMaterialInstance:NativeMenuItem;
		private var _showObjBut:PicBut;
		public function setData($fileData:FileWinData):void
		{
			_fileData=$fileData
			this.doubleClickEnabled=true;
			_fileName.mouseEnabled=false;
			if($fileData.file){
				var $file:File=$fileData.file
				var urlStr:String=$file.nativePath
				
				if($file.extension=="prefab"){
					_showObjBut.visible=true;
				}	else{
					_showObjBut.visible=false;
				}
				if($file.extension=="jpg"||$file.extension=="png"||$file.extension=="wdp"){
					LoadManager.getInstance().addSingleLoad(new LoadInfo(urlStr,LoadInfo.BITMAP,function onTextureLoad(bitmap:Bitmap,url:String):void{
						_fileBitmap.bitmapData=bitmap.bitmapData
						_fileBitmap.smoothing=true
						changeSize();
					},0,urlStr));
				}else{
					if($file.isDirectory){
						_fileBitmap.bitmapData= BrowerManage.getIcon("icon_folder_64x");
					}else{
						if($file.extension){
							_fileBitmap.bitmapData=BrowerManage.getIcon($file.extension)
						}else{
							_fileBitmap.bitmapData=new BitmapData(50,50,false,0xff0000);
						}
					}
					if(!_fileBitmap.bitmapData){
						_fileBitmap.bitmapData=$file.icon.bitmaps[0]
					}
					_fileBitmap.smoothing=true
					_picEgae.visible=false
					changeSize();
				}
				
				var $extensionListPicArr:Array=["material","prefab","cube","objs"]
				if(AppData.type==1){
					$extensionListPicArr.push("group")
				}
				for(var i:uint=0;i<$extensionListPicArr.length;i++){
					if($extensionListPicArr[i]==$file.extension){
						var $diskRendUrl:String=$file.url.replace(AppData.workSpaceUrl,"")
						$diskRendUrl=$diskRendUrl.replace("."+$file.extension,$file.extension+".jpg")
						var $bmpUrl:String=File.desktopDirectory.url+"/world/"+$diskRendUrl;
						getFileBmpByUrl($bmpUrl)
					}
				}
				_fileName.text=$file.name.replace("."+$file.extension,"")
			}else{
			
				_picEgae.visible=false;
			   if(_fileData.data is ITile){
					_fileName.text = ITile(_fileData.data).getName();
					var bmp:BitmapData = ITile(_fileData.data).getBitmapData();
					if(bmp){
						_fileBitmap.bitmapData = bmp;
					}else{
						_fileBitmap.bitmapData=BrowerManage.getIconByClass(_fileData.data["constructor"]);
					}
					if(_fileData.data as PrefabStaticMesh){
						var $object3DUrl:String=File.desktopDirectory.url+"/amani3d/object3D/"+	ITile(_fileData.data).getName()+".jpg";
						getFileBmpByUrl($object3DUrl)
					}
					if(_fileData.data as Model3DStaticMesh){
						var $model3DUrl:String=File.desktopDirectory.url+"/amani3d/Model3D/"+	ITile(_fileData.data).getName()+".jpg";
						getFileBmpByUrl($model3DUrl)
					}
				
				}
				_fileBitmap.smoothing=true;
				
			}
			changeSize();
			initMenuFile();
		}
		private function getFileBmpByUrl($url:String):void
		{
			var $file:File=new File($url)
			if($file.exists){
				BmpLoad.getInstance().addSingleLoad($url,function ($bitmap:Bitmap,$obj:Object):void{
					_fileBitmap.bitmapData=$bitmap.bitmapData
					_picEgae.visible=true
					changeSize();
				},{})
			}
		}

	
		
		
			
	}
}