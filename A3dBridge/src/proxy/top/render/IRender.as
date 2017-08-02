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
	import _Pan3D.display3D.Display3DSprite;
	
	import capture.CaptureStaticMesh;
	
	import grass.GrassStaticMesh;
	
	import light.LightProbeStaticMesh;
	import light.LightStaticMesh;
	import light.ParallelLightStaticMesh;
	import light.ReflectionStaticMesh;
	
	import materials.Texture2DMesh;
	
	import mode3d.Model3DStaticMesh;
	
	import pack.PrefabStaticMesh;
	
	import particle.ParticleStaticMesh;
	
	import proxy.top.ICam;
	import proxy.top.grass.IGrass;
	import proxy.top.ground.IGround;
	import proxy.top.model.ICapture;
	import proxy.top.model.ILight;
	import proxy.top.model.ILightProbe;
	import proxy.top.model.IModel;
	import proxy.top.model.IParallelLight;
	import proxy.top.model.IParticle;
	import proxy.top.model.IReflection;
	import proxy.top.model.ISky;
	import proxy.top.model.IWater;
	
	import terrain.TerrainData;
	
	import water.WaterStaticMesh;

	public interface IRender
	{
		function init():void;
		function changeStage3DView($x:int,$y:int,$w:int,$h:int):void;
		function creatGround($terrainData:TerrainData,$sixteenUvTexture:RectangleTexture,$idMapBmp:BitmapData,$infoBmp:BitmapData):IGround;
		function clearGroundAll():void
		function clearGrassAll():void
		function creatDisplay3DModel($prefab:PrefabStaticMesh,$bfun:Function):IModel
		function creatDisplay3DModel3D($model3DStaticMesh:Model3DStaticMesh,$bfun:Function):IModel
		function creatLightModel($lightMesh:LightStaticMesh):ILight
		function creatWaterModel($waterMesh:WaterStaticMesh,$id:int):IWater
		function creatGrassModel($grassMesh:GrassStaticMesh):IGrass
		function creatCaptureModel($captureMesh:CaptureStaticMesh,$id:int):ICapture
		function creatReFlectionModel($reFlectionMesh:ReflectionStaticMesh,$id:int):IReflection
		function creatParallelLight($parallelLightStaticMesh:ParallelLightStaticMesh):IParallelLight
		function creatParticle($lizhiStaticMesh:ParticleStaticMesh):IParticle

		function deleDisplay3DModel($iModel:IModel):void
		function selectPrefabStaticMeshById($id:int):PrefabStaticMesh
		function set workSpaceUrl(value:String):void
		function getTypeList($type:int):Array;

//		function get camData():ICam;
//		function get camMatrix3D():Matrix3D
		function camInfoMatrix3d(viewM:Matrix3D,camM:Matrix3D):void
			
		function get stage3DRect():Rectangle
		function set selectModelFun(value:Function):void
		
		
		function getScreenPos($p:Point):Vector3D
		function getMouseHitModel($mouse:Point):IModel
		function getRectHitModel($rect:Rectangle):Vector.<IModel>
		function getMouseHitLightProbeModel($mouse:Point):IModel
		

		function renderBuildToBitmapData($arr:Array,$cam:Camera3D,$rec:Rectangle):BitmapData
			
		function drawScreenToBitmapData(bFun:Function):BitmapData;
		function getObject3DXFileRange(csvId:int,bFun:Function ):void
		function getModel3DXFileMotionRange(csvId:int,_motionID:int,bFun:Function ):void
		
		function creatSky($url:String,$cubeMapUrl:String):ISky;
		function loadCubeLut($cubeUrl:String,$lutUrl:String):void;
		
		function chooseTexture2DFolderUrl($texture2DMesh:Texture2DMesh,$urlArr:Array):void
			
		function resetLightProbel($lightProBelMesh:LightProbeStaticMesh):ILightProbe
			
		function mouseClick(event:MouseEvent):void
		function saveScene(bfun:Function):void
			
		function setEnvironment($obj:Object):void
	    function deleAmaniFile($obj:Object):void
		function creatAmaniFile($name:String,typeStr:String):void

        function mapEarthFun($class:Object,$fun:Object,$data:Object,$bFun:Function):void;
			
        function set setSixteenBmp(arr:Vector.<BitmapData>):void
			
	

		

		
	}
}