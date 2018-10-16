package common.utils.ui.img
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.core.UIComponent;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;

	/**
	 * @author liuyanfei QQ:421537900
	 */
	public class FileImage extends UIComponent
	{
		private var _fileUrl:String;
		private var _type:int;
		private var _bmp:Bitmap;
		public function FileImage()
		{
			super();
		}

		public function get fileUrl():String
		{
			return _fileUrl;
		}

		public function set fileUrl(value:String):void
		{
			_fileUrl = value;
			var loaderinfo : LoadInfo = new LoadInfo(value, LoadInfo.BITMAP, onImgsLoad, 0);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		
		public function onImgsLoad(bitmap:Bitmap):void{
			while(this.numChildren){
				this.removeChildAt(0);
			}
			this.addChild(bitmap);
			if(this.width){
				bitmap.width = width;
			}else{
				bitmap.width = 50;
			}
			if(this.height){
				bitmap.height = height;
			}else{
				bitmap.height = 50;
			}
			
			bitmap.smoothing = true;
			
		
		}
		
		public function set bmp(bmp:BitmapData):void
		{
			if(!_bmp)
			{
				_bmp = new Bitmap();
				addChild(_bmp);
				_bmp.x = 3;
			}
			_bmp.bitmapData = bmp;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}


	}
}