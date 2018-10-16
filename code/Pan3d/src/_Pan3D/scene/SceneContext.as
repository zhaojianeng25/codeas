package _Pan3D.scene
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.textures.RectangleTexture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import PanV2.Stage3dView;
	
	import _Pan3D.display3D.Display3DMaterialSprite;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.display3D.Display3dCubeMap;
	import _Pan3D.display3D.capture.Display3DCaptureSprite;
	import _Pan3D.display3D.capture.ScanCaptureLookAtPicModel;
	import _Pan3D.display3D.grass.GrassEditorDisplay3DSprite;
	import _Pan3D.display3D.ground.GroundEditorSprite;
	import _Pan3D.display3D.light.Display3DLightSprite;
	import _Pan3D.display3D.lightProbe.Display3DLightProbeSprite;
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.display3D.navMesh.NavMeshDisplay3DSprite;
	import _Pan3D.display3D.parallel.Dispaly3DParallelLightSpreit;
	import _Pan3D.display3D.particle.ParticleHitBoxSprite;
	import _Pan3D.display3D.reflection.Display3DReflectionSprite;
	import _Pan3D.display3D.sky.SkyShader;
	import _Pan3D.display3D.water.Display3DWaterSprite;
	import _Pan3D.display3D.water.ScanWaterHightMapModel;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.scene.postprocess.PostProcessManager;
	import _Pan3D.texture.TextureCubeMapVo;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.utils.editorutils.Display3DEditorMovie;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import terrain.TerrainData;

	public class SceneContext
	{
		public static var sceneRender:SceneRender = new SceneRender();
		
		public static function init():void{
			Program3DManager.getInstance().registe(SkyShader.SKY_SHADER,SkyShader);
			Scene_data.stage.addEventListener(Event.ENTER_FRAME,update);
		}
		
		public static function update(event:Event):void
		{
			if(sceneRender.clossReader){
				//关闭渲染
				return ;
			}
			var lastTime:uint=getTimer()
			//MathUint.catch_cam(Scene_data.cam3D, Scene_data.focus3D)
	
			sceneRender.scanWaterReflectioinUpData()
			Scene_data.drawTriangle=0
			Scene_data.drawNum=0
			var $context3D:Context3D=Scene_data.context3D
				
		
			
			$context3D.clear(1,0,0,1)
				
			

			var $viewMatrx3D:PerspectiveMatrix3D=new PerspectiveMatrix3D();
			$viewMatrx3D.perspectiveFieldOfViewLH(1,1,1, 10000);
			Scene_data.viewMatrx3D=$viewMatrx3D;
			if(Scene_data.topViewMatrx3D){
				Scene_data.viewMatrx3D=Scene_data.topViewMatrx3D;
			}

				
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, Scene_data.viewMatrx3D, true);
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, Scene_data.cam3D.cameraMatrix, true);
		
			$context3D.setDepthTest(true,Context3DCompareMode.LESS);
			$context3D.setCulling(Context3DTriangleFace.NONE);
		
			sceneRender.update();
			
		
			//$context3D.present();
		//	trace(getTimer()-lastTime)
			Scene_data.cam3D.move=false

		}
		
		public static function set gemoUpDataFun(temp:Function):void
		{
			sceneRender.gemoUpDataFun=temp
		}
		public static function creaGround($terrainData:TerrainData,$sixteenUvTexture:RectangleTexture,$idMapBmp:BitmapData,$infoBmp:BitmapData):GroundEditorSprite
		{
			var $GroundEditorSprite:GroundEditorSprite=new GroundEditorSprite(Scene_data.context3D)
			$GroundEditorSprite.sixteenUvTexture=$sixteenUvTexture
			$GroundEditorSprite.idInfoBitmapData=$idMapBmp
			$GroundEditorSprite.grassInfoBitmapData=$infoBmp
			$GroundEditorSprite.terrainData=$terrainData
			sceneRender.groundlevel.groundItem.push($GroundEditorSprite)
			return $GroundEditorSprite
		}
		public static function creaGrass():GrassEditorDisplay3DSprite
		{
			var $grassDisplay3DSprite:GrassEditorDisplay3DSprite=new GrassEditorDisplay3DSprite(Scene_data.context3D)
			sceneRender.grassLevel.grassItem.push($grassDisplay3DSprite)
			return $grassDisplay3DSprite
		}
		public static function changeStage3DView($x:int,$y:int,$w:int,$h:int):void
		{
			Stage3dView.getInstance().setStage3DXY($x,$y)
			Stage3dView.getInstance().setStage3DSize($w,$h)
				
			PostProcessManager.getInstance().resize($w,$h);
		}
		

		public static function clearGroundAll():void
		{
			sceneRender.groundlevel.clear()
			
		}
		public static function clearGrassAll():void
		{
			sceneRender.grassLevel.clear()
			
		}
		public static function creatModel():Display3DModelSprite
		{
			var $modelSprite:Display3DModelSprite=new Display3DMaterialSprite(Scene_data.context3D)
			sceneRender.modelLevel.modelItem.push($modelSprite);
			return $modelSprite
		}
		
		public static function deleModel($sprite:Display3DSprite):void
		{
			for(var i:uint=0;i<sceneRender.modelLevel.modelItem.length;i++)
			{
				if(sceneRender.modelLevel.modelItem[i]==$sprite){
					sceneRender.modelLevel.modelItem.splice(i,1)
						
					$sprite.dispose()
				}
			}
			
		}
		public static function creatSky($url:String, $cubeMapUrl:String):Display3dCubeMap{
			var sky:Display3dCubeMap = new Display3dCubeMap(Scene_data.context3D);
			sky.program = Program3DManager.getInstance().getProgram(SkyShader.SKY_SHADER);
			sceneRender.skyLevel.display = sky;
			return sky;
		}
		public static function creatLightModel():Display3DLightSprite
		{
			var $modelSprite:Display3DLightSprite=new Display3DLightSprite(Scene_data.context3D)
			sceneRender.lightLevel.modelItem.push($modelSprite);
			return $modelSprite
		}
		
		public static function creatNavMeshModel():NavMeshDisplay3DSprite
		{
			var $modelSprite:NavMeshDisplay3DSprite=new NavMeshDisplay3DSprite(Scene_data.context3D)
			sceneRender.navMeshLevel.modelItem.push($modelSprite);
			return $modelSprite
		}
		public static function creatCaptureModel():Display3DCaptureSprite
		{
			var $display3DCaptureSprite:Display3DCaptureSprite=new Display3DCaptureSprite(Scene_data.context3D)
			sceneRender.captureLevel.captureItem.push($display3DCaptureSprite);
			return $display3DCaptureSprite
		}
		public static function creatReflectionModel():Display3DReflectionSprite
		{
			var $display3DReflectionSprite:Display3DReflectionSprite=new Display3DReflectionSprite(Scene_data.context3D)
			sceneRender.reflectionLevel.reFlectionItem.push($display3DReflectionSprite);
			return $display3DReflectionSprite
		}
		public static function creatLightProbeModel():Display3DLightProbeSprite
		{
			var $Display3DLightProbeSprite:Display3DLightProbeSprite=new Display3DLightProbeSprite(Scene_data.context3D)
			sceneRender.lightProbeLevel.lightProbeItem.push($Display3DLightProbeSprite);
			return $Display3DLightProbeSprite
		}
		public static function creatParallelLightModel():Dispaly3DParallelLightSpreit
		{
			var $Display3DLightProbeSprite:Dispaly3DParallelLightSpreit=new Dispaly3DParallelLightSpreit(Scene_data.context3D)
			sceneRender.parallelLightLevel.parallelLightItem.push($Display3DLightProbeSprite);
			return $Display3DLightProbeSprite
		}
		public static function creatParticleHitModel():ParticleHitBoxSprite
		{
			var $particleHitBoxSprite:ParticleHitBoxSprite=new ParticleHitBoxSprite(Scene_data.context3D)
			sceneRender.particleHitLevel.particleHitItem.push($particleHitBoxSprite);
			return $particleHitBoxSprite
		} 
		public static function creatRoleModel():Display3DEditorMovie
		{
			var role:Display3DEditorMovie=new Display3DEditorMovie(Scene_data.context3D)
			SceneContext.sceneRender.modelLevel.addMode(role);
			return role;
		}
	
		public static function creatWaterModel():Display3DWaterSprite
		{
			var $modelSprite:Display3DWaterSprite=new Display3DWaterSprite(Scene_data.context3D)
			sceneRender.waterLevel.modelItem.push($modelSprite);
			return $modelSprite
		}
		public static function deleLight($sprite:Display3DLightSprite):void
		{
			for(var i:uint=0;i<sceneRender.lightLevel.modelItem.length;i++)
			{
				if(sceneRender.lightLevel.modelItem[i]==$sprite){
					sceneRender.lightLevel.modelItem.splice(i,1)
				}
			}
			
		}
		public static function deleWater($sprite:Display3DWaterSprite):void
		{
			for(var i:uint=0;i<sceneRender.waterLevel.modelItem.length;i++)
			{
				if(sceneRender.waterLevel.modelItem[i]==$sprite){
					sceneRender.waterLevel.modelItem.splice(i,1)
				}
			}
			
		}
		public static function deleGrass($sprite:GrassEditorDisplay3DSprite):void
		{
			for(var i:uint=0;i<sceneRender.grassLevel.grassItem.length;i++)
			{
				if(sceneRender.grassLevel.grassItem[i]==$sprite){
					sceneRender.grassLevel.grassItem.splice(i,1)
				}
			}
			
		}
		public static function deleCapture($sprite:Display3DCaptureSprite):void
		{
			for(var i:uint=0;i<sceneRender.captureLevel.captureItem.length;i++)
			{
				if(sceneRender.captureLevel.captureItem[i]==$sprite){
					sceneRender.captureLevel.captureItem.splice(i,1)
				}
			}
			
		}
		public static function deleReflection($sprite:Display3DReflectionSprite):void
		{
			for(var i:uint=0;i<sceneRender.reflectionLevel.reFlectionItem.length;i++)
			{
				if(sceneRender.reflectionLevel.reFlectionItem[i]==$sprite){
					sceneRender.reflectionLevel.reFlectionItem.splice(i,1)
				}
			}
			
		}
		public static function deleParallelLight($sprite:Dispaly3DParallelLightSpreit):void
		{
			for(var i:uint=0;i<sceneRender.parallelLightLevel.parallelLightItem.length;i++)
			{
				if(sceneRender.parallelLightLevel.parallelLightItem[i]==$sprite){
					sceneRender.parallelLightLevel.parallelLightItem.splice(i,1)
				}
			}
			
		}
		public static function deleParticle($sprite:ParticleHitBoxSprite):void
		{
			for(var i:uint=0;i<sceneRender.particleHitLevel.particleHitItem.length;i++)
			{
				if(sceneRender.particleHitLevel.particleHitItem[i]==$sprite){
					sceneRender.particleHitLevel.particleHitItem.splice(i,1)
				}
			}
			
		}
		public static function deleRole($sprite:Display3DEditorMovie):void
		{
			for(var i:uint=0;i<SceneContext.sceneRender.modelLevel.modelItem.length;i++)
			{
				if(SceneContext.sceneRender.modelLevel.modelItem[i]==$sprite){
					SceneContext.sceneRender.modelLevel.modelItem.splice(i,1)
				}
			}
			
		}
		public static function deleNavMesh($sprite:NavMeshDisplay3DSprite):void
		{
			for(var i:uint=0;i<SceneContext.sceneRender.navMeshLevel.modelItem.length;i++)
			{
				if(SceneContext.sceneRender.navMeshLevel.modelItem[i]==$sprite){
					SceneContext.sceneRender.navMeshLevel.modelItem.splice(i,1)
				}
			}
			
		}
		public static function deleLightProbeSprite($sprite:Display3DLightProbeSprite):void
		{
			for(var i:uint=0;i<sceneRender.lightProbeLevel.lightProbeItem.length;i++)
			{
				if(sceneRender.lightProbeLevel.lightProbeItem[i]==$sprite){
					sceneRender.lightProbeLevel.lightProbeItem.splice(i,1)
				}
			}
			
		}
		public static function scanGroundAndBuildHightMap($pos:Vector3D,$rect:Rectangle,$textureSize:Number):BitmapData
		{

            var $arr:Vector.<Display3DSprite>=getScanModelItem()
			return ScanWaterHightMapModel.getInstance().scanHightBitmap($pos,$rect,$textureSize,$arr)
				
	
		}
		public static function scanCaptureLookAtBmp($pos:Vector3D,$rect:Rectangle,$textureSize:Number):BitmapData
		{
			return ScanCaptureLookAtPicModel.getInstance().scanLookAtBmp($pos,$rect,$textureSize)
		}
		private static function getScanModelItem():Vector.<Display3DSprite>
		{
			var $arr:Vector.<Display3DSprite>=new Vector.<Display3DSprite>
				
			var i:uint=0
			for( i=0;i<sceneRender.groundlevel.groundItem.length;i++)
			{
				if(sceneRender.groundlevel.groundItem[i]){
					$arr.push(sceneRender.groundlevel.groundItem[i])
				}
			}
			for( i=0;i<sceneRender.modelLevel.modelItem.length;i++)
			{
				var $buildSprite:Display3DModelSprite=sceneRender.modelLevel.modelItem[i]
				if($buildSprite){
					//$arr.push(sceneRender.modelLevel.modelItem[i])
				}
			}
		
			return $arr
		}
		
		public static function loadCubeLut($cubeUrl:String,$lutUrl:String):void{
			TextureManager.getInstance().addCubeTexture($cubeUrl,onCubeLoad,null);
			TextureManager.getInstance().addTexture($lutUrl,onLutTextureLoad,null);
		}
		
		private static function onCubeLoad(textureVo:TextureCubeMapVo,info:Object):void{
			Scene_data.skyCubeMap = textureVo;
		}
		
		private static function onLutTextureLoad(textureVo:TextureVo,info:Object):void{
			Scene_data.prbLutTexture = textureVo;
		}
		public static function setEnvironment($obj:Object):void
		{
			sceneRender.usePostProcess = $obj.openLater;
			PostProcessManager.getInstance().setHDRBloomScale($obj.highlightNum);
			PostProcessManager.getInstance().setHDRExposure($obj.exposureNum);
			PostProcessManager.getInstance().setHDRWhite($obj.whiteBalance);
			PostProcessManager.getInstance().setUseHDR($obj.openHdr);
			PostProcessManager.getInstance().setHDRBloomRang($obj.highLightRang);
			PostProcessManager.getInstance().setPsData($obj);
		}
		
      
	

		
	}
}