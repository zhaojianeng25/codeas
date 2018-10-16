package tempest.data.map
{
	import flash.geom.Point;

	import tempest.data.geom.point;

	/**
	 * 跳跃点
	 * @author zhangyong
	 *
	 */
	public class JumpPoint extends point
	{
		/**跳跃点坐标*/
		private var _position:Point;
		/**动画资源id*/
		public var aniId:int;
		/**跳跃目标点*/
		public var targetPoint:Point;
		/**动作id**/
		public var actionId:int=6;

		public function JumpPoint()
		{
		}

		/**跳跃点坐标*/
		public function get position():Point
		{
			if (!_position)
			{
				_position=new Point(x, y);
			}
			return _position;
		}
	}
}
