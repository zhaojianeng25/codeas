package common.msg.event.brower
{
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.filesystem.File;
	
	public class MEvent_Brower_Input_Obj extends ModuleEvent
	{
		public static var INPUT_MODEL_OBJ:String = "input_model_obj";
		public var prentFile:File
		public function MEvent_Brower_Input_Obj($action:String=null)
		{
			super($action);
		}
	}
}