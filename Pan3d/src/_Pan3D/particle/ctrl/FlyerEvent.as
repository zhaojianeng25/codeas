package _Pan3D.particle.ctrl
{
	import flash.events.Event;
	
	public class FlyerEvent extends Event
	{
		public static var FLYREACH:String = "flyreach";
		public static var FLYSTART:String = "flyStart";
		public var timeout:int;
		public function FlyerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		override public function clone():Event{
			var evt:FlyerEvent = new FlyerEvent(this.type);
			evt.timeout = timeout;
			return evt;
		}
	}
}