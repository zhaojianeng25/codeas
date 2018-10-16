package interfaces
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public interface ITile
	{
		function getBitmapData():BitmapData;
		function getName():String;
		function acceptPath():String;
	}
}