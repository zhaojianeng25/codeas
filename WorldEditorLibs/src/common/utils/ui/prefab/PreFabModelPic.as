package common.utils.ui.prefab
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.net.FileFilter;
	
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.events.AIREvent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.Window;
	
	import PanV2.loadV2.BmpLoad;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.brower.MEvent_BrowerShowFile;
	import common.utils.frame.BaseComponent;
	import common.utils.ui.file.FileNode;
	
	import interfaces.ITile;
	
	import materials.MaterialTree;
	
	import modules.brower.fileWin.BrowerManage;
	
	public class PreFabModelPic extends BaseComponent
	{
		protected var _iconBmp:PicBut;
		protected var _labelTxt:Label
		protected var _searchBut:PicBut;
		protected var _changePath:uint
		protected var _donotDubleClik:uint
		protected var _hasCloseBut:uint
		protected var _closeX:PicBut
		private var _gap:int = 5;
		public function PreFabModelPic()
		{
			super();
			
			this.baseWidth = 45;
			_iconBmp=new PicBut
			this.addChild(_iconBmp)

			_iconBmp.setBitmapdata(BrowerManage.getIcon("meinv"),64,64)
			_iconBmp.y=0
			_iconBmp.x=baseWidth + 5;
			_iconBmp.buttonMode=true
			_iconBmp.filters=[getBitmapFilter()]
				
				
				
			_closeX=new PicBut
			_closeX.isEvent=false
			_closeX.visible=false
			_closeX.setBitmapdata(BrowerManage.getIcon("closeX"),20,20)
			_closeX.y=_iconBmp.y
			_closeX.x= baseWidth + 50
			_closeX.buttonMode=true
			this.addChild(_closeX)
				
				
			_labelTxt=new Label
			_labelTxt.setStyle("color",0x9f9f9f);
			_labelTxt.setStyle("paddingTop",4);
			_labelTxt.y=65
			_labelTxt.x=baseWidth + 5;
			this.addChild(_labelTxt)
				
				
			 _searchBut=new PicBut
			_searchBut.setBitmapdata(BrowerManage.getIcon("search"))
			_searchBut.x=baseWidth + 75;
			_searchBut.y=55
			_searchBut.filters=[getBitmapFilter()]
			_searchBut.buttonMode=true
			this.addChild(_searchBut)
				
				
			
			_openWith=new PicBut
			_openWith.setBitmapdata(BrowerManage.getIcon("folder"))
			_openWith.scaleX=_openWith.scaleY=0.5
			_openWith.x=baseWidth + 75 + 25
			_openWith.y=55
			_openWith.filters=[getBitmapFilter()]
			_openWith.buttonMode=true
			_openWith.visible=false
			this.addChild(_openWith)
				
				
				
		     _titleLabel=new Label
			_titleLabel.setStyle("color",0x9f9f9f);
			_titleLabel.setStyle("paddingTop",4);
			_titleLabel.setStyle("textAlign","right");
			_titleLabel.width=baseWidth;
			_titleLabel.x=0
			_titleLabel.y=5
			_titleLabel.text="预览 :"
			this.addChild(_titleLabel)
				
			this.height=90
			this.isDefault=false
				
			addEvents();
		}
		
		public function get hasCloseBut():uint
		{
			return _hasCloseBut;
		}

		public function set hasCloseBut(value:uint):void
		{
			_hasCloseBut = value;
		}

		public function resetPos():void{
			_iconBmp.x= baseWidth + 5;
			_labelTxt.x= baseWidth + 5;
			_searchBut.x= baseWidth + 75;
			_openWith.x= baseWidth + 75 + 25
			_closeX.x= baseWidth + 50
		}



		public function set donotDubleClik(value:uint):void
		{
			_donotDubleClik = value;
			if(_donotDubleClik!=1){
				_iconBmp.doubleClickEnabled = true;
			}
			
		}

		public function set changePath(value:uint):void
		{
			_changePath = value;
		}

//		public function get titleLabel():Label
//		{
//			return _titleLabel;
//		}
		
		public function set titleLabel(value:String):void{
			_titleLabel.text = value;
			if(_titleLabel.measureText(value).width > baseWidth){
				_titleLabel.width = _labelTxt.measureText(value).width + 5;
				baseWidth = _titleLabel.width;
				resetPos();
			}
		}

		public function get labelTxt():Label
		{
			return _labelTxt;
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

		
		private function addEvents():void
		{
			this.addEventListener(DragEvent.DRAG_ENTER,list_dragEnterHandler)
			this.addEventListener(DragEvent.DRAG_DROP,list_dragDropHandler)
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver)
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut)
			_iconBmp.addEventListener(MouseEvent.DOUBLE_CLICK,onDubleClik)
	

		
			_closeX.addEventListener(MouseEvent.CLICK,_closeXButClik)
			_searchBut.addEventListener(MouseEvent.CLICK,_searchButClik)
			_openWith.addEventListener(MouseEvent.CLICK,_openWithClik)
				
		}
		
		protected function _closeXButClik(event:MouseEvent):void
		{
			seturl("")
			_closeX.visible=false
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			_closeX.visible=false
			
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if(target&&FunKey&&_hasCloseBut==1){
				if(	target[FunKey]){
					_closeX.visible=true
				}
			}
		}
		
		protected function _openWithClik(event:MouseEvent):void
		{
			var $file:File=new File(AppData.workSpaceUrl+String(target[FunKey]));
			$file.openWithDefaultApplication();
		}
		
		protected var _listOnly:Boolean=true
		protected function _searchButClik(event:MouseEvent):void
		{
			if(target&&FunKey){
				var file:File=new File(AppData.workSpaceUrl+target[FunKey]);
				var evt:MEvent_BrowerShowFile=new MEvent_BrowerShowFile(MEvent_BrowerShowFile.BROWER_SHOW_SAMPE_FILE)
				evt.data=target[FunKey]
				evt.listOnly=_listOnly;
				ModuleEventManager.dispatchEvent(evt);
				_listOnly=!_listOnly;
			}
		}
		protected function onDubleClik(event:MouseEvent):void
		{
			if(_donotDubleClik==1){
				return 
			}
			openDisChooseFile();
		
		}
		private function openDisChooseFile():void
		{
			var file:File=new File;

			if(target&&FunKey&&target[FunKey]){
				var lastFile:File
				if(target[FunKey] as MaterialTree){
					var $materialTree:MaterialTree=target[FunKey] as MaterialTree
				         
					lastFile=new File(	$materialTree.url)
				}else{
					lastFile=new File(AppData.workSpaceUrl+target[FunKey])
				}
				if(lastFile.exists){
					file=lastFile.parent
				}
				
				
			}
			
			
			
			var dd:String=""
			for(var i:uint=0;i<extensinonItem.length;i++)
			{
				dd+="*."+extensinonItem[i]+";"
			}
			var filefilter:FileFilter = new FileFilter("请选择",dd);
			file.browse([filefilter]);
			file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				var $fileNode:File = e.target as File;
				if(AppData.type==0||$fileNode.url.search(AppData.workSpaceUrl)!=-1)
				{
					if(canInPutFile($fileNode.extension)){
//						if(_changePath==1){
//							addPreFabMovePanel($fileNode.url)
//						}else{
//							moveFileToFolder($fileNode.url)
//						}
						
						seturl($fileNode.url.replace(AppData.workSpaceUrl,""))
					}
				}else{
					Alert.show("不在同一工作空间");
				}
			}
		}
		
		
		private function moveFileToFolder($url:String):void
		{

			if(target is ITile){
				var $iTile:ITile=target as ITile
				var $path:String=$iTile.acceptPath()
				if($path){
					var $sonfile:File=new File($url)
					var destination:File = File.documentsDirectory;
					destination = destination.resolvePath(AppData.workSpaceUrl+$path+"/"+$sonfile.name);
					$sonfile.copyTo(destination, true);
					seturl(destination.url)
				
				}
			}
			

			
		}
		private var _win:Window
		private function addPreFabMovePanel($typeStr:String):void
		{
			if(_win){
				_win.close()
			}
			var $preFabMovePanel:PreFabMovePanel=new PreFabMovePanel
			var $win:Window = new Window;
			
			$win.transparent=false;
			$win.type=NativeWindowType.UTILITY;
			$win.systemChrome=NativeWindowSystemChrome.STANDARD;
			$win.width= 500;
			$win.height= 400;
			$win.alwaysInFront=true
			
			$win.resizable=false
			$win.showStatusBar = false;
			
			$preFabMovePanel.setStyle("left",0);
			$preFabMovePanel.setStyle("right",0);
			$preFabMovePanel.setStyle("top",0);
			$preFabMovePanel.setStyle("bottom",0);
			
			$preFabMovePanel.url=$typeStr;
			$preFabMovePanel.bFun=winBackFun
			
			$win.addElement($preFabMovePanel);
			
			$win.addEventListener(AIREvent.WINDOW_COMPLETE,showWinPanel)
			$win.open(true);
			_win=$win
			_win.visible=false
		}
		public function winBackFun($str:String,$url:String):void
		{
			if(_win){
				_win.close()
			}
			
			seturl($url)
		}
		protected function showWinPanel(event:AIREvent):void
		{
			Window(event.target).nativeWindow.x=Scene_data.stage.nativeWindow.x+Scene_data.stage.stageWidth/2-Window(event.target).nativeWindow.width/2;
			Window(event.target).nativeWindow.y=Scene_data.stage.nativeWindow.y+Scene_data.stage.stageHeight/2-Window(event.target).nativeWindow.height/2;
			_win.visible=true
			
		}
		
		
		protected var extensinonItem:Array;
		private var _titleLabel:Label;
		protected var _openWith:PicBut;
		protected function canInPutFile($extension:String):Boolean
		{
			for(var i:uint=0;i<extensinonItem.length;i++)
			{
				if($extension&&extensinonItem[i]==$extension.toLowerCase()){
					return true
				}
			}
			return false
		}
		public function set extensinonStr(value:String):void
		{
			extensinonItem=value.split("|")
		}
		protected function list_dragDropHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			
			
			if(canInPutFile($fileNode.extension)){
				
				seturl($fileNode.url)
			}
			
		}
		protected function list_dragEnterHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			if(canInPutFile($fileNode.extension)){
				
				var ui:UIComponent = event.target as UIComponent;
				
				DragManager.acceptDragDrop(ui);
			}
		}
		public function seturl($url:String):void
		{
		
	
			var str:String=$url.replace(AppData.workSpaceUrl,"")
			if(target&&FunKey){
				if(target[FunKey]==str){
					return ;
				}else{
					target[FunKey]=str
				}
			}
			if(Boolean(changFun)){
				changFun($url);
			}
			
			refreshViewValue()
			
		}
		protected function labelName($url:String):void
		{
			if(!AppData.workSpaceUrl){
				return;
			}
			var $file:File=new File(AppData.workSpaceUrl+$url);
			if($file.exists&&$file.extension){
				_labelTxt.text=$file.name
	
				if($file.extension=="jpg"||$file.extension=="png"||$file.extension=="wdp"){
					getFileBmpByUrl($file.url)
				}else{
					if(BrowerManage.getIcon($file.extension)){
						_iconBmp.setBitmapdata(BrowerManage.getIcon($file.extension),64,64)
					}else{
						_iconBmp.setBitmapdata($file.icon.bitmaps[0],64,64)
					}
					if($file.extension=="objs"){
						var $diskRendUrl:String=$file.url.replace(AppData.workSpaceUrl,"")
						$diskRendUrl=$diskRendUrl.replace("."+$file.extension,".jpg")
						var $bmpUrl:String=File.desktopDirectory.url+"/world/"+$diskRendUrl;
						getFileBmpByUrl($bmpUrl)
					}
				}
				_searchBut.visible=true
				_openWith.visible=false
					
			}else
			{
				_iconBmp.setBitmapdata(BrowerManage.getIcon("meinv"),64,64)
				_labelTxt.text=" "
				_searchBut.visible=false
				_openWith.visible=false
					
			}
		}
		private function getFileBmpByUrl($url:String):void
		{
			var $file:File=new File($url)
			if($file.exists){
				BmpLoad.getInstance().addSingleLoad($url,function ($bitmap:Bitmap,$obj:Object):void{
					_iconBmp.setBitmapdata($bitmap.bitmapData,64,64)
				},{})
			}
		}
		override public function refreshViewValue():void
		{
			if(target&&FunKey){
				labelName(String(target[FunKey]))
			}
			_listOnly=false
		}
	
	}
}


