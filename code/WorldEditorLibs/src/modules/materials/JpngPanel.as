package modules.materials
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import common.AppData;
	import common.utils.frame.BasePanel;
	import common.utils.ui.btn.LButton;
	import common.utils.ui.prefab.PreFabModelPic;
	
	public class JpngPanel extends BasePanel
	{
		public function JpngPanel()
		{
			super();
			this.setStyle("backgroundColor",0x404040);
			this.setStyle("borderColor",0x000000);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";
			
			this.addJpgBase();
			this.addPngBase();
			this.addBtn();
		}
		private var jpgUI:JpngBaseUi;
		private var pngUI:JpngBaseUi;
		
		private function addJpgBase():void{
			this.jpgUI = new JpngBaseUi();
			var $preFabModelPic:PreFabModelPic=new PreFabModelPic()
			$preFabModelPic.titleLabel="rgb";
			$preFabModelPic.FunKey = "url";
			$preFabModelPic.category = "";
			$preFabModelPic.target= this.jpgUI;
			$preFabModelPic.donotDubleClik = 0;
			$preFabModelPic.extensinonStr= "jpg";
			this.addChild($preFabModelPic);
		}
		
		private function addPngBase():void{
			this.pngUI = new JpngBaseUi();
			var $preFabModelPic:PreFabModelPic=new PreFabModelPic()
			$preFabModelPic.titleLabel="alpha";
			$preFabModelPic.FunKey = "url";
			$preFabModelPic.category = "";
			$preFabModelPic.target= this.pngUI;
			$preFabModelPic.donotDubleClik = 0;
			$preFabModelPic.extensinonStr= "jpg";
			$preFabModelPic.y = 100;
			this.addChild($preFabModelPic);
		}
		
		private function addBtn():void{
			var btn:LButton = new LButton;
			btn.label = "生成";
			btn.addEventListener(MouseEvent.CLICK,onBtnClick);
			btn.y = 200;
			this.addChild(btn);
		}
		
		protected function onBtnClick(event:MouseEvent):void
		{
			var p:Sprite = this.parent as Sprite
			if(!this.jpgUI.url || !this.pngUI.url){
				Alert.show("没有选择图片","警告",4,p)
			}
			var jpgFile:File = new File(AppData.workSpaceUrl + this.jpgUI.url);
			var pngFile:File = new File(AppData.workSpaceUrl + this.pngUI.url);
			
			var jpgByte:ByteArray = new ByteArray;
			var pngByte:ByteArray = new ByteArray;
			var fs:FileStream = new FileStream();
			
			fs.open(jpgFile,FileMode.READ);
			fs.readBytes(jpgByte);
			fs.close();
			
			fs.open(pngFile,FileMode.READ);
			fs.readBytes(pngByte);
			fs.close();
			
			var allByte:ByteArray = new ByteArray();
			allByte.writeInt(jpgByte.length);
			allByte.writeBytes(jpgByte);
			allByte.writeInt(pngByte.length);
			allByte.writeBytes(pngByte);
			
			var fileName:String = pngFile.name;
			fileName = fileName.split(".")[0];
			
			var newFile:File = new File(jpgFile.parent.url + "/" + fileName + ".jpng");
			fs.open(newFile,FileMode.WRITE);
			fs.writeBytes(allByte);
			fs.close();
			
			Alert.show("生成完成","提示",4,p)
		}
		
	}
	
}

class JpngBaseUi
{
	private var _url:String;
	public function JpngBaseUi()
	{
	}
	
	public function get url():String
	{
		return _url;
	}
	
	public function set url(value:String):void
	{
		_url = value;
	}
	
}

