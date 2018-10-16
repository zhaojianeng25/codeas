package mvc.project
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	
	import common.AppData;
	
	import mvc.centen.discenten.DisCentenEvent;
	import mvc.left.disleft.DisLeftEvent;
	import mvc.left.panelleft.PanelLeftEvent;
	import mvc.left.panelleft.PanelModel;
	import mvc.scene.UiSceneEvent;
	
	public class ProjectProcessor extends Processor
	{
		public function ProjectProcessor($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				ProjectEvent,

			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
	
				case ProjectEvent:
					if($me.action==ProjectEvent.OPEN_PROJECT_FILE){
						readScene(new File(ProjectEvent($me).url))
					}
					break;
		
				
			}
		}
		private function readScene($file:File):void
		{
			var _so:SharedObject = UiData.getSharedObject() 
			_so.data.url=$file.url;
			
			
			var $fs:FileStream = new FileStream;
			$fs.open($file,FileMode.READ);
			var $obj:Object=$fs.readObject();
			$fs.close();
			
			UiData.meshBmp($obj.FileBmpItem)
			UiData.meshInfo($obj.InfoRectItem)
			PanelModel.getInstance().setPanelNodeItemByObj($obj.panelItem)
	
			
			UiData.sceneBmpRec=new Rectangle(0,0,512,512)
			if($obj.sceneColor){
				UiData.sceneColor=$obj.sceneColor
			}else{
				UiData.sceneColor=0x00ffffff
			}
			
			UiData.url=$file.url
			
				
			AppData.appTitle=decodeURI($file.url)
			ModuleEventManager.dispatchEvent( new UiSceneEvent(UiSceneEvent.REFRESH_SCENE_DATA));
			ModuleEventManager.dispatchEvent( new DisCentenEvent(DisCentenEvent.SHOW_CENTEN));
			ModuleEventManager.dispatchEvent( new DisLeftEvent(DisLeftEvent.SHOW_RIGHT));
			
			
			
		}
	}
}