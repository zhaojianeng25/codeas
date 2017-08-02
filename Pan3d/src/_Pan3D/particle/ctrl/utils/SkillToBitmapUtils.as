package _Pan3D.particle.ctrl.utils
{
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.Focus3D;
	import _Pan3D.batch.ParticleBatch;
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.event.LoadCompleteEvent;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.skill.Skill3DPoint;
	import _Pan3D.skill.SkillManager;
	import _Pan3D.skill.SkillTimeLine;
	import _Pan3D.skill.vo.ParamTarget;
	
	import _me.Scene_data;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	public class SkillToBitmapUtils
	{
		/**
		 * 临时存储舞台的宽 
		 */		
		private var _stageWidth:int;
		/**
		 *  临时存储舞台的高
		 */		
		private var _stageHeight:int;
		
		/**
		 * 转换的宽 
		 */		 
		private var _wNum:int = 500;
		/**
		 * 转换的高度 
		 */		
		private var _hNum:int = 300;
		
		private var _focus3D:Vector3D = new Vector3D;
		private var _rolePos:Point = new Point;
		
		private var _role:Display3dGameMovie;
		
		private var _skillUrl:String;

		private var skill:SkillTimeLine;
		
		private var bitmapAry:Vector.<BitmapData>;

		private var bitmap:Bitmap;
		
		public function SkillToBitmapUtils()
		{
			bitmapAry = new Vector.<BitmapData>;
			
			bitmap = new Bitmap();
			Scene_data.stage.addChild(bitmap);
			Scene_data.stage.addEventListener(Event.ENTER_FRAME,onFrame);
		}
		private var flag:int;
		private function onFrame(event:Event):void{
			if(!bitmapAry.length){
				return;
			}
			bitmap.bitmapData = bitmapAry[flag]
			
			flag++;
			if(flag == bitmapAry.length){
				flag = 0;
			}
		}
		
		public function getBitmap(role:Display3dGameMovie,skillUrl:String,targetRole:Display3dGameMovie=null):void{
			_role = role;
			_skillUrl = skillUrl;
			
			loadSkill();
			
		}
		
		public function startRender():void{
			var t:int = getTimer();
			preSetContext();
			update();
			reSetContext();
			trace("转换耗时：" + (getTimer() - t))
		}
		
		private function loadSkill():void{
			var hasSkill:Boolean = SkillManager.getInstance().hasSkill(_skillUrl);
			
			skill = SkillManager.getInstance().getSkill(_skillUrl);
			skill.configFiexEffect(_role);
			
			
//			var vec:Vector.<ParamTarget> = new Vector.<ParamTarget>;
//			var pt:ParamTarget = new ParamTarget;
//			var s3d:Skill3DPoint = new Skill3DPoint;
//			s3d.absoluteX = 500;
//			s3d.absoluteY = 0;
//			s3d.absoluteZ = 500;
//			pt.target = s3d;
//			vec.push(pt);
//			skill.configTaget(_role,vec,null,null,5);
			
			if(!hasSkill){
				skill.addEventListener(LoadCompleteEvent.LOAD_COMPLETE,onSkillLoad);
			}else{
				startRender();
			}
		}
		
		private function onSkillLoad(eve:Event):void{
			startRender();
		}
		
		public function update():void{
			
			_rolePos.setTo(_role.x,_role.y);
			_role.x = -1000;
			_role.y = 0;
			_role.play("attack_02");
			
			for(var i:int;i<70;i++){
				Scene_data.context3D.clear(0,0,0,1);
				
				Scene_data.context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				Scene_data.context3D.setDepthTest(true, Context3DCompareMode.LESS);
				
				_role.updateFrame(Scene_data.frameTime);
				skill.update(Scene_data.frameTime);
				
				_role.update();
				Scene_data.context3D.setDepthTest(false, Context3DCompareMode.LESS);
				ParticleManager.getInstance().updateByFrame();
				
				ParticleBatch.getInstance().update();
				
				var bmp:BitmapData = render();
				
				bitmapAry.push(bmp);
			}
			_role.x = _rolePos.x;
			_role.y = _rolePos.y;
			
		}
		
		/**
		 * 渲染 把渲染目标写入bitmapdata 
		 * @return 
		 * 
		 */		
		private function render():BitmapData{
			var context3D:Context3D=Scene_data.context3D;
			var bitmapdata:BitmapData = new BitmapData(_wNum,_hNum,true,0xff000000);
			context3D.drawToBitmapData(bitmapdata);
			//context3D.present();
			return bitmapdata;
		}
		
		private function preSetContext():void{
			var context3D:Context3D=Scene_data.context3D;
			_stageWidth = Scene_data.stageWidth;
			_stageHeight = Scene_data.stageHeight;
			try{
				onStageResize(_wNum,_hNum);
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
			context3D=Scene_data.context3D;
			var cam3D:Camera3D=new Camera3D({})
			cam3D.distance = Scene_data.cam3D.distance;
			cam3D.fovw = _wNum;
			cam3D.fovh = _hNum;
			var focus3D:Focus3D=new Focus3D
			focus3D.angle_x=Scene_data.cam3D.angle_x;
			focus3D.angle_y=Scene_data.cam3D.angle_y;
			
			
			var p:Vector3D=MathCore.math2Dto3Dwolrd(-1000,0);
			
			focus3D.x = p.x;
			focus3D.y = 0;
			focus3D.z = p.z;
			
			Scene_data.sceneViewHW = 800;
			
			
			MathCore._catch_cam(cam3D, focus3D,Scene_data.shake3D);
			Scene_data.cam3D.cameraMatrix = cam3D.cameraMatrix;
			context3D.clear(0, 0, 0, 1);
			
			var _projMatrixNew:Matrix3D = new  Matrix3D;
			_projMatrixNew.appendScale(0.001,0.001,0.0001);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _projMatrixNew, true);
			
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			context3D.setDepthTest(false,Context3DCompareMode.LESS);
		}
		
		/**
		 * 设置舞台宽高 
		 * @param w
		 * @param h
		 * 
		 */		
		private function onStageResize(w:int,h:int):void{
			Scene_data.stageWidth = w;
			Scene_data.stageHeight = h;
			
			Scene_data.cam3D.fovw=Scene_data.stageWidth;
			Scene_data.cam3D.fovh=Scene_data.stageHeight;
			
			Scene_data.sceneViewHW = 1000;
			
			var context3D:Context3D=Scene_data.context3D;
			context3D.configureBackBuffer(Scene_data.stageWidth, Scene_data.stageHeight,Scene_data.antiAlias, true);
		}
		
		private function reSetContext():void{
			try{
				onStageResize(_stageWidth,_stageHeight);
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
		}
		
	}
}