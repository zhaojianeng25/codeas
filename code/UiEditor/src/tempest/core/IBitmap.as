package tempest.core
{
	import flash.display.BitmapData;

	public interface IBitmap
	{
		/**
		 * 被引用的 BitmapData 对象。
		 * @return
		 */
		function get bitmapData():BitmapData;
		function set bitmapData(value:BitmapData):void;
		/**
		 * 控制在缩放时是否对位图进行平滑处理。
		 * 如果为 true，则会在缩放时对位图进行平滑处理。 如果为 false，则不会在缩放时对位图进行平滑处理。
		 * @return
		 */
		function get smoothing():Boolean;
		function set smoothing(value:Boolean):void;
	}
}
