package  xyz
{
	import flash.display.Stage;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import xyz.base.TooQuaternion;
	import xyz.base.TooSelectRotationModel;
	import xyz.base.TooXyzPosData;
	import xyz.draw.TooHitBoxLineSprite3D;
	import xyz.draw.TooLineTri3DSprite;
	import xyz.draw.TooMathMoveUint;
	import xyz.draw.TooMoveLevel;
	import xyz.draw.TooRotationLevel;
	import xyz.draw.TooScaleLevel;
	import xyz.draw.TooTriDisplay3DSprite;
	import xyz.draw.TooXyzMoveData;
	import xyz.draw.TooXyzMoveMath;
	import xyz.draw.TooXyzRotationMath;
	import xyz.draw.TooXyzScaleMath;
	import xyz.draw.TooXyzSkipMath;

	
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class MoveScaleRotationLevel 
	{
		private static var instance:MoveScaleRotationLevel;


		private var _isMouseDown:Boolean=false
		private var _xyzMoveData:TooXyzMoveData;

		
		private var _sizeNum:Number=1;
		
		private var _statceType:uint=0
			
		private var _roundDisplay3DSprite:TooRotationLevel;
		private var _moveDisplay3DSprite:TooMoveLevel;
		private var _scaleDisplay3DSprite:TooScaleLevel;

		private var _context3D:Context3D;
		private var _stage:Stage;
		
		public function MoveScaleRotationLevel()
		{
			trace("MoveScaleRotationLevel")
		}

		public function set statceType(value:uint):void
		{
			_statceType = value;
		}

		public function get xyzMoveData():TooXyzMoveData
		{
			return _xyzMoveData;
		}
		public function set viewMatrx3D(value:Matrix3D):void
		{
			TooMathMoveUint.viewMatrx3D=value
		}
		public function set cameraMatrix(value:Matrix3D):void
		{
			TooMathMoveUint.cameraMatrix=value
		}
		public function set stage3Drec(value:Rectangle):void
		{
			TooMathMoveUint.stage3Drec=value
		}
		public function set stage2Dmouse(value:Point):void
		{
			TooMathMoveUint.stage2Dmouse=value
			TooMathMoveUint.stage3Dmouse=new Point(value.x-TooMathMoveUint.stage3Drec.x,value.y-TooMathMoveUint.stage3Drec.y)
		}
		public function set camPositon(value:Vector3D):void
		{
			TooMathMoveUint.camPositon=value
		}
		public static function getInstance():MoveScaleRotationLevel
		{
			if(!instance){
				instance=new MoveScaleRotationLevel()
			}
			return instance;
		}
		public function initContext3D($context3D:Context3D,$stage:Stage,$type:uint,lizi:Boolean=false):void
		{
			_stage=$stage
			_context3D=$context3D
			TooMathMoveUint.context3D=$context3D
			TooMathMoveUint.agalLevel=$type
		
			if(lizi){
				TooMathMoveUint._line50=28
				TooLineTri3DSprite.thickNessScale=0.3
				TooTriDisplay3DSprite.triSize=10
			}else{
			
				TooMathMoveUint._line50=45
				TooLineTri3DSprite.thickNessScale=0.3
				TooTriDisplay3DSprite.triSize=20
			}
			
			initData()
			addEvents();
		}
		public function dataUpDate():void
		{
			if(!Boolean(_xyzMoveData)){
				return 
			}
			_xyzMoveData.modeMatrx3D.identity()
			if(_xyzMoveData.scale_x==0||_xyzMoveData.scale_y==0||_xyzMoveData.scale_z==0){
			}else{
				_xyzMoveData.modeMatrx3D.appendScale(_xyzMoveData.scale_x,_xyzMoveData.scale_y,_xyzMoveData.scale_z)
			}
			
			
			
			_xyzMoveData.modeMatrx3D.appendRotation(_xyzMoveData.angle_x,Vector3D.X_AXIS)
			_xyzMoveData.modeMatrx3D.appendRotation(_xyzMoveData.angle_y,Vector3D.Y_AXIS)
			_xyzMoveData.modeMatrx3D.appendRotation(_xyzMoveData.angle_z,Vector3D.Z_AXIS)
			_xyzMoveData.modeMatrx3D.appendTranslation(_xyzMoveData.x,_xyzMoveData.y,_xyzMoveData.z)
				
			for(var i:uint=0;i<_xyzMoveData.lineBoxItem.length;i++){
				var $hitBoxSprite:TooHitBoxLineSprite3D=_xyzMoveData.lineBoxItem[i]
				$hitBoxSprite.posMatrix=_xyzMoveData.modeMatrx3D.clone()
				$hitBoxSprite.posMatrix.prepend($hitBoxSprite.tempMatrix3D)
				
				var $data:TooXyzPosData=_xyzMoveData.dataItem[i]
				var $pos:Vector3D=$hitBoxSprite.posMatrix.position
				
				$data.x=$pos.x
				$data.y=$pos.y
				$data.z=$pos.z
				
				var $scaleVec:Vector3D=getScaleFromMatrix($hitBoxSprite.posMatrix)
				$data.scale_x=$scaleVec.x
				$data.scale_y=$scaleVec.y
				$data.scale_z=$scaleVec.z
				
				var $quaternion:TooQuaternion=new TooQuaternion
					/*
				var $arxi:Vector3D=new Vector3D
				$quaternion.fromMatrix($hitBoxSprite.posMatrix)
				$quaternion.toEulerAngles($arxi)
					*/
        
				var $arxi:Vector3D=getRotationFromMatrix($hitBoxSprite.posMatrix)
				$arxi.scaleBy(180/Math.PI)
				$data.angle_x=$arxi.x;
				$data.angle_y=$arxi.y;
				$data.angle_z=$arxi.z;
			}
			
			if(Boolean(_xyzMoveData.fun)){
				//_xyzMoveData.fun(_xyzMoveData)
			}
		}
		public function set xyzMoveData(value:TooXyzMoveData):void
		{
			_xyzMoveData = value;
			if(_xyzMoveData==null){
				return 
			}
			_xyzMoveData.dataUpDate=dataUpDate;
			//_xyzMoveData.isCenten=false
			_xyzMoveData.lineBoxItem=new Vector.<TooHitBoxLineSprite3D>
			if(_xyzMoveData.isCenten){
				_xyzMoveData.x=0
				_xyzMoveData.y=0
				_xyzMoveData.z=0
				
				_xyzMoveData.angle_x=0
				_xyzMoveData.angle_y=0
				_xyzMoveData.angle_z=0
					
				_xyzMoveData.scale_x=0
				_xyzMoveData.scale_y=0
				_xyzMoveData.scale_z=0
					
				for(var j:uint=0;j<_xyzMoveData.dataItem.length;j++)
				{
					_xyzMoveData.x+=_xyzMoveData.dataItem[j].x
					_xyzMoveData.y+=_xyzMoveData.dataItem[j].y
					_xyzMoveData.z+=_xyzMoveData.dataItem[j].z
						
					_xyzMoveData.scale_x+=_xyzMoveData.dataItem[j].scale_x
					_xyzMoveData.scale_y+=_xyzMoveData.dataItem[j].scale_y
					_xyzMoveData.scale_z+=_xyzMoveData.dataItem[j].scale_z
					
					_xyzMoveData.angle_x+=_xyzMoveData.dataItem[j].angle_x
					_xyzMoveData.angle_y+=_xyzMoveData.dataItem[j].angle_y
					_xyzMoveData.angle_z+=_xyzMoveData.dataItem[j].angle_z
				}

				_xyzMoveData.x/=_xyzMoveData.dataItem.length
				_xyzMoveData.y/=_xyzMoveData.dataItem.length
				_xyzMoveData.z/=_xyzMoveData.dataItem.length

				_xyzMoveData.scale_x/=_xyzMoveData.dataItem.length
				_xyzMoveData.scale_y/=_xyzMoveData.dataItem.length
				_xyzMoveData.scale_z/=_xyzMoveData.dataItem.length
					
				_xyzMoveData.angle_x/=_xyzMoveData.dataItem.length
				_xyzMoveData.angle_y/=_xyzMoveData.dataItem.length
				_xyzMoveData.angle_z/=_xyzMoveData.dataItem.length
				
			}else{
				_xyzMoveData.x=_xyzMoveData.dataItem[0].x;
				_xyzMoveData.y=_xyzMoveData.dataItem[0].y;
				_xyzMoveData.z=_xyzMoveData.dataItem[0].z;
				
				_xyzMoveData.angle_x=_xyzMoveData.dataItem[0].angle_x;
				_xyzMoveData.angle_y=_xyzMoveData.dataItem[0].angle_y;
				_xyzMoveData.angle_z=_xyzMoveData.dataItem[0].angle_z;
				
				_xyzMoveData.scale_x=_xyzMoveData.dataItem[0].scale_x;
				_xyzMoveData.scale_y=_xyzMoveData.dataItem[0].scale_y;
				_xyzMoveData.scale_z=_xyzMoveData.dataItem[0].scale_z;
			}

			_xyzMoveData.modeMatrx3D=new Matrix3D;
			_xyzMoveData.modeMatrx3D.appendScale(_xyzMoveData.scale_x,_xyzMoveData.scale_y,_xyzMoveData.scale_z);
			_xyzMoveData.modeMatrx3D.appendRotation(_xyzMoveData.angle_x,Vector3D.X_AXIS);
			_xyzMoveData.modeMatrx3D.appendRotation(_xyzMoveData.angle_y,Vector3D.Y_AXIS);
			_xyzMoveData.modeMatrx3D.appendRotation(_xyzMoveData.angle_z,Vector3D.Z_AXIS);
			_xyzMoveData.modeMatrx3D.appendTranslation(_xyzMoveData.x,_xyzMoveData.y,_xyzMoveData.z)
				
			
			for( var i:uint=0;i<_xyzMoveData.dataItem.length;i++){
				var $hitBosSprite:TooHitBoxLineSprite3D=new TooHitBoxLineSprite3D(_context3D)	;

				var $m:Matrix3D=new Matrix3D;
				$m.appendScale(_xyzMoveData.dataItem[i].scale_x,_xyzMoveData.dataItem[i].scale_y,_xyzMoveData.dataItem[i].scale_z);
				$m.appendRotation(_xyzMoveData.dataItem[i].angle_x,Vector3D.X_AXIS);
				$m.appendRotation(_xyzMoveData.dataItem[i].angle_y,Vector3D.Y_AXIS);
				$m.appendRotation(_xyzMoveData.dataItem[i].angle_z,Vector3D.Z_AXIS);
				
				$m.appendTranslation(_xyzMoveData.dataItem[i].x,_xyzMoveData.dataItem[i].y,_xyzMoveData.dataItem[i].z);
		
				$hitBosSprite.tempMatrix3D=_xyzMoveData.modeMatrx3D.clone();
				$hitBosSprite.tempMatrix3D.invert();
				$hitBosSprite.tempMatrix3D.prepend($m);
					
				$hitBosSprite.posMatrix=_xyzMoveData.modeMatrx3D.clone();
				$hitBosSprite.posMatrix.prepend($hitBosSprite.tempMatrix3D);
				$hitBosSprite.makeBox();
				_xyzMoveData.lineBoxItem.push($hitBosSprite);
			}
			
			

		}

		protected function initData():void
		{
			addMove3D();
			addRound3D();
			addScale3D();
			addTestBox();
			
			
		}
		
		private function addTestBox():void
		{
		
			
		}
		
		private function addScale3D():void
		{
			_scaleDisplay3DSprite=new TooScaleLevel(_context3D)
			
		}
		
		private function addRound3D():void
		{
			_roundDisplay3DSprite=new TooRotationLevel(_context3D)
			
		}
		private function get isComplent():Boolean
		{
			if(_statceType>3){
				return false
			}

			if(TooMathMoveUint.viewMatrx3D&&TooMathMoveUint.cameraMatrix&&TooMathMoveUint.stage3Drec&&TooMathMoveUint.stage3Dmouse&&TooMathMoveUint.camPositon&&_xyzMoveData){
				return true
			}else{
				return false
			}

		}
		protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setVertexBufferAt(3, null);
			_context3D.setVertexBufferAt(4, null);
			_context3D.setVertexBufferAt(5, null);
			_context3D.setVertexBufferAt(6, null);
			
			_context3D.setTextureAt(0,null)
			_context3D.setTextureAt(1,null)
			_context3D.setTextureAt(2,null)
			_context3D.setTextureAt(3,null)
			_context3D.setTextureAt(4,null)
			_context3D.setTextureAt(5,null)
			_context3D.setTextureAt(6,null)
			
		}
		public function upData($draw:Boolean=true):void
		{
	
			if(isComplent){
				resetVa()
				_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, TooMathMoveUint.viewMatrx3D, true);
				_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, TooMathMoveUint.cameraMatrix, true);
				
				
				var $distance:Number=Vector3D.distance(TooMathMoveUint.camPositon,new Vector3D(_xyzMoveData.x,_xyzMoveData.y,_xyzMoveData.z));
				_sizeNum=$distance/350
				_context3D.setDepthTest(true,Context3DCompareMode.ALWAYS);
				_context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
				var $roundPosMatrix:Matrix3D=new Matrix3D;
				$roundPosMatrix.appendScale(_sizeNum,_sizeNum,_sizeNum)
					
				var mpos:Vector3D=_xyzMoveData.modeMatrx3D.position
					/*
				var mrou:Vector3D=new Vector3D
				var rQ:TooQuaternion=new TooQuaternion
				rQ.fromMatrix(_xyzMoveData.modeMatrx3D)
				rQ.toEulerAngles(mrou)
				mrou.scaleBy(180/Math.PI)
					*/
				var mrou:Vector3D=getRotationFromMatrix(_xyzMoveData.modeMatrx3D)
				mrou.scaleBy(180/Math.PI)
				$roundPosMatrix.appendRotation(mrou.x,Vector3D.X_AXIS)
				$roundPosMatrix.appendRotation(mrou.y,Vector3D.Y_AXIS)
				$roundPosMatrix.appendRotation(mrou.z,Vector3D.Z_AXIS)
				$roundPosMatrix.appendTranslation(mpos.x,mpos.y,mpos.z)

					
			
					
				switch(_statceType)
				{
					case TooMathMoveUint.MOVE_XYZ:
					{
						_moveDisplay3DSprite.sizeNum=_sizeNum
						_moveDisplay3DSprite.posMatrix=$roundPosMatrix
						_context3D.setCulling(Context3DTriangleFace.NONE);
						if($draw){
							_moveDisplay3DSprite.update()
						}
				
						break;
					}
					case TooMathMoveUint.MOVE_ROUTATION:
					{
						
						_roundDisplay3DSprite.posMatrix=$roundPosMatrix
						_context3D.setCulling(Context3DTriangleFace.BACK);
						if($draw){
							_roundDisplay3DSprite.update()
						}
						break;
					}
					case TooMathMoveUint.MOVE_SCALE:
					{
						
						_scaleDisplay3DSprite.sizeNum=_sizeNum
						_scaleDisplay3DSprite.posMatrix=$roundPosMatrix
						_context3D.setCulling(Context3DTriangleFace.NONE);
						if($draw){
							_scaleDisplay3DSprite.update()
						}
						
						break;
					}
						
					default:
					{
						break;
					}
				}
					
				for(var i:uint=0;i<_xyzMoveData.lineBoxItem.length;i++){
					var $hitBoxSprite:TooHitBoxLineSprite3D=_xyzMoveData.lineBoxItem[i]
					$hitBoxSprite.posMatrix=_xyzMoveData.modeMatrx3D.clone()
					$hitBoxSprite.posMatrix.prepend($hitBoxSprite.tempMatrix3D)
					if($draw){
					//$hitBoxSprite.update()
					}
						
				}
				resetVa()
				_context3D.setCulling(Context3DTriangleFace.NONE);
				_context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
			}

		}

		private function addEvents():void
		{
			// TODO Auto Generated method stub
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove)
			_stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp)
			_stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
			_stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onRightDown);
			_stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,onRightUp);
			
		}
		
		protected function onRightUp(event:MouseEvent):void
		{
			_isRightDown=false
			
		}
		private var _isRightDown:Boolean=false
		protected function onRightDown(event:MouseEvent):void
		{
			_isRightDown=true
			
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
		
			if(!_isMouseDown&&!_isRightDown){
				if(event.keyCode==Keyboard.W){
					_statceType=TooMathMoveUint.MOVE_XYZ
				}
				if(event.keyCode==Keyboard.E){
					_statceType=TooMathMoveUint.MOVE_ROUTATION
				}
				if(event.keyCode==Keyboard.R){
					_statceType=TooMathMoveUint.MOVE_SCALE
				}
			}
			if(event.keyCode==Keyboard.Q||event.keyCode==27){
				_xyzMoveData=null;
			}
		}
		//有使用移动组件
		public function get useIt():Boolean
		{

			if(_xyzMoveData&&MoveScaleRotationLevel.moveSelectId<=5){
				return true
			}else{
				return false
			}

		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			if(!isComplent)return;
			_isMouseDown=false
			TooXyzMoveMath.mouseUp()
			TooXyzScaleMath.mouseUp()
			
			var moveSelectId:uint=TooSelectRotationModel.scanHitModel(_moveDisplay3DSprite.spriteItem,TooMathMoveUint.stage2Dmouse,Context3DTriangleFace.NONE)
			_moveDisplay3DSprite.selectHitColor(moveSelectId)
				
			var scaleSelectId:uint=TooSelectRotationModel.scanHitModel(_scaleDisplay3DSprite.spriteItem,TooMathMoveUint.stage2Dmouse,Context3DTriangleFace.NONE)
			_scaleDisplay3DSprite.selectHitColor(scaleSelectId)
             _scaleDisplay3DSprite.addScale=0
				 
		}
		private var _isChangeData:Boolean=false;
		public static  var moveSelectId:Number;
		protected function onMouseMove(event:MouseEvent):void
		{
	
			if(!isComplent||event.altKey){
				return;
			}
			_isChangeData=false
			switch(_statceType)
			{
				case TooMathMoveUint.MOVE_XYZ:
				{
					if(_isMouseDown){
						moveModel()
					}else
					{
						
							var moveSelectId:uint=TooSelectRotationModel.scanHitModel(_moveDisplay3DSprite.spriteItem,TooMathMoveUint.stage2Dmouse,Context3DTriangleFace.NONE)
							_moveDisplay3DSprite.selectHitColor(moveSelectId)
					
					
							MoveScaleRotationLevel.moveSelectId=moveSelectId;
					
					}
					break;
				}
				case TooMathMoveUint.MOVE_SCALE:
				{
					if(_isMouseDown)
					{
						scaleModle();
					}else{

							var rotationSelectId:uint=TooSelectRotationModel.scanHitModel(_scaleDisplay3DSprite.spriteItem,TooMathMoveUint.stage2Dmouse,Context3DTriangleFace.NONE)
							_scaleDisplay3DSprite.selectHitColor(rotationSelectId)
								
							MoveScaleRotationLevel.moveSelectId=rotationSelectId;
					
						
					}
					break;
				}
				case TooMathMoveUint.MOVE_ROUTATION:
				{
					if(_isMouseDown){
						roundModel();
					}else{
					
							var scaleSelectId:uint=TooSelectRotationModel.scanHitModel(_roundDisplay3DSprite.spriteItem,TooMathMoveUint.stage2Dmouse,Context3DTriangleFace.BACK)
							_roundDisplay3DSprite.selectModelId(scaleSelectId)
								
							MoveScaleRotationLevel.moveSelectId=scaleSelectId;
					
						
					}
					break;
				}
					
				default:
				{
					break;
				}
			}
			dataUpDate()
			
			if(_isMouseDown&&_isChangeData){
				if(Boolean(_xyzMoveData.dataChangeFun)){
					_xyzMoveData.dataChangeFun()
				}
				if(Boolean(_xyzMoveData.fun)){
					_xyzMoveData.fun(_xyzMoveData);
				}
			
			}
			
		}
		
		private function moveModel():void
		{
			if(!isComplent){
				return;
			}
			if(TooXyzMoveMath._hitX||TooXyzMoveMath._hitY||TooXyzMoveMath._hitZ||TooXyzMoveMath._hitCenten||TooXyzMoveMath._hitXZtri||TooXyzMoveMath._hitXYtri||TooXyzMoveMath._hitYZtri){
				var $addPos:Vector3D=TooXyzMoveMath.mouseMove()
				var $m:Matrix3D=TooXyzMoveMath.lastMatrx.clone()
				$m.prependTranslation($addPos.x,$addPos.y,$addPos.z)
				var pos:Vector3D=$m.position
				_xyzMoveData.x=pos.x
				_xyzMoveData.y=pos.y
				_xyzMoveData.z=pos.z
				_isChangeData=true
			}
			
		}
		
		private function roundModel():void
		{
			if(_roundDisplay3DSprite.rotationTpey!=""){
				var addRotation:Number=TooXyzSkipMath.getRotationSkip()
				
				var $m:Matrix3D=new Matrix3D;
				$m.appendRotation(_xyzMoveData.oldangle_x,Vector3D.X_AXIS)
				$m.appendRotation(_xyzMoveData.oldangle_y,Vector3D.Y_AXIS)
				$m.appendRotation(_xyzMoveData.oldangle_z,Vector3D.Z_AXIS)
				
				var $addM:Matrix3D=new Matrix3D
				
				if(_roundDisplay3DSprite.rotationTpey=="x"){
					$addM.appendRotation(addRotation,Vector3D.X_AXIS)
				}
				if(_roundDisplay3DSprite.rotationTpey=="y"){
					$addM.appendRotation(-addRotation,Vector3D.Y_AXIS)
				}
				if(_roundDisplay3DSprite.rotationTpey=="z"){
					$addM.appendRotation(addRotation,Vector3D.Z_AXIS)
				}
				$m.prepend($addM)
					/*
				var $q:TooQuaternion=new TooQuaternion;
				$q.fromMatrix($m)
				var $ang:Vector3D=new Vector3D
				$q.toEulerAngles($ang)
					*/
				var $ang:Vector3D=getRotationFromMatrix($m)	
				$ang.scaleBy(180/Math.PI)
				_xyzMoveData.angle_x=$ang.x;
				_xyzMoveData.angle_y=$ang.y;
				_xyzMoveData.angle_z=$ang.z;
					
				_isChangeData=true
			}
			
		}

		private function scaleModle():void
		{
			if(TooXyzScaleMath._hitX||TooXyzScaleMath._hitY||TooXyzScaleMath._hitZ||TooXyzScaleMath._hitCenten){
				var addpos:Vector3D=TooXyzScaleMath.mouseMove()
				var $temp:Number=1
				if(TooXyzScaleMath._hitCenten){
					$temp=1+addpos.x/(TooMathMoveUint.stage3Drec.height/2)
					_xyzMoveData.scale_x=TooXyzScaleMath.lastScale.scale_x*$temp
					_xyzMoveData.scale_y=TooXyzScaleMath.lastScale.scale_y*$temp
					_xyzMoveData.scale_z=TooXyzScaleMath.lastScale.scale_z*$temp
				
				}else
				if(TooXyzScaleMath._hitX)
				{
					$temp=1+addpos.x/TooXyzScaleMath.lastPos.x
					_xyzMoveData.scale_x=TooXyzScaleMath.lastScale.scale_x*$temp
				}else
				if(TooXyzScaleMath._hitY)
				{
					$temp=1+addpos.y/TooXyzScaleMath.lastPos.y
					_xyzMoveData.scale_y=TooXyzScaleMath.lastScale.scale_y*$temp
				}else
				if(TooXyzScaleMath._hitZ)
				{
					$temp=1+addpos.z/TooXyzScaleMath.lastPos.z
					_xyzMoveData.scale_z=TooXyzScaleMath.lastScale.scale_z*$temp
				}
				_scaleDisplay3DSprite.addScale=$temp-1
				_isChangeData=true
			}
		}	

		private function getScaleFromMatrix(matrix:Matrix3D):Vector3D
		{
			var vv:Vector.<Vector3D>=matrix.decompose();
			var q:Vector3D=vv[0];//  平移
			var w:Vector3D=vv[1];//  旋转
			var e:Vector3D=vv[2];//  缩放
			return e;
		}
		private function getRotationFromMatrix(matrix:Matrix3D):Vector3D
		{
			var vv:Vector.<Vector3D>=matrix.decompose();
			var q:Vector3D=vv[0];//  平移
			var w:Vector3D=vv[1];//  旋转
			var e:Vector3D=vv[2];//  缩放
			return w;
		}



		protected function onMouseDown(event:MouseEvent):void
		{
			
	
		
			
			if(!isComplent||event.shiftKey||event.ctrlKey){
				return;
			}

			var $num:Number=TooMathMoveUint._line50*_sizeNum
			_isMouseDown=true
			_xyzMoveData.oldx=_xyzMoveData.x	
			_xyzMoveData.oldy=_xyzMoveData.y
			_xyzMoveData.oldz=_xyzMoveData.z	
			_xyzMoveData.oldangle_x=_xyzMoveData.angle_x
			_xyzMoveData.oldangle_y=_xyzMoveData.angle_y
			_xyzMoveData.oldangle_z=_xyzMoveData.angle_z

			
			switch(_statceType)
			{
				case TooMathMoveUint.MOVE_XYZ:
				{
					TooXyzMoveMath.mouseDown(_moveDisplay3DSprite,_xyzMoveData)
					break;
				}
				case TooMathMoveUint.MOVE_SCALE:
				{
					TooXyzScaleMath.mouseDown(_scaleDisplay3DSprite,_xyzMoveData)
					break;
				}
				case TooMathMoveUint.MOVE_ROUTATION:
				{
					
					if(TooMathMoveUint.agalLevel==2){  //特殊处理，当AMANI3D找到当前所选的
						var scaleSelectId:uint=TooSelectRotationModel.scanHitModel(_roundDisplay3DSprite.spriteItem,TooMathMoveUint.stage2Dmouse,Context3DTriangleFace.BACK)
						_roundDisplay3DSprite.selectModelId(scaleSelectId)
					}
					
					
					if(_roundDisplay3DSprite.rotationTpey!=""){
						var a:Vector3D,b:Vector3D,c:Vector3D
						if(_roundDisplay3DSprite.rotationTpey=="x"){
							a=new Vector3D(-0,-100,+50)	
							b=new Vector3D(-0,-100,-50)	
							c=new Vector3D(+0,100,+50)	
						}
						if(_roundDisplay3DSprite.rotationTpey=="y"){
							a=new Vector3D(-100,0,+50)	
							b=new Vector3D(-100,0,-50)	
							c=new Vector3D(+100,0,+50)	
						}
						if(_roundDisplay3DSprite.rotationTpey=="z"){
							a=new Vector3D(-100,+50,0)	
							b=new Vector3D(-100,-50,0)	
							c=new Vector3D(+100,+50,0)	
						}
						TooXyzRotationMath.showYaix(a,b,c,_xyzMoveData)
					}
					break;
				}
					
				default:
				{
					
					break;
				}
			}

		}


		

		private function addMove3D():void
		{
			_moveDisplay3DSprite=new TooMoveLevel(_context3D)
		}
		

		

	}
}