package _Pan3D.event
{
	import flash.events.Event;
	
	public class LoadCompleteEvent extends Event
	{
		public static var LOAD_COMPLETE:String = "LoadComplete";
		public function LoadCompleteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}