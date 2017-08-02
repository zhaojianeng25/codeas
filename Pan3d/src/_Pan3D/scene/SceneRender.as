package _Pan3D.scene
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.capture.CaptureLevel;
	import _Pan3D.display3D.grass.GrassLevel;
	import _Pan3D.display3D.ground.GroundLevel;
	import _Pan3D.display3D.light.LightLevel;
	import _Pan3D.display3D.lightProbe.LightProbeLevel;
	import _Pan3D.display3D.model.ModelLevel;
	import _Pan3D.display3D.navMesh.NavMeshLevel;
	import _Pan3D.display3D.parallel.ParallelLightLevel;
	import _Pan3D.display3D.particle.ParticleHitLevel;
	import _Pan3D.display3D.reflection.ReflectionLevel;
	import _Pan3D.display3D.sky.SkyLevel;
	import _Pan3D.display3D.water.WaterLeve;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.particle.ctrl.ParticleRender;
	import _Pan3D.scene.postprocess.PostProcessManager;
	
	import _me.Scene_data;

	public class SceneRender
	{
		public var groundlevel:GroundLevel=new GroundLevel();
		public var grassLevel:GrassLevel=new GrassLevel();
		public var modelLevel:ModelLevel=new ModelLevel();
		public var lightLevel:LightLevel=new LightLevel();
		public var waterLevel:WaterLeve=new WaterLeve();
		public var navMeshLevel:NavMeshLevel=new NavMeshLevel();
		
		public var captureLevel:CaptureLevel=new CaptureLevel();
		public var reflectionLevel:ReflectionLevel=new ReflectionLevel();
		public var lightProbeLevel:LightProbeLevel=new LightProbeLevel();
		public var parallelLightLevel:ParallelLightLevel=new ParallelLightLevel();
		public var particleHitLevel:ParticleHitLevel=new ParticleHitLevel();
		
		public var skyLevel:SkyLevel = new SkyLevel();

		public var gemoUpDataFun:Function
		private var _context3D:Context3D;
		
		public var usePostProcess:Boolean;
		public var clossReader:Boolean;

		public function SceneRender()
		{

		}
		public function update():void{
			_context3D=Scene_data.context3D;
			
			ParticleManager.getInstance().update();
			
			if(usePostProcess){
				_context3D.setRenderToTexture(PostProcessManager.getInstance().outTexture,true);
				
				updateLevel();
				
				if(PostProcessManager.getInstance().useDistortion){
					_context3D.setRenderToTexture(PostProcessManager.getInstance().outDistortionTexture,true);
					updateDistortion();
				}
				
				_context3D.setRenderToBackBuffer();
				
				PostProcessManager.getInstance().update();
			}else{
				updateLevel();
	
				_context3D.present();
			}
			
			
		
		}
		
		public function updateLevel():void{
			
			if(Scene_data.light){
				var backColor:Vector3D=Scene_data.light.ClearColor;
				_context3D.clear(backColor.x/255,backColor.y/255,backColor.z/255,1)
			}else{
				_context3D.clear(50/255,50/255,50/255,1)
			}
			_context3D.setDepthTest(true,Context3DCompareMode.LESS);
			_context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
			navMeshLevel.updata();
			reflectionLevel.updata()
			groundlevel.updata();
			grassLevel.updata();
			parallelLightLevel.updata()
			lightProbeLevel.updata()
			modelLevel.updata();
	
			captureLevel.updata();
		

			lightLevel.updata();
			waterLevel.updata();
			
			particleHitLevel.updata();
	
		
			skyLevel.updata();
			modelLevel.upDataCollision()
			_context3D.setDepthTest(false,Context3DCompareMode.LESS);
			ParticleRender.getInstance().update();
			
			if(Boolean(gemoUpDataFun)){
				gemoUpDataFun()
			}
		}
		
		private function updateDistortion():void{
			_context3D.clear(0,0,0,1);
			_context3D.setDepthTest(false,Context3DCompareMode.LESS);
			ParticleRender.getInstance().updateDistortion();
		}
		
		public static var ShowMc:Object
		private var skipNum:uint=0
		/**
		 * 
		 * 折色
		 */
        public function scanWaterReflectioinUpData():void
		{
			if(skipNum++%60==1||Scene_data.cam3D.move){
				
				if(_context3D){
		
					_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, Scene_data.viewMatrx3D, true);
					_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, Scene_data.cam3D.cameraMatrix, true);
					reflectionLevel.scanWaterReflectioinUpData()
				}
			
			}
			
		}
	
		
	}
}