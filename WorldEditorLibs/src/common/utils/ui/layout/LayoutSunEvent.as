package common.utils.ui.layout
{
	import flash.events.Event;
	
	import common.utils.ui.tab.TabPanel;
	
	public class LayoutSunEvent extends Event
	{
		public var direct:String;
		public var panel:TabPanel;
		
		public static var LAYOUTSUN_EVENT:String = "LayoutSunEvent"
		
		public function LayoutSunEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}