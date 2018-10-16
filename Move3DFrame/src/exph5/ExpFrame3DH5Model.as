package exph5
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import _Pan3D.utils.Cn2en;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	
	import materials.MaterialTree;
	
	import modules.hierarchy.FileSaveModel;
	import modules.hierarchy.h5.ExpH5ByteModel;
	import modules.hierarchy.h5.ExpResourcesModel;
	import modules.hierarchy.h5.MakeResFileList;
	import modules.prefabs.PrefabManager;
	
	import mvc.frame.FrameModel;
	import mvc.frame.lightbmp.LightBmpModel;
	import mvc.frame.view.FrameFileNode;
	
	import pack.PrefabStaticMesh;
	
	import proxy.top.render.Render;
	

	public class ExpFrame3DH5Model
	{
		private static var instance:ExpFrame3DH5Model;
		public function ExpFrame3DH5Model()
		{
		}
		public static function getInstance():ExpFrame3DH5Model{
			if(!instance){
				instance = new ExpFrame3DH5Model();
			}
			return instance;
		}

		public  function exp():void
		{
		//	FileSaveModel.getInstance().initJpgQuality(75);
			FileSaveModel.expPicQualityType=100;
			ExpFrameRoleH5Model.getInstance().expAllRoleNode(this.expRoleFinish)
		}
		private function expRoleFinish($arr:Array):void
		{
			MakeResFileList.getInstance().clear();
			ExpH5ByteModel.getInstance().clear();
			ExpResourcesModel.getInstance().initData(_rootUrl,returnFun)
			this.expScene();
		}
		private function expScene():void
		{
			var $nodeItem:Vector.<FrameFileNode>=new Vector.<FrameFileNode>
			for(var i:uint=0;i<FrameModel.getInstance().ary.length;i++){
				var $FrameFileNode:FrameFileNode=FrameModel.getInstance().ary[i] as FrameFileNode
				var $arr:Vector.<FileNode>=FileNodeManage.getChildeFileNode($FrameFileNode)
				for(var j:Number=0;$arr&&j<$arr.length;j++){
					var $node:FrameFileNode=$arr[j] as FrameFileNode
					if($node&&$node.type==FrameFileNode.build1){
						$nodeItem.push($node);
					}
				}	
			}
			this.expBuild($nodeItem)
			ExpResourcesModel.getInstance().run()
		}
		private function returnFun():void{
			
	
			var $sceneFile:File=new File(AppData.workSpaceUrl+ AppDataFrame.fileUrl);
			var $saveUrl:String=$sceneFile.name.replace(".3dmove","_frame.txt");
			$saveUrl=Cn2en.toPinyin(decodeURI($saveUrl))
			
			var $sceneFileByte:ByteArray=new ByteArray;
		
			$sceneFileByte.writeInt(Scene_data.version);
			$sceneFileByte.writeUTF(Cn2en.toPinyin(AppDataFrame.fileUrl))
				
			$sceneFileByte.writeInt(AppDataFrame.frameSpeed);
			
			
			
			
			this.writeSceneInfo($sceneFileByte);
			var $byte:ByteArray=new ByteArray;
			ExpH5ByteModel.getInstance().WriteByte($byte,true,[1,3,4,6]);
			$sceneFileByte.writeBytes($byte,0,$byte.length);	

			var strObj:String=JSON.stringify(this.frame3dItem);
			var $frameNodeByte:ByteArray=new ByteArray;
			$frameNodeByte.writeMultiByte(strObj,"utf-8")
			$sceneFileByte.writeInt($frameNodeByte.length)
			$sceneFileByte.writeBytes($frameNodeByte,0,$frameNodeByte.length);
			var fs:FileStream = new FileStream;
			fs.open(new File(_rootUrl+""+$saveUrl),FileMode.WRITE);
			fs.writeBytes($sceneFileByte,0,$sceneFileByte.length);		
			fs.close();
			
			this.writeBasefile()

		}
		private function writeBasefile():void //和上面一样，只是改了是否写图片手参数
		{
			var $sceneFile:File=new File(AppData.workSpaceUrl+ AppDataFrame.fileUrl);
			var $saveUrl:String=$sceneFile.name.replace(".3dmove","_frame_base.txt");
			$saveUrl=Cn2en.toPinyin(decodeURI($saveUrl))
			
			var $sceneFileByte:ByteArray=new ByteArray;
			$sceneFileByte.writeInt(Scene_data.version);
			$sceneFileByte.writeUTF(Cn2en.toPinyin(AppDataFrame.fileUrl))
			$sceneFileByte.writeInt(AppDataFrame.frameSpeed);
			
			this.writeSceneInfo($sceneFileByte);
			var $byte:ByteArray=new ByteArray;
			ExpH5ByteModel.getInstance().WriteByte($byte,false,[1,3,4,6]);
			$sceneFileByte.writeBytes($byte,0,$byte.length);	
			
			var strObj:String=JSON.stringify(this.frame3dItem);
			var $frameNodeByte:ByteArray=new ByteArray;
			$frameNodeByte.writeMultiByte(strObj,"utf-8")
			$sceneFileByte.writeInt($frameNodeByte.length)
			$sceneFileByte.writeBytes($frameNodeByte,0,$frameNodeByte.length);
			var fs:FileStream = new FileStream;
			fs.open(new File(_rootUrl+""+$saveUrl),FileMode.WRITE);
			fs.writeBytes($sceneFileByte,0,$sceneFileByte.length);		
			fs.close();
		}
		
		private function writeSceneInfo($byte:ByteArray):void
		{
			var $jasobj:Object=new Object
			var AmbientLight:Vector3D=new Vector3D;
			AmbientLight.x=Scene_data.light.AmbientLight.color.x*Scene_data.light.AmbientLight.intensity
			AmbientLight.y=Scene_data.light.AmbientLight.color.y*Scene_data.light.AmbientLight.intensity
			AmbientLight.z=Scene_data.light.AmbientLight.color.z*Scene_data.light.AmbientLight.intensity
			AmbientLight.scaleBy(1/255)
			
			
			var SunLigth:Vector3D=new Vector3D();
			SunLigth.x=Scene_data.light.SunLigth.color.x*Scene_data.light.SunLigth.intensity
			SunLigth.y=Scene_data.light.SunLigth.color.y*Scene_data.light.SunLigth.intensity
			SunLigth.z=Scene_data.light.SunLigth.color.z*Scene_data.light.SunLigth.intensity
			SunLigth.scaleBy(1/255)
			
			
			var SunNrm:Vector3D=new Vector3D()
			SunNrm.x=Scene_data.light.SunLigth.dircet.x
			SunNrm.y=Scene_data.light.SunLigth.dircet.y
			SunNrm.z=Scene_data.light.SunLigth.dircet.z
			SunNrm.normalize()
			
			
			$jasobj.AmbientLight=AmbientLight
			$jasobj.SunLigth=SunLigth
			$jasobj.SunNrm=SunNrm
			$jasobj.videoLightUvData=MergeVideoModel.getInstance().videoLightUvData;
		
			$jasobj.haveVideo=false;
				
			var strObj:String=JSON.stringify($jasobj);
			
			var $sceneInfo:ByteArray=new ByteArray;
			$sceneInfo.writeMultiByte(strObj,"utf-8");
			$byte.writeInt($sceneInfo.length)
			$byte.writeBytes($sceneInfo,0,$sceneInfo.length);
		}
		
		//private var _rootUrl:String="file:///G:/frame3d/"
		private var _rootUrl:String="file:///C:/wamp/www/work/cannondemo/cannondemo/res/frame3d/"
		public function expBuild(_fileNodeItem:Vector.<FrameFileNode>):void
		{
			
		
			LightBmpModel.getInstance().makeLightBmpToResModel(_rootUrl)
			this.frame3dItem=new Array
			for(var i:uint=0;i<_fileNodeItem.length;i++){
				var $frameFileNode:FrameFileNode=_fileNodeItem[i] ;

				if($frameFileNode.type==FrameFileNode.build1){
					var $tempObj:Object=new Object;
					$tempObj.type=$frameFileNode.type;
					$tempObj.url=$frameFileNode.url;
					$tempObj.id=$frameFileNode.id;
					$tempObj.name=$frameFileNode.name;
					$tempObj.pointitem=$frameFileNode.getPointItemObject();

					if(	$frameFileNode.url.search(".prefab")!=-1){
						var $prefabMesh:PrefabStaticMesh=PrefabManager.getInstance().getPrefabByUrl(AppData.workSpaceUrl+ $frameFileNode.url);
						ExpH5ByteModel.getInstance().saveMaterialTreeHasNrmOrPbnByUrl($prefabMesh.materialUrl,$prefabMesh.axoFileName);			
						ExpResourcesModel.getInstance().expMaterialInfoArr($prefabMesh.materialInfoArr,_rootUrl);
						if(MaterialTree($prefabMesh.material).isHaveMaterialInfoArr()){
							$tempObj.materialInfoArr=ExpResourcesModel.getInstance().changeUrlByMaterialInfoArr($prefabMesh.materialInfoArr)
						}
						$tempObj.resurl=ExpResourcesModel.getInstance().expObjsByUrl($prefabMesh.axoFileName,_rootUrl)
						$tempObj.materialurl=ExpResourcesModel.getInstance().expMaterialTreeToH5(MaterialTree($prefabMesh.material),_rootUrl)
							
						$tempObj.directLight=MaterialTree($prefabMesh.material).directLight  ;
						$tempObj.noLight=MaterialTree($prefabMesh.material).noLight ;
						$tempObj.receiveShadow=$frameFileNode.receiveShadow;
			
						if($tempObj.noLight==false){ //no为否，就是有烘培贴图
							$tempObj.lighturl=ExpResourcesModel.getInstance().expPicByUrl(Render.lightUvRoot+$frameFileNode.id+".jpg",_rootUrl)
						}
			

						
						
					}
					if(	$frameFileNode.url.search(".lyf")!=-1){
						$tempObj.resurl=ExpResourcesModel.getInstance().expParticleByUrl($frameFileNode.url,_rootUrl);
					}
					if(	$frameFileNode.url.search(".zzw")!=-1){
						var roleurl:String=Cn2en.toPinyin(new File(AppData.workSpaceUrl+$frameFileNode.url).name); //注意这里的名字是一样的
						roleurl="role/"+roleurl.replace(".zzw",".txt");
						$tempObj.resurl=roleurl
					}
					this.frame3dItem.push($tempObj);
				}
			}
		}
		public var frame3dItem:Array;

		
	}
}