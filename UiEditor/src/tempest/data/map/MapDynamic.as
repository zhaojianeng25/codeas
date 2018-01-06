package tempest.data.map
{


	public class MapDynamic
	{
		//String	文件名
		public var filename:String;
		//坐标x
		private var _x:int;
		//坐标y
		private var _y:int;
		/*注册点x*/
		public var regX:int;
		/*注册点y*/
		public var regY:int;
		/*旋转*/
		private var _rotation360:uint;
		/*帧频*/
		public var frameRate:uint=12;
		//渲染模式
		public var blendMode:String="normal";
		/*位于地表*/
		public var atBottom:Boolean=true;
		/*是否水平翻转*/
		public var flipHorizontal:Boolean=false;

		/*位于地图的逻辑坐标*/
		public var postion:WorldPostion;
		/**角度*/
		public var roationAngle:Number=0;

		public function MapDynamic(tileWidth:int, tileHeight:int)
		{
			postion=new WorldPostion(tileWidth, tileHeight)
		}

		public function get rotation360():uint
		{
			return _rotation360;
		}

		public function set rotation360(value:uint):void
		{
			_rotation360=value;
			roationAngle=Math.PI * (_rotation360 / 180);
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x=value;
			postion.tileX=_x / postion.tileWidth;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y=value;
			postion.tileY=_y / postion.tileHeight;
		}

	}
}
