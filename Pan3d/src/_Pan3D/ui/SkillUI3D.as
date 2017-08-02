package _Pan3D.ui
{
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.shadow.dynamicShadow.DynamicShadowUIShader;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class SkillUI3D extends UIComponent3D
	{
		private var _baseBg:Display3DBoard;
		private var _context3D:Context3D;
		public var allScale:Number = 0.9;
		private var _projMatrix:Matrix3D = new Matrix3D;
		private var camera2dMatrix:Matrix3D = new Matrix3D;
		public function SkillUI3D()
		{
			super();
			_context3D = Scene_data.context3D;
			
			Program3DManager.getInstance().registe(DynamicShadowUIShader.DYNAMIC_SHADOWUI_SHADER,DynamicShadowUIShader);
			
			//particleContainer = new Display3DContainer;
			
			configCamera();
			
			Scene_data.stage.addEventListener(Event.RESIZE,onResize);
		}
		
		protected function onResize(event:Event):void
		{
			configCamera();
		}
		
		public function addRole($sc:Display3dGameMovie):void
		{
			$sc.is3D = true;//必须添加	
			$sc.uiParticleContaniner = particleContainer;
			addGameMovie($sc);
		}
		
		
		public function setRoleXY($sc:Display3dGameMovie,$x:Number,$y:Number):void{
			var vec:Vector3D=new Vector3D;
			var sin_y:Number=Math.sin(45*Math.PI/180)
			var sin_x:Number=Math.sin(30*Math.PI/180)
			vec.x=sin_y * $x - sin_y * (-$y/sin_x);
			vec.z=sin_y * $x + sin_y * (-$y/sin_x);
			vec.scaleBy(1/allScale)
			
			$sc.x = vec.x;
			$sc.y = vec.y;
			$sc.z = vec.z;
		}
		
		
	
		override public function update():void{
			
			Scene_data.cam3D.cameraMatrix = camera2dMatrix;
			
			var angleX:Number = Scene_data.cam3D.angle_x;
			var angleY:Number = Scene_data.cam3D.angle_y; 
			
			Scene_data.cam3D.angle_x = -30;
			Scene_data.cam3D.angle_y = 45;

			superUpdate();
			
			Scene_data.cam3D.angle_x = angleX;
			Scene_data.cam3D.angle_y = angleY; 
			
			Scene_data.cam3D.cameraMatrix = Scene_data.cam3D.camera3dMatrix;
			
		}
		
		public function configCamera():void{
			camera2dMatrix.identity();
			camera2dMatrix.prependScale(1*(1000/Scene_data.cam3D.fovw*2), Scene_data.cam3D.fovw / Scene_data.cam3D.fovh*(1000/Scene_data.cam3D.fovw*2), 1);
			camera2dMatrix.prependTranslation(0, 0, 500);
			camera2dMatrix.prependRotation(-30, Vector3D.X_AXIS);
			camera2dMatrix.prependRotation(45, Vector3D.Y_AXIS);
		}
		
		public function superUpdate():void{
//			if(_bg){
//				_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
//				Scene_data.context3D.setDepthTest(false, Context3DCompareMode.LESS);
//				_baseBg.update();
//				
//				updateShadow();
//				
//				_context3D.setBlendFactors(Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ZERO);
//				_bg.update();
//				
//				Scene_data.context3D.setDepthTest(true, Context3DCompareMode.LESS);
//				
//				_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
//			}
			
			if(_bg){
				_bg.update();
			}
			
			setVc0();
			
			for(var i:int;i<_roleList.length;i++){
				_roleList[i].update();
			}
			
			_context3D.setDepthTest(false, Context3DCompareMode.LESS);
			particleContainer.update();
			
			resetVc0();
		}
		
		private function setVc0():void{
			_projMatrix.identity();
			_projMatrix.appendScale(0.001*allScale,0.001*allScale,0.00025);
			_projMatrix.appendTranslation(0,0,0.2);
			var xs:Number=-1+2/Scene_data.stageWidth*(this.x)
			var ys:Number=1-2/Scene_data.stageHeight*(this.y)
			_projMatrix.appendTranslation(xs,ys,0)
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _projMatrix, true);
		}
		
		private function resetVc0():void{
			_projMatrix.identity();
			_projMatrix.appendScale(0.001,0.001,0.00025);
			_projMatrix.appendTranslation(0,0,0.1);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _projMatrix, true);
		}
		

//		private var role:Display3dGameMovie;
//		private var _otherRole:Display3dGameMovie;
//		private var skill:SkillTimeLine;
		
		private function updateShadow():void{
			_context3D.setProgram(Program3DManager.getInstance().getProgram(DynamicShadowUIShader.DYNAMIC_SHADOWUI_SHADER));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([0.5,0.5,0.5,1]));
			
			_projMatrix.identity();
			_projMatrix.appendScale(0.001 * allScale,0.001 * allScale,0.00025);
			_projMatrix.appendTranslation(0,0,0.2);
			var xs:Number=-1+2/Scene_data.stageWidth*(this.x)
			var ys:Number=1-2/Scene_data.stageHeight*(this.y)
			_projMatrix.appendTranslation(xs,ys,0)
			_projMatrix.prepend(Scene_data.cam3D.cameraMatrix);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _projMatrix, true);
			
			for(var i:int;i<_roleList.length;i++){
				_roleList[i].updateShadow();
			}
			
			
			_projMatrix.identity();
			_projMatrix.appendScale(0.001,0.001,0.00025);
			_projMatrix.appendTranslation(0,0,0.1);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _projMatrix, true);
			
			
		}
		
		override public function reload():void{
			_context3D = Scene_data.context3D;
			super.reload();
		}
		
		override public function dispose():void{
			super.dispose();
			Scene_data.stage.removeEventListener(Event.RESIZE,onResize);
		}
		
		
		
	}
}