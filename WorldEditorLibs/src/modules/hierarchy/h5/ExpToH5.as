package modules.hierarchy.h5
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	
	import _Pan3D.base.CollisionVo;
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.analysis.TBNUtils;
	import _Pan3D.display3D.lightProbe.LightProbeManager;
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.event.LoadCompleteEvent;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.utils.Cn2en;
	
	import _me.Scene_data;
	
	import collision.CollisionType;
	
	import common.AppData;
	import common.msg.event.collision.MEvent_Collision;
	import common.utils.ui.file.FileNode;
	
	import materials.MaterialTree;
	
	import modules.hierarchy.FileSaveModel;
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	import modules.hierarchy.node.SceneQuadTree;
	
	import pack.BuildMesh;
	
	import particle.ParticleStaticMesh;
	
	import proxy.pan3d.particle.ProxyPan3DParticle;
	import proxy.top.ground.IGround;
	import proxy.top.model.IModel;
	
	import render.ground.GroundManager;
	import render.ground.TerrainEditorData;
	
	import terrain.GroundData;
	

	public class ExpToH5
	{
		private static var instance:ExpToH5;
		private var _willdeleFileItem:Vector.<String>
		public function ExpToH5()
		{
		}
		public static function getInstance():ExpToH5{
			if(!instance){
				instance = new ExpToH5();
			}
			return instance;
		}
		public function expObjsToH5($url:String,$root:String):String
		{
			var $fileURL:String=$url.replace(AppData.workSpaceUrl,"");
			var $toURL:String=decodeURI($fileURL)
			$toURL=Cn2enFun($toURL.replace(".objs",".xml"))
			setObjsToxml(new File(AppData.workSpaceUrl+$fileURL),$root+$toURL);
			
			return $toURL;
			
		}
		public function expMaterialTreeToH5(material:MaterialTree,$root:String):String
		{
			var $picArr:Array=material.getTxtList()
			for(var i:uint=0;i<$picArr.length;i++){
				var picUrl:String=$picArr[i];
				if(picUrl){
					var picFile:File=new File(AppData.workSpaceUrl+picUrl)
					var toPicUrl:String=decodeURI($root)+Cn2enFun(picUrl)
					moveFile(picFile,toPicUrl)	
				}
			}
			var materialUrl:String=material.url.replace(".material",".txt");
			materialUrl=materialUrl.replace(AppData.workSpaceUrl,"");
			var materialFile:File=new File(AppData.workSpaceUrl+materialUrl)
			if(materialFile.exists){
				var toXmlUrl:String=decodeURI($root)+Cn2enFun(materialUrl);
				moveFile(materialFile,toXmlUrl)
				return Cn2enFun(materialUrl);
			}else{
				Alert.show(decodeURI(material.url),"无地址提示")
				return null
			}
			
			
		}
		private var particleUrlDic:Dictionary = new Dictionary;
	
		
		
		
		private var _picItem:Array
		private var _objsItem:Array
		private var _materialItem:Array
		private var _lyfItem:Array
		
		private function pushStrToArr($arr:Array,$str:String):void
		{
	
			
			for(var i:uint=0;i<$str.length;i++){
				$arr.push($str.substr(i,1))
			}
			
		}
		private function makeGroundUrl():Array
		{
			var $groundItem:Array=new Array
			var idNum:uint=0
			for each(var $IGround:IGround in GroundManager.getInstance().groundItem)
			{
				var $sprite:Object=$IGround 
		
				$sprite.scanQuickTexture()
				var $bmp:BitmapData=$sprite.ground.quickBitmapData.clone()
				var $url:String=TerrainEditorData.fileRoot+idNum+".jpg"
				$url=(decodeURI($url))
				FileSaveModel.getInstance().saveBitmapdataToJpg($bmp,decodeURI($url));

				$url=$url.replace(AppData.workSpaceUrl,"")
				_picItem.push($url)
					
				var materialurl:String=makeMaterialUrl($url);
				_materialItem.push(materialurl)
				
					
				var $groundObjs:ObjData=new ObjData;
				$groundObjs.vertices=$IGround.terrainData.vertices
				$groundObjs.uvs=$IGround.terrainData.uvs
				$groundObjs.lightUvs=$IGround.terrainData.uvs
				$groundObjs.normals=$IGround.terrainData.normals
				$groundObjs.indexs=$IGround.terrainData.indexs
				var toXmlUrl:String=decodeURI(AppData.workSpaceUrl)+Cn2enFun($url.replace(".jpg",".xml"));
				writeFile($groundObjs,toXmlUrl);
				
				trace(toXmlUrl)
				trace(Cn2enFun($url.replace(".jpg",".xml")))
				
				ExpH5ByteModel.getInstance().addObjs(new File(toXmlUrl),Cn2enFun($url.replace(".jpg",".xml")));
				
				//ExpH5ByteModel.getInstance().addObjs(new File(toXmlUrl),Cn2enFun(objsUrl.replace(".objs",".xml")));
				
				
				var $tempObj:Object=new Object
				$tempObj.x=$IGround.x;
				$tempObj.y=$IGround.y;
				$tempObj.z=$IGround.z;
				$tempObj.rotationX=$IGround.rotationX;
				$tempObj.rotationY=$IGround.rotationY;
				$tempObj.rotationZ=$IGround.rotationZ;
				$tempObj.scaleX=$IGround.scaleX;
				$tempObj.scaleY=$IGround.scaleY;
				$tempObj.scaleZ=$IGround.scaleZ;
				$tempObj.objsurl=Cn2enFun($url.replace(".jpg",".xml"))
				$tempObj.picurl=Cn2enFun($url);
				$tempObj.materialurl=Cn2enFun(materialurl);
				$tempObj.lighturl=TerrainEditorData.fileRoot+"lightuv/"+"ground"+idNum+".jpg"
				$tempObj.lighturl=Cn2enFun(String($tempObj.lighturl).replace(AppData.workSpaceUrl,""));
				
				$groundItem.push($tempObj);
				
	
				_picItem.push($tempObj.lighturl)
					
				idNum++;
				
			}
			return $groundItem

		}
		private function makeMaterialUrl($url:String):String
		{

			//{"normalScale":1,"timeSpeed":null,"useKill":false,"backCull":false,"killNum":null,"hasVertexColor":false,"usePbr":false,"useNormal":false,"blendMode":0,"roughness":0,"shaderStr":"precision mediump float;\nuniform sampler2D fs0;\nuniform sampler2D fs1;\nvarying vec2 v0;\nvarying vec2 v2;\nvoid main(void){\n\nvec4 ft0 = texture2D(fs0,v0);\nvec4 ft1 = texture2D(fs1,v2);\nft1.xyz = ft1.xyz * 2.0;\nft1.xyz = ft1.xyz * ft0.xyz;\nvec4 ft2 = vec4(0,0,0,1);\nft2.xyz = ft1.xyz;\nft2.w = 1.0;\ngl_FragColor = ft2;\n\n}","writeZbuffer":true,"texList":[{"wrap":0,"isMain":true,"filter":0,"paramName":null,"url":"xfile/fram/img/atlas1.png","isParticleColor":false,"permul":false,"isDynamic":false,"id":0,"type":0,"mipmap":0},{"wrap":0,"isMain":false,"filter":0,"paramName":null,"url":null,"isParticleColor":false,"permul":false,"isDynamic":false,"id":1,"type":1,"mipmap":0}],"hasFresnel":false,"constList":[],"useDynamicIBL":false,"lightProbe":false,"hasTime":false}
			var textureObj:Object={"normalScale":1,"timeSpeed":null,"useKill":false,"backCull":false,"killNum":null,"hasVertexColor":false,"usePbr":false,"useNormal":false,"blendMode":0,"roughness":0,"shaderStr":"precision mediump float;\nuniform sampler2D fs0;\nuniform sampler2D fs1;\nvarying vec2 v0;\nvarying vec2 v2;\nvoid main(void){\n\nvec4 ft0 = texture2D(fs0,v0);\nvec4 ft1 = texture2D(fs1,v2);\nft1.xyz = ft1.xyz * 2.0;\nft1.xyz = ft1.xyz * ft0.xyz;\nvec4 ft2 = vec4(0,0,0,1);\nft2.xyz = ft1.xyz;\nft2.w = 1.0;\ngl_FragColor = ft2;\n\n}","writeZbuffer":true,"texList":[{"wrap":0,"isMain":true,"filter":0,"paramName":null,"url":"xfile/fram/img/atlas1.png","isParticleColor":false,"permul":false,"isDynamic":false,"id":0,"type":0,"mipmap":0},{"wrap":0,"isMain":false,"filter":0,"paramName":null,"url":null,"isParticleColor":false,"permul":false,"isDynamic":false,"id":1,"type":1,"mipmap":0}],"hasFresnel":false,"constList":[],"useDynamicIBL":false,"lightProbe":false,"hasTime":false}
			textureObj.texList[0].url=$url

			var materialUrl:String=$url.replace(".jpg",".txt")
		//	var $textureFileA:File = new File(_saveH5url+"/assets/"+materialUrl);
		//	writeToXml($textureFileA,textureObj);
			
			var $textureFileB:File = new File(AppData.workSpaceUrl+Cn2enFun(materialUrl));
			writeToXml($textureFileB,textureObj);
			
			
			return materialUrl
		}
	
		private var _fileNodeItem:Vector.<FileNode>;
		private var _quadTreeData:Object;
		
		public function setHierarchy($arr:Vector.<FileNode>):void
		{
			MakeResFileList.getInstance().clear();
			var _quadTree:SceneQuadTree = new SceneQuadTree();
			_quadTreeData = _quadTree.setHierarchy($arr);
			
			_fileNodeItem=$arr
				
			if(!Display3DModelSprite.collistionState){ 
				ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.SHOW_SCENE_COLLISTION));
			}
			
		    setTimeout(scanCollisionFieldFun,150)

		}
	
		private function scanCollisionFieldFun():void	
		{
			FieldCollisionModel.getInstance().setHierarchy(_fileNodeItem)
		

		}
		private var _saveH5url:String;
	
		
		private function clearFiles():void
		{
			for(var i:uint=0;i<_willdeleFileItem.length;i++)
			{
				var $file:File=new File(_willdeleFileItem[i])
				if($file.exists)
				{
					$file.deleteFile();
				}
			}
			
			deleEmpletFileDic(new File((_saveH5url)+"/assets"))
			
			
			while(clearEmptyDirectory(new File(_saveH5url))){
			
			
			}
			
		}
		private function clearEmptyDirectory($file:File):Boolean
		{
			var isHave:Boolean=false
			var allFileItem:Vector.<File>=getEmpFolderFile($file)
			for each(var $tempFile:File in allFileItem){
				if($tempFile.isDirectory){
					if($tempFile.exists){
						
						trace("删除空文件夹",$tempFile.url);
						
						$tempFile.deleteDirectory()
						isHave=true
						
					}
				}
				
			}
			return isHave
			
		}
		private function getEmpFolderFile($sonFile:File):Vector.<File>
		{
			
			var $fileItem:Vector.<File>=new Vector.<File>
			
			if($sonFile.exists && $sonFile.isDirectory)
			{
				var arr:Array=$sonFile.getDirectoryListing();
				for each(var $tempFile:File in arr)
				{
					if($tempFile.isDirectory){
						
						var barr:Array=$tempFile.getDirectoryListing();
						if(barr.length>0){
							$fileItem=$fileItem.concat(getEmpFolderFile($tempFile))
						}else{
							$fileItem.push($tempFile)
						}
					}
					
				}
			}
			
			return $fileItem
		}
		private function deleEmpletFileDic($file:File):void
		{
	
			if($file.exists){
			    if($file.isDirectory){
					var fileAry:Array = $file.getDirectoryListing();
					if(fileAry.length>0){
						for(var i:uint=0;i<fileAry.length;i++)
						{
							
							deleEmpletFileDic(File(fileAry[i]));
						}
					}else{
						//$file.deleteFile();
						
						$file.deleteDirectory()
					}
				}
			}
		}
		private function getTerrainName():String
		{
			var $file:File=new File(AppData.workSpaceUrl + AppData.mapUrl);
			return $file.name.replace("."+$file.extension,"");
		}
		private  function writeToXml($file:File,$dataArr:Object):void
		{
			
			var str:String = JSON.stringify($dataArr);
			var fs:FileStream = new FileStream();
			fs.open($file, FileMode.WRITE);

			for(var i:int = 0; i < str.length; i++)
			{
				fs.writeMultiByte(str.substr(i,1),"utf-8");
			}
	
			fs.close();
			
		}

		private function mathLyfItem():void
		{
			for(var i:uint=0;i<_lyfItem.length;i++){
				var lyflUrl:String=_lyfItem[i];
				var $file:File=new File(decodeURI(_saveH5url)+"/assets/"+lyflUrl)
	
				
				ExpH5ByteModel.getInstance().addLyf($file,Cn2enFun(lyflUrl))
					
				_willdeleFileItem.push($file.url)
			}
		}
		private function mathMaterialArr():void
		{
			for(var i:uint=0;i<_materialItem.length;i++){
				var materialUrl:String=_materialItem[i].replace(".material",".txt")
				var materialFile:File=new File(AppData.workSpaceUrl+materialUrl)
				var toXmlUrl:String=decodeURI(_saveH5url)+"/assets/"+Cn2enFun(materialUrl);
				moveFile(materialFile,toXmlUrl)
				
				ExpH5ByteModel.getInstance().addMaterial(new File(toXmlUrl),Cn2enFun(materialUrl))
					
				_willdeleFileItem.push(toXmlUrl)
			}
		}
		
		private function mathObjsArr():void
		{
			for(var i:uint=0;i<_objsItem.length;i++){
				var objsUrl:String=_objsItem[i];
				var objsFile:File=new File(AppData.workSpaceUrl+objsUrl)
				var toXmlUrl:String=decodeURI(_saveH5url)+"/assets/"+Cn2enFun(objsUrl.replace(".objs",".xml"))
				setObjsToxml(objsFile,toXmlUrl)
				
				ExpH5ByteModel.getInstance().addObjs(new File(toXmlUrl),Cn2enFun(objsUrl.replace(".objs",".xml")));
				_willdeleFileItem.push(toXmlUrl)
			}
			
		}
		private function setObjsToxml($file:File,$toFileUrl:String):void
		{
			if($file.extension=="objs"){
				var $fs:FileStream = new FileStream;
				if($file.exists){
					$fs.open($file,FileMode.READ);
					var $objList:Object = $fs.readObject();
					var $hasPbr:Boolean=ExpH5ByteModel.getInstance().usePbrUrlObj[$file.url]
					var $hasNormal:Boolean=ExpH5ByteModel.getInstance().useNormalUrlObj[$file.url]
					
					writeFile($objList,$toFileUrl,$hasNormal,$hasPbr)
				}
			}
		}
		private  function writeFile($obj:Object, $url:String,$hasNormal:Boolean=true,$hasPbr:Boolean=true):void
		{
			
			var $objData:ObjData=new ObjData;
			$objData.vertices=$obj.vertices
			$objData.uvs=$obj.uvs
			$objData.lightUvs=$obj.lightUvs
			$objData.normals=$obj.normals
			$objData.indexs=$obj.indexs
			TBNUtils.processTBN($objData)
			
			var i:uint=0
			var file:File=new File($url);
			var fs:FileStream=new FileStream;
			fs.open(file,FileMode.WRITE)
			fs.writeUTF($url);
			
			fs.writeInt($objData.vertices.length)
			for(i=0;i<$objData.vertices.length;i++)
			{
				fs.writeFloat($objData.vertices[i])
			}
			
			fs.writeInt($objData.uvs.length)
			for(i=0;i<$objData.uvs.length;i++)
			{
				fs.writeFloat($objData.uvs[i])
			}
			fs.writeInt($objData.lightUvs.length)
			for(i=0;i<$objData.lightUvs.length;i++)
			{
				fs.writeFloat($objData.lightUvs[i])
			}
	
			//特殊因为法线没转换正确的问题
			if($hasNormal){
				var arr:Array=new Array;
				for(i=0;i<$objData.normals.length/3;i++)
				{
					arr.push(+$objData.normals[i*3+0])
					arr.push(-$objData.normals[i*3+2])
					arr.push(+$objData.normals[i*3+1])
				}
				fs.writeInt($objData.normals.length)
				for(i=0;i<$objData.normals.length;i++)
				{
					fs.writeFloat(arr[i])
				}
			}else{
				fs.writeInt(0)
			}
			fs.writeInt($objData.indexs.length)
			for(i=0;i<$objData.indexs.length;i++)
			{
				fs.writeInt($objData.indexs[i])
			}
			if($hasPbr){
				fs.writeInt($objData.tangents.length)
				for(i=0;i<$objData.tangents.length;i++)
				{
					fs.writeFloat($objData.tangents[i])
				}
				fs.writeInt($objData.bitangents.length)
				for(i=0;i<$objData.bitangents.length;i++)
				{
					fs.writeFloat($objData.bitangents[i])
				}
			}else{
				fs.writeInt(0);
				fs.writeInt(0);
			}
			if(!Boolean($obj is ObjData)){   //这里要优化。。 不为地面，而是原始的文件 存入碰撞体
				if($obj.item){
					witerCollisionItemToByte(fs,$obj.item)
					fs.writeFloat(Number($obj.friction))
					fs.writeFloat(Number($obj.restitution))
					fs.writeBoolean(Boolean($obj.isField))
				}
			}
			fs.close();
		}
		private function witerCollisionItemToByte($fs:FileStream,$item:Array):void
		{
			if($item){
				$fs.writeInt($item.length);
				for(var i:uint=0;i<$item.length;i++)
				{
					var $obj:Object=$item[i];
					var $collisionVo:CollisionVo=new CollisionVo;
					$collisionVo.type=$obj.type
					$collisionVo.x=$obj.x
					$collisionVo.y=$obj.y
					$collisionVo.z=$obj.z
					
					$collisionVo.rotationX=$obj.rotationX
					$collisionVo.rotationY=$obj.rotationY
					$collisionVo.rotationZ=$obj.rotationZ
						
					$collisionVo.scale_x=$obj.scale_x;
					$collisionVo.scale_y=$obj.scale_y;
					$collisionVo.scale_z=$obj.scale_z;
					$collisionVo.radius=$obj.radius;
					$collisionVo.data=$obj.data;
					
					$collisionVo.name=$obj.name;
					
					
					$collisionVo.colorInt=$obj.colorInt;
					
					$fs.writeUTF($collisionVo.name)
					$fs.writeInt($collisionVo.type);
					$fs.writeFloat($collisionVo.x)
					$fs.writeFloat($collisionVo.y)
					$fs.writeFloat($collisionVo.z)
					$fs.writeFloat($collisionVo.rotationX)
					$fs.writeFloat($collisionVo.rotationY)
					$fs.writeFloat($collisionVo.rotationZ)
						
					switch($collisionVo.type)
					{
						case CollisionType.Polygon:
						{
							$fs.writeFloat($collisionVo.scale_x)
							$fs.writeFloat($collisionVo.scale_x)
							$fs.writeFloat($collisionVo.scale_x)
							
							if($collisionVo.data){
								$fs.writeBoolean(true);
								$fs.writeInt($collisionVo.data.vertices.length)
								for(var j:uint=0;j<$collisionVo.data.vertices.length;j++)
								{
									$fs.writeFloat($collisionVo.data.vertices[j])
								}
								$fs.writeInt($collisionVo.data.indexs.length)
								for(var k:uint=0;k<$collisionVo.data.indexs.length;k++)
								{
									$fs.writeInt($collisionVo.data.indexs[k])
								}
	
							}else{
								$fs.writeBoolean(false)
							}

							break;
						}
						case CollisionType.BOX:
						{
							$fs.writeFloat($collisionVo.scale_x)
							$fs.writeFloat($collisionVo.scale_y)
							$fs.writeFloat($collisionVo.scale_z)
							break;
						}
						case CollisionType.BALL:
						{
							$fs.writeFloat($collisionVo.radius)
							
							break;
						}
						case CollisionType.Cylinder:
						{
							$fs.writeFloat($collisionVo.scale_x)
							$fs.writeFloat($collisionVo.scale_y)
							$fs.writeFloat($collisionVo.scale_z)
							
							break;
						}
						case CollisionType.Cone:
						{
							$fs.writeFloat($collisionVo.scale_x)
							$fs.writeFloat($collisionVo.scale_y)
							$fs.writeFloat($collisionVo.scale_z)
							
							break;
						}
						default:
						{
							Alert.show("还没有的CollisionType")
							break;
						}
					}
						
					
				
				}
			}
		}
		
		private function mathPicArr():void
		{
			for(var i:uint=0;i<_picItem.length;i++){
				var picUrl:String=_picItem[i];
				if(picUrl){
					var picFile:File=new File(AppData.workSpaceUrl+picUrl)
					var toPicUrl:String=decodeURI(_saveH5url)+"/assets/"+Cn2enFun(picUrl)
					ExpH5ByteModel.getInstance().addPic(picFile,Cn2enFun(picUrl))
					
					moveFile(picFile,toPicUrl)
					
					MakeResFileList.getInstance().pushUrl(toPicUrl)
				}
				
			}
		}
		
		public function Cn2enFun($str:String):String
		{
			
			return Cn2en.toPinyin(decodeURI($str))
		}
		public function mathOnlyUrlArr(arr:Array):Array
		{
			var tempArr:Array=new Array
			for(var i:uint=0;i<arr.length;i++){
				var $needAdd:Boolean=true
				for(var j:uint=0;j<tempArr.length;j++){
					if(tempArr[j]==arr[i]){
						$needAdd=false
					}
				}
				if($needAdd){
					tempArr.push(arr[i])
				}
			}
			return tempArr;
		}
		public function moveFile($file:File,$toUrl:String):void
		{
			if($file.exists){
				var destination:File = File.documentsDirectory;
				destination = destination.resolvePath($toUrl);
				$file.copyTo(destination, true);
				
				
		
			}
			
			
		}
		
	
	}
}