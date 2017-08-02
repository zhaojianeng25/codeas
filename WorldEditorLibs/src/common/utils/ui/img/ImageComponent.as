package common.utils.ui.img
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
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
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import common.AppData;
	import common.msg.event.brower.MEvent_BrowerShowFile;
	import common.utils.frame.BaseComponent;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.prefab.PicBut;
	
	import materials.MaterialTree;
	
	import modules.brower.fileWin.BrowerManage;
	
	public class ImageComponent extends BaseComponent
	{
		protected var _iconBmp:PicBut;
		protected var _labelTxt:Label
		protected var _searchBut:PicBut;
		protected var _changePath:uint
		protected var _donotDubleClik:uint
		public var baseUrl:String;
		public function ImageComponent()
		{
			super();
			_iconBmp=new PicBut
			this.addChild(_iconBmp)
			
			_iconBmp.setBitmapdata(BrowerManage.getIcon("meinv"),64,64)
			_iconBmp.y=0
			_iconBmp.x=95
			_iconBmp.buttonMode=true
			_iconBmp.filters=[getBitmapFilter()]
			
			_labelTxt=new Label
			_labelTxt.setStyle("color",0x9f9f9f);
			_labelTxt.setStyle("paddingTop",4);
			_labelTxt.y=65
			_labelTxt.x=95
			this.addChild(_labelTxt)
			
			
			_searchBut=new PicBut
			_searchBut.setBitmapdata(BrowerManage.getIcon("search"))
			_searchBut.x=170
			_searchBut.y=55
			_searchBut.filters=[getBitmapFilter()]
			_searchBut.buttonMode=true
			//this.addChild(_searchBut)
			
			
			
			_openWith=new PicBut
			_openWith.setBitmapdata(BrowerManage.getIcon("folder"))
			_openWith.scaleX=_openWith.scaleY=0.5
			_openWith.x=170
			_openWith.y=55
			_openWith.filters=[getBitmapFilter()]
			_openWith.buttonMode=true
			_openWith.visible=false
			this.addChild(_openWith)
			
			
			
			_titleLabel=new Label
			_titleLabel.setStyle("color",0x9f9f9f);
			_titleLabel.setStyle("paddingTop",4);
			_titleLabel.width=baseWidth;
			_titleLabel.setStyle("textAlign","right");
			_titleLabel.x=0
			_titleLabel.y=5
			_titleLabel.text="预览 :"
			this.addChild(_titleLabel)
			
			this.height=90
			this.isDefault=false
			
			addEvents();
		}
		
		override public function set label(value:String):void{
			_titleLabel.text = value;
			
			if(_titleLabel.measureText(value).width > baseWidth){
				_titleLabel.width = _titleLabel.measureText(value).width + 5;
			}
		}
		
		
		
		public function set donotDubleClik(value:uint):void
		{
			_donotDubleClik = value;
		}
		
		public function set changePath(value:uint):void
		{
			_changePath = value;
		}
		
		public function get titleLabel():Label
		{
			return _titleLabel;
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
			_iconBmp.doubleClickEnabled=true
			_iconBmp.addEventListener(MouseEvent.DOUBLE_CLICK,onDubleClik)
			_searchBut.addEventListener(MouseEvent.CLICK,_searchButClik)
			_openWith.addEventListener(MouseEvent.CLICK,_openWithClik)
			
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
			
			var file:File=new File;
			if(target&&FunKey&&target[FunKey]){
				var lastFile:File
				lastFile=new File(AppData.workSpaceUrl+target[FunKey])
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
				if($fileNode.url.search(baseUrl)!=-1)
				{
					if(canInPutFile($fileNode.extension)){

							seturl($fileNode.url)
						
					}
				}else{
					Alert.show("不在同一工作空间");
				}
			}
		}
		
		
	
		
		protected var extensinonItem:Array = ["jpg","png"];
		private var _titleLabel:Label;
		private var _openWith:PicBut;
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
			
			var str:String=$url.replace(baseUrl,"");//.substr(AppData.workSpaceUrl.length,$url.length)
			if(target&&FunKey){
				if(target[FunKey]==str){
					return;
				}else{
					target[FunKey]=str
				}
			}
			
			_iconBmp.setUrl($url);
			
			this.dispatchEvent(new Event(Event.CHANGE));
			//labelName(str)
			
		}
		private function labelName($url:String):void
		{
			var $file:File=new File(baseUrl+$url);
			if($file.exists){
				_labelTxt.text=$file.name
				var urlStr:String=$file.nativePath
				if($file.extension=="jpg"||$file.extension=="png"||$file.extension=="wdp"){
					LoadManager.getInstance().addSingleLoad(new LoadInfo(urlStr,LoadInfo.BITMAP,function onTextureLoad(bitmap:Bitmap,url:String):void{
						_iconBmp.setBitmapdata(bitmap.bitmapData,64,64)
					},0,urlStr));
				}else{
					_iconBmp.setBitmapdata($file.icon.bitmaps[0],64,64)
				}
				_searchBut.visible=true
				_openWith.visible=true
			}else
			{
				_iconBmp.setBitmapdata(BrowerManage.getIcon("meinv"),64,64)
				_labelTxt.text=" "
				_searchBut.visible=false
				_openWith.visible=false
				
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



