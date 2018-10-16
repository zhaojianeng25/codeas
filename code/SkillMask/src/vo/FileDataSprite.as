package vo
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class FileDataSprite extends Sprite
	{
		private var _bitmap:Bitmap;
		private var _fileDataVo:FileDataVo
		public function FileDataSprite()
		{
			super();
			_bitmap=new Bitmap()
			this.addChild(_bitmap);
			addEvents();
			initMenuFile()
		}
		
		private function addEvents():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp)
			this.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			_fileDataVo.rect.x=this.x
			_fileDataVo.rect.y=this.y
			this.stopDrag();
		}
		
		protected function onRightClick(event:MouseEvent):void
		{
			_menuFile.display(this.stage,this.stage.mouseX,this.stage.mouseY);
			
		}
		private var _menuFile:NativeMenu;
		public function initMenuFile():void{
			

			
			_menuFile = new NativeMenu;
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;
			

			
			item = new NativeMenuItem("删除")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onDele);
			
			
			
		}
		
		protected function onDele(event:Event):void
		{
			_fileDataVo.dele=true
			this.parent.removeChild(this)
			
			
		}
		protected function onMouseDown(event:MouseEvent):void
		{
			this.startDrag()
			
		}
		
		public function get fileDataVo():FileDataVo
		{
			return _fileDataVo;
		}

		public function set fileDataVo(value:FileDataVo):void
		{
			_fileDataVo = value;
		}

		public function set bitmapData(value:BitmapData):void
		{
			_bitmap.bitmapData=value;
		}
	}
}