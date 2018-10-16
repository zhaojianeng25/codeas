package  xyz.draw
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	
	public class TooScaleLevel extends TooUtilDisplay
	{
		
		private var _boxA:TooBoxDisplay3DSprite
		private var _boxB:TooBoxDisplay3DSprite
		private var _boxC:TooBoxDisplay3DSprite
		private var _boxO:TooBoxDisplay3DSprite
		public function TooScaleLevel(context:Context3D)
		{
			super(context);
			_basePointLine=new TooLineTri3DSprite(_context3D)
			_boxA=new TooBoxDisplay3DSprite(_context3D)
			_boxB=new TooBoxDisplay3DSprite(_context3D)
			_boxC=new TooBoxDisplay3DSprite(_context3D)
			_boxO=new TooBoxDisplay3DSprite(_context3D)
				
			_boxA.colorVec=new Vector3D(1,0,0)
			_boxB.colorVec=new Vector3D(0,1,0)
			_boxC.colorVec=new Vector3D(0,0,1)
			_boxO.colorVec=new Vector3D(0.5,0.5,1)
		}
		private var _basePointLine:TooLineTri3DSprite;



		public function set sizeNum(value:Number):void
		{
			_sizeNum = value;
		}
		public function get spriteItem():Vector.<TooUtilDisplay>
		{
			var arr:Vector.<TooUtilDisplay>=new Vector.<TooUtilDisplay>
			arr.push(_boxO)
			arr.push(_boxA)
			arr.push(_boxB)
			arr.push(_boxC)
			return arr
		}
		
		public function selectHitColor($selectId:uint):void
		{

			
			if($selectId==0){
				_boxO.colorVec=new Vector3D(1,1,0)
			}else{
				_boxO.colorVec=new Vector3D(1,0,1)
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
		}

		private function drawXyzPosLine():void
		{
	
			_basePointLine.clear();	
			var baseSize:Number=(1/_sizeNum)*3
			var line50:Number=TooMathMoveUint._line50
			_basePointLine.clear();	
			if(TooXyzScaleMath._hitX||TooXyzScaleMath._hitCenten){
				_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(line50+addScale*line50,0,0),baseSize,new Vector3D(1,0,0,1))
			}else{
				_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(line50,0,0),baseSize,new Vector3D(1,0,0,1))
			}
			if(TooXyzScaleMath._hitY||TooXyzScaleMath._hitCenten){
				_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(0,line50+addScale*line50,0),baseSize,new Vector3D(0,1,0,1))
			}else{
				_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(0,line50,0),baseSize,new Vector3D(1,0,0,1))
			}
			if(TooXyzScaleMath._hitZ||TooXyzScaleMath._hitCenten){
				_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(0,0,line50+addScale*line50),baseSize,new Vector3D(0,0,1,1))
			}else{
				_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(0,0,line50),baseSize,new Vector3D(1,0,0,1))
			}
			_basePointLine.reSetUplodToGpu();

		}
		private var _sizeNum:Number=1;
		private var _jiantouSize:Number=1
        public var addScale:Number=0
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
				if(TooXyzScaleMath._hitX||TooXyzScaleMath._hitCenten){
					_boxA.posMatrix.prependTranslation(line50*(1+addScale),0,0)
				}else{
					_boxA.posMatrix.prependTranslation(line50,0,0)
				}
				_boxA.update()
					
				_boxB.posMatrix=this.posMatrix.clone()
				if(TooXyzScaleMath._hitY||TooXyzScaleMath._hitCenten){
					_boxB.posMatrix.prependTranslation(0,line50*(1+addScale),0)
				}else{
					_boxB.posMatrix.prependTranslation(0,line50,0)
				}
				_boxB.update()
				_boxC.posMatrix=this.posMatrix.clone()
				if(TooXyzScaleMath._hitZ||TooXyzScaleMath._hitCenten){
					_boxC.posMatrix.prependTranslation(0,0,line50*(1+addScale))
				}else{
					_boxC.posMatrix.prependTranslation(0,0,line50)
				}
				_boxC.update()
			}
		}
		
	}
}