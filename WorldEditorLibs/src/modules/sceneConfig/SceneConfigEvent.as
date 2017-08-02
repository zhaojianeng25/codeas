package modules.sceneConfig
{
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEvent;
	
	public class SceneConfigEvent extends ModuleEvent
	{
		public static var SHOW_SCENE_CONFIG_PANEL:String = "show_scene_config_panel";
		public static var CLOSE_CENEN_CONFIG_PANEL:String = "CLOSE_CENEN_CONFIG_PANEL";
		
		public function SceneConfigEvent($action:String=null)
		{
			super($action);
		}
	}
}