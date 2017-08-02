package modules.hierarchy
{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import spark.components.Alert;
	
	import _Pan3D.base.MakeModelData;
	import _Pan3D.base.ObjData;
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.Display3DMaterialSprite;
	import _Pan3D.display3D.grass.GrassDisplay3DSprite;
	import _Pan3D.display3D.ground.GroundEditorSprite;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.net.NetManager;
	import common.msg.net.TSocket;
	import common.utils.ui.file.FileNode;
	
	import light.LightProbeStaticMesh;
	import light.LightProbeTempStaticMesh;
	import light.ParallelLightStaticMesh;
	
	import materials.MaterialCubeMap;
	
	import modules.brower.fileTip.RadiostiyInfoWindow;
	import modules.brower.fileTip.RenderSocketType;
	import modules.materials.CubeMapManager;
	
	import pack.BuildMesh;
	
	import proxy.top.ground.IGround;
	import proxy.top.model.IModel;
	import proxy.top.render.Render;
	
	import render.ground.GroundManager;
	import render.ground.TerrainEditorData;
	
	import terrain.GroundData;
	import terrain.GroundMath;
	import terrain.TerrainData;
	

	public class RenderModel
	{
		private static var instance:RenderModel;
		private var _tSocket:TSocket;
		private var _cFileByte:ByteArray;
		private var useLittleEncode:Boolean = false;
		public function RenderModel()
		{
		}

		public static function getInstance():RenderModel{
			if(!instance){
				instance = new RenderModel();
			}
			return instance;
		}
		private var _listArr:Vector.<FileNode>
		private var _grassLightBmp:BitmapData=new BitmapData(512,512,false,0xffffff)
		
		/**
		 *保存草地的lightUV,用的是所有地面的灯光贴图来拼 
		 * @param $bmp
		 * @param cellX
		 * @param cellZ
		 * 
		 */
		private function saveGrassLightUv($bmp:BitmapData,cellX:uint,cellZ:uint):void
		{
		
			var $m:Matrix=new Matrix
			$m.scale(1/GroundData.cellNumX*(_grassLightBmp.width/$bmp.width),1/GroundData.cellNumZ*(_grassLightBmp.height/$bmp.height))
			$m.tx=cellX/GroundData.cellNumX*_grassLightBmp.width
			$m.ty=cellZ/GroundData.cellNumZ*_grassLightBmp.height
			_grassLightBmp.draw($bmp,$m)
			var $url:String=Render.lightUvRoot+"allGroundLightUv.jpg"
			if(_grassLightBmp){
				FileSaveModel.getInstance().useWorkerSaveBmp(_grassLightBmp.clone(),$url,"jpg")
			}
				
			GrassDisplay3DSprite.groundLightUvTexture=TextureManager.getInstance().bitmapToTexture(_grassLightBmp)
				
		}
		/**
		 *保存渲染程序返回的lightUv,要区分是地面还是普通建筑 
		 * @param $uid
		 * @param $bmp
		 * 
		 */
		public function resetTexture($uid:String,$bmp:BitmapData):void
		{
			if($uid.search("ground")!=-1){
				var sss:String=$uid.replace("ground","")
				var groundId:uint=uint(sss)
				for (var j:uint=0;j< GroundManager.getInstance().groundItem.length;j++)
				{
					if(groundId==j){
						var $imode:IGround=GroundManager.getInstance().groundItem[j];
						$imode.lightMapTexture=TextureManager.getInstance().bitmapToTexture($bmp)
						saveGrassLightUv($bmp,$imode.cellX,$imode.cellZ)
					}
				}
			}
			var $item:Vector.<HierarchyFileNode>=new Vector.<HierarchyFileNode>
			for(var i:uint=0;i<_listArr.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=_listArr[i] as HierarchyFileNode ;
				if($hierarchyFileNode.type==HierarchyNodeType.Prefab){
					if($hierarchyFileNode.iModel&&$hierarchyFileNode.iModel.uid==$uid)
					{
						var $proxyPan3dModel:Object=$hierarchyFileNode.iModel
						if($proxyPan3dModel&&$proxyPan3dModel.sprite){
							var $sprite:Display3DMaterialSprite=$proxyPan3dModel.sprite  as Display3DMaterialSprite
							$sprite.lightMapTexture=TextureManager.getInstance().bitmapToTexture($bmp)
						}
					}
					
				}
			}
			
			
		}
		/**
		 *打断渲染 
		 * 
		 */
		public function stopRender():void
		{
			RadiostiyInfoWindow.getInstance().close()
			//var $byte:ByteArray=new ByteArray
			//$byte.writeInt(1)
			//sendMsg($byte,RenderSocketType.STOPRENDER);
				
			var byte:ByteArray = new ByteArray;
			byte.endian = Endian.LITTLE_ENDIAN;
			byte.writeUTF("kill");
			NetManager.getInstance().sendCtrlMsg(byte,2);
		}

        private var _cubeMapSkyBoxUrl:String  //开空盒的图片地址
		
		
		/**
		 *将地址的文件列表用于渲染 
		 * @param $arr
		 * 
		 */
		public function setRenderItem($arr:Vector.<FileNode>):void
		{
			var $materialCubeMap:MaterialCubeMap=	CubeMapManager.getInstance().getCubeMapByUrl(AppData.workSpaceUrl+Scene_data.light.SkyBoxUrl)	
			if($materialCubeMap){
				_cubeMapSkyBoxUrl=$materialCubeMap.textureName0
			}else{
				_cubeMapSkyBoxUrl=""
			}
			_listArr=$arr
				
			addBackInfo();
			sendEditorType();
			
			RenderMathPointLigth.getInstance().mathLihtItem($arr);
			
		
			makeGroundUrl(); //生存地面贴图图片。并记录下图片地地址 
			_cFileByte=new ByteArray();
			if(this.useLittleEncode){
				_cFileByte.endian = Endian.LITTLE_ENDIAN;
			}
			makeTextBye($arr)   //统计所有图片地址
			makeObjData($arr)   //创建立建筑物模型字节 
			makeLightProbeData($arr)  //LightProbe
			makeParallelLight($arr)   //ParallelLight
			makeAmbientLight();       //换进参数
			saveCfile();
			
		}
		
		private function saveCfile():void
		{
			var $fs:FileStream = new FileStream;
			var $mapFile:File=new File(AppData.workSpaceUrl + AppData.mapUrl);
			$fs.open(new File($mapFile.url.replace("."+$mapFile.extension,".c")),FileMode.WRITE);
			$fs.writeBytes(_cFileByte,0,_cFileByte.length)
			$fs.close();
			
		}

		private function makeParallelLight($arr:Vector.<FileNode>):void
		{
			var paralleLightItem:Vector.<HierarchyFileNode>=new Vector.<HierarchyFileNode>
			for(var u:uint=0;u<$arr.length;u++){
				var $hierarchyFileNode:HierarchyFileNode=$arr[u] as HierarchyFileNode ;
				if($hierarchyFileNode.type==HierarchyNodeType.ParallelLight){
					paralleLightItem.push($hierarchyFileNode)
				}
			}
			var $byte:ByteArray=new ByteArray
			$byte.writeInt(paralleLightItem.length)
			for(var v:uint=0;v<paralleLightItem.length;v++){
				var $tempMesh:ParallelLightStaticMesh=paralleLightItem[v].data as ParallelLightStaticMesh
				var $tempImode:IModel=paralleLightItem[v].iModel
				$byte.writeInt($tempMesh.color)//$nodeId
				$byte.writeFloat($tempMesh.strong)//$nodeId
				var $nrm:Vector3D=new Vector3D(0,-1,0)
				var $m:Matrix3D=new Matrix3D
				$m.prependRotation($tempImode.rotationZ , Vector3D.Z_AXIS);
				$m.prependRotation($tempImode.rotationY , Vector3D.Y_AXIS);
				$m.prependRotation($tempImode.rotationX , Vector3D.X_AXIS);
				$nrm=$m.transformVector($nrm)
				var $nrmObj:Object=new Object
				$nrmObj.x=$nrm.x
				$nrmObj.y=$nrm.y
				$nrmObj.z=$nrm.z
				$byte.writeObject($nrmObj)	
			}
			pushByteToCfile($byte,RenderSocketType.MAKEPARALLELLIGHT)
			sendMsg($byte,RenderSocketType.MAKEPARALLELLIGHT);
			
		}
		/**
		 * LightProbe
		 * @param $arr
		 * 
		 */
		private function makeLightProbeData($arr:Vector.<FileNode>):void
		{
			var $hierarchyFileNode:HierarchyFileNode
			var $item:Vector.<HierarchyFileNode>=new Vector.<HierarchyFileNode>
			var $buildMesh:BuildMesh
			var $objectData:ObjData=MakeModelData.makeJuXinTampData(new Vector3D(-1,0,-1),new Vector3D(1,0,1))
			

			var $probeMeshItem:Vector.<LightProbeStaticMesh>=new Vector.<LightProbeStaticMesh>
			var $idItem:Vector.<HierarchyFileNode>=new Vector.<HierarchyFileNode>
			for(var u:uint=0;u<$arr.length;u++){
				$hierarchyFileNode=$arr[u] as HierarchyFileNode ;
				if($hierarchyFileNode.type==HierarchyNodeType.LightProbe){
					$probeMeshItem.push(LightProbeStaticMesh($hierarchyFileNode.data))
					$idItem.push($hierarchyFileNode)
				}
			}
			var $byte:ByteArray=new ByteArray
			$byte.writeInt($probeMeshItem.length)
			for(var v:uint=0;v<$probeMeshItem.length;v++){
				var $tempMesh:LightProbeStaticMesh=$probeMeshItem[v]
				$byte.writeInt($idItem[v].id)//$nodeId
				$byte.writeInt($tempMesh.posItem.length)
				$byte.writeInt($tempMesh.posItem[0].length)
				$byte.writeInt($tempMesh.posItem[0][0].length)
				for(var i:uint=0;i<$tempMesh.posItem.length;i++){
					for(var j:uint=0;j<$tempMesh.posItem[i].length;j++){
						for(var k:uint=0;k<$tempMesh.posItem[i][j].length;k++){
				
							var $MeshToObj:Object=LightProbeTempStaticMesh($tempMesh.posItem[i][j][k]).readObject()
							var basePos:Vector3D=new Vector3D($idItem[v].iModel.x,$idItem[v].iModel.y,$idItem[v].iModel.z)
								
							$MeshToObj.postion=basePos.add($MeshToObj.postion)
							var $m:Matrix3D=new Matrix3D
							$m.appendTranslation($MeshToObj.postion.x,$MeshToObj.postion.y,$MeshToObj.postion.z)
							$byte.writeObject(RenderMathPointLigth.getInstance().getModelHaseLightArr($objectData,$m))
							$byte.writeObject($MeshToObj)
						}
					}
				}
			}
			pushByteToCfile($byte,RenderSocketType.MAKELIGHTPROBE)
			sendMsg($byte,RenderSocketType.MAKELIGHTPROBE);

			
		}
		
		/**
		 * 打开显示面板初始化
		 * 
		 */
		private function addBackInfo():void
		{
			
				RadiostiyInfoWindow.getInstance().initRadiostiyPanel()
			
			
		}
		
		/**
		 *发送编辑属性 
		 * 
		 */
		private function sendEditorType():void
		{
			var $byte:ByteArray=new ByteArray
			$byte.writeInt(1)
			sendMsg($byte,RenderSocketType.SENDEDITORTYPE);
			
		}
		
		/**
		 *计算场景环境灯光信息 
		 * 
		 */
		private function makeAmbientLight():void
		{

			
			var $byte:ByteArray=new ByteArray
			var nrmVector:Vector3D=Scene_data.light.SunLigth.dircet.clone()
			nrmVector.normalize()
			$byte.writeFloat(nrmVector.x)
			$byte.writeFloat(nrmVector.y)
			$byte.writeFloat(nrmVector.z)
				
			$byte.writeFloat(Scene_data.light.SunLigth.color.x)
			$byte.writeFloat(Scene_data.light.SunLigth.color.y)
			$byte.writeFloat(Scene_data.light.SunLigth.color.z)
				
			$byte.writeFloat(Scene_data.light.AmbientLight.color.x)
			$byte.writeFloat(Scene_data.light.AmbientLight.color.y)
			$byte.writeFloat(Scene_data.light.AmbientLight.color.z)

			$byte.writeFloat(Scene_data.light.SunLigth.intensity)
			$byte.writeFloat(Scene_data.light.AmbientLight.intensity)
			$byte.writeFloat(Scene_data.light.Zhenqiang)
			$byte.writeFloat(Scene_data.light.Yanseyichu)
			$byte.writeFloat(Scene_data.light.Shuaijian)

			$byte.writeFloat(Scene_data.light.patchPrecision)
			$byte.writeFloat(Scene_data.light.lightPassNum)
			$byte.writeFloat(Scene_data.light.shadowIntensity)
				
	
			$byte.writeUTF(_cubeMapSkyBoxUrl)
			pushByteToCfile($byte,RenderSocketType.MAKEAMBIENTLIGHT)
			sendMsg($byte,RenderSocketType.MAKEAMBIENTLIGHT);
			
		}
		/**
		 *创建立建筑物模型字节 
		 * @param $arr
		 * 
		 */
		private function makeObjData($arr:Vector.<FileNode>):void
		{
			var $hierarchyFileNode:HierarchyFileNode
			var $item:Vector.<HierarchyFileNode>=new Vector.<HierarchyFileNode>
			var $buildMesh:BuildMesh
			for(var i:uint=0;i<$arr.length;i++){
				$hierarchyFileNode=$arr[i] as HierarchyFileNode ;
				if($hierarchyFileNode.type==HierarchyNodeType.Prefab){
					$buildMesh=BuildMesh($hierarchyFileNode.data)
					if($buildMesh&&$buildMesh.isNotCook){
						$item.push($hierarchyFileNode)
					}
				
				}
			}
			var $byte:ByteArray=new ByteArray;
			if(this.useLittleEncode){
				$byte.endian =Endian.LITTLE_ENDIAN;
			}
			if(GroundData.showTerrain)
			{//有地面
				$byte.writeInt($item.length+GroundManager.getInstance().groundItem.length)
				writerGroundObj($byte)
			}else{
				$byte.writeInt($item.length)
			
			}
			
			
			for(var j:uint=0;j<$item.length;j++){
				$hierarchyFileNode=	$item[j]
				$buildMesh=BuildMesh($hierarchyFileNode.data)
				var $imode:IModel=$hierarchyFileNode.iModel
				var $objectData:Object=$imode.readObject
	
				if(!$objectData){   //当没有模型数据信息时
					Alert.show($hierarchyFileNode.name+"没有模型")
					stopRender()
					return 
				}
				$byte.writeInt($hierarchyFileNode.type)   //类形
				$byte.writeInt($hierarchyFileNode.id)    //id
				$byte.writeUTF("build"+String($hierarchyFileNode.id))
					
			
					
				var $proxyPan3dModel:Object=$hierarchyFileNode.iModel 
				var $sprite:Display3DMaterialSprite=$proxyPan3dModel.sprite  as Display3DMaterialSprite
				var $fileUrl:String=$sprite.material.getMainTexUrl()
				var $backCull:Boolean=$sprite.material.backCull
				$byte.writeInt($buildMesh.lightMapSize)
				$byte.writeInt($buildMesh.lightBlur)
	
				$byte.writeUTF($buildMesh.prefabStaticMesh.axoFileName)  //模型地址
				$byte.writeUTF($fileUrl)
					
				$byte.writeFloat($sprite.material.killNum)  //killnum
				$byte.writeBoolean($backCull)//正反面
				$byte.writeBoolean($buildMesh.lightProbe)//lightProbe
	
				$byte.writeBoolean(false)//不是地面
			
				
				$byte.writeFloat($imode.x)
				$byte.writeFloat($imode.y)
				$byte.writeFloat($imode.z)
				$byte.writeFloat($imode.rotationX)
				$byte.writeFloat($imode.rotationY)
				$byte.writeFloat($imode.rotationZ)
				$byte.writeFloat($imode.scaleX)
				$byte.writeFloat($imode.scaleY)
				$byte.writeFloat($imode.scaleZ)
				
				$byte.writeObject(RenderMathPointLigth.getInstance().getModelHaseLightArr($objectData,	$sprite.posMatrix))
					
				$byte.writeObject($objectData)
				
			}
			pushByteToCfile($byte,RenderSocketType.MAKEOBJDATA)
			sendMsg($byte,RenderSocketType.MAKEOBJDATA);
			

		}
		/**
		 *写入地面模型数据 
		 * @param $byte
		 * 
		 */
		private function writerGroundObj($byte:ByteArray):void
		{
			for (var i:uint=0;i< GroundManager.getInstance().groundItem.length;i++)
			{
				var $imode:IGround=GroundManager.getInstance().groundItem[i];
				var $url:String=TerrainEditorData.fileRoot+i+".jpg";
				$url=(decodeURI($url));
				$url=$url.replace(AppData.workSpaceUrl,"");
				$byte.writeInt(HierarchyNodeType.Prefab)
				$byte.writeInt(i)    //id
				$byte.writeUTF("ground"+String(i))   //uid
				$byte.writeInt(TerrainEditorData.lightMapSize)
				$byte.writeInt(GroundData.lightBlur)//lightBlur=3
				$byte.writeUTF("ground"+i)   //模型地焉
				$byte.writeUTF($url)   //urljpg
					
				$byte.writeFloat(0)  //killnum
				$byte.writeBoolean(true) //双面显示
				$byte.writeBoolean(false)//lightProbe
				$byte.writeBoolean(true)//是地面
				$byte.writeInt($imode.cellX)
				$byte.writeInt($imode.cellZ)
			
					
				$byte.writeFloat($imode.x)
				$byte.writeFloat($imode.y)
				$byte.writeFloat($imode.z)
				$byte.writeFloat($imode.rotationX)
				$byte.writeFloat($imode.rotationY)
				$byte.writeFloat($imode.rotationZ)
				$byte.writeFloat($imode.scaleX)
				$byte.writeFloat($imode.scaleY)
				$byte.writeFloat($imode.scaleZ)
					
				var sprite:GroundEditorSprite=Object($imode).ground;
				GroundMath.getInstance().mathIndexNode(sprite.terrainData,2,new Vector3D,2);
				mathNrmForBmp(sprite.terrainData)
				var $objectData:Object=new Object;
				$objectData.vertices=sprite.terrainData.vertices;
				$objectData.normals=sprite.terrainData.normals;
				$objectData.uvs=sprite.terrainData.uvs;
				$objectData.lightUvs=sprite.terrainData.uvs;
				$objectData.indexs=sprite.terrainData.indexs;
				var kkkkkkkk:Array=RenderMathPointLigth.getInstance().getModelHaseLightArr($objectData,sprite.posMatrix)
				$byte.writeObject(RenderMathPointLigth.getInstance().getModelHaseLightArr($objectData,sprite.posMatrix))
				$byte.writeObject($objectData);
			}
		}
		/**
		 *重得计划地面的法线 
		 * @param $terrainData
		 * 
		 */
		private static function mathNrmForBmp($terrainData:TerrainData):void
		{
			for(var i:uint=0;i<$terrainData.vertices.length/3;i++){
				var p:Vector3D=new Vector3D($terrainData.vertices[i*3+0],0,$terrainData.vertices[i*3+2]);
				p.scaleBy(1/$terrainData.area_Size*$terrainData.area_Cell_Num)
				var c:Vector3D=MathCore.hexToArgbNum($terrainData.normalMap.getPixel(p.x,p.z))
				c=c.subtract(new Vector3D(0.5,0.5,0.5))	
				c.normalize()
				$terrainData.normals[i*3+0]=c.x
				$terrainData.normals[i*3+1]=c.y
				$terrainData.normals[i*3+2]=c.z
			}
		}
		private var _groundMateriaUrlArr:Array=new Array
		/**
		 *生存地面贴图图片。并记录下图片地地址 
		 * 
		 */
		private function makeGroundUrl():void
		{
		
		
			var idNum:uint=0
			for each(var $IGround:IGround in GroundManager.getInstance().groundItem)
			{
				var $sprite:Object=$IGround 
				$sprite.lightMapTexture=null
				$sprite.scanQuickTexture()
				var $bmp:BitmapData=$sprite.ground.quickBitmapData.clone()
				var $url:String=TerrainEditorData.fileRoot+idNum+".jpg"
				$url=(decodeURI($url))
				FileSaveModel.getInstance().saveBitmapdataToJpg($bmp,$url)
				$url=$url.replace(AppData.workSpaceUrl,"")
				_groundMateriaUrlArr.push($url)
				idNum++;

			}
			trace("地面生存图片....")
		}

		/**
		 *统计场景纹理路径 
		 * @param $arr
		 * @return 
		 * 
		 */
		private function makeTextBye($arr:Vector.<FileNode>):ByteArray
		{
			var $item:Vector.<HierarchyFileNode>=new Vector.<HierarchyFileNode>
			var $urlItem:Array=new Array
			for(var i:uint=0;i<$arr.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=$arr[i] as HierarchyFileNode ;
				if($hierarchyFileNode.type==HierarchyNodeType.Prefab){
					
					var $proxyPan3dModel:Object=$hierarchyFileNode.iModel
					if($proxyPan3dModel&&$proxyPan3dModel.sprite){
						var $sprite:Display3DMaterialSprite=$proxyPan3dModel.sprite  as Display3DMaterialSprite
						if($sprite.material){
							var $fileUrl:String=$sprite.material.getMainTexUrl()
							var $tempFile:File=new File(AppData.workSpaceUrl+$fileUrl)
							if($tempFile.exists){
								$urlItem.push($fileUrl)
							}
						}
					}
				}
			}
			$urlItem=$urlItem.concat(_groundMateriaUrlArr)
			if(_cubeMapSkyBoxUrl){
				$urlItem.push(_cubeMapSkyBoxUrl)
			}
			$urlItem=storUrlItem($urlItem)
				
			var $fs:FileStream = new FileStream;
			var $byte:ByteArray=new ByteArray;
			if(this.useLittleEncode){
				$byte.endian = Endian.LITTLE_ENDIAN;
			}
			$byte.writeInt($urlItem.length)
			for(var j:uint=0;j<$urlItem.length;j++){
				var $file:File=new File(AppData.workSpaceUrl+$urlItem[j])
				if($file.exists){
					$fs.open($file,FileMode.READ);
					var $by:ByteArray=new ByteArray
					if(this.useLittleEncode){
						$by.endian = Endian.LITTLE_ENDIAN;
					}
					$fs.readBytes($by,0,$fs.bytesAvailable)
					$byte.writeUTF($urlItem[j])
					$byte.writeInt($by.length)
					$byte.writeBytes($by);
				}
			}

			pushByteToCfile($byte,RenderSocketType.MAKETEXTBYE)

			sendMsg($byte,RenderSocketType.MAKETEXTBYE);
			return $byte
		}
		private function pushByteToCfile($byte:ByteArray,$type:uint):void
		{
			_cFileByte.writeInt($type);
			_cFileByte.writeInt($byte.length);
			_cFileByte.writeBytes($byte,0,$byte.length);
	
		}
		/**
		 *删除重复的图片地址 
		 * @param $urlItem
		 * @return 
		 * 
		 */
		private function storUrlItem($urlItem:Array):Array
		{
			var arr:Array=new Array
			for(var i:uint=0;i<$urlItem.length;i++)
			{
				var needAdd:Boolean=true
				for(var j:uint=0;j<arr.length;j++)
				{
					if(arr[j]==$urlItem[i]){
						needAdd=false
					}
				}
				if(needAdd){
					arr.push($urlItem[i])
				}
			}
			return arr
		}
		public var isRadiosity:Boolean=true//渲染或导出H5数据
		private function sendMsg(msgByte:ByteArray,msgId:uint):void
		{
			trace((msgByte.length/1024/1024) + "MB");
			var byte:ByteArray = new ByteArray;
			var length:int = msgByte.length + 4;
			byte.writeInt(length);
			byte.writeInt(msgId);
			byte.writeBytes(msgByte);
			
			
			NetManager.getInstance().setMsg(byte)
			
			
		}
		
	}
}