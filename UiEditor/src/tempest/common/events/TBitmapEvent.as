package tempest.common.events
{
	import flash.events.Event;
	import tempest.common.graphics.TBitmap;

	public class TBitmapEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
		public static const PROGRESS:String = "progress";
		private var _bitmap:TBitmap;
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
		private var _text:String;

		public function get bitmap():TBitmap
		{
			return _bitmap;
		}

		public function get bytesLoaded():uint
		{
			return _bytesLoaded;
		}

		public function get bytesTotal():uint
		{
			return _bytesTotal;
		}

		public function get text():String
		{
			return _text;
		}

		public function TBitmapEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, bitmap:TBitmap = null, bytesLoaded:uint = 0, bytesTotal:uint = 0, text:String = "")
		{
			super(type, bubbles, cancelable);
			this._bitmap = bitmap;
			this._bytesLoaded = bytesLoaded;
			this._bytesTotal = bytesTotal;
			this._text = text;
		}

		public override function clone():Event
		{
			return new TBitmapEvent(type, bubbles, cancelable, _bitmap, _bytesLoaded, _bytesTotal, _text);
		}
	}
}
