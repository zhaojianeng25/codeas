package renderLevel.levels
{
	import _Pan3D.base.BaseLevel;
	import _Pan3D.lineTri.LineTri3DShader;
	import _Pan3D.lineTri.LineTri3DSprite;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import flash.display3D.Program3D;
	import flash.geom.Vector3D;
	
	public class MoveLineLevel extends BaseLevel
	{
		private var _basePointLine:LineTri3DSprite;
		private var _PointArr:Array;
		private var _x:Number=0
		private var _y:Number=0
		private var _z:Number=0
		private var _rotationX:Number = 0;
		private var _rotationY:Number = 0;
		private var _rotationZ:Number = 0;
		public function MoveLineLevel()
		{
			super();
		}

		public function get rotationZ():Number
		{
			return _rotationZ;
		}

		public function set rotationZ(value:Number):void
		{
			_rotationZ = value;
		}

		public function get rotationY():Number
		{
			return _rotationY;
		}

		public function set rotationY(value:Number):void
		{
			_rotationY = value;
		}

		public function get rotationX():Number
		{
			return _rotationX;
		}

		public function set rotationX(value:Number):void
		{
			_rotationX = value;
		}

		public function get z():Number
		{
			return _z;
		}

		public function set z(value:Number):void
		{
			_z = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function get jiantouSize():Number
		{
			return _jiantouSize;
		}

		public function set jiantouSize(value:Number):void
		{
			_jiantouSize = value;
			drawXyzPosLine();
		}

		public function get lineLonger():Number
		{
			return _lineLonger;
		}

		public function set lineLonger(value:Number):void
		{
			_lineLonger = value;
			drawXyzPosLine();
		}

		public function get lineSize():Number
		{
			return _lineSize;
		}

		public function set lineSize(value:Number):void
		{
			_lineSize = value;
			drawXyzPosLine();
		}

		override protected function initData():void
		{
			addLine3D();
		}
		private function addLine3D():void
		{
			_basePointLine=new LineTri3DSprite(_context3D);
			_basePointLine.setLineData({PointArr:_PointArr});
			_display3DContainer.addChild(_basePointLine)
			_basePointLine.program=Program3DManager .getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
			drawXyzPosLine();
		}
		private var _sizeNum:Number=1
		private var _lineLonger:Number=50
		private var _jiantouSize:Number=5
		private var _lineSize:Number=1
		private function drawXyzPosLine():void
		{
			_sizeNum=Scene_data.cam3D.distance/1000
			_basePointLine.clear();	
			_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(_lineLonger*_sizeNum,0,0),_lineSize,new Vector3D(1,0,1,1))
			_basePointLine.makeLineMode(new Vector3D((_lineLonger-_jiantouSize)*_sizeNum,0,_jiantouSize*_sizeNum),new Vector3D(_lineLonger*_sizeNum,0,0),_lineSize,new Vector3D(1,0,0,1))
			_basePointLine.makeLineMode(new Vector3D((_lineLonger-_jiantouSize)*_sizeNum,0,-_jiantouSize*_sizeNum),new Vector3D(_lineLonger*_sizeNum,0,0),_lineSize,new Vector3D(1,0,0,1))
			
			_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(0,_lineLonger*_sizeNum,0),_lineSize,new Vector3D(0,1,0,1))
			_basePointLine.makeLineMode(new Vector3D(_jiantouSize*_sizeNum,(_lineLonger-_jiantouSize)*_sizeNum,0),new Vector3D(0,_lineLonger*_sizeNum,0),_lineSize,new Vector3D(0,1,0,1))
			_basePointLine.makeLineMode(new Vector3D(-_jiantouSize*_sizeNum,(_lineLonger-_jiantouSize)*_sizeNum,0),new Vector3D(0,_lineLonger*_sizeNum,0),_lineSize,new Vector3D(0,1,0,1))
			
			_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(0,0,_lineLonger*_sizeNum),_lineSize,new Vector3D(0,0,1,1))
			_basePointLine.makeLineMode(new Vector3D(_jiantouSize*_sizeNum,0,(_lineLonger-_jiantouSize)*_sizeNum),new Vector3D(0,0,_lineLonger*_sizeNum),_lineSize,new Vector3D(0,0,1,1))
			_basePointLine.makeLineMode(new Vector3D(-_jiantouSize*_sizeNum,0,(_lineLonger-_jiantouSize)*_sizeNum),new Vector3D(0,0,_lineLonger*_sizeNum),_lineSize,new Vector3D(0,0,1,1))
			
			_basePointLine.refreshGpu();
				
		}
		override public function upData():void
		{
			var _isShow:Boolean = true;
			if(_isShow){
				_display3DContainer.update();
			}
            if(_basePointLine){
				_basePointLine.x=x
				_basePointLine.y=y
				_basePointLine.z=z
				_basePointLine.rotationX=rotationX
				_basePointLine.rotationY=rotationY
				_basePointLine.rotationZ=rotationZ
			}
		}
		override protected function addShaders():void
		{
			Program3DManager.getInstance().registe(LineTri3DShader.LINE_TRI3D_SHADER,LineTri3DShader);
		}
	}
}