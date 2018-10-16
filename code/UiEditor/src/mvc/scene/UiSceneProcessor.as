package mvc.scene
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.Event;
	
	import manager.LayerManager;
	
	import mesh.H5UIFile9Mesh;
	import mesh.H5UIFileMesh;
	import mesh.H5UIFrameMesh;
	import mesh.H5UIGroupMesh;
	import mesh.H5UIMetaDataView;
	import mesh.PicInfoMesh;
	
	import mvc.centen.discenten.DisCentenEvent;
	import mvc.centen.piccenten.PicCentenEvent;
	
	import vo.FileInfoType;
	import vo.H5UIFileNode;
	
	public class UiSceneProcessor extends Processor
	{
		private var _uiScenePanel:UiScenePanel;
		private var _picInfoMeshView:H5UIMetaDataView;
		private var _h5UI9FileMesh:H5UIMetaDataView;
		private var _h5UIFrameMesh:H5UIMetaDataView;
		private var _h5UIFileMesh:H5UIMetaDataView;
		private var _h5UIGroupMesh:H5UIMetaDataView;

		public function UiSceneProcessor($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				DisCentenEvent,
				PicCentenEvent,
				UiSceneEvent,
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case UiSceneEvent:
					if($me.action==UiSceneEvent.SHOW_UI_SCENE){
		
						showHide()
				
					}
			
					if($me.action==UiSceneEvent.SELECT_INFO_NODE){
						selectInfoNode(UiSceneEvent($me) )
					}
					if($me.action==UiSceneEvent.REFRESH_SCENE_DATA){
						refreshSceneData()
					}
					
					if($me.action==UiSceneEvent.SHOW_PIC_UI_SCENE){
						showPicUiCenten()
					}
					
					
					break;
				case DisCentenEvent:
					if($me.action==DisCentenEvent.REFRESH_SELECT_FILENODE){
						refreshSelectFileNode()
					}
					
				case PicCentenEvent:
					if($me.action==PicCentenEvent.SHOW_PIC_MESH){
						showPicUiCenten()
					}
					
					break;
				
			}
		}
		
		private function showPicUiCenten():void
		{
			if(!_picInfoMeshView){
				_picInfoMeshView = new H5UIMetaDataView();
				_picInfoMeshView.init(this,"属性",2);
				_picInfoMeshView.creatByClass(PicInfoMesh);
				
			}
			var $PicInfoMesh:PicInfoMesh=new PicInfoMesh
			_picInfoMeshView.setTarget($PicInfoMesh);
			LayerManager.getInstance().addPanel(_picInfoMeshView);
		
		
		}
		
		private function refreshSelectFileNode():void
		{
			if(_h5UI9FileMesh){
				_h5UI9FileMesh.refreshView()
			}
			
			if(_h5UIFileMesh){
				_h5UIFileMesh.refreshView()
			}
			
			if(_h5UIFrameMesh){
				_h5UIFrameMesh.refreshView()
			}
			
			if(_picInfoMeshView){
				_picInfoMeshView.refreshView()
			}
			
			
			
		}
		
		private function refreshSceneData():void
		{
			_uiScenePanel.refreshSceneData()
				
		
			
		}
		public function showHide():void
		{
			if(!_uiScenePanel){
				_uiScenePanel = new UiScenePanel;
			}
			_uiScenePanel.init(this,"属性",2);
			LayerManager.getInstance().addPanel(_uiScenePanel);
			
		}
		
		private function selectInfoNode($centenEvent:UiSceneEvent):void
		{
			if(!UiData.selectArr){
				UiData.selectArr=new Vector.<H5UIFileNode>;
			}
			if($centenEvent.h5UIFileNode){
				if($centenEvent.ctrlKey){
					UiData.selectArr=new Vector.<H5UIFileNode>;
					UiData.selectArr.push($centenEvent.h5UIFileNode)
					
				}else if($centenEvent.shiftKey){
					clearSelectNode($centenEvent.h5UIFileNode)
					if(!$centenEvent.h5UIFileNode.select){
						UiData.selectArr.push($centenEvent.h5UIFileNode)
					}
					
				}else{
					UiData.selectArr=new Vector.<H5UIFileNode>;
					UiData.selectArr.push($centenEvent.h5UIFileNode)
				}
			}
			
	
			
			
			
			for(var i:uint=0;i<UiData.nodeItem.length;i++){
				var has:Boolean=false;
				for(var j:uint=0;j<UiData.selectArr.length;j++){
					if(H5UIFileNode(UiData.nodeItem[i])==UiData.selectArr[j]){
						has=true;
					}
				}
				H5UIFileNode(UiData.nodeItem[i]).select=has;
				H5UIFileNode(UiData.nodeItem[i]).sprite.updata();
			}
			
			ModuleEventManager.dispatchEvent(new DisCentenEvent(DisCentenEvent.REFRESH_SELECT_FILENODE));
			
	
			if(UiData.selectArr&&UiData.selectArr.length==1){
				if(UiData.selectArr[0].type==FileInfoType.baseUi){
					showH5UIFile(UiData.selectArr[0])
				}
				if(UiData.selectArr[0].type==FileInfoType.ui9){
					showH5UI9File(UiData.selectArr[0])
				}
				if(UiData.selectArr[0].type==FileInfoType.frame){
					showH5UIFrame(UiData.selectArr[0])
				}
			}
			if(UiData.selectArr&&UiData.selectArr.length>1){
				showH5UIGroup()
			}
			
			
		}
	
		
		private function showH5UIFrame($h5UIFileNode:H5UIFileNode):void
		{
			if(!_h5UIFrameMesh){
				_h5UIFrameMesh = new H5UIMetaDataView();
				_h5UIFrameMesh.init(this,"属性",2);
				_h5UIFrameMesh.creatByClass(H5UIFrameMesh);
				
			}
			var $H5UIFile9Mesh:H5UIFrameMesh=new H5UIFrameMesh
			$H5UIFile9Mesh.h5UIFileNode=$h5UIFileNode
			_h5UIFrameMesh.setTarget($H5UIFile9Mesh);
			LayerManager.getInstance().addPanel(_h5UIFrameMesh);
			$H5UIFile9Mesh.addEventListener(Event.CHANGE,h5UIFileMeshChange);
			
		}
		private function showH5UIGroup():void
		{
			if(!_h5UIGroupMesh){
				_h5UIGroupMesh = new H5UIMetaDataView();
				_h5UIGroupMesh.init(this,"属性",2);
				_h5UIGroupMesh.creatByClass(H5UIGroupMesh);
				
			}
			var $H5UIGroupMesh:H5UIGroupMesh=new H5UIGroupMesh
			$H5UIGroupMesh.selectItem=UiData.selectArr
			_h5UIGroupMesh.setTarget($H5UIGroupMesh);
			
		
			LayerManager.getInstance().addPanel(_h5UIGroupMesh);

			
		}
		private function showH5UI9File($h5UIFileNode:H5UIFileNode):void
		{
			if(!_h5UI9FileMesh){
				_h5UI9FileMesh = new H5UIMetaDataView();
				_h5UI9FileMesh.init(this,"属性",2);
				_h5UI9FileMesh.creatByClass(H5UIFile9Mesh);
				
			}
			var $H5UIFile9Mesh:H5UIFile9Mesh=new H5UIFile9Mesh
			$H5UIFile9Mesh.h5UIFileNode=$h5UIFileNode
			_h5UI9FileMesh.setTarget($H5UIFile9Mesh);
			LayerManager.getInstance().addPanel(_h5UI9FileMesh);
			$H5UIFile9Mesh.addEventListener(Event.CHANGE,h5UIFileMeshChange);
			
		}
		private function showH5UIFile($h5UIFileNode:H5UIFileNode):void
		{
			if(!_h5UIFileMesh){
				_h5UIFileMesh = new H5UIMetaDataView();
				_h5UIFileMesh.init(this,"属性",2);
				_h5UIFileMesh.creatByClass(H5UIFileMesh);
				
			}
			var $H5UIFileMesh:H5UIFileMesh=new H5UIFileMesh
			$H5UIFileMesh.h5UIFileNode=$h5UIFileNode
			_h5UIFileMesh.setTarget($H5UIFileMesh);
			LayerManager.getInstance().addPanel(_h5UIFileMesh);
			$H5UIFileMesh.addEventListener(Event.CHANGE,h5UIFileMeshChange)
			
		}
		
		protected function h5UIFileMeshChange(event:Event):void
		{
			var $H5UIFileMesh:H5UIFileMesh=H5UIFileMesh(event.target);
			$H5UIFileMesh.h5UIFileNode.sprite.updata();
			
		}
		private function clearSelectNode($node:H5UIFileNode):void
		{ 
			for(var i:uint=0;i<UiData.selectArr.length;i++){
			
				if($node==UiData.selectArr[i]){
					UiData.selectArr.splice(i,1)
					break;
				}
			}
		}
			
		
		
		
	}
}