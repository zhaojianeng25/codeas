package mvc.left.panelleft.vo
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class FrameSprite extends Sprite
	{
		private var _bitmap:Bitmap
		private var _baseBitmapData:BitmapData;
		private var _speed:Number;
		private var _rowColumn:Point
		
		public function FrameSprite($bmp:BitmapData,$rowColumn:Point,$speed:Number)
		{
			_baseBitmapData=$bmp;
			_speed=$speed
			_rowColumn=$rowColumn
	
			_bitmap=new Bitmap
			this.addChild(_bitmap)
			_bitmap.bitmapData=new BitmapData(_baseBitmapData.width/_rowColumn.x,_baseBitmapData.height/_rowColumn.y)
				

			var myTimer:Timer = new Timer(1000/$speed, 99999);
			myTimer.addEventListener("timer", timerHandler);
			myTimer.start();
		}
		
		protected function timerHandler(event:TimerEvent):void
		{
			var totalNum:Number=_rowColumn.x*_rowColumn.y;
			_skipNum++
			if(_skipNum>=totalNum){
				_skipNum=0
			}
			_skipNum=0
			var m:Matrix=new Matrix;
			m.tx=-(_skipNum%_rowColumn.x)*(_baseBitmapData.width/_rowColumn.x)
			m.ty=-int(_skipNum/_rowColumn.x)*(_baseBitmapData.height/_rowColumn.y)
			_bitmap.bitmapData=new BitmapData(_bitmap.bitmapData.width,_bitmap.bitmapData.height,true,0x00000000)
			_bitmap.bitmapData.draw(_baseBitmapData,m)
			
		}
		private var _skipNum:Number=0
	
	}
}