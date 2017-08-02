package _Pan3D.event
{
	import flash.events.Event;
	/**
	 * 位置加载完成事件 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class PosCompleteEvent extends Event
	{
		public static var POS_COMPLETE_EVENT:String = "PosCompleteEvent";
		public function PosCompleteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}