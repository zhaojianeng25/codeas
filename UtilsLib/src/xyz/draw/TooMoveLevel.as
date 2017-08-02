package xyz.draw
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	
	public class TooMoveLevel extends TooUtilDisplay
	{
		private var _boxA:TooJianTouDisplay3DSprite
		private var _boxB:TooJianTouDisplay3DSprite
		private var _boxC:TooJianTouDisplay3DSprite
		private var _boxO:TooBoxDisplay3DSprite
		private var _XzTri:TooTriDisplay3DSprite
		private var _XyTri:TooTriDisplay3DSprite
		private var _YzTri:TooTriDisplay3DSprite
		
		
		public function TooMoveLevel(context:Context3D)
		{
			super(context);
			_basePointLine=new TooLineTri3DSprite(_context3D)
			_boxA=new TooJianTouDisplay3DSprite(_context3D)
			_boxB=new TooJianTouDisplay3DSprite(_context3D)
			_boxC=new TooJianTouDisplay3DSprite(_context3D)
			_boxO=new TooBoxDisplay3DSprite(_context3D)
				
			_XzTri=new TooTriDisplay3DSprite(_context3D);
			_XzTri.colorVec=new Vector3D(1,0,0,0.2);
			_XyTri=new TooTriDisplay3DSprite(_context3D);
			_XyTri.colorVec=new Vector3D(0,1,0,0.2);
			_YzTri=new TooTriDisplay3DSprite(_context3D);
			_YzTri.colorVec=new Vector3D(0,0,1,0.2);
				
				
			
			_boxA.colorVec=new Vector3D(1,0,0)
			_boxB.colorVec=new Vector3D(0,1,0)
			_boxC.colorVec=new Vector3D(0,0,1)
			_boxO.colorVec=new Vector3D(0.5,0.5,0)
			
		}
		private var _basePointLine:TooLineTri3DSprite;
		private var _jiantouSize:Number=5
		private var _lineSize:Number=1
	
	
		private var _sizeNum:Number=1;



		private function drawXyzPosLine():void
		{
			var $NUM:Number=1;
			var line50:Number=TooMathMoveUint._line50
			_basePointLine.clear();	
			
	
			var baseSize:Number=(1/_sizeNum)*3
			_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(line50*$NUM,0,0),baseSize,new Vector3D(1,0,0,1))

			_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(0,line50*$NUM,0),baseSize,new Vector3D(0,1,0,1))

			_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(0,0,line50*$NUM),baseSize,new Vector3D(0,0,1,1))

			_basePointLine.reSetUplodToGpu();
			
			
		}
		public function get spriteItem():Vector.<TooUtilDisplay>
		{
			var arr:Vector.<TooUtilDisplay>=new Vector.<TooUtilDisplay>
			arr.push(_boxO)
			arr.push(_boxA)
			arr.push(_boxB)
			arr.push(_boxC)
			arr.push(_XzTri)
			arr.push(_XyTri)
			arr.push(_YzTri)
			
			return arr
		}
		public function selectHitColor($selectId:uint):void
		{
			
			
			if($selectId==0){
				_boxO.colorVec=new Vector3D(1,0,1)
			}else{
				_boxO.colorVec=new Vector3D(1,1,0)
			}
			if($selectId==1){
				_boxA.colorVec=new Vector3D(1,1,0)
			}else{
				_boxA.colorVec=new Vector3D(1,0,0)
			}
			if($selectId==2){
				_boxB.colorVec=new Vector3D(1,1,0)
			}else{
				_boxB.colorVec=new Vector3D(0,1,0)
			}
			if($selectId==3){
				_boxC.colorVec=new Vector3D(1,1,0)
			}else{
				_boxC.colorVec=new Vector3D(0,0,1)
			}
			
			if($selectId==4){
				_XzTri.colorVec=new Vector3D(1,0,0,0.5);
			}else{
				_XzTri.colorVec=new Vector3D(1,0,0,0.2);
			}
			if($selectId==5){
				_XyTri.colorVec=new Vector3D(0,1,0,0.5);
			}else{
				_XyTri.colorVec=new Vector3D(0,1,0,0.2);
			}
			if($selectId==6){
				_YzTri.colorVec=new Vector3D(0,0,1,0.5);
			}else{
				_YzTri.colorVec=new Vector3D(0,0,1,0.2);
			}
	
		}
		public function set sizeNum(value:Number):void
		{
			_sizeNum = value;
		}
	
		override public function update():void
		{
			if(_basePointLine){
				var line50:Number=TooMathMoveUint._line50
					
				drawXyzPosLine();
				_basePointLine.posMatrix=this.posMatrix
				_basePointLine.update()
					
				_boxO.posMatrix=this.posMatrix
				_boxO.update()
					
				var $m:Matrix3D
				_boxA.posMatrix=this.posMatrix.clone()
				_boxA.posMatrix.prependTranslation(line50,0,0)
				_boxA.update()
				
				_boxB.posMatrix=this.posMatrix.clone()
				_boxB.posMatrix.prependTranslation(0,line50,0)
				_boxB.posMatrix.prependRotation(90,Vector3D.Z_AXIS)
				_boxB.update()
				
				_boxC.posMatrix=this.posMatrix.clone()
				_boxC.posMatrix.prependTranslation(0,0,line50)
				_boxC.posMatrix.prependRotation(-90,Vector3D.Y_AXIS)
				_boxC.update()
					
					
				_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				
				_XzTri.posMatrix=this.posMatrix.clone()
				_XzTri.update();
				_XyTri.posMatrix=this.posMatrix.clone()
				_XyTri.posMatrix.prependRotation(-90,Vector3D.X_AXIS)
				_XyTri.update();
				_YzTri.posMatrix=this.posMatrix.clone()
				_YzTri.posMatrix.prependRotation(90,Vector3D.Z_AXIS)
				_YzTri.update();
				_context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE);
			
				
			}
		}
		
	}
}


