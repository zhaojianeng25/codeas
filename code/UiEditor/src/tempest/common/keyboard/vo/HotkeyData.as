package tempest.common.keyboard.vo
{

	public class HotkeyData
	{
		private var _name:String;
		private var _handler:Function;
		private var _keyString:String;
		private var _needKeys:Boolean;
		private var _keys:Array;

		public function HotkeyData(name:String, keys:Array, keyString:String, handler:Function, needKeys:Boolean)
		{
			_handler = handler;
			_name = name;
			_keyString = keyString;
			_needKeys = needKeys;
			_keys = keys;
		}

		public function get name():String
		{
			return _name;
		}

		public function get keyString():String
		{
			return _keyString;
		}

		public function execute():void
		{
			if (_needKeys)
			{
				_handler.apply(null, _keys);
			}
			else
			{
				_handler();
			}
		}
	}
}
