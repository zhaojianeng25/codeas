package  render
{
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import PanV2.xyzmove.MathUint;
	
	import _Pan3D.base.MouseVO;
	import _Pan3D.base.Object3D;
	import _Pan3D.core.Quaternion;
	
	import _me.Scene_data;
	
	import common.AppData;
	
	import modules.scene.sceneCtrl.SceneCtrlView;
	
	import proxy.top.render.Render;
	
	import xyz.MoveScaleRotationLevel;
	

	
	public class NewKeyControl extends EventDispatcher
	{
		private static var instance:NewKeyControl;
        
		public static function getInstance():NewKeyControl
		{
			if(!instance)
			{
				instance = new NewKeyControl();
			}
			return instance;
		}
		
		private var _keyobj:Object = new Object;
		private var _rightDown:Boolean = false;
		private var _mouseInfo:MouseVO = new MouseVO;
		private var _isMiddleDown:Boolean = false;
		
		public static var speedNum:Number = 10;
		public var isTure:Boolean=true   //不再可控制
		private var _middleMoveVe:Vector3D = new Vector3D();
	
		
		public function NewKeyControl()
		{
			
		}
		public function init($D:EventDispatcher):void
		{
			if($D){
				_evtDisp=$D
			}else{
				_evtDisp=Scene_data.stage
			}
			addEvents();
		}
		private var _evtDisp:EventDispatcher
		public function get rightDown():Boolean
		{
			return _rightDown;
		}
	    
		private function addEvents():void
		{
			
			_evtDisp.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onRightMouseDown);
			_evtDisp.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,onMiddleMouseDown);
			_evtDisp.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			
			
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);

			
			Scene_data.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,onRightMouseUp);
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			Scene_data.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,onMiddleMouseUp);
			Scene_data.stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		protected function onMouseWheel(event:MouseEvent):void
		{
			if(event.target is SceneCtrlView)
			{
				var $p:Vector3D = getCamForntPos(event.delta*speedNum)

				Scene_data.cam3D.x = $p.x;
				Scene_data.cam3D.y = $p.y;
				Scene_data.cam3D.z = $p.z;
				Scene_data.cam3D.move=true
			
			}
		}
		
		private function getCamForntPos(dis:Number):Vector3D
		{
		
			var $p:Vector3D = new Vector3D(0,0,dis);
			var $m:Matrix3D = new Matrix3D;
			$m.appendRotation(-Scene_data.cam3D.rotationX, Vector3D.X_AXIS);
			$m.appendRotation(-Scene_data.cam3D.rotationY, Vector3D.Y_AXIS);
			$p=$m.transformVector($p);
			$p.x=Scene_data.cam3D.x + $p.x;
			$p.y=Scene_data.cam3D.y + $p.y;
			$p.z=Scene_data.cam3D.z + $p.z;
			return $p
		}
		protected function onMiddleMouseUp(event:MouseEvent):void
		{
			_isMiddleDown=false;
			Scene_data.cam3D.move=true
		}
		private var middleMovetType:Boolean=true
		protected function onMiddleMouseDown(event:MouseEvent):void
		{
			_isMiddleDown=true;
			_middleMoveVe=mouseHitInWorld3D(new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY));
			_mouseInfo._last_rx = Scene_data.cam3D.x;
			_mouseInfo._last_ry = Scene_data.cam3D.y;
			_mouseInfo._last_rz = Scene_data.cam3D.z;
			
			_mouseInfo._old_x=Scene_data.cam3D.rotationX;
			_mouseInfo._old_y=Scene_data.cam3D.rotationY;
			_mouseInfo._last_x=Scene_data.stage.mouseX;
			_mouseInfo._last_y=Scene_data.stage.mouseY;
			

			if(!MoveScaleRotationLevel.getInstance().xyzMoveData){
				var tempMInvert:Matrix3D=Scene_data.cam3D.cameraMatrix.clone()
				tempMInvert.invert()
				Scene_data.selectVec=tempMInvert.transformVector(new Vector3D(0,0,Scene_data.cam3D.distance))	
			}
			
			if(event.altKey&&Scene_data.selectVec){
				
				middleMovetType=true
				
				baseCamData=getCamData(Scene_data.cam3D.camera3dMatrix)
				baseCamData.rotationX=Scene_data.cam3D.rotationX;
				baseCamData.rotationY=Scene_data.cam3D.rotationY;
				
				
				A=new Matrix3D;
				B=new Matrix3D;
				C=new Matrix3D;
				

				A=Scene_data.cam3D.camera3dMatrix.clone()
				B.appendTranslation(-Scene_data.selectVec.x,-Scene_data.selectVec.y,-Scene_data.selectVec.z)
				var $q:Quaternion=new Quaternion;
				$q.fromMatrix(Scene_data.cam3D.camera3dMatrix)
				C=$q.toMatrix3D();	
				
				disMatrix3D=A.clone();
				var $Binvert:Matrix3D=B.clone()
				$Binvert.invert()
				disMatrix3D.prepend($Binvert)
				
			}else{
				middleMovetType=false
			}
		}
		
		
		private  function  mouseHitInWorld3D($p:Point):Vector3D
		{
			var stageHeight:Number=Scene_data.stage3DVO.width
			var stageWidth:Number=Scene_data.stage3DVO.height
			var $v:Vector3D=new Vector3D();
			$v.x=$p.x-stageWidth/2;
			$v.y=stageHeight/2-$p.y;
			$v.z=Scene_data.sceneViewHW*2;
			var $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-Scene_data.cam3D.rotationX,Vector3D.X_AXIS);
			$m.appendRotation(-Scene_data.cam3D.rotationY,Vector3D.Y_AXIS);
			return $m.transformVector($v);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
		
			var nx:Number=-(Scene_data.stage.mouseX-_mouseInfo._last_x);
			var ny:Number=-(Scene_data.stage.mouseY-_mouseInfo._last_y)
	
			if(_rightDown)
			{
				Scene_data.cam3D.rotationX=_mouseInfo._old_x+ny
				Scene_data.cam3D.rotationY=_mouseInfo._old_y+nx
				Scene_data.cam3D.move=true
			}
			else
			{
				if(_isMiddleDown)
				{

					if(event.altKey){
						if(middleMovetType==true){
							if(Scene_data.selectVec){
								if(baseCamData){
									var $m:Matrix3D=B.clone();
									var $Cinvert:Matrix3D=C.clone();
									$Cinvert.invert();
									$m.appendRotation(nx,Vector3D.Y_AXIS)	
									$m.append(C)
									$m.appendRotation(ny,Vector3D.X_AXIS)	
									$m.append($Cinvert)
									$m.append(disMatrix3D)
									var obj:Object3D=getCamData($m)
									Scene_data.cam3D.x=-obj.x;
									Scene_data.cam3D.y=-obj.y;
									Scene_data.cam3D.z=-obj.z;
									Scene_data.cam3D.rotationX=baseCamData.rotationX+ny
									Scene_data.cam3D.rotationY=baseCamData.rotationY+nx
								}
								
							}
						}else{
							onMiddleMouseDown(event)
						
						}
						
					}else{
						//中键移动;
	
						if(middleMovetType==false){
							var $v:Vector3D=mouseHitInWorld3D(new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY));
							Scene_data.cam3D.x=_mouseInfo._last_rx+	(_middleMoveVe.x-$v.x);
							Scene_data.cam3D.y=_mouseInfo._last_ry+	(_middleMoveVe.y-$v.y);
							Scene_data.cam3D.z=_mouseInfo._last_rz+	(_middleMoveVe.z-$v.z);
						
						}else{
							onMiddleMouseDown(event)
						
						}
						
					}
					
					
					Scene_data.cam3D.move=true
				
				}
			}
			
		}

		private var A:Matrix3D=new Matrix3D;
		private var B:Matrix3D=new Matrix3D;
		private var C:Matrix3D=new Matrix3D;
		protected function onRightMouseDown(event:MouseEvent):void
		{
			_rightDown=true;
			_mouseInfo._old_x=Scene_data.cam3D.rotationX;
			_mouseInfo._old_y=Scene_data.cam3D.rotationY;
			_mouseInfo._last_x=Scene_data.stage.mouseX;
			_mouseInfo._last_y=Scene_data.stage.mouseY;
			Scene_data.cam3D.move=true
		}

		private function getMatrix3Dinvert($m:Matrix3D):Matrix3D
		{
			var $mInvert:Matrix3D=$m.clone()
			$mInvert.invert();
			return $mInvert;
			
			
		}
		private var baseCamData:Object3D;
		private function getCamData(tempMatrix3D:Matrix3D):Object3D
		{
			var $motherAct:Object3D=new Object3D
			var $Minvert:Matrix3D=tempMatrix3D.clone()
			$Minvert.invert()
			var vec:Vector.<Vector3D> = $Minvert.decompose();
			$motherAct.x			= -vec[0].x;
			$motherAct.y			= -vec[0].y;
			$motherAct.z			= -vec[0].z;
			$motherAct.rx		= -vec[1].x;
			$motherAct.ry		= -vec[1].y;
			$motherAct.rz		= -vec[1].z;
			return $motherAct;
			
		}
		private var disMatrix3D:Matrix3D=new Matrix3D
	
		private function getScaleFromMatrix(matrix:Matrix3D):Vector3D
		{
			var vv:Vector.<Vector3D>=matrix.decompose();
			var q:Vector3D=vv[0];//  平移
			var w:Vector3D=vv[1];//  旋转
			var e:Vector3D=vv[2];//  缩放
			return w;
		}

		
		protected function onRightMouseUp(event:MouseEvent):void
		{
			_rightDown=false;
			Scene_data.cam3D.move=true
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			_keyobj[event.keyCode] = false;
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			_keyobj[event.keyCode] = true;
			if(event.keyCode == 13)//enter
			{
				if(event.target.parent && !(event.target.parent is WorldEditor) && event.target.parent.parent &&
					event.target.parent.parent.hasOwnProperty("setFocus"))
				{
					event.target.parent.parent.setFocus();
				}
			}
			if(event.keyCode==Keyboard.F)
			{
				FouceTo(event.ctrlKey)
			}
		
		}
		
		protected function onEnterFrame(event:Event):void
		{

			if(!isTure){
				return 
			}
			if(_rightDown)
			{
				
				if(_keyobj[Keyboard.W])
				{
					tureUp();
					Scene_data.cam3D.move=true
				}
				if(_keyobj[Keyboard.S])
				{
					tureDown();
					Scene_data.cam3D.move=true
				}
				if(_keyobj[Keyboard.A])
				{
					tureLeft();
					Scene_data.cam3D.move=true
				}
				if(_keyobj[Keyboard.D])
				{
					tureRight();
					Scene_data.cam3D.move=true
				}
				if(_keyobj[Keyboard.Q])
				{
					tureYup();
					Scene_data.cam3D.move=true
				}
				if(_keyobj[Keyboard.E])
				{
					tureYdown();
					Scene_data.cam3D.move=true
				}
				
				
			
			}
			MathUint.MathCam(Scene_data.cam3D)
			
			MoveScaleRotationLevel.getInstance().stage3Drec=Render.stage3DRect
			MoveScaleRotationLevel.getInstance().stage2Dmouse=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY);
			MoveScaleRotationLevel.getInstance().camPositon=new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z);

		
			MoveScaleRotationLevel.getInstance().viewMatrx3D=Scene_data.viewMatrx3D
			MoveScaleRotationLevel.getInstance().cameraMatrix=Scene_data.cam3D.cameraMatrix


		}
		public function FouceTo(value:Boolean=false):void
		{
	
			if(Scene_data.selectVec){
				var  $m:Matrix3D=new Matrix3D;
				if(value){
					Scene_data.cam3D.rotationX=-45;
					Scene_data.cam3D.rotationY=Scene_data.gameAngle;
					Scene_data.cam3D.distance=250;
				}
			
				$m.appendRotation(-Scene_data.cam3D.rotationX, Vector3D.X_AXIS);
				$m.appendRotation(-Scene_data.cam3D.rotationY, Vector3D.Y_AXIS);
				$m.appendTranslation( Scene_data.selectVec.x, Scene_data.selectVec.y, Scene_data.selectVec.z)
				var $p:Vector3D=$m.transformVector(new Vector3D(0,0,-Scene_data.cam3D.distance))
				TweenLite.to(Scene_data.cam3D, 0.4, {x:$p.x, y:$p.y,z:$p.z}); 
			}
	
		
		}

		
		private function tureYdown():void
		{
			Scene_data.cam3D.y+=speedNum;
		}
		
		private function tureYup():void
		{
			Scene_data.cam3D.y-=speedNum;
		}
		
		private function tureRight():void
		{
			var $p:Vector3D=new Vector3D(speedNum,0,0);
			var $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-Scene_data.cam3D.rotationX,Vector3D.X_AXIS);
			$m.appendRotation(-Scene_data.cam3D.rotationY,Vector3D.Y_AXIS);
			$p=$m.transformVector($p);
			Scene_data.cam3D.x+=$p.x;
			Scene_data.cam3D.z+=$p.z;
		
		}
		
		private function tureLeft():void
		{
			var $p:Vector3D=new Vector3D(-speedNum,0,0);
			var $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-Scene_data.cam3D.rotationX,Vector3D.X_AXIS);
			$m.appendRotation(-Scene_data.cam3D.rotationY,Vector3D.Y_AXIS);
			$p=$m.transformVector($p);
			Scene_data.cam3D.x+=$p.x;
			Scene_data.cam3D.z+=$p.z;

		}
		
		private function tureUp():void
		{
	        var $p:Vector3D=new Vector3D(0,0,speedNum);
			var $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-Scene_data.cam3D.rotationX,Vector3D.X_AXIS);
			$m.appendRotation(-Scene_data.cam3D.rotationY,Vector3D.Y_AXIS);
			$p=$m.transformVector($p);
			Scene_data.cam3D.x+=$p.x;
			Scene_data.cam3D.y+=$p.y;
			Scene_data.cam3D.z+=$p.z;

		}
		
		private function tureDown():void
		{
			var $p:Vector3D=new Vector3D(0,0,-speedNum);
			var $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-Scene_data.cam3D.rotationX,Vector3D.X_AXIS);
			$m.appendRotation(-Scene_data.cam3D.rotationY,Vector3D.Y_AXIS);
			$p=$m.transformVector($p);
			Scene_data.cam3D.x+=$p.x;
			Scene_data.cam3D.y+=$p.y;
			Scene_data.cam3D.z+=$p.z;

		}

		
		
	}
}