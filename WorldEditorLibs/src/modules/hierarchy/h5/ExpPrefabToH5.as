package modules.hierarchy.h5
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import _Pan3D.utils.Cn2en;
	
	import _me.Scene_data;
	
	import materials.MaterialTree;
	
	import modules.hierarchy.HierarchyFileNode;
	
	import pack.BuildMesh;
	
	import render.ground.TerrainEditorData;

	public class ExpPrefabToH5
	{
		private static var instance:ExpPrefabToH5;
		public function ExpPrefabToH5()
		{
		}
		public static function getInstance():ExpPrefabToH5{
			if(!instance){
				instance = new ExpPrefabToH5();
			}
			return instance;
		}
		public function expToH5($hierarchyFileNode:HierarchyFileNode):void
		{
			this.hierarchyFileNode=$hierarchyFileNode
			trace(hierarchyFileNode.name)
			
			var file:File = new File;
			file.addEventListener(Event.SELECT,onFileWorkChg);
			file.browseForDirectory("选择文件夹");
		}
		private var _rootUrl:String;
		private var hierarchyFileNode:HierarchyFileNode
		protected function onFileWorkChg(event:Event):void
		{
			var file:File = event.target as File;
			_rootUrl=decodeURI(file.url+"/")
				

			var objsurl:String
			var materialurl:String
			var directLight:Boolean
			
			if(hierarchyFileNode.data as BuildMesh)	{
				var $BuildMesh:BuildMesh=hierarchyFileNode.data as BuildMesh;
				
				ExpH5ByteModel.getInstance().clear();
				ExpResourcesModel.getInstance().initData(_rootUrl,returnFun)
		
					
				ExpH5ByteModel.getInstance().saveMaterialTreeHasNrmOrPbnByUrl($BuildMesh.prefabStaticMesh.materialUrl,$BuildMesh.prefabStaticMesh.axoFileName);			
				
			
				objsurl=ExpResourcesModel.getInstance().expObjsByUrl($BuildMesh.prefabStaticMesh.axoFileName,_rootUrl)
				directLight=MaterialTree($BuildMesh.prefabStaticMesh.material).directLight
				materialurl=ExpResourcesModel.getInstance().expMaterialTreeToH5(MaterialTree($BuildMesh.prefabStaticMesh.material),_rootUrl)
				

			
				ExpResourcesModel.getInstance().run()
				
			}
	
			
			function returnFun():void
			{
				

				
				//_byte


				var fs:FileStream
				var $byte:ByteArray
				
				var $oneUrl:String = _rootUrl +"model/" + Cn2enFun(hierarchyFileNode.name)+".txt"
				MakeResFileList.getInstance().pushUrl($oneUrl)
				fs = new FileStream;
				fs.open(new File($oneUrl),FileMode.WRITE);
				 $byte=new ByteArray;
				
			
				ExpH5ByteModel.getInstance().WriteByte($byte,true,[1,2,3]);
				$byte.writeUTF(objsurl)
				$byte.writeUTF(materialurl)
				$byte.writeBoolean(directLight)
				if(directLight){
					writeScene($byte)
					
				}
				fs.writeBytes($byte,0,$byte.length);
				fs.close()
					
					
					
				var $twoUrl:String = _rootUrl  +"model/" +Cn2enFun( hierarchyFileNode.name)+"_base.txt"
				MakeResFileList.getInstance().pushUrl($twoUrl)
				fs = new FileStream;
				fs.open(new File($twoUrl),FileMode.WRITE);
				$byte=new ByteArray;
			
				ExpH5ByteModel.getInstance().WriteByte($byte,false,[1,2,3]);
				$byte.writeUTF(objsurl)
				$byte.writeUTF(materialurl)
				$byte.writeBoolean(directLight)
				if(directLight){
					writeScene($byte)
				}
				fs.writeBytes($byte,0,$byte.length);
				
				fs.close()
					
				MakeResFileList.getInstance().saveFileListToH5(_rootUrl,"model",Cn2enFun( hierarchyFileNode.name));
		
				
			}
		
		}
		private function writeScene($byte:ByteArray):void
		{
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
				
				
			$byte.writeFloat(AmbientLight.x)
			$byte.writeFloat(AmbientLight.y)
			$byte.writeFloat(AmbientLight.z)
			$byte.writeFloat(SunLigth.x)
			$byte.writeFloat(SunLigth.y)
			$byte.writeFloat(SunLigth.z)
			$byte.writeFloat(SunNrm.x)
			$byte.writeFloat(SunNrm.y)
			$byte.writeFloat(SunNrm.z)
				
				
				
			
		}
		public function Cn2enFun($str:String):String
		{
			
			return Cn2en.toPinyin(decodeURI($str))
		}
	}
}