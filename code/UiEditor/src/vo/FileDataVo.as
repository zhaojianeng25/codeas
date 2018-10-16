package vo
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class FileDataVo
	{
		//图片对象
		public function FileDataVo()
		{
		}
		public var bmp:BitmapData;
		public var rect:Rectangle;
		public var url:String;
		public var sprite:FileDataSprite;
		public var dele:Boolean;
	}
}