package mvc.project
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import _me.Scene_data;
	
	import common.AppData;
	
	import mvc.centen.discenten.DisCentenEvent;
	import mvc.left.disleft.DisLeftEvent;
	import mvc.left.panelleft.PanelModel;
	import mvc.left.picleft.PicLeftEvent;
	import mvc.scene.UiSceneEvent;
	
	import vo.FileDataVo;
	
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
		private function makeBasePicItem(picSceneData:Object):void
		{
			UiData.picFileDataVo=new FileDataVo;
			if(picSceneData&&UiData.picItem.length){
				UiData.picFileDataVo.url=picSceneData.url
				var rect:Rectangle=new Rectangle;
				rect.x=	int(picSceneData.rect.x)
				rect.y=	int(picSceneData.rect.y)
				rect.width=picSceneData.rect.width
				rect.height=picSceneData.rect.height
				UiData.picFileDataVo.bmp=new BitmapData(rect.width,rect.height)
				var $bmpByte:ByteArray=ByteArray(picSceneData.bmpByte);
				UiData.picFileDataVo.bmp.setPixels(rect, $bmpByte)
				UiData.picFileDataVo.rect=rect
					
		
				ModuleEventManager.dispatchEvent( new PicLeftEvent(PicLeftEvent.SHOW_PIC_LEFT))
			
	
			}else{
				UiData.picFileDataVo.url="";
				UiData.picFileDataVo.bmp=new BitmapData(512,256,false,0xffffffff)
				UiData.picFileDataVo.rect=new Rectangle(0,0,UiData.picFileDataVo.bmp.width,UiData.picFileDataVo.bmp.height);
			}
			

		}
		private function readScene($file:File):void
		{
			var _so:SharedObject = UiData.getSharedObject() 
			_so.data.url=$file.url;
			
			
			var $fs:FileStream = new FileStream;
			$fs.open($file,FileMode.READ);
			var $obj:Object=new Object
			try{
				 $obj=$fs.readObject();
				$fs.close();
			}catch(e:Error){
				Alert.show("方件对象不存在，请重新保存")
				$obj.FileBmpItem=new Array
				$obj.InfoRectItem=new Array
				$obj.picinfoRectItem=new Array
				$obj.FileBmpItem=new Array
		
			}
		
			
			UiData.meshBmp($obj.FileBmpItem)
			UiData.meshInfo($obj.InfoRectItem)
			UiData.meshPicInfo($obj.picinfoRectItem)
			this.makeBasePicItem($obj.picSceneData)

			PanelModel.getInstance().setPanelNodeItemByObj($obj.panelItem)
	
			
			if($obj.sceneBmpRec){
				UiData.sceneBmpRec=new Rectangle(0,0,$obj.sceneBmpRec.width,$obj.sceneBmpRec.height)
			}else{
				UiData.sceneBmpRec=new Rectangle(0,0,512,512)
			}
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