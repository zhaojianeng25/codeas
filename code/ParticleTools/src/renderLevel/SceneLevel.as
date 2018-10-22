package renderLevel
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Program3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.lineTri.LineTriGrildLevel;
	import _Pan3D.particle.Display3DPartilceShader;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.program.shaders.StatShader;
	import _Pan3D.scene.postprocess.PostProcessManager;
	
	import _me.Scene_data;
	
	import common.AppData;
	
	import guiji.GuijiLevel;
	
	import modules.scene.sceneSave.FilePathManager;
	
	import renderLevel.backGround.BackGroundLevel;
	import renderLevel.levels.ParticleLevel;
	import renderLevel.levels.RoleLevel;
	import renderLevel.quxian.QuxianLevel;
	
	import xyz.MoveScaleRotationLevel;
	
	

	public class SceneLevel
	{

	
		public var _keyControl:PraticleKeyControl=new PraticleKeyControl;
		
		public var backGroud:BackGroundLevel;
		public var roleLevel:RoleLevel;
		
		public var usePostProcess:Boolean;

		public function SceneLevel()
		{
			AppParticleData.sceneLevel = this;
		}

		public function initData():void
		{
			_keyControl.init(Scene_data.stage);
			context3D=Scene_data.context3D;
			makeScene();
			initCam();
		}
		/*
		private function initCam():void{
			
			Scene_data.cam3D.distance = 200;
			Scene_data.focus3D.angle_x = -30;
			Scene_data.focus3D.angle_y = 0;
			Scene_data.focus3D.x = 0;
			Scene_data.focus3D.y = 0;
			Scene_data.focus3D.z = 0;
			
		}
		*/
		private function initCam():void{


			Scene_data.cam3D.distance = 200;
			Scene_data.cam3D.angle_x = -45;
			Scene_data.cam3D.angle_y = 5;
			Scene_data.cam3D.x = 10;
			Scene_data.cam3D.y = +300;
			Scene_data.cam3D.z = -300;
		}

		private var particleLevel:ParticleLevel;
		public var drawLevel:LineTriGrildLevel;
		
		private var _guijiLevel:GuijiLevel;


		private var context3D:Context3D;
		
		public function makeScene():void
		{
			var program:Program3D = Program3DManager.getInstance().getProgram(StatShader.STATSHADER);
			
			Program3DManager.getInstance().registe(Display3DPartilceShader.DISPLAY3DPARTILCESHADER,Display3DPartilceShader);
			program = Program3DManager.getInstance().getProgram(Display3DPartilceShader.DISPLAY3DPARTILCESHADER);
			particleLevel = new ParticleLevel;
			AppParticleData.particleLevel = particleLevel;
			drawLevel = new LineTriGrildLevel;
			drawLevel.lineGrldSprite.scale_x=0.1
			drawLevel.lineGrldSprite.scale_y=0.1
			drawLevel.lineGrldSprite.scale_z=0.1
	
			
			_guijiLevel=GuijiLevel.Instance();

			
			backGroud = new BackGroundLevel;
			AppParticleData.backLevel = backGroud;
			
			roleLevel = new RoleLevel;

		}

		
		public function upData():void
		{
			Scene_data.drawNum = 0;
			if (!Scene_data.ready){
				return;
			}
			
			Scene_data.drawNum=0
			Scene_data.drawTriangle=0
			if(usePostProcess){
				context3D.setRenderToTexture(PostProcessManager.getInstance().outTexture,true);
				
				updateScene();
				
				
				context3D.setRenderToTexture(PostProcessManager.getInstance().outDistortionTexture,true);
				
				updateDistortion();
				
				PostProcessManager.getInstance().update();
			}else{
				updateScene();
				
				context3D.present();
			}
			
		}
		
		public function updateScene():void{
			
			var context3D:Context3D=Scene_data.context3D;
		//	MathCore._catch_cam(Scene_data.cam3D, Scene_data.focus3D,Scene_data.shake3D);
			context3D.clear(64/256, 64/256, 64/256, 1);
			
			setProjMatrix();
			
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, Scene_data.cam3D.cameraMatrix, true);
			
			updateRole();
			
			updateGrid();
			
			updateParticle();
			
			updateOther();
		}
		
		private function setProjMatrix():void{
			
			var $viewMatrx3D:PerspectiveMatrix3D=new PerspectiveMatrix3D();
			$viewMatrx3D.perspectiveFieldOfViewLH(1,1,1, 5000);
			Scene_data.viewMatrx3D=$viewMatrx3D
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, $viewMatrx3D, true);

			
		}
		
		private function updateGrid():void{
			context3D.setCulling(Context3DTriangleFace.NONE);
			if(AppParticleData.showGrid && AppParticleData.is3d){
				context3D.setDepthTest(true,Context3DCompareMode.LESS);
				drawLevel.upData();
			}
		}
		
		private function updateRole():void{
			context3D.setCulling(Context3DTriangleFace.NONE);
			context3D.setDepthTest(true, Context3DCompareMode.LESS);
			roleLevel.upData();
		}
		
		private function updateBackGround():void{
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			context3D.setDepthTest(false,Context3DCompareMode.LESS);
			if(!AppParticleData.is3d){
				backGroud.upData();
			}
		}
		
		private function updateOther():void{
			_guijiLevel.upData();
			QuxianLevel.getInstance().upData()
	
			upMovelData();
		}
		
		private function updateParticle():void{
			context3D.setDepthTest(false,Context3DCompareMode.LESS);
			particleLevel.upData();
		}
		
		private function updateDistortion():void{
			context3D.clear(0,0,0,1);
			context3D.setDepthTest(false,Context3DCompareMode.LESS);
			particleLevel.updateDistortion();
			
		}
		
		private function upMovelData():void
		{
			
			MoveScaleRotationLevel.getInstance().stage3Drec=new Rectangle(0,0,Scene_data.stage.stageWidth,Scene_data.stage.stageHeight)
			MoveScaleRotationLevel.getInstance().stage2Dmouse=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY);
			MoveScaleRotationLevel.getInstance().camPositon=new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z);
			MoveScaleRotationLevel.getInstance().viewMatrx3D=Scene_data.viewMatrx3D
			MoveScaleRotationLevel.getInstance().cameraMatrix=Scene_data.cam3D.cameraMatrix
			MoveScaleRotationLevel.getInstance().upData()
			
		}
		private function UpDataBoWen():void
		{
			var context3D:Context3D=Scene_data.context3D;
			context3D.setRenderToTexture(Scene_data.bowenText, true, 0, 0);
			MathCore._catch_cam(Scene_data.cam3D, Scene_data.focus3D,Scene_data.shake3D);
			context3D.clear(64/256, 64/256, 64/256, 1);
			
			var $viewMatrx3D:PerspectiveMatrix3D=new PerspectiveMatrix3D();
			$viewMatrx3D.perspectiveFieldOfViewLH(1,1,1, 5000);
			Scene_data.viewMatrx3D=$viewMatrx3D
				
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, $viewMatrx3D, true);
			context3D.setCulling(Context3DTriangleFace.NONE);
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			context3D.setDepthTest(true, Context3DCompareMode.LESS);
			if(AppParticleData.showGrid){
				context3D.setDepthTest(true,Context3DCompareMode.LESS);
				drawLevel.upData();
	
			}
			context3D.setDepthTest(false,Context3DCompareMode.LESS);
			particleLevel.upData();
			_guijiLevel.upData();

			context3D.setRenderToBackBuffer();
			//显示波纹后的效果
			context3D.clear(0, 0, 0, 1);
			context3D.setDepthTest(true, Context3DCompareMode.LESS);
			context3D.setCulling(Context3DTriangleFace.FRONT);
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			context3D.present();
		}

		public function stageResize():void
		{
			Scene_data.cam3D.fovw=Scene_data.stageWidth;
			Scene_data.cam3D.fovh=Scene_data.stageHeight;
			var context3D:Context3D=Scene_data.context3D;
			//trace(Scene_data.stageWidth,Scene_data.stageHeight);
			context3D.configureBackBuffer(Scene_data.stageWidth, Scene_data.stageHeight,0, true);
		}
	}
}
