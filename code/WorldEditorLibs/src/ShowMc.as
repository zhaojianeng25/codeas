package    
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class ShowMc extends Sprite
	{
		private var _bmpPic:Bitmap;
		private var _sp:Sprite;
		private static var instance:ShowMc;
		public function ShowMc()
		{
			super();
			addBmp();
		}
		public static function getInstance():ShowMc{
			if(!instance){
				instance = new ShowMc();
			}
			return instance;
		}
		
		public function get bmpPic():Bitmap
		{
			return _bmpPic;
		}

		public function set bmpPic(value:Bitmap):void
		{
			_bmpPic = value;
		}

		public function get sp():Sprite
		{
			return _sp;
		}

		private function addPoint():void
		{
			_sp=new Sprite
			_sp.graphics.beginFill(0xff0000,1);
			_sp.graphics.drawCircle(0,0,1)
			_sp.graphics.endFill();
			addChild(_sp)
			
		}
		
		private function addBmp():void
		{
			_bmpPic=new Bitmap()
		    addChild(_bmpPic)
		}
		public function setBitMapData(bmp:BitmapData,P:Point=null):void
		{
			this.mouseChildren=false
			this.mouseEnabled=false;
			_bmpPic.bitmapData=bmp;
			if(P){
				x=P.x;
				y=P.y;
			}
		}
		
		
	}
}