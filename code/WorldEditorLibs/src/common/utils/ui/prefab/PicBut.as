package common.utils.ui.prefab
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	public class PicBut extends UIComponent
	{
		private var _bmp:Bitmap;
		public var isEvent:Boolean=true
		public function PicBut()
		{
			_bmp = new Bitmap();
			addChild(_bmp);
			_bmp.x = 3;
			addEvents();
		}
		
		public function get bmp():Bitmap
		{
			return _bmp;
		}

		public function set bmp(value:Bitmap):void
		{
			_bmp = value;
		}

		private function addEvents():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOVER)
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseOut)
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut)
		}
		protected function onMouseOut(event:MouseEvent):void
		{
			if(isEvent){
				this.alpha=1
			}
			
		}
		protected function onMouseOVER(event:MouseEvent):void
		{
			if(isEvent){
				this.alpha=0.5
			}
			
			
		}
		public function setBitmapdata(bmp:BitmapData,$w:uint=0,$h:uint=0):void
		{
	
			if($w==0||$h==0)
			{
				$w=bmp.width
				$h=bmp.height
			}
			_bmp.smoothing=true
			_bmp.bitmapData = bmp;
			_bmp.width=$w
			_bmp.height=$h
		}
		
		public function setUrl($url:String):void{
			var loaderinfo:LoadInfo = new LoadInfo($url,LoadInfo.BITMAP,onImgLoad,0);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		
		private function onImgLoad($bitmap:Bitmap):void
		{
			setBitmapdata($bitmap.bitmapData,64,64);
			
		}		

	}
}


