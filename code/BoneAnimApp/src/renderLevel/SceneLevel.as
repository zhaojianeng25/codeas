package renderLevel
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _Pan3D.lineTri.LineTriGrildLevel;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.particle.ctrl.ParticleRender;
	import _Pan3D.scene.postprocess.PostProcessManager;
	
	import _me.Scene_data;
	
	import renderLevel.backGround.BackGroundLevel;
	import renderLevel.levels.BoundsLevel;
	import renderLevel.levels.ParticleLevel;
	import renderLevel.levels.RoleLevel;
	import renderLevel.levels.TittleLevel;
	
	import utils.ai.AIManager;
	
	import view.frame.FrameEditPanle;
	
	import xyz.MoveScaleRotationLevel;
	
	

	public class SceneLevel
	{

		public var _projMatrix:PerspectiveMatrix3D;
		
		public var backGroud:BackGroundLevel;
		
		public var boundLevle:BoundsLevel;
		
		public var usePostProcess:Boolean;
		//public var xyzLevel:XyzPosLevel;
		public function SceneLevel()
		{
			AppDataBone.sceneLevel = this;
		}

		public function initData():void
		{

			initCam();
			makeScene();
		}
		
		private function initCam():void{
//			var came:Camera3D = Scene_data.cam3D;
//			came.distance = 90;
//			Scene_data.focus3D.angle_x = -45;
			
			
			Scene_data.cam3D.distance = 200;
			Scene_data.cam3D.angle_x = -45;
			Scene_data.cam3D.angle_y = 0;
			Scene_data.cam3D.x = 0;
			Scene_data.cam3D.y = +300;
			Scene_data.cam3D.z = -300;
		}

		public var drawLevel:LineTriGrildLevel;
		public var roleLevel:RoleLevel;
		public var particleLevel:ParticleLevel;

		private var context3D:Context3D;
		
		public function makeScene():void
		{
			context3D=Scene_data.context3D;
			
			drawLevel = new LineTriGrildLevel;
			
			drawLevel.lineGrldSprite.scale_x=0.1
			drawLevel.lineGrldSprite.scale_y=0.1
			drawLevel.lineGrldSprite.scale_z=0.1
			
			roleLevel = new RoleLevel;
			
			particleLevel = new ParticleLevel;
			
			backGroud = new BackGroundLevel;
			
			boundLevle = new BoundsLevel;
			
			AppDataBone.backLevel = backGroud;
		}
		
//		private function initLine():void{
//			xyzLevel.movePos=true;
//			xyzLevel.xyzPosData=getSampleLightPosData()
//			xyzLevel.upFunSkip=0;
//			xyzLevel.removeEvents();
//		}
//		private function getSampleLightPosData():XyzPosData
//		{
//			var xyzPosData:XyzPosData=new XyzPosData()
//			xyzPosData.id=0;
//			xyzPosData.x=100;
//			xyzPosData.y=0;
//			xyzPosData.z=0;
//			xyzPosData.type=1
//			return xyzPosData;
//			
//		}
		public function upData():void
		{
			Scene_data.drawNum = 0;
			Scene_data.drawTriangle=0
			if (!Scene_data.ready)
				return;
			
			
			AIManager.getInstance().update();
			FrameEditPanle.getInstance().update();
			
			
			if(AppDataBone.usePostProcess){
				context3D.setRenderToTexture(PostProcessManager.getInstance().outTexture,true);
				
				updateScene();
				
				context3D.setRenderToTexture(PostProcessManager.getInstance().outDistortionTexture,true);
				
				context3D.clear(0,0,0,1);
				context3D.setDepthTest(false,Context3DCompareMode.LESS);
				ParticleRender.getInstance().updateDistortion();
				
				PostProcessManager.getInstance().update();
				
			}else{
				updateScene();
				
				context3D.present();
			}
			
//			updateScene();
//			
//			context3D.present();

		}
		public static var ClearColor:Vector3D
		private function updateScene():void{
			//MathCore._catch_cam(Scene_data.cam3D, Scene_data.focus3D,Scene_data.shake3D);
			setMoveScaleRotationData();
			
			context3D.clear(64/256, 64/256, 64/256, 1);
			if(SceneLevel.ClearColor){
				context3D.clear(SceneLevel.ClearColor.x/255,SceneLevel.ClearColor.y/255,SceneLevel.ClearColor.z/255,1)
			}
			
			_projMatrix=new PerspectiveMatrix3D();
			_projMatrix.perspectiveFieldOfViewLH(1, 1, 0.1, 5000);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _projMatrix, true);
			Scene_data.viewMatrx3D = _projMatrix;
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, Scene_data.cam3D.cameraMatrix, true);
			
			
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			context3D.setDepthTest(false,Context3DCompareMode.LESS);
			if(!AppDataBone.is3d){
				backGroud.upData();
			}
			
			context3D.setCulling(Context3DTriangleFace.NONE);
			context3D.setDepthTest(true,Context3DCompareMode.LESS);
			MoveScaleRotationLevel.getInstance().upData();
			BoneHitModelSprite.getInstance().update()
			context3D.setCulling(Context3DTriangleFace.NONE);
			context3D.setDepthTest(true,Context3DCompareMode.LESS);
			roleLevel.upData();
			
	
			boundLevle.upData();
			TittleLevel.getInstance().upData();
	
			if(AppDataBone.is3d){
				context3D.setCulling(Context3DTriangleFace.NONE);
				context3D.setDepthTest(true,Context3DCompareMode.LESS);
				drawLevel.upData();
			}
			context3D.setDepthTest(false,Context3DCompareMode.LESS);
			ParticleManager.getInstance().update();
			ParticleRender.getInstance().update();
			
			context3D.setCulling(Context3DTriangleFace.NONE);
			context3D.setDepthTest(true,Context3DCompareMode.LESS);
		}
		
		private function setMoveScaleRotationData():void
		{
			var rect:Rectangle=new Rectangle(0,0,Scene_data.stage.width,Scene_data.stage.height)
			MoveScaleRotationLevel.getInstance().stage3Drec=rect
			MoveScaleRotationLevel.getInstance().stage2Dmouse=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY);
			MoveScaleRotationLevel.getInstance().camPositon=new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z);
			MoveScaleRotationLevel.getInstance().viewMatrx3D=Scene_data.viewMatrx3D 
			MoveScaleRotationLevel.getInstance().cameraMatrix=Scene_data.cam3D.cameraMatrix
				
		    Scene_data.selectVec=MoveScaleRotationLevel.getInstance().xyzMoveData;
			
		}
		
		public function stageResize():void
		{
			Scene_data.cam3D.fovw=Scene_data.stageWidth;
			Scene_data.cam3D.fovh=Scene_data.stageHeight;
			var context3D:Context3D=Scene_data.context3D;
			//trace(Scene_data.stageWidth,Scene_data.stageHeight);
			context3D.configureBackBuffer(Scene_data.stageWidth, Scene_data.stageHeight,Scene_data.antiAlias, true);
		}
	}
}
