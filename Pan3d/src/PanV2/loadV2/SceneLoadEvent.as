package  PanV2.loadV2
{
	import flash.events.Event;
	
	public class SceneLoadEvent extends Event
	{
		public function SceneLoadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public var num:uint=0
		public var total:uint=0
		public static const LOAD_CUTTFT:String = "LOAD_CUTTFT";
	}
}