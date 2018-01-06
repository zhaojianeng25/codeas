package tempest.common.graphics
{
	import flash.geom.Point;

	/**
	 * 直线
	 * @author wushangkun
	 */
	public class TLine
	{
		private var _p1:Point;
		private var _p2:Point;
		private var _k:Number;
		private var _radian:Number;
		private var _angle:Number;

		/**
		 * 直线
		 * @param p1 点1
		 * @param p2 点2
		 */
		public function TLine(p1:Point, p2:Point)
		{
			_p1 = p1;
			_p2 = p2;
			init();
		}

		private function init():void
		{
			_k = (_p2.x == _p1.x) ? NaN : (_p2.y - _p1.y) / (_p2.x - _p1.x);
			_radian = Math.atan2(_p2.y - _p1.y, _p2.x - _p1.x);
			_angle = _radian * 180 / Math.PI;
		}

		/**
		 * 获取/设置点1
		 * @return
		 */
		public function get p1():Point
		{
			return _p1;
		}

		public function set p1(value:Point):void
		{
			_p1 = value;
			init();
		}

		/**
		 * 获取/设置点2
		 * @return
		 */
		public function get p2():Point
		{
			return _p2;
		}

		public function set p2(value:Point):void
		{
			_p2 = value;
			init();
		}

		/**
		 * 斜率
		 * @return
		 */
		public function get k():Number
		{
			return _k;
		}

		/**
		 * 角度
		 * @return
		 */
		public function get angle():Number
		{
			return _angle;
		}

		/**
		 * 弧度
		 * @return
		 */
		public function get radian():Number
		{
			return _radian;
		}

		/**
		 * 是否在直线上
		 * @param p 要检测的点
		 * @return
		 */
		public function isOnLine(p:Point):Boolean
		{
			var kk:Number = (p.x == _p1.x) ? NaN : (p.y - _p1.y) / (p.x - _p1.x);
			if (isNaN(_k) && isNaN(kk))
			{
				return true;
			}
			return _k == kk;
		}

		/**
		 * 是否在直线上
		 * @param p1
		 * @param p2
		 * @param p
		 * @return
		 */
		public static function isOnLine(p1:Point, p2:Point, p:Point):Boolean
		{
			var k1:Number = (p2.x == p1.x) ? NaN : (p2.y - p1.y) / (p2.x - p1.x);
			var k2:Number = (p.x == p1.x) ? NaN : (p.y - p1.y) / (p.x - p1.x);
			return (isNaN(k1) && isNaN(k2)) || (k1 == k2);
		}

		/**
		 * 是否在线段上
		 * @param p 要检测的点
		 * @return
		 */
		public function isOnSegment(p:Point):Boolean
		{
			var ratioX:Number = Math.round((_p1.x - p.x) / -(_p2.x - _p1.x) * 100) / 100;
			var ratioY:Number = Math.round((_p1.y - p.y) / -(_p2.y - _p1.y) * 100) / 100;
			return (ratioX == ratioY && ratioX >= 0 && ratioX <= 1);
		}

		/**
		 * 按制定刻度分割线段
		 * @param tick 分割刻度
		 * @return
		 */
		public function split(tick:Number = 1):Array
		{
			var vx:Number = _p2.x - _p1.x;
			var vy:Number = _p2.y - _p1.y;
			var dx:Number = (vx < 0) ? -vx : vx;
			var dy:Number = (vy < 0) ? -vy : vy;
			var tx:Number = 0;
			var ty:Number = 0;
			var count:int = 0;
			var arr:Array = [];
			arr.push(_p1);
			if (dx % tick == 0 && dy % tick == 0)
			{
				if (dx == 0)
				{
					tx = 0;
					ty = (vy < 0) ? -tick : tick;
					count = dy / tick;
				}
				else if (dy == 0)
				{
					ty = 0;
					tx = (vx < 0) ? -tick : tick;
					count = dx / tick;
				}
				else if (dy / tick == dx / tick)
				{
					tx = (vx < 0) ? -tick : tick;
					ty = (vy < 0) ? -tick : tick;
					count = dx / tick;
				}
				for (var i:int = 1; i < count; i++)
				{
					arr.push(new Point(_p1.x + i * tx, _p1.y + i * ty));
				}
			}
			arr.push(_p2);
			return arr;
		}

		public function toString():String
		{
			return "p1:" + _p1 + " p2:" + _p2 + " k:" + _k + " radian:" + _radian + " angle:" + _angle;
		}
	}
}
