package mvc.scene
{
	import com.zcp.frame.event.ModuleEvent;
	
	import vo.H5UIFileNode;
	
	public class UiSceneEvent extends ModuleEvent
	{
		public static const SHOW_UI_SCENE:String = "SHOW_UI_SCENE";
		//public static const INIT_UI_SCENE:String = "INIT_UI_SCENE";
		public static const REFRESH_SCENE_DATA:String = "REFRESH_SCENE_DATA";
		public static const SELECT_INFO_NODE:String="SELECT_INFO_NODE";
		public static const START_MOVE_NODE_INFO:String="START_MOVE_NODE_INFO";
		public static const CHANGE_SCENE_COLOR:String="CHANGE_SCENE_COLOR";
		public static const SHOW_HIDE_LINE:String="SHOW_HIDE_LINE";
		public static const REFRESH_SCENE_BITMAPDATA:String="REFRESH_SCENE_BITMAPDATA";
		
		public static const SHOW_PIC_UI_SCENE:String = "SHOW_PIC_UI_SCENE";
		
		public var h5UIFileNode:H5UIFileNode;
		public var shiftKey:Boolean;
		public var ctrlKey:Boolean;
		public var modelType:uint=0;
		public function UiSceneEvent($action:String=null)
		{
			super($action);
		}
	}
}