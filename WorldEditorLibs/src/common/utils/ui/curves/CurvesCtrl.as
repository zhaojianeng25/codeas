package common.utils.ui.curves
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import curves.CurveType;
	
	public class CurvesCtrl extends Sprite
	{
		private var leftSp:CurvesCtrlBar;
		private var rightSp:CurvesCtrlBar;
		private var currentTarget:CurvesCtrlBar;
		private var _ctrlKey:CurvesKeyUI
		private var _isBreak:Boolean;
		
		public function CurvesCtrl()
		{
			super();
			
			leftSp = new CurvesCtrlBar;
			leftSp.type = CurvesCtrlBar.LEFT;
			this.addChild(leftSp);
			//leftSp.x = -40;
			
			
			rightSp = new CurvesCtrlBar;
			rightSp.type = CurvesCtrlBar.RIGHT;
			this.addChild(rightSp);
			rightSp.isLine = true;
			//rightSp.x = 40;
			
			draw();
			
			leftSp.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			rightSp.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		public function setCurvesType(value:uint):void
		{
		
			if(_ctrlKey){
				if(currentTarget == rightSp){
					_ctrlKey.ctrlCurveType=value
				}
				if(currentTarget == leftSp){
					_ctrlKey.ctrlCurveTypeLeft=value
				}
                if(value==CurveType.A||value==CurveType.B)
				{
					_ctrlKey.ctrlCurveType=value
					_ctrlKey.ctrlCurveTypeLeft=value
					
				}
				
				if(_ctrlKey.ctrlCurveType==CurveType.A&&_ctrlKey.ctrlCurveTypeLeft==CurveType.A){    //都为A类，
					var $num:Number=(leftSp.rotation+rightSp.rotation)/2
					leftSp.rotation=$num
					rightSp.rotation=$num
				}
				if(_ctrlKey.ctrlCurveType==CurveType.C||_ctrlKey.ctrlCurveTypeLeft==CurveType.C){   //有直线
					//mathLineRotation();
					
					CurvesKeyUI.mathIsLineCurves(_ctrlKey)
						
					leftSp.rotation=_ctrlKey.ctrlRotationLeft
					rightSp.rotation=_ctrlKey.ctrlRotation
			
				}
				resteDataToDraw()
			}
			
		}
		
		private function mathLineRotation():void
		{
			var nextKey:CurvesKeyUI 
			var p0:Point 
			var p1:Point 
			
			if(_ctrlKey.parentCurveItem.nextItem&&_ctrlKey.ctrlCurveType==CurveType.C){    //后面的部分
				 nextKey = _ctrlKey.parentCurveItem.nextItem.getKey(_ctrlKey.id);
				 p0 = _ctrlKey.localToGlobal(new Point);
				 p1 = nextKey.localToGlobal(new Point);
				rightSp.rotation=Math.atan2(p1.y-p0.y,p1.x-p0.x)*180/Math.PI
			}
			if(_ctrlKey.parentCurveItem.parentItem&&_ctrlKey.ctrlCurveTypeLeft==CurveType.C){  //前面的部分
				 nextKey = _ctrlKey.parentCurveItem.parentItem.getKey(_ctrlKey.id);
				 p0 = _ctrlKey.localToGlobal(new Point);
				 p1 = nextKey.localToGlobal(new Point);
				 leftSp.rotation=Math.atan2(p1.y-p0.y,p1.x-p0.x)*180/Math.PI-180
			}
		
		}
		public function show($p:Point,$ctrlKey:CurvesKeyUI):void{
			this.visible = true;
			var p:Point = this.parent.globalToLocal($p);
			_ctrlKey = $ctrlKey;
			this.x = p.x;
			this.y = p.y;
			leftSp.rotation = _ctrlKey.ctrlRotationLeft;
			rightSp.rotation = _ctrlKey.ctrlRotation;

		
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			currentTarget = event.target as CurvesCtrlBar;
			currentTarget.select = true;
			
			if(leftSp != currentTarget){
				leftSp.select = false;
			}
			if(rightSp != currentTarget){
				rightSp.select = false;
			}
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			
			flagY = stage.mouseY;
		}		
		private var flagY:int;
		protected function onMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			if(currentTarget == rightSp&&_ctrlKey.ctrlCurveType==CurveType.C){
				return ;
			}
			if(currentTarget == leftSp&&_ctrlKey.ctrlCurveTypeLeft==CurveType.C){
				return ;
			}
			
			if(currentTarget == rightSp){
				rightSp.rotation += stage.mouseY - flagY;
			}else{
				leftSp.rotation -= stage.mouseY - flagY;
			}
			flagY = stage.mouseY;
			if(rightSp.rotation < -90){
				rightSp.rotation = -90
			}
			if(rightSp.rotation > 90){
				rightSp.rotation = 90;
			}
			if(leftSp.rotation < -90){
				leftSp.rotation = -90
			}
			if(leftSp.rotation > 90){
				leftSp.rotation = 90;
			}
			
			if(_ctrlKey.ctrlCurveType==CurveType.A||_ctrlKey.ctrlCurveTypeLeft==CurveType.A){
				if(currentTarget == rightSp&&_ctrlKey.ctrlCurveTypeLeft==CurveType.A){
					leftSp.rotation=rightSp.rotation
				}
				if(currentTarget == leftSp&&_ctrlKey.ctrlCurveType==CurveType.A){
					rightSp.rotation=leftSp.rotation
				}
			}
			resteDataToDraw()
			
		}	
		private function resteDataToDraw():void
		{
			if(_ctrlKey){
		
				_ctrlKey.ctrlRotation = rightSp.rotation;
				_ctrlKey.ctrlRotationLeft = leftSp.rotation;
				
				_ctrlKey.parentCurveItem.reDraw();
			}
		}
		
		public function draw():void{
			this.graphics.clear();
			this.graphics.lineStyle(1,0xffffff);
			if(!_isBreak){
				this.graphics.beginFill(0xffffff);
			}
			this.graphics.drawCircle(0,0,4);
			this.graphics.endFill();
		}

		public function get isBreak():Boolean
		{
			return _isBreak;
		}

		public function set isBreak(value:Boolean):void
		{
			_isBreak = value;
		}
		
		
	}
}