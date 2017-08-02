package common.msg.event.brower
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_BrowerShowFile extends ModuleEvent
	{
		public static var BROWER_SHOW_SAMPE_FILE:String = "BrowerShowSampleFile";
		public var url:String
		public var data:Object
		public var listOnly:Boolean
		public function MEvent_BrowerShowFile($action:String=null)
		{
			super($action);
		}
	}
}