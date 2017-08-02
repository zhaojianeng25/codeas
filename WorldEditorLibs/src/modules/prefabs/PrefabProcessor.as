package modules.prefabs
{
	import com.zcp.frame.Module;
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	
	import common.AppData;
	import common.msg.event.prefabs.MEvent_Group_Show;
	import common.msg.event.prefabs.MEvent_Objs_Show;
	import common.msg.event.prefabs.MEvent_Prefab;
	import common.msg.event.prefabs.MEvent_XFile_Bone_Show;
	import common.msg.event.prefabs.MEvent_XFile_Model3D_Show;
	import common.msg.event.prefabs.Mevent_Model3D_Show;
	import common.utils.frame.BaseProcessor;
	import common.utils.frame.MetaDataView;
	
	import manager.LayerManager;
	
	import mode3d.Model3DStaticMesh;
	import mode3d.XFileBoneStaticMesh;
	import mode3d.XFileMode3DStaticMesh;
	
	import modules.brower.fileWin.BrowerManage;
	import modules.hierarchy.FileSaveModel;
	import modules.hierarchy.HierarchyNodeType;
	import modules.materials.view.MaterialTreeManager;
	
	import pack.GroupMesh;
	import pack.PrefabStaticMesh;
	
	public class PrefabProcessor extends BaseProcessor
	{
		private var _prefabDic:Object = new Object;
		private var _preFabDataView:MetaDataView;
		public function PrefabProcessor($module:Module)
		{
			super($module);
		}
		
		override protected function listenModuleEvents():Array 
		{
			return [
				MEvent_XFile_Bone_Show,
				MEvent_XFile_Model3D_Show,
				Mevent_Model3D_Show,
				MEvent_Group_Show,
				MEvent_Objs_Show,
				MEvent_Prefab
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case MEvent_Prefab:
					if($me.action == MEvent_Prefab.MEVENT_PREFAB_CREATNEW){
						creatPrefab(MEvent_Prefab($me).url,MEvent_Prefab($me).name);
					}else if($me.action == MEvent_Prefab.MEVENT_PREFAB_SHOW){
						showPrefab(MEvent_Prefab($me));
					}
					break;
				case MEvent_XFile_Model3D_Show:
					var $mEvent_XFile_Model3D_Show:MEvent_XFile_Model3D_Show= $me as MEvent_XFile_Model3D_Show
					if($mEvent_XFile_Model3D_Show.action==MEvent_XFile_Model3D_Show.MEVENT_XFILE_MODEL3D_SHOW){
						showXFileMode3dMesh($mEvent_XFile_Model3D_Show)
					}
					break;
				case MEvent_XFile_Bone_Show:
					var $mEvent_XFile_Bone_Show:MEvent_XFile_Bone_Show= $me as MEvent_XFile_Bone_Show
					if($mEvent_XFile_Bone_Show.action==MEvent_XFile_Bone_Show.MEVENT_XFILE_BONE_SHOW){
						showXFileBoneMesh($mEvent_XFile_Bone_Show)
					}
					break;
				case Mevent_Model3D_Show:
					var $mevent_Model3D_Show:Mevent_Model3D_Show= $me as Mevent_Model3D_Show
					if($mevent_Model3D_Show.action==Mevent_Model3D_Show.MEVENT_MODEL3D_SHOW){
						showMode3dMesh($mevent_Model3D_Show)
					}
					break;
				case MEvent_Group_Show:
					var $mEvent_Group_Show:MEvent_Group_Show= $me as MEvent_Group_Show
					if($mEvent_Group_Show.action==MEvent_Group_Show.MEVENT_GROUP_SHOW){
						showGroupMesh($mEvent_Group_Show)
					}
					break;
		
			}
		}
		
		private var _groupMeshView:MetaDataView;
		private function showGroupMesh($mEvent_Group_Show:MEvent_Group_Show):void
		{
			var $url:String=$mEvent_Group_Show.url
			var $prefabItem:Array=new Array
			if($url){
				if(!_groupMeshView){
					_groupMeshView = new MetaDataView();
					_groupMeshView.init(this,"属性",2);
					_groupMeshView.creatByClass(GroupMesh);
				}
				var $file:File=new File($url)
				var $groupMesh:GroupMesh=new GroupMesh
				$groupMesh.groupName=$file.name
				if($file.exists){
					var $fs:FileStream = new FileStream;
					$fs.open($file,FileMode.READ);
					var obj:Object=$fs.readObject()
					$fs.close()
					readGroupData(obj["item"])
					$groupMesh.prefabItem=$prefabItem;
				}
			    if(AppData.type==1){
					saveGroupIcon($groupMesh,$url)
				}
				
				
				
				LayerManager.getInstance().showPropPanle(_groupMeshView);
				_groupMeshView.setTarget($groupMesh);
			}
			

			
			function readGroupData($arr:Array):void
			{
				
				for(var i:uint=0;$arr&&i<$arr.length;i++){
					var $tempNode:Object = new Object;
					if($arr[i].type==undefined){
						if($arr[i].data){
							$arr[i].type=HierarchyNodeType.Prefab
						}
					}
					if($arr[i].type==HierarchyNodeType.Prefab){
						//var $Pre:PrefabStaticMesh=objToPreFab($arr[i].data)
						var $Pre:PrefabStaticMesh=PrefabManager.getInstance().getPrefabByUrl(AppData.workSpaceUrl+$arr[i].data.url)
				        if($Pre){
							if($Pre.materialUrl){
								$Pre.materialUrl=$Pre.materialUrl.replace("file:///E:/zzw/TE/","")
								$Pre.material = MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$Pre.materialUrl);
							}
							$tempNode.x=$arr[i].x
							$tempNode.y=$arr[i].y
							$tempNode.z=$arr[i].z
							$tempNode.data=$Pre
							$prefabItem.push($tempNode)
						}
						
					}
					if($arr[i].children){
						readGroupData($arr[i].children)
					}
				
					
				}
			}
		}
	    private function saveGroupIcon($groupMesh:GroupMesh,$url:String):void	
		{
			PrefabRenderToBmpModel.getInstance().scanGroupToBmp($groupMesh,function ($bmp:BitmapData):void{
				
				var $bmp128:BitmapData=new BitmapData(128,128);
				var $m:Matrix=new Matrix()
				$m.scale($bmp128.width/$bmp.width,$bmp128.height/$bmp.height)
				$bmp128.draw($bmp,$m)
				
				var $folderUrl:String=$url.replace(AppData.workSpaceUrl,"")
				
				var $bmpFileName:String=$folderUrl.replace(".group","group.jpg")
				var $tourl:String=File.desktopDirectory.url+"/world/"+$bmpFileName
				
				var $iconBmp:BitmapData=BrowerManage.getIcon("prefab")
				var $mIcon:Matrix=new Matrix
				if($iconBmp){
					$mIcon.scale(20/$iconBmp.width,20/$iconBmp.height);
					$mIcon.tx=105
					$mIcon.ty=5
				}
				
				FileSaveModel.getInstance().saveBitmapdataToJpg($bmp128,$tourl)
				
			})
		}
	
		
		
		private var _xFileBoneView:MetaDataView;
		private function showXFileBoneMesh($mEvent_XFile_Bone_Show:MEvent_XFile_Bone_Show):void
		{
			if($mEvent_XFile_Bone_Show.xFileBoneStaticMesh){
				if(!_xFileBoneView){
					_xFileBoneView = new MetaDataView();
					_xFileBoneView.init(this,"属性",2);
					_xFileBoneView.creatByClass(XFileBoneStaticMesh);
				}
				LayerManager.getInstance().showPropPanle(_xFileBoneView);
				_xFileBoneView.setTarget($mEvent_XFile_Bone_Show.xFileBoneStaticMesh);
			}
			
		}
		private var _xFileMode3dView:MetaDataView;
		private function showXFileMode3dMesh($mEvent_XFile_Model3D_Show:MEvent_XFile_Model3D_Show):void
		{
			if($mEvent_XFile_Model3D_Show.xFileMode3DStaticMesh){
				if(!_xFileMode3dView){
					_xFileMode3dView = new MetaDataView();
					_xFileMode3dView.init(this,"属性",2);
					_xFileMode3dView.creatByClass(XFileMode3DStaticMesh);
				}
				LayerManager.getInstance().showPropPanle(_xFileMode3dView);
			
				_xFileMode3dView.setTarget($mEvent_XFile_Model3D_Show.xFileMode3DStaticMesh);
			}
			
		}
		
		private var _mode3dView:MetaDataView;
		public function showMode3dMesh($mevent_Model3D_Show:Mevent_Model3D_Show):void{
			
			if($mevent_Model3D_Show.model3DStaticMesh){
				if(!_mode3dView){
					_mode3dView = new MetaDataView();
					_mode3dView.init(this,"属性",2);
					_mode3dView.creatByClass(Model3DStaticMesh);
				}
				LayerManager.getInstance().showPropPanle(_mode3dView);
				_mode3dView.setTarget($mevent_Model3D_Show.model3DStaticMesh);
			}
			
		}
		public function creatPrefab($url:String,name:String):void{
			var rootFile:File = new File($url);
			var file:File = new File($url + "/" + name + ".prefab");
			if(!file.exists){
				
				var _editPreFab:PrefabStaticMesh=new PrefabStaticMesh;
				_editPreFab.axoFileName="";
				_editPreFab.materialUrl=AppData.defaultMaterialUrl
				_editPreFab.url=file.url.replace(AppData.workSpaceUrl)
				var fs:FileStream = new FileStream;
				fs.open(file,FileMode.WRITE);
				fs.writeObject(_editPreFab.readObject());
				fs.close();
			}
		}
		
		public function showPrefab($mEvent_Prefab:MEvent_Prefab):void{
			
			if($mEvent_Prefab.prefabStaticMesh){
				showMaterialCube($mEvent_Prefab.prefabStaticMesh)
			}else{
			
				if(!_preFabDataView){
					_preFabDataView = new MetaDataView();
					_preFabDataView.init(this,"属性",2);
					_preFabDataView.creatByClass(PrefabStaticMesh);
				}
				LayerManager.getInstance().showPropPanle(_preFabDataView);
				var $editPreFab:PrefabStaticMesh = PrefabManager.getInstance().getPrefabByUrl($mEvent_Prefab.url)
				_preFabDataView.setTarget($editPreFab)
					
			}

		}
		public function showMaterialCube($prefabStaticMesh:PrefabStaticMesh):void{
			if(!_prefabView){
				_prefabView = new MetaDataView();
				_prefabView.init(this,"属性",2);
				_prefabView.creatByClass(PrefabStaticMesh);
			}
			
			LayerManager.getInstance().showPropPanle(_prefabView);
			_prefabView.setTarget($prefabStaticMesh);
		}
	
		private var _prefabView:MetaDataView;
		private function objToPreFab($obj:Object):PrefabStaticMesh
		{
			var prefab:PrefabStaticMesh = new PrefabStaticMesh();
			for(var i:String in $obj) {
				prefab[i]=$obj[i]
			}
			return prefab
		}
	
		
	}
}