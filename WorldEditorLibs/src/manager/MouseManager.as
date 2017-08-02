package manager
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;

	public class MouseManager
	{
		[Embed(source="assets/icon/Zoom_camera.png")]
		private static var doubelArrow:Class;
		
		[Embed(source="assets/icon/Zoom_camera01.png")]
		private static var doubelVerArrow:Class;
		
		public function MouseManager()
		{
		}
		
		public static function initMouse():void{
			var mouseCursorData:MouseCursorData = new MouseCursorData();
			var bmp:Bitmap = new doubelArrow();
			var vec:Vector.<BitmapData> = new Vector.<BitmapData>;
			vec.push(bmp.bitmapData);
			mouseCursorData.data = vec;
			mouseCursorData.frameRate = 1;
			
			Mouse.registerCursor( "doubelArrow", mouseCursorData );
			
			mouseCursorData = new MouseCursorData();
			bmp = new doubelVerArrow();
			vec = new Vector.<BitmapData>;
			vec.push(bmp.bitmapData);
			mouseCursorData.data = vec;
			mouseCursorData.frameRate = 1;
			
			Mouse.registerCursor( "doubelVerArrow", mouseCursorData );
		}
	}
}