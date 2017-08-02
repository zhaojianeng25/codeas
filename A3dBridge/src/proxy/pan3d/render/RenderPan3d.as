package proxy.pan3d.render
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.textures.RectangleTexture;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import PanV2.SelectModelMath;
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.ObjData;
	import _Pan3D.core.MathClass;
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.Display3DMaterialSprite;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.display3D.Display3dCubeMap;
	import _Pan3D.display3D.capture.Display3DCaptureSprite;
	import _Pan3D.display3D.grass.GrassEditorDisplay3DSprite;
	import _Pan3D.display3D.ground.GroundEditorSprite;
	import _Pan3D.display3D.light.Display3DLightSprite;
	import _Pan3D.display3D.lightProbe.Display3DLightProbeSprite;
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.display3D.navMesh.NavMeshDisplay3DSprite;
	import _Pan3D.display3D.parallel.Dispaly3DParallelLightSpreit;
	import _Pan3D.display3D.particle.ParticleHitBoxSprite;
	import _Pan3D.display3D.reflection.Display3DReflectionSprite;
	import _Pan3D.display3D.water.Display3DWaterSprite;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.scene.SceneContext;
	import _Pan3D.utils.materialShow.BuildShowModel;
	
	import _me.Scene_data;
	
	import capture.CaptureStaticMesh;
	
	import grass.GrassStaticMesh;
	
	import light.LightProbeStaticMesh;
	import light.LightStaticMesh;
	import light.ParallelLightStaticMesh;
	import light.ReflectionStaticMesh;
	
	import materials.MaterialTree;
	import materials.Texture2DMesh;
	
	import mode3d.Model3DStaticMesh;
	
	import navMesh.NavMeshStaticMesh;
	
	import pack.PrefabStaticMesh;
	
	import particle.ParticleStaticMesh;
	
	import proxy.pan3d.capture.ProxyPan3dCapture;
	import proxy.pan3d.grass.ProxyPan3dGrass;
	import proxy.pan3d.ground.ProxyPan3dGround;
	import proxy.pan3d.light.ProxyPan3DLightProbe;
	import proxy.pan3d.light.ProxyPan3DParallelLight;
	import proxy.pan3d.light.ProxyPan3DTempLightProbe;
	import proxy.pan3d.light.ProxyPan3dLight;
	import proxy.pan3d.model.ProxyPan3dModel;
	import proxy.pan3d.model.ProxyPan3dSky;
	import proxy.pan3d.navMesh.ProxyPan3dNavMesh;
	import proxy.pan3d.particle.ProxyPan3DParticle;
	import proxy.pan3d.reFlection.ProxyPan3dReflection;
	import proxy.pan3d.roles.ProxyPan3DRole;
	import proxy.pan3d.water.ProxyPan3dWater;
	import proxy.top.grass.IGrass;
	import proxy.top.ground.IGround;
	import proxy.top.model.ICapture;
	import proxy.top.model.ILight;
	import proxy.top.model.ILightProbe;
	import proxy.top.model.IModel;
	import proxy.top.model.INavMesh;
	import proxy.top.model.IParallelLight;
	import proxy.top.model.IParticle;
	import proxy.top.model.IReflection;
	import proxy.top.model.ISky;
	import proxy.top.model.IWater;
	import proxy.top.render.IRender;
	
	import roles.RoleStaticMesh;
	
	import terrain.TerrainData;
	
	import water.WaterStaticMesh;
	
	import xyz.MoveScaleRotationLevel;

	public class RenderPan3d implements IRender
	{
		public function RenderPan3d()
		{
			
		}
		
		public function mapEarthFun($class:Object, $fun:Object, $data:Object,$bFun:Function):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function deleAmaniFile($obj:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function creatAmaniFile($name:String, typeStr:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function creatParticle($particleStaticMesh:ParticleStaticMesh):IParticle
		{

			var $modelSprite:CombineParticle = ParticleManager.getInstance().getParticle(Scene_data.fileRoot+$particleStaticMesh.url);
			
			var $hitSprite:ParticleHitBoxSprite=SceneContext.creatParticleHitModel()
			var $proxyPan3DParticle:ProxyPan3DParticle = new ProxyPan3DParticle;
			$proxyPan3DParticle.sprite=$hitSprite;
			$proxyPan3DParticle.particleSprite=$modelSprite
			$proxyPan3DParticle.particleStaticMesh=$particleStaticMesh;
				
			ParticleManager.getInstance().addParticle($modelSprite);
			_iModeItem.push($proxyPan3DParticle)
			return $proxyPan3DParticle;
			
		}
		public function creatRole($roleStaticMesh:RoleStaticMesh):IModel
		{
			var $ProxyPan3DRole:ProxyPan3DRole = new ProxyPan3DRole;
			$ProxyPan3DRole.sprite=SceneContext.creatRoleModel()
			$ProxyPan3DRole.roleStaticMesh=$roleStaticMesh;
		
			return $ProxyPan3DRole;
		}
		
		
		public function creatParallelLight($parallelLightStaticMesh:ParallelLightStaticMesh):IParallelLight
		{

			var $modelSprite:Dispaly3DParallelLightSpreit=SceneContext.creatParallelLightModel()
			var $proxyPan3dReflection:ProxyPan3DParallelLight = new ProxyPan3DParallelLight
			$modelSprite.colorVec=MathCore.hexToArgbNum($parallelLightStaticMesh.color)
				
				
			$modelSprite.x=$parallelLightStaticMesh.postion.x
			$modelSprite.y=$parallelLightStaticMesh.postion.y
			$modelSprite.z=$parallelLightStaticMesh.postion.z
				
			$proxyPan3dReflection.sprite=$modelSprite
			$proxyPan3dReflection.parallelLightStaticMesh=$parallelLightStaticMesh
			_iModeItem.push($proxyPan3dReflection)
			return $proxyPan3dReflection;
			
			
			return null;
		}
		
		
		public function set selectModelFun(value:Function):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function mouseClick(event:MouseEvent):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function getMouseHitLightProbeModel($mouse:Point):IModel
		{
			var $arr:Vector.<Display3DSprite>=new Vector.<Display3DSprite>
			var $tempLightArr:Vector.<ProxyPan3DTempLightProbe>=new Vector.<ProxyPan3DTempLightProbe>
			for(var i:uint=0;i<proxyLightProbeItem.length;i++){
				var $display3DLightProbeSprite:Display3DLightProbeSprite=proxyLightProbeItem[i].sprite
				for(var j:uint=0;j<$display3DLightProbeSprite.ballItem.length;j++)
				{
					$arr.push($display3DLightProbeSprite.ballItem[j])
					$tempLightArr.push(proxyLightProbeItem[i].lightProbeTempItem[j])
				}
			}
			var hitID:uint=SelectModelMath.scanHitModel($arr,$mouse)
			if(hitID<$tempLightArr.length){
				return $tempLightArr[hitID]
			}
			return null;

		}
		
		private var proxyLightProbeItem:Vector.<ProxyPan3DLightProbe>=new Vector.<ProxyPan3DLightProbe>
		//private var _proxyPan3DLightProbe:ProxyPan3DLightProbe
		public function resetLightProbel($lightProBelMesh:LightProbeStaticMesh):ILightProbe
		{
			var $display3DLightProbeSprite:Display3DLightProbeSprite=SceneContext.creatLightProbeModel()
			var _proxyPan3DLightProbe:ProxyPan3DLightProbe= new ProxyPan3DLightProbe
			_proxyPan3DLightProbe.sprite=$display3DLightProbeSprite
			_proxyPan3DLightProbe.lightProbeMesh=$lightProBelMesh
				
			proxyLightProbeItem.push(_proxyPan3DLightProbe)
			return _proxyPan3DLightProbe;
		
			
		}

		public function changeTexture2DData($texture2DMesh:Texture2DMesh):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function creatReFlectionModel($reFlectionMesh:ReflectionStaticMesh, $id:int):IReflection
		{
			var $modelSprite:Display3DReflectionSprite=SceneContext.creatReflectionModel()
			$modelSprite.url=$reFlectionMesh.url
			var $proxyPan3dReflection:ProxyPan3dReflection = new ProxyPan3dReflection
			$proxyPan3dReflection.sprite=$modelSprite
			$proxyPan3dReflection.reFlectionMesh=$reFlectionMesh
			_iModeItem.push($proxyPan3dReflection)
			return $proxyPan3dReflection;
			
			
			return null;
		}
		
		
		public function creatCaptureModel($captureMesh:CaptureStaticMesh, $id:int):ICapture
		{
			
			var $modelSprite:Display3DCaptureSprite=SceneContext.creatCaptureModel()
			$modelSprite.url=$captureMesh.url
			var $proxyPan3dModel:ProxyPan3dCapture = new ProxyPan3dCapture
			$proxyPan3dModel.sprite=$modelSprite
			$proxyPan3dModel.captureMesh=$captureMesh
			_iModeItem.push($proxyPan3dModel)
			return $proxyPan3dModel;
		}
		
		
		public function chooseTexture2DFolderUrl($texture2DMesh:Texture2DMesh, $urlArr:Array):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function creatGrassModel($grassMesh:GrassStaticMesh):IGrass
		{
			var $grassEditorDisplay3DSprite:GrassEditorDisplay3DSprite=SceneContext.creaGrass();
			//var $objsUrl:String=Scene_data.fileRoot+"xFile/moba_dae/Tree_Pine_1_1.objs"
			var $objsUrl:String=Scene_data.fileRoot+$grassMesh.modeUrl
			$grassEditorDisplay3DSprite.faceAtlook=$grassMesh.faceAtlook
			$grassEditorDisplay3DSprite.url=$objsUrl
			$grassEditorDisplay3DSprite.setGrassInfoItem($grassMesh.grassArr)
				
				
			$grassEditorDisplay3DSprite.material=MaterialTree($grassMesh.material)
			var $proxyPan3dGrass:ProxyPan3dGrass=new ProxyPan3dGrass
			$proxyPan3dGrass.sprite=$grassEditorDisplay3DSprite
			$proxyPan3dGrass.grassMesh=$grassMesh
			return $proxyPan3dGrass;
		}
		
		
		public function getObject3DXFileRange(csvId:int, bFun:Function):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function creatSky($url:String, $cubeMapUrl:String):ISky
		{
			var $sky:Display3dCubeMap=SceneContext.creatSky($url,$cubeMapUrl);
			var $proxyPan3dSky:ProxyPan3dSky = new ProxyPan3dSky;
			$proxyPan3dSky.display = $sky;
			$proxyPan3dSky.url = $url;
			$proxyPan3dSky.cubeMapUrl = $cubeMapUrl;
			return $proxyPan3dSky;
		}
		
		
		public function drawScreenToBitmapData(bFun:Function):BitmapData
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		
		public function getTypeList($type:int):Array
		{
			return null;
		}
		
		public function init():void
		{
			SceneContext.gemoUpDataFun=MoveScaleRotationLevel.getInstance().upData
		}
		private var _iModeItem:Vector.<IModel>=new Vector.<IModel>
		public function creatDisplay3DModel($prefab:PrefabStaticMesh,$bfun:Function):IModel
		{
			var $preFabMesh:PrefabStaticMesh=$prefab as PrefabStaticMesh
			var $modelSprite:Display3DModelSprite=SceneContext.creatModel()
			var $proxyPan3dModel:ProxyPan3dModel = new ProxyPan3dModel;
			$proxyPan3dModel.sprite=Display3DMaterialSprite($modelSprite)
			$proxyPan3dModel.prefab=$prefab
				
			_iModeItem.push($proxyPan3dModel)
			return $proxyPan3dModel;
		}
		public function changeStage3DView($x:int, $y:int, $w:int, $h:int):void
		{
			SceneContext.changeStage3DView($x,$y,$w,$h);
	
		}
		

		public function creatGround($terrainData:TerrainData, $sixteenUvTexture:RectangleTexture, $idMapBmp:BitmapData, $infoBmp:BitmapData):IGround
		{
			var $groundEditorSprite:GroundEditorSprite=SceneContext.creaGround($terrainData,$sixteenUvTexture,$idMapBmp,$infoBmp);
			var proxypan3dGround:ProxyPan3dGround = new ProxyPan3dGround;
			proxypan3dGround.ground = $groundEditorSprite;
			
		
			return proxypan3dGround;
		}
		public function clearGrassAll():void
		{
			SceneContext.clearGrassAll()
		}
		public function clearGroundAll():void
		{
			SceneContext.clearGroundAll()
		}

		public function set workSpaceUrl(value:String):void
		{
			Scene_data.fileRoot=value
		}
		
		public function camInfoMatrix3d(viewM:Matrix3D, camM:Matrix3D):void
		{
			// TODO Auto Generated method stub
			
		}
		
		

		
		public function get stage3DRect():Rectangle
		{
			var $rect:Rectangle=new Rectangle(Scene_data.stage3DVO.x,Scene_data.stage3DVO.y,Scene_data.stage3DVO.width,Scene_data.stage3DVO.height)
			
			return $rect;
		}
		
		
		public function getScreenPos($p:Point):Vector3D
		{
			// TODO Auto Generated method stub
			return new Vector3D;
		}
		
		public function get camMatrix3D():Matrix3D
		{
			//var $m:Matrix3D=Scene_data.viewMatrx3D.clone()
			//$m.append(Scene_data.cam3D.cameraMatrix)
			var $m:Matrix3D=Scene_data.cam3D.cameraMatrix.clone()
			$m.append(Scene_data.viewMatrx3D)
			return $m;
		}
		
		public function selectPrefabStaticMeshById($id:int):PrefabStaticMesh
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getRectHitModel($rect:Rectangle):Vector.<IModel>
		{

			var $arr:Vector.<IModel>=new Vector.<IModel>
			for(var i:uint=0;i<_iModeItem.length;i++){
				var modePos:Vector3D=new Vector3D(_iModeItem[i].x,_iModeItem[i].y,_iModeItem[i].z);
				if(_iModeItem[i] as ProxyPan3dModel||_iModeItem[i] as ProxyPan3dWater){
					var $objData:ObjData=ProxyPan3dModel(_iModeItem[i]).sprite.objData;
					var $posMatrix:Matrix3D=ProxyPan3dModel(_iModeItem[i]).sprite.posMatrix
					for(var j:Number=0;j<$objData.vertices.length/3;j++){
						var $verPos:Vector3D=new Vector3D($objData.vertices[j*3+0],$objData.vertices[j*3+1],$objData.vertices[j*3+2]);
						if(inRect($posMatrix.transformVector($verPos))){
							$arr.push(_iModeItem[i])
							j=$objData.vertices.length/3
						}
					}

				}else{
					if(inRect(modePos)){
						$arr.push(_iModeItem[i])
					}
				}
	
			}
			function inRect($pos:Vector3D):Boolean
			{
				var $p:Point=MathCore.mathWorld3DPosto2DView($pos)
				var dz:Vector3D=Scene_data.cam3D.cameraMatrix.transformVector(modePos)
				if(dz.z>1){
					if($rect.containsPoint($p)){
						return true
					}
				}
				return false
				
			}

			return $arr;
		}
		public function getMouseHitModel($mouse:Point):IModel
		{
			var $arr:Vector.<Display3DSprite>=new Vector.<Display3DSprite>
			for(var i:uint=0;i<_iModeItem.length;i++){
				if(_iModeItem[i] as ProxyPan3dModel){
					$arr.push(ProxyPan3dModel(_iModeItem[i]).sprite)
				}
				if(_iModeItem[i] as ProxyPan3dLight){
					$arr.push(ProxyPan3dLight(_iModeItem[i]).sprite)
				}
				if(_iModeItem[i] as ProxyPan3dWater){
					$arr.push(ProxyPan3dWater(_iModeItem[i]).sprite)
				}
				if(_iModeItem[i] as ProxyPan3dCapture){
					$arr.push(ProxyPan3dCapture(_iModeItem[i]).sprite)
				}
				if(_iModeItem[i] as ProxyPan3dReflection){
					$arr.push(ProxyPan3dReflection(_iModeItem[i]).sprite)
				}
				if(_iModeItem[i] as ProxyPan3DParallelLight){
					$arr.push(ProxyPan3DParallelLight(_iModeItem[i]).sprite)
				}
				if(_iModeItem[i] as ProxyPan3DParticle){
					$arr.push(ProxyPan3DParticle(_iModeItem[i]).sprite)
				}
			}
			var hitID:uint=SelectModelMath.scanHitModel($arr,$mouse)
			if(hitID<_iModeItem.length){
				return _iModeItem[hitID]
			}
			return null;
		}
		

		
		public function deleDisplay3DModel($iModel:IModel):void
		{
			for(var i:uint=0;i<_iModeItem.length;i++)
			{
				if(_iModeItem[i]==$iModel){
					_iModeItem.splice(i,1)
				}
			
			}
			if($iModel as ProxyPan3dModel){
				SceneContext.deleModel(ProxyPan3dModel($iModel ).sprite )
			}
			if($iModel as ProxyPan3dLight){
				SceneContext.deleLight( ProxyPan3dLight($iModel).sprite )
			}
			if($iModel as ProxyPan3dWater){
				SceneContext.deleWater( ProxyPan3dWater($iModel).sprite )
			}
			if($iModel as ProxyPan3dGrass){
				SceneContext.deleGrass( ProxyPan3dGrass($iModel).sprite )
			}
			if($iModel as ProxyPan3dCapture){
				SceneContext.deleCapture( ProxyPan3dCapture($iModel).sprite )
			}
			if($iModel as ProxyPan3dReflection){
				SceneContext.deleReflection( ProxyPan3dReflection($iModel).sprite )
			}			
			if($iModel as ProxyPan3DLightProbe){
				deleProxyPan3DLightProbe(ProxyPan3DLightProbe($iModel))
			}
			if($iModel as ProxyPan3DParallelLight){
				SceneContext.deleParallelLight(ProxyPan3DParallelLight($iModel).sprite)
			}
			if($iModel as ProxyPan3DParticle){
				SceneContext.deleParticle(ProxyPan3DParticle($iModel).sprite)
				ParticleManager.getInstance().removeParticle(ProxyPan3DParticle($iModel).particleSprite)
			}
			if($iModel as ProxyPan3DRole){
				SceneContext.deleRole(ProxyPan3DRole($iModel).sprite)
			}
			if($iModel as ProxyPan3dNavMesh){
				SceneContext.deleNavMesh(ProxyPan3dNavMesh($iModel).navMeshDisplay3DSprite)
			}
			//	proxyLightProbeItem
		}
		
		private function deleProxyPan3DLightProbe($lightProbeModel:ProxyPan3DLightProbe):void
		{
			for(var i:uint=0;i<proxyLightProbeItem.length;i++)
			{
				if(proxyLightProbeItem[i]==$lightProbeModel){
					proxyLightProbeItem.splice(i,1)
				}
			}
			SceneContext.deleLightProbeSprite( $lightProbeModel.sprite )
			
		}
		
		public function creatWaterModel($waterMesh:WaterStaticMesh,$id:int):IWater
		{
			
			var $modelSprite:Display3DWaterSprite=SceneContext.creatWaterModel()
			$modelSprite.url=Scene_data.fileRoot+$waterMesh.modeUrl
			$modelSprite.dephtBmp=new BitmapData(128,128,false,0xff0000)
			BmpLoad.getInstance().addSingleLoad($waterMesh.rootUrl+$id+".jpg",function ($bitmap:Bitmap,$obj:Object):void{
				$modelSprite.dephtBmp=$bitmap.bitmapData
			},{})
				
		
			var $proxyPan3dWater:ProxyPan3dWater = new ProxyPan3dWater
			$proxyPan3dWater.sprite=$modelSprite
			$proxyPan3dWater.waterMesh=$waterMesh
			
			_iModeItem.push($proxyPan3dWater)
			return $proxyPan3dWater;
		}
		
		
		public function creatLightModel($lightMesh:LightStaticMesh):ILight
		{
			
			var $modelSprite:Display3DLightSprite=SceneContext.creatLightModel()
			var $proxyPan3dLight:ProxyPan3dLight = new ProxyPan3dLight
			$proxyPan3dLight.sprite=$modelSprite
			$proxyPan3dLight.lightMesh=$lightMesh
			
			_iModeItem.push($proxyPan3dLight)
			return $proxyPan3dLight;
			
		}
		
		public function creatNavMeshModel($NavMeshStaticMesh:NavMeshStaticMesh):INavMesh
		{
			
			var $modelSprite:NavMeshDisplay3DSprite=SceneContext.creatNavMeshModel()
			var $proxyPan3dNavMesh:ProxyPan3dNavMesh = new ProxyPan3dNavMesh()
			$proxyPan3dNavMesh.navMeshDisplay3DSprite=$modelSprite
			$proxyPan3dNavMesh.navMeshStaticMesh=$NavMeshStaticMesh
		

			return $proxyPan3dNavMesh;
			
		}
		
		public function creatDisplay3DModel3D($model3DStaticMesh:Model3DStaticMesh,$bfun:Function):IModel
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function renderBuildToBitmapData($arr:Array, $cam:Camera3D, $rec:Rectangle):BitmapData
		{
			return BuildShowModel.getInstance().renderBuildToBitmapData($arr,$cam,$rec);
		}
		
		public function getModel3DXFileMotionRange(csvId:int, _motionID:int, bFun:Function):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function loadCubeLut($cubeUrl:String, $lutUrl:String):void
		{
			SceneContext.loadCubeLut($cubeUrl, $lutUrl);
			
		}
		
		public function saveScene(bfun:Function):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function setEnvironment($obj:Object):void
		{
			SceneContext.setEnvironment($obj)
			
		}
		
		public function setAlertMainWin($dis:Sprite):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function creatAmaniMaterial($name:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function creatAmaniObject3D($name:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function creatAmaniModel3D($name:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function set setSixteenBmp(arr:Vector.<BitmapData>):void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}