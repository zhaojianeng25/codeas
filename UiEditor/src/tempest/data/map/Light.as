package tempest.data.map
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Shape;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	
	import tempest.data.geom.ConstValue;
	import tempest.data.utils.TD;

	/**
	 * 光源 
	 * @author Elaine
	 * 
	 */	
	public class Light
	{
		/**
		 * 小 
		 */		
		private static const SIZE_SMALL:uint = 0;
		/**
		 * 中 
		 */		
		private static const SIZE_MID:uint = 1;
		/**
		 *大 
		 */		
		private static const SIZE_BIG:uint = 2;
		/**
		 * 尺寸列表 
		 */		
		private static const SIZE_MAX:uint = 3;
		
		//光源素材
//		private static const LIGHT_BITMAPDATA:Vector.<BitmapData> = new Vector.<BitmapData>(SIZE_MAX, true);
//		LIGHT_BITMAPDATA[SIZE_SMALL] = createLight(200, 80);		//小
//		LIGHT_BITMAPDATA[SIZE_MID] = createLight(320, 100);	//中
//		LIGHT_BITMAPDATA[SIZE_BIG] = createLight(480, 128);	//大
		
		/**
		 * 主玩家使用的光源 
		 */		
//		public static const MAINPLAYER_LIGHT:BitmapData = createLight(600, 140);
		
		/*创建亮灯*/
		public static function createLight(ellipseWidth:uint, blurFiter:uint):BitmapData
		{
			var ellipseHeight:uint = ellipseWidth * 0.6; //椭圆高度
			var bitmapWidth:uint = ellipseWidth+blurFiter*2;
			var bitmapHeight:uint = ellipseHeight+blurFiter*2;
			//从缓冲区的红色通道值复制到 黑夜蒙版的透明通道			
			var buf1:BitmapData = new BitmapData(bitmapWidth, bitmapHeight, false, 0xFFFFFF);
			var buf2:BitmapData = new BitmapData(buf1.width, buf1.height, true, 0x0);
			
			var child:Shape = new Shape();		
			child.graphics.beginFill(0x000000);
			child.graphics.drawEllipse(0, 0, ellipseWidth, ellipseHeight);
			child.graphics.endFill();
			//模糊滤镜
			var blurFilter:BlurFilter = new BlurFilter(blurFiter, blurFiter, BitmapFilterQuality.HIGH);
			child.filters = [blurFilter];
			
			TD.TemporaryMatrix.identity();
			TD.TemporaryMatrix.tx = (buf1.width - ellipseWidth)/2;
			TD.TemporaryMatrix.ty = (buf1.height - ellipseHeight)/2;
			buf1.draw(child, TD.TemporaryMatrix);
			
			buf2.copyChannel(buf1, buf1.rect, ConstValue.ZeroPoint,
				BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			return buf2;
		}
		
		/**
		 * 坐标 
		 */		
		public var x:uint;
		public var y:uint;
		
		/**
		 * 位于屏幕的区域 
		 */		
//		public var sceneRect:Rectangle = new Rectangle();
		
		/**
		 * 光源尺寸 
		 */		
		public var size:uint;
		
		/**
		 * 光源位图 
		 */		
		public var lightBitmapData:BitmapData;
		
		public function Light()
		{
			
		}
		
//		/**
//		 * 更新数据 
//		 * 
//		 */		
//		public function update():void
//		{
//			lightBitmapData = LIGHT_BITMAPDATA[size];
//			sceneRect.x = x * Config.CELL_WIDTH;
//			sceneRect.y = y * Config.CELL_HEIGHT;
//			sceneRect.width = lightBitmapData.width;
//			sceneRect.height = lightBitmapData.height;
//		}

	}
}