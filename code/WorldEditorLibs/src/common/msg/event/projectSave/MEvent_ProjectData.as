package common.msg.event.projectSave
{
	import com.zcp.frame.event.ModuleEvent;
	
	public class MEvent_ProjectData extends ModuleEvent
	{
		public static var PROJECT_SAVE_GET_DATA:String = "project_Save_Get_Data";
		public static var PROJECT_SAVE_SET_DATA:String = "project_Save_Set_Data";
		
		public static var PROJECT_SAVE:String = "project_Save";
		public static var PROJECT_OPEN:String = "PROJECT_Open";
		
		public static var PROJECT_INIT:String = "Project_init";
		public static var PROJECT_WORKSPACE_CONFIG:String = "PROJECT_workspace_config";
		public static var PROJECT_WORKSPACE_CHANGE:String = "project_workspace_change";
		public static var PROJECT_SAVE_CONFIG:String = "project_save_config";
		public static var PROJECT_INIT_COMPLETE:String = "project_init_complete";

		public function MEvent_ProjectData($action:String=null)
		{
			super($action);
		}
	}
}