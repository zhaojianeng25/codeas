package modules.hierarchy.h5
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.analysis.TBNUtils;
	import _Pan3D.display3D.lightProbe.LightProbeManager;
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.utils.Cn2en;
	import _Pan3D.utils.MaterialManager;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.collision.MEvent_Collision;
	import common.utils.ui.file.FileNode;
	
	import materials.MaterialTree;
	
	import modules.expres.ExpResFunVo;
	import modules.expres.ExpResModel;
	import modules.expres.ExpResPanel;
	import modules.hierarchy.FileSaveModel;
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	import modules.hierarchy.node.SceneQuadTree;
	import modules.materials.MergeLightUV;
	import modules.scene.sceneSave.FilePathManager;
	import modules.terrain.TerrainOutH5DataModel;
	
	import navMesh.NavMeshStaticMesh;
	
	import pack.BuildMesh;
	
	import particle.ParticleStaticMesh;
	
	import proxy.pan3d.particle.ProxyPan3DParticle;
	import proxy.top.ground.IGround;
	import proxy.top.model.IModel;
	
	import render.ground.GroundManager;
	import render.ground.TerrainEditorData;
	
	import terrain.GroundData;
	
	
	
	public class ExpToH5Copy
	{
		private static var instance:ExpToH5Copy;


		public function ExpToH5Copy()
		{
		}
		public static function getInstance():ExpToH5Copy{
			if(!instance){
				instance = new ExpToH5Copy();
			}
			return instance;
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
		public function moveFile($file:File,$toUrl:String):void
		{
			if($file.exists){
				var destination:File = File.documentsDirectory;
				destination = destination.resolvePath($toUrl);
				$file.copyTo(destination, true);
			}
			
			
		}
		public function expParticleToH5($CombineParticle:CombineParticle,$root:String):String
		{
			var $picArr:Array=new Array;
			var a:Array=$CombineParticle.getMaterialTexUrlAry()
			$picArr=$picArr.concat(a)
			var b:Array=$CombineParticle.getMaterialAry();
			for(var materialTreeId:uint=0;materialTreeId<b.length;materialTreeId++){
				$picArr=$picArr.concat(MaterialTree(b[materialTreeId]).getTxtList())
			}
			for(var i:uint=0;i<$picArr.length;i++){
				var picUrl:String=$picArr[i];
				if(picUrl){
					var picFile:File=new File(AppData.workSpaceUrl+picUrl)
					var toPicUrl:String=decodeURI($root)+Cn2enFun(picUrl)
					moveFile(picFile,toPicUrl)	
				}
			}
			var lyfFile:File=new File(decodeURI($CombineParticle.url.replace(".lyf",".txt")))
			if(lyfFile.exists){
				var toXmlUrl:String=decodeURI($root)+Cn2enFun(lyfFile.url.replace(AppData.workSpaceUrl,""));
				moveFile(lyfFile,toXmlUrl)
				return Cn2enFun(lyfFile.url.replace(AppData.workSpaceUrl,""))
			}else{
				Alert.show(decodeURI(lyfFile.url),"无地址提示")
				return null
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
				$url=$url.replace(AppData.workSpaceUrl,"")
					
				FileSaveModel.getInstance().saveBitmapdataToJpg($bmp,decodeURI(AppData.workSpaceUrl)+decodeURI($url));
				
				
				var $groundObjs:ObjData=new ObjData;
				$groundObjs.vertices=$IGround.terrainData.vertices;
				$groundObjs.uvs=$IGround.terrainData.uvs;
				$groundObjs.lightUvs=$IGround.terrainData.uvs;
				/*
				$groundObjs.lightUvs=new Vector.<Number>
				for(var i:Number=0;i<$IGround.terrainData.uvs.length;i++){
					$groundObjs.lightUvs.push($IGround.terrainData.uvs[i])
				}
				*/
				$groundObjs.normals=$IGround.terrainData.normals
				$groundObjs.indexs=$IGround.terrainData.indexs
				var toXmlUrl:String=decodeURI(AppData.workSpaceUrl)+Cn2enFun($url.replace(".jpg",".xml"));   //这是大小写得改
				
				ExpResourcesModel.getInstance().writeFile($groundObjs,toXmlUrl,false,false,false);
			
				
				var $tempObj:Object=new Object
				$tempObj.id=idNum;
				$tempObj.type= HierarchyNodeType.Ground
				$tempObj.x=$IGround.x;
				$tempObj.y=$IGround.y;
				$tempObj.z=$IGround.z;
				$tempObj.rotationX=$IGround.rotationX;
				$tempObj.rotationY=$IGround.rotationY;
				$tempObj.rotationZ=$IGround.rotationZ;
				$tempObj.scaleX=$IGround.scaleX;
				$tempObj.scaleY=$IGround.scaleY;
				$tempObj.scaleZ=$IGround.scaleZ;
				
				$tempObj.objsurl=ExpResourcesModel.getInstance().expObjsOnlyXmlByUrl(toXmlUrl,_rootUrl)
				$tempObj.picurl=ExpResourcesModel.getInstance().expPicByUrl($url,_rootUrl)
					/*
				$tempObj.materialurl=ExpResourcesModel.getInstance().expMaterialTreeToH5(_terrainMaterial,_rootUrl)
				$tempObj.materialInfoArr=[{name:"param0",type:"0",url:$tempObj.picurl}]	
					*/
					
				var $terrainMaterial:MaterialTree=_terrainMaterial;
				if($terrainMaterial&&$terrainMaterial.hasMainTex()){
					for(var i:Number=0;i<$terrainMaterial.texList.length;i++){
						if($terrainMaterial.texList[i].isMain){
							var mianParamName:String=$terrainMaterial.texList[i].paramName
							$tempObj.materialInfoArr=[{name:mianParamName,type:"0",url:$tempObj.picurl}]	
						}
					}
				}else{
					Alert.show("地面材质没有主键");
				}
				$tempObj.materialurl=ExpResourcesModel.getInstance().expMaterialTreeToH5($terrainMaterial,_rootUrl);
				$tempObj.lighturl=ExpResourcesModel.getInstance().expPicByUrl(TerrainEditorData.fileRoot+"lightuv/"+"ground"+idNum+".jpg",_rootUrl)
	
				$groundItem.push($tempObj);
				idNum++;
				
			}
			return $groundItem
			
		}

		
		private var _fileNodeItem:Vector.<FileNode>;
		private var _quadTreeData:Object;
		private var _aabb:Object;
		
		public function setHierarchy($arr:Vector.<FileNode>):void
		{
			MakeResFileList.getInstance().clear();
			FileSaveModel.getInstance().initJpgQuality(80);
				
			var _quadTree:SceneQuadTree = new SceneQuadTree();
			_quadTreeData = _quadTree.setHierarchy($arr);
			_aabb = _quadTree.tempRecList;
			
			
			_fileNodeItem=this.sortFileNode($arr);
			if(!Display3DModelSprite.collistionState){ 
				ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.SHOW_SCENE_COLLISTION));
			}
			MaterialManager.getInstance().getMaterial(AppData.workSpaceUrl+GroundData.materialUrl,function bfun($matrial:MaterialTree,$url:String):void{
				_terrainMaterial=$matrial
				setTimeout(scanCollisionFieldFun,150);
				
			},null)

		}
		//根据材质排序新的数组
		private function sortFileNode($arr:Vector.<FileNode>):Vector.<FileNode>
		{
			var backArr:Vector.<FileNode>=new Vector.<FileNode>;
			var data:Array=new Array();
			for(var i:uint=0;i<$arr.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=$arr[i] as HierarchyFileNode
				if($hierarchyFileNode.data as BuildMesh)	{
					var $BuildMesh:BuildMesh=$hierarchyFileNode.data as BuildMesh;
					if(!$BuildMesh.isGround){
						if(!$BuildMesh.prefabStaticMesh.material){
							Alert.show($BuildMesh.nodeName+"对象材质为无");
						}
						var $picItem:Array=ExpResourcesModel.getInstance().changeUrlByMaterialInfoArr($BuildMesh.prefabStaticMesh.materialInfoArr)
						var $picKey:String="";
						while($picItem.length){
							var $obj:Object=$picItem.pop();
							if($obj.type==0){
								$picKey+=$obj.url
							}
						}
						var $kkkk:Object=new Object();
						$kkkk.node=$arr[i];
						$kkkk.hasAlpha=MaterialTree($BuildMesh.prefabStaticMesh.material).hasAlpha
						$kkkk.materialUrl=decodeURI($BuildMesh.prefabStaticMesh.materialUrl)
						$kkkk.picKey=$picKey;
						data.push($kkkk);
					}
				}else{
					backArr.push($arr[i])
				}
			}
			data.sortOn(["hasAlpha","materialUrl","picKey"])
			for(var j:uint=0;j<data.length;j++){
				backArr.push(data[j].node)
				trace(data[j].materialUrl)
			}

			
			return backArr;
		}
		
		
		
		

		private var _terrainMaterial:MaterialTree
		
		private function scanCollisionFieldFun():void	
		{
			FieldCollisionModel.getInstance().setHierarchy(_fileNodeItem)
				
			if(ExpResModel.expArpg){
				ExpResPanel.initExpPanel(selectBackFun,["tb_map"]);
			}else{
				var file:File = new File(FilePathManager.getInstance().getPathByUid("expToH5"));
				file.addEventListener(Event.SELECT,onFileWorkChg);
				file.browseForDirectory("选择文件夹");
			}
			
	
		}
		private function selectFile(event:Event):void
		{
			this.onFileWorkChg(event.target as File);
		}
		private var tabelMapStr:String
		private function selectBackFun($obj:ExpResFunVo):void
		{
			tabelMapStr=String($obj.id)
			//_rootUrl=AppData.expSpaceUrl+"/";
			onFileWorkChg(new File(AppData.expSpaceUrl))
//			ExpH5ByteModel.getInstance().clear();
//			ExpResourcesModel.getInstance().initData(_rootUrl,returnFun)
//			toBuild()
		}
		
		private var _rootUrl:String;
		protected function onFileWorkChg(file:File):void
		{
			ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.HIDE_SCENE_COLLISTION));
			FilePathManager.getInstance().setPathByUid("expToH5",file.url)
			_rootUrl=decodeURI(file.url+"/")
			
			ExpH5ByteModel.getInstance().clear();
			ExpResourcesModel.getInstance().initData(_rootUrl,returnFun)
			toBuild()

		}
		private function toBuild():void
		{
			
			var $jasobj:Object=new Object;
			
			if(GroundData.showTerrain){
				$jasobj.groundItem=makeGroundUrl();
			}
			
			var buildItem:Array=new Array;
			
			//this.combineLightMap();
			
			for(var i:uint=0;i<_fileNodeItem.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=_fileNodeItem[i] as HierarchyFileNode
				if($hierarchyFileNode.iModel){
					var $iModel:IModel=$hierarchyFileNode.iModel;
					var $tempObj:Object=new Object;
					
					$tempObj.type=$hierarchyFileNode.type
					$tempObj.x=$iModel.x;
					$tempObj.y=$iModel.y;
					$tempObj.z=$iModel.z;
					$tempObj.rotationX=$iModel.rotationX;
					$tempObj.rotationY=$iModel.rotationY;
					$tempObj.rotationZ=$iModel.rotationZ;
					$tempObj.scaleX=$iModel.scaleX;
					$tempObj.scaleY=$iModel.scaleY;
					$tempObj.scaleZ=$iModel.scaleZ;
					$tempObj.id=$hierarchyFileNode.id
					
					
					
					if($hierarchyFileNode.data as BuildMesh)	{
						
				
							var $BuildMesh:BuildMesh=$hierarchyFileNode.data as BuildMesh;
							if(!$BuildMesh.isGround){
								ExpH5ByteModel.getInstance().saveMaterialTreeHasNrmOrPbnByUrl($BuildMesh.prefabStaticMesh.materialUrl,$BuildMesh.prefabStaticMesh.axoFileName);			
								
								
								if(!$BuildMesh.prefabStaticMesh.material){
									Alert.show($BuildMesh.nodeName+"对象材质为无");
								}
								 
								ExpResourcesModel.getInstance().expMaterialInfoArr($BuildMesh.prefabStaticMesh.materialInfoArr,_rootUrl);
								
								if(MaterialTree($BuildMesh.prefabStaticMesh.material).isHaveMaterialInfoArr()){
									$tempObj.materialInfoArr=ExpResourcesModel.getInstance().changeUrlByMaterialInfoArr($BuildMesh.prefabStaticMesh.materialInfoArr)
								}
				
								$tempObj.objsurl=ExpResourcesModel.getInstance().expObjsByUrl($BuildMesh.prefabStaticMesh.axoFileName,_rootUrl)
							
								$tempObj.materialurl=ExpResourcesModel.getInstance().expMaterialTreeToH5(MaterialTree($BuildMesh.prefabStaticMesh.material),_rootUrl)
								$tempObj.isPerspective=$BuildMesh.isPerspective;
								if(!MaterialTree($BuildMesh.prefabStaticMesh.material).noLight)
								{
									var $lighturl:String=TerrainEditorData.fileRoot+"lightuv/"+"build"+$hierarchyFileNode.id+".jpg";
									$tempObj.lighturl=ExpResourcesModel.getInstance().expPicByUrl($lighturl,_rootUrl)
									$tempObj.mergUrl=$BuildMesh.prefabStaticMesh.axoFileName;
									$tempObj.merg=true
								}
								buildItem.push($tempObj);
							}
					}
					if($hierarchyFileNode.data as ParticleStaticMesh)	{
						var $ParticleStaticMesh:ParticleStaticMesh=$hierarchyFileNode.data as ParticleStaticMesh;
						var $ProxyPan3DParticle:ProxyPan3DParticle=$hierarchyFileNode.iModel as ProxyPan3DParticle
						$tempObj.url=ExpResourcesModel.getInstance().expParticleByUrl($ParticleStaticMesh.url,_rootUrl);
						buildItem.push($tempObj);
						
					}
					if($hierarchyFileNode.data as NavMeshStaticMesh)	{
						var $NavMeshStaticMesh:NavMeshStaticMesh=$hierarchyFileNode.data as NavMeshStaticMesh;
						$tempObj.vecTri=$NavMeshStaticMesh.vecTri
						$tempObj.midu=$NavMeshStaticMesh.midu
						$tempObj.astarItem=$NavMeshStaticMesh.astarItem
						$tempObj.heightItem=$NavMeshStaticMesh.heightItem
						$tempObj.aPos=$NavMeshStaticMesh.aPos
						_navMeshStaticMeshToByte=$NavMeshStaticMesh
					}
				}
			}
			ExpMergLightUvOnlyObj.getInstance().mergBuildModeObj(buildItem,_rootUrl);
			
			$jasobj.buildItem=buildItem;
			$jasobj.quadTreeData=_quadTreeData;
			$jasobj.aabb = _aabb;
			$jasobj.lightProbeItem=LightProbeManager.getInstance().dataAry;
			$jasobj.fieldVo=FieldCollisionModel.getInstance().fieldVo;
			$jasobj.sceneCollisionItem=FieldCollisionModel.getInstance().sceneCollisionItem;
			
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
			
			
			$jasobj.AmbientLight=AmbientLight
			$jasobj.SunLigth=SunLigth
			$jasobj.SunNrm=SunNrm
				
				
			$jasobj.fogColor=	Scene_data.fogColor	
			if(Scene_data.fogShowObj){
				$jasobj.fogDistance=Scene_data.fogShowObj.tempfogDistance;
				$jasobj.fogAttenuation=Scene_data.fogShowObj.tempfogAttenuation;
			}else{
				$jasobj.fogDistance=	Scene_data.fogDistance	;
				$jasobj.fogAttenuation=	Scene_data.fogAttenuation	;
			}

			$jasobj.gameAngle=	Scene_data.gameAngle	
		
	
			
			_sceneFileXml = new File(_rootUrl+"map/"+getTerrainName()+".xml");
			writeToXml(_sceneFileXml,$jasobj)
			
			ExpResourcesModel.getInstance().run()
				
				
		}
	
		
		private var _navMeshStaticMeshToByte:NavMeshStaticMesh;
		private function getAstarItemByte():ByteArray
		{
			var $byte:ByteArray=new ByteArray;
			if(_navMeshStaticMeshToByte){
				$byte.writeBoolean(true);
				
				
				
				$byte.writeFloat(_navMeshStaticMeshToByte.midu)
				$byte.writeFloat(_navMeshStaticMeshToByte.aPos.x)
				$byte.writeFloat(_navMeshStaticMeshToByte.aPos.y)
				$byte.writeFloat(_navMeshStaticMeshToByte.aPos.z)
				
				var  tw:Number	=_navMeshStaticMeshToByte.astarItem.length
				var  th:Number	=_navMeshStaticMeshToByte.astarItem[0].length
				$byte.writeInt(tw);
				$byte.writeInt(th);
				var i:Number=0;
				var j:Number=0;
				var ptx:Point
				
				var $astarNum:Number;
				var $heightNum:Number;
				var $jumpNum:Number;
				var allHeightNum:Vector.<Number>=new  Vector.<Number>
				for( i=0;i<th;i++){
					for( j=0;j<tw;j++){
						ptx=new Point(j,th-i-1);
						$heightNum=Number(_navMeshStaticMeshToByte.heightItem[ptx.x][ptx.y]);
						allHeightNum.push($heightNum);
					}
				}
				var tempMax:Number=1
				for( var $kt:Number=0;$kt<allHeightNum.length;$kt++)
				{
					if(Math.abs(tempMax)<Math.abs(allHeightNum[$kt])){
						tempMax=allHeightNum[$kt]
					}
				}
				var $heightScaleNum:Number=32767/tempMax;  //比例
				$byte.writeFloat($heightScaleNum);//高度比例
				var  $astarArr:Array=new Array;
				var  $jumpArr:Array=new Array;
				for( i=0;i<th;i++){
					for( j=0;j<tw;j++){
						ptx=new Point(j,th-i-1);
						$astarNum=Number(_navMeshStaticMeshToByte.astarItem[ptx.x][ptx.y])
						$astarArr.push($astarNum);
						if($astarNum==1){
							if(_navMeshStaticMeshToByte.jumpItem){
								$jumpArr.push(Number(_navMeshStaticMeshToByte.jumpItem[ptx.x][ptx.y]));
							}else{
								$jumpArr.push(0);
							}
						}
					}
				}
				this.writeAstarToByte($astarArr,$byte);
				this.writeAstarToByte($jumpArr,$byte);
				for( i=0;i<th;i++){
					for( j=0;j<tw;j++){
						ptx=new Point(j,th-i-1);
						$heightNum=Number(_navMeshStaticMeshToByte.heightItem[ptx.x][ptx.y]);
						$byte.writeShort(Math.floor($heightNum*$heightScaleNum));
					}
				}

			}else{
				$byte.writeBoolean(false)
			}
			return $byte;
		}
		private function writeAstarToByte(temp:Array,$byte:ByteArray):void
		{
			var i:Number;
			var j:Number;
			$byte.writeUnsignedInt(temp.length);
			for ( i = 0; i < temp.length; i += 32) {
				var val:Number = 0;
				for ( j = Math.min(i+31, temp.length-1); j >= i; -- j) {
					val = (val * 2) + temp[j];
				}
				$byte.writeUnsignedInt(val);
			}
	
		}
		private var _sceneFileXml:File 
		private function returnFun():void{
			
			var $fsScene:FileStream = new FileStream;
			$fsScene.open(_sceneFileXml,FileMode.READ);
			var $Scenebyte:ByteArray=new ByteArray;
			
			$fsScene.readBytes($Scenebyte,0,$fsScene.bytesAvailable);
			$fsScene.close();
			_sceneFileXml.deleteFile();
			
			/*
			var $byte:ByteArray=new ByteArray;
			var fileByte:ByteArray=new ByteArray;
			var fs:FileStream = new FileStream;
			var newUrl1:String = _rootUrl + "map/" + getTerrainName()+".txt"
			MakeResFileList.getInstance().pushUrl(newUrl1)
			fs.open(new File(newUrl1),FileMode.WRITE);
			fs.writeInt(Scene_data.version);
		
			$byte=new ByteArray;
			ExpH5ByteModel.getInstance().WriteByte($byte,true,[1,2,3,4]);
			fs.writeBytes($byte,0,$byte.length);			
			fs.writeInt(5)
			

				
			var astarByte:ByteArray=getAstarItemByte();  //A星数据
			fs.writeBytes(astarByte,0,astarByte.length);
			trace("A星:"+astarByte.length/1000+"k")
			fs.writeInt($Scenebyte.length)
			fs.writeBytes($Scenebyte,0,$Scenebyte.length);
			trace("场景:"+$Scenebyte.length/1000+"k")
			
			trace("fs.bytesAvailable")
		
			
			fs.close();
			*/
			
			var astarByte:ByteArray=getAstarItemByte();  //A星数据
			var terrainByte:ByteArray=TerrainOutH5DataModel.getInstance().makeTerrainH5IdInfoByteArray()
			ExpH5ByteModel.getInstance().addInfoStr="\nA星:"+astarByte.length/1024+"k\n"
			ExpH5ByteModel.getInstance().addInfoStr+="场景:"+$Scenebyte.length/1024+"k\n"
			ExpH5ByteModel.getInstance().addInfoStr+="地面信息图:"+terrainByte.length/1024+"k\n"
		
			var $byte:ByteArray=new ByteArray;
			var $sceneFileByte:ByteArray=new ByteArray;
	
			var newUrl1:String = _rootUrl + "map/" + getTerrainName()+".txt"
			MakeResFileList.getInstance().pushUrl(newUrl1)
	
			$sceneFileByte.writeInt(Scene_data.version);
			
			$byte=new ByteArray;
			ExpH5ByteModel.getInstance().WriteByte($byte,true,[1,3,4,6]);
			$sceneFileByte.writeBytes($byte,0,$byte.length);			
			
			$sceneFileByte.writeInt(5)
			$sceneFileByte.writeBytes(astarByte,0,astarByte.length);
			
			$sceneFileByte.writeBytes(terrainByte,0,terrainByte.length);
			
	
	
			$sceneFileByte.writeInt($Scenebyte.length)
			$sceneFileByte.writeBytes($Scenebyte,0,$Scenebyte.length);
		

			var fs:FileStream = new FileStream;
			fs.open(new File(newUrl1),FileMode.WRITE);
			fs.writeBytes($sceneFileByte,0,$sceneFileByte.length);		
			fs.close();
			
			this.wirteTo512FileZip($sceneFileByte,newUrl1)

				
			var ddd:Object=MergeLightUV.getMergeData()
		
				
			FileSaveModel.getInstance().initJpgQuality(100)
			//this.wiritMapListFile()
		}

		private function wirteTo512FileZip($aaa:ByteArray,$url:String):void
		{
//			trace("原来长底",$aaa.length);
//			var zip:ASZip = new ASZip();
//			zip.addFile($aaa,"data");
//			var $byte:ByteArray = zip.saveZIP(Method.LOCAL);

			
			var $byte:ByteArray =$aaa
			trace("文件长度512",$byte.length);

			var  $id:Number=0;
			var $needNext:Boolean=true;
			var $fileItem:Vector.<ByteArray>=new Vector.<ByteArray>
			while($needNext){
				var $postion:Number=$id*(1024*512);
				var $len:Number=1024*512;
				if(($postion+$len+1024*256)>=$byte.length){
					$len=($byte.length-$postion)
					$needNext=false;
				}
				
				var $tempByte:ByteArray=new ByteArray();
				$tempByte.writeBytes($byte,$postion,$len);
				$fileItem.push($tempByte);
				
				trace($id,$len)
				$id++;
			}
			for(var i:Number=0;i<$fileItem.length;i++)
			{
				var fs:FileStream = new FileStream;
				var $toFileUrl:String=$url.replace(".txt","/"+i+".txt");
				fs.open(new File($toFileUrl),FileMode.WRITE);
				fs.writeBytes($fileItem[i],0,$fileItem[i].length);		
			
				fs.close();
			}
			trace("需要几个文件",$fileItem.length);
			this.writeSceneFileNumToTb($fileItem.length)
		}
		private function writeSceneFileNumToTb($len:Number):void
		{
		//	var newUrl1:String = _rootUrl + "map/" + getTerrainName()+".txt"
			getTerrainName()
			var $file:File=new File( _rootUrl + "data/scene.txt");
			var $list:Object=new Object

			if($file.exists){
				var $fs:FileStream = new FileStream();
				$fs.open($file, FileMode.READ);
			    $list= JSON.parse($fs.readUTFBytes($fs.bytesAvailable))
				$fs.close();
			}
		    var $sceneName:String= getTerrainName();
			$list[$sceneName]=new Object;
			$list[$sceneName].len=$len;
			$list[$sceneName].version=Scene_data.version;
			this.writeToXml($file,$list);
		}
		//写入地图列表
		private function wiritMapListFile():void
		{
			var $dicUrl:String = _rootUrl + "map/";
			var $dicFile:File=new File($dicUrl);
			var $objArr:Array=new Array;
			if($dicFile.exists && $dicFile.isDirectory){
				var fileAry:Array = $dicFile.getDirectoryListing();
				for(var i:int=0;i<fileAry.length;i++){
					var tempFile:File=File(fileAry[i])
					if(tempFile.url.search("base.txt")==-1 &&tempFile.url.search("list.txt")==-1){
						var $tempObj:Object=new Object;
						$tempObj.name=tempFile.name.replace(".txt","")
						$objArr.push($tempObj)
					}
				}
			}
			var strObj:String=JSON.stringify($objArr);
			var fs:FileStream = new FileStream();
			fs.open(new File($dicUrl+"list.txt"), FileMode.WRITE);
			fs.writeMultiByte(strObj,"utf-8");
			fs.close();
		}
	
		
		private function getTerrainName():String
		{
			if(tabelMapStr){
			   return tabelMapStr
			}
			var $file:File=new File(AppData.workSpaceUrl + AppData.mapUrl);
			return decodeURI($file.name.replace("."+$file.extension,""));
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
	
			fs.close();
		}
		
		public function Cn2enFun($str:String):String
		{
			
			return Cn2en.toPinyin(decodeURI($str))
		}


		
		
	}
}


