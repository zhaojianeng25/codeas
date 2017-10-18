package proxy.top.render
{
	import flash.display.BitmapData;
	import flash.display3D.textures.RectangleTexture;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Camera3D;
	
	import _me.Scene_data;
	
	import capture.CaptureStaticMesh;
	
	import grass.GrassStaticMesh;
	
	import light.LightProbeStaticMesh;
	import light.LightStaticMesh;
	import light.ParallelLightStaticMesh;
	import light.ReflectionStaticMesh;
	
	import materials.Texture2DMesh;
	
	import mode3d.Model3DStaticMesh;
	
	import navMesh.NavMeshStaticMesh;
	
	import pack.PrefabStaticMesh;
	
	import particle.ParticleStaticMesh;
	
	import proxy.pan3d.render.RenderPan3d;
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
	
	import roles.RoleStaticMesh;
	
	import terrain.TerrainData;
	
	import water.WaterStaticMesh;
	
	import xyz.MoveScaleRotationLevel;
	import xyz.base.TooXyzPosData;
	import xyz.draw.TooXyzMoveData;

	public class Render
	{
		private static var renderContext:RenderPan3d;
		public static var lightUvRoot:String;

		public function Render()
		{
			
		}
		public static function init():void{
			renderContext = new RenderPan3d
			renderContext.init();
		}
		public static function set workSpaceUrl(value:String):void
		{
			renderContext.workSpaceUrl=value;
		}
		public static function changeStage3DView($x:int,$y:int,$w:int,$h:int):void{
			renderContext.changeStage3DView($x,$y,$w,$h);
		}
		public static function creaGround($terrainData:TerrainData,$sixteenUvTexture:RectangleTexture,$idMapBmp:BitmapData,$infoBmp:BitmapData):IGround
		{
			var ground:IGround = renderContext.creatGround($terrainData,$sixteenUvTexture,$idMapBmp,$infoBmp);
			return ground;
		}
		public static function creatDisplay3DModel($prefab:PrefabStaticMesh,$id:uint,$bfun:Function=null):IModel
		{
			var $iModel:IModel = renderContext.creatDisplay3DModel($prefab,$bfun);
			$iModel.uid="build"+String($id)
			return $iModel;
		}
		public static function creatDisplay3DModel3D($model3DStaticMesh:Model3DStaticMesh,$bfun:Function=null):IModel
		{
			var $iModel:IModel = renderContext.creatDisplay3DModel3D($model3DStaticMesh,$bfun);
			return $iModel;
		}
		public static function creatLightModel($lightStaticMesh:LightStaticMesh):ILight
		{
			var $iLight:ILight = renderContext.creatLightModel($lightStaticMesh);
			return $iLight;
		}
		public static function creatWaterModel($waterStaticMesh:WaterStaticMesh,$id:int):IWater
		{
			var $iWater:IWater = renderContext.creatWaterModel($waterStaticMesh,$id);
			return $iWater;
		}
		public static function creatNavMeshModel($NavMeshStaticMesh:NavMeshStaticMesh,$id:int):INavMesh
		{
			var $INavMesh:INavMesh = renderContext.creatNavMeshModel($NavMeshStaticMesh);
			return $INavMesh;
		}
		public static function creatCaptureModel($captureMesh:CaptureStaticMesh,$id:int):ICapture
		{
			var $iCapture:ICapture = renderContext.creatCaptureModel($captureMesh,$id);
			return $iCapture;
		}
		public static function creatParticle($particleStaticMesh:ParticleStaticMesh):IParticle
		{
			var $iParticle:IParticle = renderContext.creatParticle($particleStaticMesh);
			return $iParticle;
		}
		public static function creatRole($roleStaticMesh:RoleStaticMesh):IModel
		{
			var $imode:IModel = renderContext.creatRole($roleStaticMesh);
			return $imode;
		}
		
		public static function creatReFlectionModel($reFlection:ReflectionStaticMesh,$id:int):IReflection
		{
			var $iReflection:IReflection = renderContext.creatReFlectionModel($reFlection,$id);
			return $iReflection;
		}
		public static function creatGrassModel($grassMesh:GrassStaticMesh):IGrass
		{
			var $iGrass:IGrass = renderContext.creatGrassModel($grassMesh);
			return $iGrass;
		}
		public static function creatParallelLight($parallelLightStaticMesh:ParallelLightStaticMesh):IParallelLight
		{
			var $imodel:IParallelLight = renderContext.creatParallelLight($parallelLightStaticMesh);
			return $imodel;
			return null
		}
		public static function deleDisplay3DModel($iModel:IModel):void
		{
			 renderContext.deleDisplay3DModel($iModel);
		
		}
		public static function clearGroundAll():void
		{
			renderContext.clearGroundAll()
		}

		public static function clearGrassAll():void
		{
			renderContext.clearGrassAll()
		}
		public static function setEnvironment($obj:Object):void
		{
			renderContext.setEnvironment($obj)
		}
		public static function setSixteenBmp(arr:Vector.<BitmapData>):void
		{
			renderContext.setSixteenBmp=arr
		}

		public static function getMouseHitModel($mouse:Point):IModel
		{
			return renderContext.getMouseHitModel($mouse);
		}
		public static function getRectHitModel($rect:Rectangle):Vector.<IModel>
		{
			return renderContext.getRectHitModel($rect);
		}
		public static function getMouseHitLightProbeModel($mouse:Point):IModel
		{
			return renderContext.getMouseHitLightProbeModel($mouse);
		}
		private static var _tooXyzMoveData:TooXyzMoveData
		public static function xyzPosMoveItem($arr:Vector.<IModel>):TooXyzMoveData
		{
	
			if(_tooXyzMoveData){
				_tooXyzMoveData.dataItem=null
				_tooXyzMoveData.lineBoxItem=null
				_tooXyzMoveData.isCenten=false
				_tooXyzMoveData.modelItem=null
				_tooXyzMoveData.dataChangeFun=null
				_tooXyzMoveData.dataUpDate=null
			}
			_tooXyzMoveData=new TooXyzMoveData
			if($arr){
				
				_tooXyzMoveData.dataItem=new Vector.<TooXyzPosData>;
				_tooXyzMoveData.modelItem=new Array
				for (var i:uint=0;i<$arr.length;i++)
				{
					var k:TooXyzPosData=new TooXyzPosData;
					k.x=$arr[i].x
					k.y=$arr[i].y
					k.z=$arr[i].z
					k.scale_x=$arr[i].scaleX
					k.scale_y=$arr[i].scaleY
					k.scale_z=$arr[i].scaleZ
					k.angle_x=$arr[i].rotationX
					k.angle_y=$arr[i].rotationY
					k.angle_z=$arr[i].rotationZ
					_tooXyzMoveData.dataItem.push(k)
					_tooXyzMoveData.modelItem.push($arr[i])
					
				}
				_tooXyzMoveData.fun=xyzBfun
				MoveScaleRotationLevel.getInstance().xyzMoveData=_tooXyzMoveData
					
			
				
			}else{
				MoveScaleRotationLevel.getInstance().xyzMoveData=null
			
			}
			Scene_data.selectVec=MoveScaleRotationLevel.getInstance().xyzMoveData
			return _tooXyzMoveData
			
		}
		private static function xyzBfun($XyzMoveData:xyz.draw.TooXyzMoveData):void
		{
			for(var i:uint=0;i<$XyzMoveData.modelItem.length;i++){
				var $iModel:IModel=IModel($XyzMoveData.modelItem[i])
				var $dataPos:TooXyzPosData=$XyzMoveData.dataItem[i]
				
				$iModel.x=$dataPos.x
				$iModel.y=$dataPos.y
				$iModel.z=$dataPos.z
				
				$iModel.rotationX=$dataPos.angle_x
				$iModel.rotationY=$dataPos.angle_y
				$iModel.rotationZ=$dataPos.angle_z
				
				$iModel.scaleX=$dataPos.scale_x
				$iModel.scaleY=$dataPos.scale_y
				$iModel.scaleZ=$dataPos.scale_z

			}
		}
		
		public static function getTypeList($type:int):Array{
			return renderContext.getTypeList($type);
		}
	


		public static function camInfoMatrix3d(viewM:Matrix3D, camM:Matrix3D):void
		{
			renderContext.camInfoMatrix3d(viewM,camM);
			
		}
	
        public static function getScreenPos($p:Point):Vector3D
		{
			return renderContext.getScreenPos($p)
		}
        public static function selectPrefabStaticMeshById($id:uint):PrefabStaticMesh
		{
			return renderContext.selectPrefabStaticMeshById($id)
		}
        public static function get stage3DRect():Rectangle
		{
			return renderContext.stage3DRect
		}
        public static function  drawScreenToBitmapData(bFun:Function):BitmapData
		{
			return renderContext.drawScreenToBitmapData(bFun)
		}

        public static function renderBuildToBitmapData($arr:Array,$cam:Camera3D,$rec:Rectangle):BitmapData
		{
			return renderContext.renderBuildToBitmapData($arr,$cam,$rec)
		}
		
		public static function creatSky($url:String,$cubeMapUrl:String):ISky
		{
			var sky:ISky = renderContext.creatSky($url,$cubeMapUrl);
			return sky;
		}
		public static function getObject3DXFileRange(csvId:int,bFun:Function):void
		{
			renderContext.getObject3DXFileRange(csvId,bFun);
	
		}
	
		public static function getModel3DXFileMotionRange(csvId:int,_motionID:int,bFun:Function):void
		{
			renderContext.getModel3DXFileMotionRange(csvId,_motionID,bFun);
	
		}
		public static function resetLightProbel($lightProBelMesh:LightProbeStaticMesh):ILightProbe
		{
			return renderContext.resetLightProbel($lightProBelMesh);
	
		}
		
		public static function loadCubeLut($cubeUrl:String, $lutUrl:String):void{
			renderContext.loadCubeLut($cubeUrl, $lutUrl);
		}
		public static function chooseTexture2DFolderUrl($texture2DMesh:Texture2DMesh,$urlArr:Array):void{
			renderContext.chooseTexture2DFolderUrl($texture2DMesh, $urlArr);
		}
		public static function mouseClick(evt:MouseEvent):void
		{
			renderContext.mouseClick(evt)
		}

		public static function set selectModelFun(value:Function):void
		{
			renderContext.selectModelFun=value
		}
       
		public static function  saveScene($bFun:Function):void
		{
			renderContext.saveScene($bFun)
		}
		public static function  deleAmaniFile($obj:Object):void
		{
			renderContext.deleAmaniFile($obj)
		}

		public static function  creatAmaniFile($name:String,typeStr:String):void
		{
			renderContext.creatAmaniFile($name,typeStr)
		}
       
		public static function  mapEarthFun($class:Object,$fun:Object,$data:Object,$bFun:Function=null):void
		{
			renderContext.mapEarthFun($class,$fun,$data,$bFun);
		}
       


		
	}
}