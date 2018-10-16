package modules.brower
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.SharedObject;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.collections.ArrayCollection;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.MEvent_baseShowHidePanel;
	import common.msg.event.brower.MEvent_BrowerShow;
	import common.msg.event.brower.MEvent_BrowerShowFile;
	import common.msg.event.brower.MEvent_Brower_Input_Obj;
	import common.msg.event.brower.MEvent_Brower_Refresh;
	import common.msg.event.engineConfig.MEventStageResize;
	
	import interfaces.ITile;
	
	import manager.LayerManager;
	
	import materials.Material;
	import materials.MaterialCubeMap;
	import materials.MaterialReflect;
	import materials.MaterialShadow;
	import materials.MaterialTree;
	
	import mode3d.Model3DStaticMesh;
	import mode3d.XFileBoneStaticMesh;
	import mode3d.XFileMode3DStaticMesh;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	
	import pack.BuildMesh;
	import pack.ModePropertyMesh;
	import pack.PrefabStaticMesh;
	
	import proxy.top.render.Render;
	
	public class BrowerProcessor extends Processor
	{
		private var _browerView:BrowerPanel;
		public function BrowerProcessor($module:Module)
		{
			super($module);
		}
		
		override protected function listenModuleEvents():Array 
		{
			return [
				MEventStageResize,
				MEvent_Brower_Refresh,
				MEvent_BrowerShowFile,
				MEvent_Brower_Input_Obj,
				MEvent_BrowerShow
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case MEvent_BrowerShow:
					
					if($me.action == MEvent_baseShowHidePanel.SHOW){
						showHide($me as MEvent_BrowerShow);
					}else if($me.action == MEvent_BrowerShow.BROWER_CHANGE){
						showRoot();
					}
					addEvents()
					break;
				case MEvent_BrowerShowFile:
					var $MEvent_BrowerShowFile:MEvent_BrowerShowFile=$me as MEvent_BrowerShowFile
					if($MEvent_BrowerShowFile.action==MEvent_BrowerShowFile.BROWER_SHOW_SAMPE_FILE){
						showSampleFile($MEvent_BrowerShowFile)
					}
					break;
				case MEvent_Brower_Refresh:
					_browerView.refresh()
					break;
				case MEvent_Brower_Input_Obj:
					var $MEvent_Brower_Input_Obj:MEvent_Brower_Input_Obj= $me as MEvent_Brower_Input_Obj
					if($me.action == MEvent_Brower_Input_Obj.INPUT_MODEL_OBJ){
						inputObjFun($MEvent_Brower_Input_Obj.prentFile)
					}
					break;
				case MEventStageResize:
					resize($me as MEventStageResize)
					break;
			}
		}
		
		private function InputDaeToObjsBackFun($arr:Array):void
		{
			var fs:FileStream = new FileStream;
			var $arrayCollection:ArrayCollection=new ArrayCollection
			var $baseFileNode:HierarchyFileNode=new HierarchyFileNode
			$baseFileNode.name=_baseName
			$baseFileNode.type=HierarchyNodeType.Folder
			$baseFileNode.children=new ArrayCollection
			$baseFileNode.treeSelect=false
			
			var $folderUrl:String=_prentFile.url
			$folderUrl=$folderUrl.replace(AppData.workSpaceUrl,"")
			$folderUrl=$folderUrl+"/"
			
			var $selectPreFabFile:File;
			for(var i:uint=0;i<$arr.length;i++){

				var $fileName:String=($arr[i])
				$fileName=$fileName.substr(0,$fileName.length-5)
				var _editPreFab:PrefabStaticMesh=new PrefabStaticMesh;
				
				_editPreFab.axoFileName=$folderUrl+$fileName+".objs"
				_editPreFab.materialUrl=AppData.defaultMaterialUrl
				_editPreFab.url=$folderUrl+$fileName+".prefab";
				var _prbUrl:String=AppData.workSpaceUrl+_editPreFab.url
				
				
				fs.open(new File(_prbUrl),FileMode.WRITE);
				fs.writeObject(_editPreFab.readObject());
				fs.close();
				
				var $hierarchyFileNode:HierarchyFileNode=new HierarchyFileNode
				$hierarchyFileNode.data=_editPreFab
				$hierarchyFileNode.name=$fileName
				$hierarchyFileNode.parentNode=$baseFileNode
				$hierarchyFileNode.treeSelect=true
		
				$hierarchyFileNode.type=HierarchyNodeType.Prefab
				$baseFileNode.children.addItem($hierarchyFileNode)
				
				$selectPreFabFile=new File(_prbUrl)
			}
			$arrayCollection.addItem($baseFileNode)
			if($baseFileNode.children.length>1){
				var $groupArr:Array=wirteItem($arrayCollection)
				var $groupFile:File = new File(AppData.workSpaceUrl+$folderUrl+_baseName+".group");
				fs.open($groupFile,FileMode.WRITE);
				fs.writeObject({item:$groupArr});
				fs.close();
				_browerView.refresh();
				_browerView.slectFolderByFile($groupFile);
			}else{
				_browerView.refresh();
				_browerView.slectFolderByFile($selectPreFabFile);  //只有一个文件里就不再创建group
			}
		
			
			
		}
		private function inputObjFun($tempFile:File):void
		{
			_prentFile=$tempFile
			var $file:File=new File;
			var txtFilter:FileFilter = new FileFilter("Text", ".DAE;*.dae;");
			$file.browseForOpen("打开导入的文件 ",[txtFilter]);
			$file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				_baseName=$file.name
				_baseName=_baseName.replace("."+$file.extension,"")
				BrowerInputDaeFile.getInstance().inputFileUrl($file.url,_prentFile.url,_baseName,InputDaeToObjsBackFun)
				//BrowerInputObjFile.getInstance().inputFileUrl($file.url,$prentFile.url,$baseName,InputBackFun)
			}
			
			
		}
		private var _prentFile:File
		private var _baseName:String
	
		private function wirteItem(childItem:ArrayCollection):Array
		{
		
			var $item:Array=new Array
			for(var i:uint=0;childItem&&i<childItem.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=childItem[i] as HierarchyFileNode
				var $obj:Object=new Object;
				$obj.name=$hierarchyFileNode.name
				$obj.treeSelect=$hierarchyFileNode.treeSelect
				$obj.children=wirteItem($hierarchyFileNode.children)
		
				if($hierarchyFileNode.data is PrefabStaticMesh){
					var $preObj:PrefabStaticMesh=$hierarchyFileNode.data as PrefabStaticMesh
					$obj.data=$preObj.readObject();
					$obj.type=HierarchyNodeType.Prefab
				}else{
					$obj.type=HierarchyNodeType.Folder
				}
				$obj.x=0
				$obj.y=0
				$obj.z=0
				$obj.scaleX=1
				$obj.scaleY=1
				$obj.scaleZ=1
				$obj.rotationX=0
				$obj.rotationY=0
				$obj.rotationZ=0
					
				$item.push($obj)
			}
			if($item.length){
				return $item
			}
			return null
		}
	
		
		private function showSampleFile(evt:MEvent_BrowerShowFile):void
		{

			if(evt.data){
				var str:String
				var $iTile:ITile
				
			
				if(evt.data as MaterialTree ){
					var _materialTree:MaterialTree=evt.data as MaterialTree;
					
					var $urlName:String=_materialTree.url
					$urlName=$urlName.replace(AppData.workSpaceUrl,"")
					evt.data=$urlName
				}
				if(evt.data  as BuildMesh){
					if(BuildMesh(evt.data ).url){
						evt.data=BuildMesh(evt.data ).url
					}
				}
				if(evt.data  as MaterialCubeMap){
					if(MaterialCubeMap(evt.data ).url){
						evt.data=MaterialCubeMap(evt.data ).url
					}
				}
				if(evt.data as ModePropertyMesh )
				{
					var _modePropertyMesh:ModePropertyMesh=evt.data as ModePropertyMesh;
			
					if(_modePropertyMesh.taget as PrefabStaticMesh){
						if(PrefabStaticMesh(_modePropertyMesh.taget).url){
							evt.data=PrefabStaticMesh(_modePropertyMesh.taget).url
						}else{
							evt.data=_modePropertyMesh.taget
						}
					}
				
				}else if(evt.data is MaterialCubeMap)
				{
					 $iTile=evt.data as ITile
					 str=AppData.workSpaceUrl+"CSV/texture/TextureCubeMap/"+$iTile.getName()
					_browerView.showSampleFile(str,evt.listOnly,evt.data)
	
				}else if(evt.data is  Material)
				{
					 $iTile=evt.data as ITile
				   	 str=AppData.workSpaceUrl+"CSV/texture/Texture3D/"+$iTile.getName()
					 _browerView.showSampleFile(str,evt.listOnly,evt.data)
				}else	if(evt.data is  MaterialReflect)
				{
					 $iTile=evt.data as ITile
					 str=AppData.workSpaceUrl+"CSV/texture/TextureSpecial/"+$iTile.getName()
					_browerView.showSampleFile(str,evt.listOnly,evt.data)
	
				}else	if(evt.data is  MaterialShadow)
				{
					 $iTile=evt.data as ITile
					 str=AppData.workSpaceUrl+"CSV/texture/MaterialShadow/"+$iTile.getName()
					_browerView.showSampleFile(str,evt.listOnly,evt.data)
	
				}else	if(evt.data is  PrefabStaticMesh)
				{
					 $iTile=evt.data as ITile
					if(AppData.type==0){
						str=AppData.workSpaceUrl+"CSV/object/Object3D/"+$iTile.getName()
					}else
					if(AppData.type==1){
						str=AppData.workSpaceUrl+PrefabStaticMesh(evt.data).url
						evt.data=str
					}
					_browerView.showSampleFile(str,evt.listOnly,evt.data)
	
				}
				else if(evt.data as XFileMode3DStaticMesh){
				
					$iTile=evt.data as ITile
					str=AppData.workSpaceUrl+"CSV/object/Model3DXFile/"+$iTile.getName()
					_browerView.showSampleFile(str,evt.listOnly,evt.data)
						
				}
				else if(evt.data as XFileBoneStaticMesh){
				
					$iTile=evt.data as ITile
					str=AppData.workSpaceUrl+"CSV/object/Bone/"+$iTile.getName()
					_browerView.showSampleFile(str,evt.listOnly,evt.data)
						
				}
				else if(evt.data as Model3DStaticMesh){
				
					$iTile=evt.data as ITile
					str=AppData.workSpaceUrl+"CSV/object/Model3D/"+$iTile.getName()
					_browerView.showSampleFile(str,evt.listOnly,evt.data)
						
				}
				else	if(evt.data is String)
				{
					str=AppData.workSpaceUrl+String(evt.data)
					_browerView.showSampleFile(str,evt.listOnly,evt.data)
				}

			}
		
		}
		
		private function addEvents():void
		{
			_browerView.cutLineBack.addEventListener(MouseEvent.MOUSE_DOWN,cutLineBackDown)
			_browerView.cutLineBack.addEventListener(MouseEvent.MOUSE_OVER,onLineMouseOver)
			_browerView.cutLineBack.addEventListener(MouseEvent.MOUSE_OUT,onLineMouseOut)
			
			
		}
		
		protected function onLineMouseOut(event:MouseEvent):void
		{
			if(!lineButDown){
				Mouse.cursor = MouseCursor.AUTO;
			}
		}
		
		protected function onLineMouseOver(event:MouseEvent):void
		{
			Mouse.cursor = "doubelArrow";
			
		}
		
		protected function onStageMouseMove(event:MouseEvent):void
		{

			_browerView.postionNum=Math.min(0.8,Math.max(_browerView.mouseX/_browerView.width,0.10))
			_browerView.onSize()

		}
		private var lineButDown:Boolean=false
		protected function cutLineBackDown(event:MouseEvent):void
		{
			lineButDown=true
			Mouse.cursor = "doubelArrow";
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove)
			
			
		}
		protected function onStageMouseUp(event:MouseEvent):void
		{

			
			Scene_data.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp)
			Scene_data.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove)
			Mouse.cursor = MouseCursor.AUTO;
			lineButDown=false
		}

	
		
		private function resize(evt:MEventStageResize):void
		{
			if(_browerView){
				_browerView.onSize()
			}
		}
		
		public function showRoot():void{
			var _soUrl:SharedObject = SharedObject.getLocal("rootFile", "/");
		
			if(String(_soUrl.data.url).search(AppData.workSpaceUrl)!=-1){
				_browerView.rootUrl=_soUrl.data.url
			}else{
				_browerView.rootUrl = AppData.workSpaceUrl+"img/";
			}
		

			Render.workSpaceUrl=AppData.workSpaceUrl

		}
		
		public function showHide($me:MEvent_baseShowHidePanel):void
		{
			if($me.action == MEvent_baseShowHidePanel.SHOW){
				if(!_browerView){
					_browerView = new BrowerPanel;
				}

				_browerView.init(this,"文件",0);
				LayerManager.getInstance().addPanel(_browerView);
			}
		}
		
		
		
	}
}