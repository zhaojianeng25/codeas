package _Pan3D.particle.follow
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.ball.Display3DBallPartilceNew;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;


	public class Display3DFollowPartilce extends Display3DBallPartilceNew
	{
		public function Display3DFollowPartilce(context:Context3D)
		{
			super(context);
			_particleType = 8;
			initBingMatrixAry();
		}

		
		override protected function setVc() : void {
			super.setVc();
			//_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,24, modelMatrix, true);
			//_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12, Scene_data.cam3D.cameraMatrix, true);
			
			for(var i:int;i<_totalNum;i++){
				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 28 + i,  _bindMatrixAry[i]);//Vector.<Number>( [_lixinForce.x,_lixinForce.y,_lixinForce.z,_lixinForce.w]
				//_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 28 + i,  Vector.<Number>([0,0,0,0]));//
			}
		}
		
		private var flag:int;
		private var flagNum:int;
		

		override public function setBind($bindVecter3d:Vector3D,$bindMatrix:Matrix3D,_bindAlpha:Number=1):void{
			bindVecter3d = $bindVecter3d;
			_alpha = _bindAlpha;
			//trace($bindVecter3d);
			
			var time:Number = _timer/Scene_data.frameTime;
			for(var i:int=flag;i<_totalNum;i++){
				var temp:Number = (time-i*_shootSpeed)/_life;
				if(temp >= _bindFlagAry[i]){
					
					
						_bindMatrixAry[i][0] = bindVecter3d.x;
						_bindMatrixAry[i][1] = bindVecter3d.y;
						_bindMatrixAry[i][2] = bindVecter3d.z;
					
					_bindFlagAry[i]++;
				}
			}
			
		}

		override public function clearAllAnim():void{
			super.clearAllAnim();
			flag = 0; 
			for(var i:int;i<_bindFlagAry.length;i++){
				_bindFlagAry[i] = 0;
			}
			
			if(!Scene_data.isDevelop){
				for(i=0;i<_bindMatrixAry.length;i++){
					for(var j:int=0;j<_bindMatrixAry[i].length;j++){
						_bindMatrixAry[i][j] = -100000;
					}
				}
			}
		}
		
		override public function resetPos($xpos:int,$ypos:int,$zpos:int):void{
			super.resetPos($xpos,$ypos,$zpos);
			
			for(var i:int=0;i<_bindMatrixAry.length;i++){
				_bindMatrixAry[i][0] = $xpos;
				_bindMatrixAry[i][1] = $ypos;
				_bindMatrixAry[i][2] = $zpos;
			}
		}
		
		private var _bindMatrixAry:Vector.<Vector.<Number>>;
		private var _bindFlagAry:Vector.<int>;
		
		private function initBingMatrixAry():void{
			_bindMatrixAry = new Vector.<Vector.<Number>>;
			_bindFlagAry = new Vector.<int>;
			for(var i:int;i<_totalNum;i++){
				_bindMatrixAry.push(Vector.<Number>([0,0,0,1]));
				_bindFlagAry.push(0);
			}
		}
		

		override public function updateMatrix():void{
			_allRotationMatrix.identity();
			
			_allRotationMatrix.prependScale(overAllScale*_scaleX*0.1,overAllScale*_scaleY*0.1,overAllScale*_scaleZ*0.1);
			
			modelMatrix.identity();
			
			if(isInGroup){
				posMatrix.appendScale(groupScale.x,groupScale.y,groupScale.z);
				posMatrix.appendTranslation(groupPos.x,groupPos.y,groupPos.z);
			}
			
			modelMatrix.append(posMatrix);
			
			//modelMatrix.append(Scene_data.cam3D.cameraMatrix);
			
		}
		
		override public function setBindPosVc():void{
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,24, Scene_data.cam3D.cameraMatrix,true);
		}
		
		override public function getModeRotationMatrix():Matrix3D
		{
			_rotationMatrix.identity();
			
			if (this.facez)
			{
				_rotationMatrix.prependRotation(90, Vector3D.X_AXIS);
			}else if(_is3Dlizi){
				
			}else if(_watchEye){
				
				if(!_lockY){
					_rotationMatrix.prependRotation(-Scene_data.cam3D.angle_y , Vector3D.Y_AXIS);
				}
				if(!_lockX){
					_rotationMatrix.prependRotation(-Scene_data.cam3D.angle_x , Vector3D.X_AXIS);
				}
				
			}
			
			return _rotationMatrix;
		}
	
		
		override public function clone():Display3DParticle{
			var display:Display3DFollowPartilce = new Display3DFollowPartilce(_context3D);
			display.setProgram3D(this._program);
			display.setAllInfo(_data,true);
			display.particleData = particleData;
			//display.gpuTuoQiuData=_gpuTuoQiuData;
			display._textureColor = _textureColor;
			display.initBingMatrixAry();
			
			return display;
		}
		
		override public function clear():void{
			super.clear();
			_bindMatrixAry = null;
			_bindFlagAry = null;
		}
		
		override public function reload():void{
			super.reload();
			_program = Program3DManager.getInstance().getProgram(Display3DFollowShader.DISPLAY3DFOLLOWSHADER);
		}
		
		override public function regShader():void{
			if(!materialParam){
				return;
			}
			var hasParticleColor:Boolean = materialParam.material.hasParticleColor();
			_needRandomColor = materialParam.material.hasVertexColor;
			
			var shaderParameAry:Array;
			
			var hasParticle:int;
			if(hasParticleColor){
				hasParticle = 1;
			}else{
				hasParticle = 0;
			}
			
			var hasRandomClolr:int = _needRandomColor ? 1 : 0;
			
			var isMul:int = _is3Dlizi ? 1 : 0;
			
			var needRotation:int = this._needSelfRotation ? 1 : 0;
			
			shaderParameAry = [hasParticle,hasRandomClolr,isMul,needRotation];
			
			materialParam.program = Program3DManager.getInstance().getMaterialProgram(Display3DFollowShader.DISPLAY3DFOLLOWSHADER,Display3DFollowShader,materialParam.material,shaderParameAry);
			
		}
		

		
		
	}
}