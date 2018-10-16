package modules.projectSave
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.display3D.grass.GrassDisplay3DSprite;
	import _Pan3D.display3D.ground.quick.QuickModelMath;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import adobe.utils.ProductManager;
	
	import common.AppData;
	import common.GameUIInstance;
	import common.msg.event.brower.MEvent_BrowerShow;
	import common.msg.event.projectSave.MEvent_ProjectData;
	
	import modules.brower.fileWin.VirtualFile;
	import modules.materials.view.MaterialTreeManager;
	import modules.scene.EnvironmentVo;
	
	import proxy.top.render.Render;
	
	import render.grass.GrassManager;
	
	public class ProjectSaveProcess extends Processor
	{
		public function ProjectSaveProcess($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				MEvent_ProjectData
			]
		}
		
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {

				case MEvent_ProjectData:
					if($me.action == MEvent_ProjectData.PROJECT_SAVE){
					
						save();
					
						
					}else if($me.action == MEvent_ProjectData.PROJECT_OPEN){
						openMap();
					}else if($me.action == MEvent_ProjectData.PROJECT_INIT){
						init();
					}else if($me.action == MEvent_ProjectData.PROJECT_WORKSPACE_CHANGE){
						changWorkSpace();
					}else if($me.action == MEvent_ProjectData.PROJECT_SAVE_CONFIG){
						writeProjectConfig();
					}else if($me.action == MEvent_ProjectData.PROJECT_WORKSPACE_CONFIG){
						readWorkSpaceFile();
					}
					break;
			}
		}
		
		private function saveAmani():void
		{
	
				
		}		
	
		
		public function changWorkSpace():void{
			var file:File = new File;
			file.addEventListener(Event.SELECT,onFileWorkChg);
			file.browseForDirectory("选择文件夹");
		}
		
		protected function onFileWorkChg(event:Event):void
		{
			var file:File = event.target as File;
			
			AppData.workSpaceUrl = file.url + "/";
			AppData.mapUrl = "default.lmap";
			writeProjectConfig();
			
			Scene_data.fileRoot=AppData.workSpaceUrl;

			
			var mgr:ProductManager = new ProductManager("airappinstaller");  
			mgr.launch("-launch " + NativeApplication.nativeApplication.applicationID + " " + NativeApplication.nativeApplication.publisherID);  
			NativeApplication.nativeApplication.exit();  
		}
		
		public function save():void{
			
			ModuleEventManager.dispatchEvent(new MEvent_ProjectData(MEvent_ProjectData.PROJECT_SAVE_SET_DATA));
			AppData.environment=EnvironmentVo.getInstance().readObject()
			AppData.writeFog()
			AppData.writeRayTraceVo()
				
			var obj:Object = AppData.readObject();
			var file:File = new File(AppData.workSpaceUrl + AppData.mapUrl);
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.WRITE);
			fs.writeObject(obj);
		//	AppData.writeObject(obj);
			fs.close()
		}
		
		public function openMap():void{
			var file:File = new File(AppData.workSpaceUrl + AppData.mapUrl);
			Scene_data.fileRoot=AppData.workSpaceUrl
	
				if(file.exists){
					AppData.appTitle="MainEditor--"+decodeURI(AppData.mapUrl)

						
					var fs:FileStream = new FileStream;
					
					fs.open(file,FileMode.READ);
					var obj:Object = fs.readObject();
					fs.close();
					AppData.writeObject(obj);
			
					Render.lightUvRoot=file.url.replace(".lmap","_hide/lightuv/")
						
					GrassManager.getInstance().clear();
					ModuleEventManager.dispatchEvent(new MEvent_ProjectData(MEvent_ProjectData.PROJECT_SAVE_GET_DATA));
					
					writeProjectConfig();
					loadGroundLightUvToGrass();
				}else
				{
					if(AppData.type==1){
						Alert.show("地图文件不存在")
					}
				
				}
		}
		private function loadGroundLightUvToGrass():void
		{
			if(AppData.type==1){
				var $url:String=Render.lightUvRoot+"allGroundLightUv.jpg"
				BmpLoad.getInstance().addSingleLoad($url,function ($bitmap:Bitmap,$obj:Object):void{
					GrassDisplay3DSprite.groundLightUvTexture=TextureManager.getInstance().bitmapToTexture($bitmap.bitmapData)
				},{})
			}
		
		}
		
		public function init():void{
		
			readFileConfig();
			
		}
		
		public function readFileConfig():void{
			var file:File = new File(File.documentsDirectory.url + "/worldeditor.config");
			if(file.exists){
				readProjectConfig();
			}else{
				if(!AppData.workSpaceUrl){
					Alert.show("工作空间未配置！是否立即配置？","警告",Alert.YES | Alert.NO,null,onClose);
				}
			}
		}
		
		private function onClose(evt:CloseEvent):void
		{
			if(evt.detail == Alert.NO){
				GameUIInstance.stage.nativeWindow.close();
			}else{
				var file:File = new File;
				file.browseForDirectory("选择工作空间");
				file.addEventListener(Event.SELECT,onRootSel);
			}
		}		
		
		protected function onRootSel(event:Event):void
		{
			var file:File = event.target as File;
			
			AppData.workSpaceUrl = file.url + "/";
		
			creatDefultMap();
			
			writeProjectConfig();
			
			ModuleEventManager.dispatchEvent(new MEvent_BrowerShow(MEvent_BrowerShow.BROWER_CHANGE));
		}		
		
		public function readProjectConfig():void{
			var file:File = new File(File.documentsDirectory.url + "/worldeditor.config");
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.READ);
			var obj:Object = fs.readObject();
			fs.close();
			AppData.mapUrl = obj.mapUrl;
			AppData.workSpaceUrl = obj.workSpaceUrl;
			AppData.expSpaceUrl = obj.expSpaceUrl;
		
			Scene_data.particleRoot=AppData.workSpaceUrl
			if( obj.RenderSocketUrl){
				AppData.RenderSocketUrl = obj.RenderSocketUrl;
			}
			
			if(AppData.mapUrl == null){
				creatDefultMap();
			}else{ 
				openMap();
			}
			
			readWorkSpaceFile();
			
			
			
				
			ModuleEventManager.dispatchEvent(new MEvent_BrowerShow(MEvent_BrowerShow.BROWER_CHANGE));
			ModuleEventManager.dispatchEvent(new MEvent_ProjectData(MEvent_ProjectData.PROJECT_INIT_COMPLETE));
		}
		
		public function writeProjectConfig():void{
			var file:File = new File(File.documentsDirectory.url + "/worldeditor.config");
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.WRITE);
			
			var obj:Object = new Object;
			obj.mapUrl = AppData.mapUrl;
			obj.workSpaceUrl = AppData.workSpaceUrl;
			obj.expSpaceUrl = AppData.expSpaceUrl;
			obj.RenderSocketUrl = AppData.RenderSocketUrl;
			fs.writeObject(obj);
			fs.close();
		}
		
		private function creatDefultMap():void{
			AppData.mapUrl = "default.lmap"
			save();
		}

		public function readWorkSpaceFile():void{

			MoveAssetFileModel.getInstance().moveAsSetFile();
			
	
		}
		
	
		
		public function creatFile($url:String):File{
			var file:File = new File($url);
			if(!file.exists){
				file.createDirectory();
			}
			return file;
		}
		
		
		
		
	}
}