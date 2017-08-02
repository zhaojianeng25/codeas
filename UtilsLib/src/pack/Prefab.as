package pack
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	import interfaces.ITile;

	public class Prefab extends EventDispatcher implements ITile
	{
		private var _csvID:int
		private var _name:String
		public function Prefab()
		{
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get csvID():int
		{
			return _csvID;
		}

		public function set csvID(value:int):void
		{
			_csvID = value;
		}

		public function getBitmapData():BitmapData
		{
			return null;
		}
		
		public function getName():String
		{
			return null;
		}
		
		public function acceptPath():String
		{
			return null;
		}
		
		
		
		
	}
}