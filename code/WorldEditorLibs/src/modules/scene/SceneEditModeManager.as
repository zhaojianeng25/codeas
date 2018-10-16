package modules.scene
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import _Pan3D.scene.SceneContext;
	
	import common.AppData;
	import common.msg.event.scene.MEvent_EditMode;
	import common.vo.editmode.EditModeEnum;

	public class SceneEditModeManager
	{
		public function SceneEditModeManager()
		{
		}
		
		public static function changeMode($mode:String):void{
			
			if($mode==EditModeEnum.EDIT_COLLISION){
				SceneContext.sceneRender.clossReader=true;
			}else{
				SceneContext.sceneRender.clossReader=false;
			}
		
			
			AppData.editMode = $mode;
			var evt:MEvent_EditMode = new MEvent_EditMode(MEvent_EditMode.MEVENT_EDITMODE_CHANGE);
			evt.mode = $mode;
			ModuleEventManager.dispatchEvent(evt);
		}
	}
}