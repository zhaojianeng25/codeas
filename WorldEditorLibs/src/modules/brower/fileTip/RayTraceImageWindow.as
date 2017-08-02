package modules.brower.fileTip
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Button;
	import mx.core.UIComponent;
	import mx.graphics.codec.JPEGEncoder;
	
	import spark.components.Window;

	public class RayTraceImageWindow
	{
		private var bmpdata:BitmapData;
		private var timeStr:String;
		public function RayTraceImageWindow()
		{
		}
		
		public function add(bmp:BitmapData):void{
			var $win:Window = new Window;
			$win.transparent=false;
			$win.type=NativeWindowType.NORMAL;
			$win.systemChrome=NativeWindowSystemChrome.STANDARD;
			$win.width= 512;
			$win.height= 550;
			$win.alwaysInFront=false
			$win.resizable=true
			$win.showStatusBar = false;
			$win.setStyle("backgroundColor","#404040");
			$win.title = "光线追踪";
			
			var btn:Button = new Button;
			btn.setStyle("bottom",0);
			btn.label = "保存";
			btn.height = 30;
			btn.width = 100;
			btn.x = (512 - 100)/2 - 60;
			btn.addEventListener(MouseEvent.CLICK,onClick);
			$win.addElement(btn);
			
			var btn2:Button = new Button;
			btn2.setStyle("bottom",0);
			btn2.label = "保存桌面";
			btn2.height = 30;
			btn2.width = 100;
			btn2.x = (512 - 100)/2 + 60;
			btn2.addEventListener(MouseEvent.CLICK,onDeskClick);
			$win.addElement(btn2);
			
			var ui:UIComponent = new UIComponent;
			$win.addElement(ui);
			ui.addChild(new Bitmap(bmp));
			//$win.addEventListener(AIREvent.WINDOW_COMPLETE,windowComplete)
			//$win.addEventListener(AIREvent.APPLICATION_ACTIVATE,windowActivate)

			$win.open(true);
			
			var date:Date = new Date();
			timeStr = date.getFullYear() + "." + (date.getMonth()+1) + "." + date.getDate() + "-" 
				+ date.getHours() + "-" + date.getMinutes() + "-" + date.getSeconds();
			trace(timeStr);
			this.bmpdata = bmp;
		}
		
		protected function onDeskClick(event:MouseEvent):void
		{
			var file:File =  new File(File.desktopDirectory.url + "/" + timeStr + ".jpg");
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			var byte:ByteArray = new JPEGEncoder(100).encode(bmpdata);
			fs.writeBytes(byte,0,byte.length);
			fs.close();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var file:File = new File;
			file.browseForSave("保存图片");
			file.addEventListener(Event.SELECT,onSel); 
		}
		
		protected function onSel(event:Event):void
		{
			var file:File = event.target as File;
			if(!file.extension){
				file = new File(file.url + ".jpg");
			}
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			var byte:ByteArray = new JPEGEncoder(100).encode(bmpdata);
			fs.writeBytes(byte,0,byte.length);
			fs.close();
		}
	}
}