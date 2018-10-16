package common.utils.ui
{
	import flash.display.BitmapData;
	
	import common.utils.frame.BaseComponent;
	import common.utils.ui.img.FileImage;
	
	public class PicShow extends BaseComponent
	{
		private var _bmp:FileImage;
		public function PicShow()
		{
			super();
			_bmp=new FileImage
			this.addChild(_bmp)
			_bmp.bmp=new BitmapData(64,64,false,0xff0000)
			this.height=100
			this.isDefault=false
		}
		public function seturl($url:String):void
		{
			
		}
	}
}