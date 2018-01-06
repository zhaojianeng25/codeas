package tempest.common.webservice
{
	import flash.events.Event;

	/**
	 * ...
	 * @author wsk
	 */
	public class TSoapEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		private var _data:Object;

		public function TSoapEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this._data = data;
		}

		public function get data():Object
		{
			return _data;
		}

		override public function clone():Event
		{
			return new TSoapEvent(type, _data, bubbles, cancelable);
		}
	}
}
