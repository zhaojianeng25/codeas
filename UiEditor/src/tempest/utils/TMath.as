package tempest.utils
{
	import flash.geom.Point;
	import tempest.common.graphics.TLine;

	public class TMath
	{
		//=====================================================直线==========================================================
		/**
		 * 根据两点确定这两点连线的二元一次方程 y = ax + b或者 x = ay + b
		 * @param ponit1
		 * @param point2
		 * @param type		指定返回函数的形式。为0则根据x值得到y，为1则根据y得到x
		 *
		 * @return 由参数中两点确定的直线的二元一次函数
		 */
		public static function getLineFunc(p1:Point, p2:Point, type:int = 0):Function
		{
			var resultFuc:Function;
			// 先考虑两点在一条垂直于坐标轴直线的情况，此时直线方程为 y = a 或者 x = a 的形式
			if (p1.x == p2.x)
			{
				if (type == 0)
				{
					throw new Error("两点所确定直线垂直于y轴，不能根据x值得到y值");
				}
				else if (type == 1)
				{
					resultFuc = function(y:Number):Number
					{
						return p1.x;
					}
				}
				return resultFuc;
			}
			else if (p1.y == p2.y)
			{
				if (type == 0)
				{
					resultFuc = function(x:Number):Number
					{
						return p1.y;
					}
				}
				else if (type == 1)
				{
					throw new Error("两点所确定直线垂直于y轴，不能根据x值得到y值");
				}
				return resultFuc;
			}
			// 当两点确定直线不垂直于坐标轴时直线方程设为 y = ax + b
			var a:Number;
			// 根据
			// y1 = ax1 + b
			// y2 = ax2 + b
			// 上下两式相减消去b, 得到 a = ( y1 - y2 ) / ( x1 - x2 ) 
			a = (p1.y - p2.y) / (p1.x - p2.x);
			var b:Number;
			//将a的值代入任一方程式即可得到b
			b = p1.y - a * p1.x;
			//把a,b值代入即可得到结果函数
			if (type == 0)
			{
				resultFuc = function(x:Number):Number
				{
					return a * x + b;
				}
			}
			else if (type == 1)
			{
				resultFuc = function(y:Number):Number
				{
					return (y - b) / a;
				}
			}
			return resultFuc;
		}

		/**
		 * 得到两点间连线的斜率
		 * @param ponit1
		 * @param point2
		 * @return 			两点间连线的斜率
		 *
		 */
		public static function getSlope(p1:Point, p2:Point):Number
		{
			return (p2.y - p1.y) / (p2.x - p1.x);
		}

		/**
		 * 求垂足
		 * @param l
		 * @param p
		 * @return
		 */
		public static function getPerpendicularFoot2(l:TLine, p:Point):Point
		{
			if (l.k == 0)
			{
				return new Point(p.x, l.p1.y);
			}
			if (isNaN(l.k))
			{
				return new Point(l.p1.x, p.y);
			}
			var k:Number = -((l.p1.x - p.x) * (l.p2.x - l.p1.x) + (l.p1.y - p.y) * (l.p2.y - l.p1.y)) / ((l.p2.x - l.p1.x) * (l.p2.x - l.p1.x) + (l.p2.y - l.p1.y) * (l.p2.y - l.p1.y));
			return new Point(k * (l.p2.x - l.p1.x) + l.p1.x, k * (l.p2.y - l.p1.y) + l.p1.y);
		}

		/**
		 * 求垂足
		 * @param p1 点1
		 * @param p2 点2
		 * @param p 点
		 * @return
		 */
		public static function getPerpendicularFoot(p1:Point, p2:Point, p:Point):Point
		{
			if (p1.y == p2.y)
			{
				return new Point(p.x, p1.y);
			}
			if (p1.x == p2.x)
			{
				return new Point(p1.x, p.y);
			}
			var k:Number = -((p1.x - p.x) * (p2.x - p1.x) + (p1.y - p.y) * (p2.y - p1.y)) / ((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y));
			return new Point(k * (p2.x - p1.x) + p1.x, k * (p2.y - p1.y) + p1.y);
		}

		//====================================================角度、弧度============================================================================
		/**
		 * 获取两点之间的弧度
		 * @param p1
		 * @param p2
		 * @return
		 */
		public static function getRadian(p1:Point, p2:Point):Number
		{
			return Math.atan2(p2.y - p1.y, p2.x - p1.x);
		}

		/**
		 * 弧度转角度
		 * @param radian
		 * @return
		 */
		public static function radian2Angle(radian:Number):Number
		{
			return radian * 180 / Math.PI;
		}

		/**
		 * 角度转弧度
		 * @param angel
		 * @return
		 */
		public static function angel2Radian(angel:Number):Number
		{
			return angel * Math.PI / 180;
		}

		/**
		 * 获取两点角度
		 * @param p1
		 * @param p2
		 */
		public static function getAngle(p1:Point, p2:Point):Number
		{
			return Math.atan2(p2.y - p1.y, p2.x - p1.x) * 180 / Math.PI;
		}
	}
}
