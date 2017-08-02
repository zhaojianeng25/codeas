package _Pan3D.event
{
	import flash.events.Event;
	
	public class PlayEvent extends Event
	{
		/** @parm $new_onPlayBeforeStart
		* @parm $new_onPlayStart
		* @parm $new_onPlayUpdate
		* @parm $new_onPlayComplete
		* @parm $new_onAdd
		* @parm $new_onRemove*/

		public static var PLAY_BEFORESTART_EVENT:String = "onPlayBeforeStartEvent";
		public static var PLAY_START_EVENT:String = "OnPlayStartEvent";
		public static var PLAY_COMPLETE_EVENT:String = "OnPlayComplete";
		public static var ADD_EVENT:String = "onAddEvent";
		
		public function PlayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}