package mvc.libray
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	
	import _Pan3D.light.LightVo;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.engineConfig.MEventStageResize;
	import common.utils.ui.file.FileNode;
	
	import exph5.MergeVideoModel;
	
	import manager.LayerManager;
	
	import modules.scene.EnvironmentVo;
	
	import mvc.centen.DisCentenEvent;
	import mvc.frame.FrameEvent;
	import mvc.project.ProjectEvent;
	import mvc.scene.UiSceneEvent;
	
	import proxy.top.render.Render;
	
	public class LibraryProcessor extends Processor
	{
		private var _libraryPanel:LibraryPanel;
		public function LibraryProcessor($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				LibraryEvent,
				UiSceneEvent,
				DisCentenEvent,
				MEventStageResize,
				ProjectEvent,
				
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case LibraryEvent:
					if($me.action==LibraryEvent.SHOW_RIGHT){
						showHide()
					}
					if($me.action==LibraryEvent.MEVENT_LIBRAY_MOVENODE){
						
						this.MoveLibrayEvt($me as LibraryEvent)
					}
					if($me.action==LibraryEvent.MEVENT_LIBRAY_REFRISHNAME){
						var $resteNode:LibrayFildNode=LibrayFildNode( LibraryEvent($me).fileNode)
						LibrayModel.getInstance().librayTree.selectedItems=[$resteNode];

					}
	
					if($me.action==LibraryEvent.MEVENT_LIBRAY_DELENODE){
						
						var $dele:LibrayFildNode=LibrayFildNode( LibraryEvent($me).fileNode)
						if($dele.parentNode){
							$dele.parentNode.children.removeItem($dele)
						}else{
							LibrayModel.getInstance().librayArr.removeItem(LibraryEvent($me).fileNode)
						}

					}
					
					break;
				case ProjectEvent:
					if($me.action==ProjectEvent.OPEN_PROJECT_FILE){
						AppDataFrame.fileUrl=decodeURI(ProjectEvent($me).url)
						this.readFileData()
					}
				case MEventStageResize:
					resize($me as MEventStageResize)
					break;
			}
		}
		
		private function readFileData():void
		{
			
			
			var file:File = new File(AppData.workSpaceUrl +AppDataFrame.fileUrl);
			
			Render.lightUvRoot=AppData.workSpaceUrl+AppDataFrame.fileUrl.replace("."+file.extension,"_hide/lightuv/");

			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.READ);
			var $obj:Object = fs.readObject();
			fs.close();
			LibrayModel.getInstance().initObj($obj.libarr)
			AppDataFrame.frameSpeed=$obj.frameSpeed;
			AppData.light=$obj.light
			AppData.environment=$obj.environment
			MergeVideoModel.getInstance().data=$obj.videoLightUvData
				
			Scene_data.light = new LightVo();
			Scene_data.light.writeObject(AppData.light);
			EnvironmentVo.getInstance().objToEnvironment(AppData.environment)
			
			ModuleEventManager.dispatchEvent(new FrameEvent(FrameEvent.OPEN_FRAME_FILE));
	
			
		}
		private function MoveLibrayEvt($evt:LibraryEvent):void
		{
		
			//this.fileNodeMoveToFileNode($evt.moveNode,$evt.toNode)
		     var $items:Array=	LibrayModel.getInstance().librayTree.selectedItems;
			 trace($items)
			 var $toNode:LibrayFildNode= $evt.toNode;
			 if($toNode.type==LibrayFildNode.Folder_TYPE0){
				 for(var i:Number=0;i<$items.length;i++){
					 var $temp:LibrayFildNode= $items[i]
					 this.fileNodeMoveToFileNode($temp,$toNode)
				 }
			 
			 }
			 
			
		}
		
		public function fileNodeMoveToFileNode($moveNode:FileNode,toNode:FileNode):void
		{
			
			if($moveNode!=toNode){
				var moveParent:FileNode=$moveNode.parentNode
				if(moveParent){
					moveParent.children.removeItem($moveNode)
					if(moveParent.children.length==0){
						moveParent.children=null
					}
				}else{
					LibrayModel.getInstance().librayArr.removeItem($moveNode)
				}
				
				if(toNode){
					if(!toNode.children){
						toNode.children=new ArrayCollection;
					}
					$moveNode.parentNode=toNode;
					toNode.children.addItemAt($moveNode,0);
				}else{
					$moveNode.parentNode=null
					LibrayModel.getInstance().librayArr.addItemAt($moveNode,0)
				}
				
			}
		}

		
		private function resize($mEventStageResize:MEventStageResize):void
		{
			if(_libraryPanel){
				_libraryPanel.onSize()
			}
		
			
		}

		public function showHide():void
		{
			if(!_libraryPanel){
				_libraryPanel = new LibraryPanel;
			}
			_libraryPanel.init(this,"库",4);
			LayerManager.getInstance().addPanel(_libraryPanel);
			
		}
	}
}


