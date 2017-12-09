package  scenelevel
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Program3D;
	
	import _Pan3D.lineTri.LineTriGrildLevel;
	import _Pan3D.particle.Display3DPartilceShader;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.particle.ctrl.ParticleRender;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.program.shaders.StatShader;
	import _Pan3D.scene.SceneContext;
	
	import _me.Scene_data;
	
	import xyz.MoveScaleRotationLevel;
	
	
	
	public class SceneLevel
	{
		
		

		
		public var _frameKeyControl:FrameKeyControl=new FrameKeyControl;
		
		public function SceneLevel()
		{

		}
		
		public function initData():void
		{

			context3D=Scene_data.context3D;
			makeScene();
			initCam();
			
			_frameKeyControl.init(Scene_data.stage)
		}

		private function initCam():void{
			
			
			Scene_data.cam3D.distance = 1000;
			Scene_data.cam3D.angle_x = -45;
			Scene_data.cam3D.angle_y = 0;
			Scene_data.cam3D.x = 0;
			Scene_data.cam3D.y = +2000;
			Scene_data.cam3D.z = -2000;
		}
		

		public var drawLevel:LineTriGrildLevel;
		

		
		
		private var context3D:Context3D;
		
		public function makeScene():void
		{

				
			Program3DManager.getInstance().initReg();
			var program:Program3D = Program3DManager.getInstance().getProgram(StatShader.STATSHADER);
			
			Program3DManager.getInstance().registe(Display3DPartilceShader.DISPLAY3DPARTILCESHADER,Display3DPartilceShader);
			program = Program3DManager.getInstance().getProgram(Display3DPartilceShader.DISPLAY3DPARTILCESHADER);

			drawLevel = new LineTriGrildLevel;

			

	
	
		}

		
		public function upData():void
		{
			Scene_data.drawNum = 0;
			if (!Scene_data.ready){
				return;
			}
			Scene_data.drawNum=0
			Scene_data.drawTriangle=0
			updateScene();
		}
		
		public function updateScene():void{
			
			var context3D:Context3D=Scene_data.context3D;
			context3D.clear(64/256, 64/256, 64/256, 1);
	
			setProjMatrix();
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, Scene_data.cam3D.cameraMatrix, true);
			context3D.setCulling(Context3DTriangleFace.NONE);
		
			updateGrid();
			SceneContext.sceneRender.modelLevel.updata();
			MoveScaleRotationLevel.getInstance().upData();
			
			context3D.setDepthTest(false,Context3DCompareMode.LESS);
			ParticleManager.getInstance().update()
			ParticleRender.getInstance().update();
			
			
			context3D.present();

		}

		
		private function setProjMatrix():void{
			
			var $viewMatrx3D:PerspectiveMatrix3D=new PerspectiveMatrix3D();
			$viewMatrx3D.perspectiveFieldOfViewLH(1,1,1, 10000);
			Scene_data.viewMatrx3D=$viewMatrx3D
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, $viewMatrx3D, true);
			
			
		}
		
		private function updateGrid():void{
			context3D.setCulling(Context3DTriangleFace.NONE);

			context3D.setDepthTest(true,Context3DCompareMode.LESS);
			drawLevel.upData();
		
		}
		

	
	}
}
