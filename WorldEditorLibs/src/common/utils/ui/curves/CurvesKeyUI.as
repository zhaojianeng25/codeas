package common.utils.ui.curves
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.BezierClass;
	
	import curves.CurveType;
	
	public class CurvesKeyUI extends Sprite
	{
		public var id:int;
		public var parentCurveItem:CurvesItemUI;
		
		private var _ctrlRotation:int;
		private var _ctrlRotationLeft:int;
		private var _ctrlCurveType:int
		private var _ctrlCurveTypeLeft:int
		
		private var testSp:Sprite;
		
		private var _valueVec:Vector.<Number>;
		
		private var baseW:int = 8;
		
		public var scaleNum:Number = 1;
		
		public function CurvesKeyUI()
		{
			super();
			
			testSp = new Sprite;
			this.addChild(testSp);
			
		}
		
		




		public function get ctrlCurveTypeLeft():int
		{
			return _ctrlCurveTypeLeft;
		}

		public function set ctrlCurveTypeLeft(value:int):void
		{
			_ctrlCurveTypeLeft = value;
		}

		public function get ctrlCurveType():int
		{
			return _ctrlCurveType;
		}

		public function set ctrlCurveType(value:int):void
		{
			_ctrlCurveType = value;
		}

		public function get valueVec():Vector.<Number>
		{
			return _valueVec;
		}

        public static function mathIsLineCurves($tempKey:CurvesKeyUI):void
		{
			var p0:Point 
			var p1:Point 
			if($tempKey.parentCurveItem.nextItem&&$tempKey.ctrlCurveType==CurveType.C){
				var nextKey:CurvesKeyUI  = $tempKey.parentCurveItem.nextItem.getKey($tempKey.id);
				p0 = $tempKey.localToGlobal(new Point);
				p1 = nextKey.localToGlobal(new Point);
				$tempKey.ctrlRotation=Math.atan2(p1.y-p0.y,p1.x-p0.x)*180/Math.PI
				//mathIsLineCurves(nextKey)
			}
			if($tempKey.parentCurveItem.parentItem&&$tempKey.ctrlCurveTypeLeft==CurveType.C){
				var preKey:CurvesKeyUI = $tempKey.parentCurveItem.parentItem.getKey($tempKey.id);
				p0 = $tempKey.localToGlobal(new Point);
				p1 = preKey.localToGlobal(new Point);
				$tempKey.ctrlRotationLeft=Math.atan2(p1.y-p0.y,p1.x-p0.x)*180/Math.PI-180
			}
		}

		public function draw():void{
			
			if(!_valueVec){
				_valueVec = new Vector.<Number>;
			}
			if(this.ctrlCurveType==CurveType.C||this.ctrlCurveTypeLeft==CurveType.C){
				mathIsLineCurves(this)
				if(this.parentCurveItem.nextItem){//特殊对下一上节点也更新
					var $nextCtrlKeyUi:CurvesKeyUI=this.parentCurveItem.nextItem.getKey(this.id);
					mathIsLineCurves($nextCtrlKeyUi)
				}
			}
			
			this.graphics.clear();
			this.graphics.beginFill(getColor(),1);
			this.graphics.drawRect(-4,-4,8,8);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1,getColor(),0.5);
			var p:Point;
		
			if(this.parentCurveItem.nextItem){
				var nextKey:CurvesKeyUI = this.parentCurveItem.nextItem.getKey(this.id);
				p = nextKey.localToGlobal(new Point);
				p = this.globalToLocal(p);
				
				this.graphics.moveTo(0,0);
				
				var lp:Point = new Point(p.x/2,0);
				var ma:Matrix = new Matrix;
				ma.rotate(ctrlRotation * Math.PI / 180);
				lp = ma.transformPoint(lp);
				
				var rp:Point = new Point(-p.x/2,0);
				ma.identity();
				ma.rotate(nextKey.ctrlRotationLeft * Math.PI / 180);
				rp = ma.transformPoint(rp);
				
				this.graphics.cubicCurveTo(lp.x,lp.y,rp.x + p.x,rp.y + p.y,p.x,p.y);
				
				drawTest(new Point(0,0),new Point(lp.x,lp.y),new Point(rp.x + p.x,rp.y + p.y),new Point(p.x,p.y),p.x);
				
			}else{
				this.graphics.moveTo(0,0);
				this.graphics.lineTo(2000,0);
				_valueVec.length = 0;
				
	
				
				_valueVec.push(Math.abs((this.y)/(CurvesItemUI.maxLineHeight)+CurvesItemUI.minLineHeight) * scaleNum);
				
				//_valueVec.push(Math.abs(this.y/160)* scaleNum);
			}
			
			if(!this.parentCurveItem.parentItem){
				p = CurvesUI.getInstance().getXpos();
				p = this.globalToLocal(p);
				
				this.graphics.moveTo(0,0);
				this.graphics.lineTo(p.x,0);
			}
			
		}
		
		private function drawTest(p0:Point,p1:Point,p2:Point,p3:Point,leng:int):void{
			var numPoint:int = leng / baseW * 3;
			
			var ary:Array = [new Vector3D(p0.x,p0.y,0),new Vector3D(p1.x,p1.y,0),new Vector3D(p2.x,p2.y,0),new Vector3D(p3.x,p3.y,0)];
			
			//testSp.graphics.clear();
			//testSp.graphics.beginFill(0x00ff00);
			
			var posAry:Vector.<Point> = new Vector.<Point>;
			
			for(var i:int = 1;i<numPoint;i++){
				var num:Number = i/numPoint;
				var p:Object = BezierClass.drawbezier(ary,num);
				posAry.push(new Point(p.x,p.y));
			}
			
			_valueVec.length = 0;
			
			var flag:int;
			
			var maxFlag:int = leng / baseW;
			
			for(i=0;i<maxFlag;i++){
				for(var j:int = 0;j<posAry.length;j++){
					if(posAry[j].x >= i*baseW){
						_valueVec.push(Math.abs((posAry[j].y + this.y)/(CurvesItemUI.maxLineHeight)+CurvesItemUI.minLineHeight) * scaleNum);
						break;
					}
				}
			}
			
			//testSp.graphics.endFill();
			
		}
		
		public function getColor():uint{
			if(id == 0){
				return 0xff0000;
			}else if(id == 1){
				return 0x00ff00;
			}else if(id == 2){
				return 0x0000ff;
			}else{
				return 0x999999;
			}
		}

		public function get ctrlRotation():int
		{
			return _ctrlRotation;
		}

		public function set ctrlRotation(value:int):void
		{
			_ctrlRotation = value;
			
			//this.parentCurveItem.reDraw();
			
		}

		public function get ctrlRotationLeft():int
		{
			return _ctrlRotationLeft;
		}
		
		public function set ctrlRotationLeft(value:int):void
		{
			_ctrlRotationLeft = value;
		//	this.parentCurveItem.reDraw();
		}

	}
}