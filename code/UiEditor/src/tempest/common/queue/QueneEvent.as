package tempest.common.queue {
	import flash.events.Event;

	public class QueneEvent extends Event {
		public static const START:String = "start";
		public static const COMPLETE:String = "complete";

		public function QueneEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		public override function clone():Event {
			return new QueneEvent(type, bubbles, cancelable);
		}
	}
}
