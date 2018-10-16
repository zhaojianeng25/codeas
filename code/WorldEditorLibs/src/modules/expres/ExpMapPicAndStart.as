package modules.expres
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Program3D;
	import flash.display3D.textures.RectangleTexture;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import PanV2.TextureCreate;
	
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.display3D.water.ScanWaterHightMapShader;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.scene.SceneContext;
	
	import _me.Scene_data;
	
	import common.msg.event.projectSave.MEvent_ProjectData;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	
	import modules.hierarchy.FileSaveModel;
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	
	import navMesh.NavMeshStaticMesh;
	
	import pack.BuildMesh;
	
	import proxy.pan3d.ground.ProxyPan3dGround;
	import proxy.pan3d.model.ProxyPan3dModel;
	import proxy.top.ground.IGround;
	
	import render.build.BuildManager;
	import render.ground.GroundManager;
	
	import terrain.GroundData;

	public class ExpMapPicAndStart
	{
		public function ExpMapPicAndStart()
		{
		}
		private static var instance:ExpMapPicAndStart;
		public static function getInstance():ExpMapPicAndStart{
			if(!instance){
				instance = new ExpMapPicAndStart();
			}
			return instance;
		}
		private function saveToFile():void
		{
			var $item:Vector.<FileNode>=FileNodeManage.getListAllFileNode(BuildManager.getInstance().listArr)
			var  $navMeshStaticMesh:NavMeshStaticMesh
			for(var i:uint=0;i<$item.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=$item[i] as HierarchyFileNode ;
				if($hierarchyFileNode.type==HierarchyNodeType.NavMesh){
					$navMeshStaticMesh=	   $hierarchyFileNode.data as NavMeshStaticMesh;
				}
			}
			if($navMeshStaticMesh){
				var wwwww: Number = $navMeshStaticMesh.astarItem.length
				var hhhhh: Number = $navMeshStaticMesh.astarItem[0].length
					
					
				var tw:Number=$navMeshStaticMesh.aPos.x+ wwwww*$navMeshStaticMesh.midu
				var th:Number=$navMeshStaticMesh.aPos.z+ hhhhh*$navMeshStaticMesh.midu
				
				tw=Math.max(Math.abs($navMeshStaticMesh.aPos.x)	,Math.abs(tw))
				th=Math.max(Math.abs($navMeshStaticMesh.aPos.z)	,Math.abs(th))
				var bsew:Number=Math.max(tw,th)
				bsew+=100
				bsew=Math.round(bsew)
				var $infoRect:Rectangle=new Rectangle();
				$infoRect.x=-bsew;
				$infoRect.y=-bsew;
				$infoRect.width=bsew*2;
				$infoRect.height=bsew*2;
				
	
			
				this.scanGroundHigth($infoRect);
			}else{
				Alert.show("没有A星数据")
			}
		}
	
		

		public function  scanPic():void
		{
	
		    this.saveToFile()
		}
		private var _infoRect:Rectangle;
		private var _hightRectInfo:Rectangle;

		private var scanHeightNum:Number=800
		public function scanGroundHigth($infoRect:Rectangle,$rotation:Number=0):void
		{
		
			_hightRectInfo=$infoRect.clone()
			_hightRectInfo.x-=1;
			_hightRectInfo.y-=1;
			_hightRectInfo.width+=2;
			_hightRectInfo.height+=2;
			

			
			var $w:uint=1024;
			var $pos:Vector3D=new Vector3D(_hightRectInfo.x+_hightRectInfo.width/2,scanHeightNum/2,_hightRectInfo.y+_hightRectInfo.height/2,scanHeightNum);
			var $rect:Rectangle=new Rectangle(0,0,_hightRectInfo.width/2,_hightRectInfo.height/2);
			var _dephtBmp:BitmapData=this.scanGroundAndBuildHightMap($pos,$rect,Math.max($w,64),$rotation);
			//ShowMc.getInstance().setBitMapData(_dephtBmp)
				
				
			var $outBmp:BitmapData=new BitmapData(_hightRectInfo.width/2,_hightRectInfo.height/2);
			var $m:Matrix=new Matrix();
			$m.scale($outBmp.width/_dephtBmp.width,-$outBmp.height/_dephtBmp.height);
			$m.ty=$outBmp.height;
			
			$outBmp.draw(_dephtBmp,$m);

			var saveFileUrl:String=File.desktopDirectory.url+"/min.jpg"
			FileSaveModel.getInstance().saveBitmapdataToJpg($outBmp,saveFileUrl);

			//Alert.show(decodeURI(saveFileUrl),"导出成功");
		
			Alert.show("生存小图完成， 注意是否要将配置数据也存到场景中，方便下次使用","提示!",3,null,enterFun)
			function enterFun(event:CloseEvent):void
			{
				if(event.detail==Alert.YES)
				{
					ModuleEventManager.dispatchEvent(new MEvent_ProjectData(MEvent_ProjectData.PROJECT_SAVE));
				}
			}

		
		}
		private  function scanGroundAndBuildHightMap($pos:Vector3D,$rect:Rectangle,$textureSize:Number,$rotation:Number=0):BitmapData
		{
			var $arr:Vector.<Display3DSprite>;
			
			$arr=getScanModelItem();

			
			return this.scanHightBitmap($pos,$rect,$textureSize,$arr,$rotation)
			
			
		}
		private var _colorTexture:RectangleTexture
		private var _dephTexture:RectangleTexture
		private  function scanHightBitmap($pos:Vector3D,$rect:Rectangle,$textureSize:Number,$arr:Vector.<Display3DSprite>,$rotation:Number=0):BitmapData
		{
			var $context3D:Context3D=Scene_data.context3D
			
			var $bmpW:uint=Math.max(50,int($textureSize*$rect.width/100))
			var $bmpH:uint=Math.max(50,int($textureSize*$rect.height/100))
			$bmpW=$textureSize
			$bmpH=$textureSize
			var bmp:BitmapData=	new BitmapData($bmpW,$bmpH,false,Math.random()*0xffffff)
			
			
			if(_colorTexture){
				_colorTexture.dispose()
			}
			if(_dephTexture){
				_dephTexture.dispose()
			}
			_colorTexture=TextureCreate.getInstance().bitmapToRectangleTexture(new BitmapData($bmpW,$bmpH,true,0xffff0000*Math.random()))
			_dephTexture=TextureCreate.getInstance().bitmapToRectangleTexture(new BitmapData($bmpW,$bmpH,false,0xff006c00))
			
	
			
			$context3D.configureBackBuffer(bmp.width, bmp.height,0, true);
			$context3D.clear(1,1,1,1)
			
			Program3DManager.getInstance().registe(ScanWaterHightMapShader.SCAN_WATER_HIGHT_MAP_SHADER,ScanWaterHightMapShader)
			var program:Program3D=Program3DManager.getInstance().getProgram(ScanWaterHightMapShader.SCAN_WATER_HIGHT_MAP_SHADER)
			
			var viewMatrx3D:Matrix3D=new Matrix3D
			viewMatrx3D.appendScale(1/$rect.width,-1/$rect.height,1/$pos.w)
			
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewMatrx3D, true);
			
			
			var cameraMatrix:Matrix3D=new Matrix3D
			cameraMatrix.prependTranslation(-$pos.x, -($pos.y),-$pos.z);
			cameraMatrix.appendRotation(-90, Vector3D.X_AXIS);
			
			var rotationM:Matrix3D=new Matrix3D
			rotationM.appendRotation($rotation, Vector3D.Z_AXIS);
			
			cameraMatrix.append(rotationM)
			
			
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, cameraMatrix, true);
			$context3D.setDepthTest(true,Context3DCompareMode.LESS);
			$context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
			$context3D.setCulling(Context3DTriangleFace.NONE);
			

			SceneContext.sceneRender.groundlevel.updata();
			
			SceneContext.sceneRender.modelLevel.updata();

	
			
			$context3D.drawToBitmapData(bmp)
				
				
				
			$context3D.configureBackBuffer(Scene_data.stage3DVO.width, Scene_data.stage3DVO.height,0, true);
			return bmp
		}
		
		private  function getScanModelItem():Vector.<Display3DSprite>
		{
			var $arr:Vector.<Display3DSprite>=new Vector.<Display3DSprite>
			
			for each(var $IGround:IGround in GroundManager.getInstance().groundItem)
			{
				var $sprite:ProxyPan3dGround=ProxyPan3dGround($IGround )
				
				if(GroundData.showTerrain){
					$arr.push($sprite.ground)
				}
				
			}
			var $item:Vector.<FileNode>=FileNodeManage.getListAllFileNode(BuildManager.getInstance().listArr)
			for(var i:uint=0;i<$item.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=$item[i] as HierarchyFileNode ;
				if($hierarchyFileNode.type==HierarchyNodeType.Prefab){
					
					var $buildMesh:BuildMesh=$hierarchyFileNode.data as BuildMesh
					var $proxyPan3dModel:ProxyPan3dModel=$hierarchyFileNode.iModel as ProxyPan3dModel
					
					if($buildMesh.isGround){
						if($proxyPan3dModel&&$proxyPan3dModel.sprite){
							$arr.push($proxyPan3dModel.sprite)
						}
					}else{
						
						
						if($proxyPan3dModel.sprite.objData){
					
							$arr.push($proxyPan3dModel.sprite)
						}
						
						
					}
					
				}
			}
			
			return $arr
		}
	}
}