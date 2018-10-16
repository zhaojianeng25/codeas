package _Pan3D.core
{
	import flash.geom.Point;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class TestTriangle
	{
		public var p1:Point;
		public var p2:Point;
		public var p3:Point;
		public var precision:Number;

		public function TestTriangle( $p1:Point=null, $p2:Point=null, $p3:Point=null ,$precision:Number = 0.1):void
		{
			p1 = $p1;
			p2 = $p2;
			p3 = $p3;
			precision = $precision;
		}
		public function setAllPoint($p1:Point, $p2:Point, $p3:Point):void
		{
			p1 = $p1;
			p2 = $p2;
			p3 = $p3;
		}

		public function checkPointIn( tp:Point ):Boolean
		{
			var area:Number = getArea();
			var targetThreeTimesArea:Number = 0;
			targetThreeTimesArea += getAreaByPoints( tp, p1, p2 );
			targetThreeTimesArea += getAreaByPoints( tp, p2, p3 );
			targetThreeTimesArea += getAreaByPoints( tp, p3, p1 );
			return targetThreeTimesArea == area || Math.abs( targetThreeTimesArea - area ) < precision;
		}

		public function getArea():Number
		{
			return getAreaByPoints( p1, p2, p3 );
		}

		public static function getAreaByPoints( p1:Point, p2:Point, p3:Point ):Number
		{
			// 方法一
			// 利用两点之间距离公式，求出三角形的三边长a，b，c后，
			// 令p = (a+b+c)/2。再套入以下公式就可以求出三角形的面积S :
			// S = sqrt(p*(p-a)*(p-b)*(p-c))
			var dx:Number = p1.x - p2.x;
			var dy:Number = p1.y - p2.y;
			var p1Len:Number = Math.sqrt( dx * dx + dy * dy );
			dx = p2.x - p3.x;
			dy = p2.y - p3.y;
			var p2Len:Number = Math.sqrt( dx * dx + dy * dy );
			dx = p3.x - p1.x;
			dy = p3.y - p1.y;
			var p3Len:Number = Math.sqrt( dx * dx + dy * dy );

			var p:Number = (p1Len + p2Len + p3Len) / 2;
			var v:Number = p * (p - p1Len) * (p - p2Len) * (p - p3Len);
			if(v > 0)
			{
				return Math.sqrt(v);
			}
			return 0;
		}
	}
}
