package  xyz.draw
{
	import flash.geom.Point;
	
	//import _me.Scene_data;

	public class TooXyzSkipMath
	{
		public function TooXyzSkipMath()
		{
		}
		public static var _disA:Point
		public static var _disB:Point
		public static var _lastMouseChuiZhu:Point
		
		/**
		 *两点一线 ，计算垂点 
		 * @param a 线 A
		 * @param b 线B
		 * @param c 线外一点
		 * @return  在线上的垂足
		 * 
		 */
		public  static function mathChuizhu(a:Point,b:Point,c:Point):Point
		{
			var A:Number=	(b.y-a.y)	
			var B:Number=	-1*(b.x-a.x)
			var C:Number=	-a.x*(b.y-a.y)+a.y*(b.x-a.x)
			
			var DD:Point=	footOfPerpendicular(c.x,c.y,A,B,C)
			function footOfPerpendicular( x1:Number,  y1:Number,  A:Number,  B:Number,  C:Number):Point
			{
				var kkkk:Point=new Point
				if (A * A + B * B < 1e-13) return null;           
				if (Math.abs(A * x1 + B * y1 + C) < 1e-13)
				{
					kkkk.x = x1;
					kkkk.y= y1;
				}
				else
				{
					kkkk.x = (B * B * x1 - A * B * y1 - A * C) / (A * A + B * B);
					kkkk.y = (-A * B * x1 + A * A * y1 - B * C) / (A * A + B * B);
				}
				return kkkk;
			}
			return DD
		}
		/**
		 * 
		 * @return  得到垂足于屏幕上的，在平面线上的点
		 * 
		 */
		private static function getChunZhiPos():Point
		{
			var c:Point=TooMathMoveUint.stage3Dmouse.clone()
			if(TooXyzSkipMath._disA&&TooXyzSkipMath._disB){
				var kk:Point=mathChuizhu(TooXyzSkipMath._disA,TooXyzSkipMath._disB,c)
				if(kk){
					return kk
				}
			}
			return null
		}
		
		/**
		 * 
		 * @return 得到返回旋转的角度
		 * 
		 */
		public static function getRotationSkip():Number
		{
			var num:Number=0
			var keeike:Point=getChunZhiPos()
			if(keeike&&_lastMouseChuiZhu){
				var pnr0:Point=new Point(keeike.y-_lastMouseChuiZhu.y,keeike.x-_lastMouseChuiZhu.x)
				pnr0.normalize(1)
				var pnr1:Point=new Point((TooXyzSkipMath._disB.y-TooXyzSkipMath._disA.y),(TooXyzSkipMath._disB.x-TooXyzSkipMath._disA.x))
				pnr1.normalize(1)
				var rrr:Number=Point.distance(keeike,_lastMouseChuiZhu)
				if(rrr){
					num=rrr*(pnr0.x*pnr1.x+pnr0.y*pnr1.y)*0.5
				}
			}
			return  num
			
		}
		public static function mathLastChuiZhu():void
		{
			_lastMouseChuiZhu=getChunZhiPos()
		}
	}
}