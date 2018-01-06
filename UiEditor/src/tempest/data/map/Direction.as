package tempest.data.map
{
	import flash.geom.Point;

	public class Direction
	{
		/**
		 * 正北
		 * @default
		 */
		public static const NORTH:uint=0; //
		/**
		 * 东北
		 * @default
		 */
		public static const NOTRH_EAST:uint=1; //
		/**
		 * 正东
		 * @default
		 */
		public static const EAST:uint=2; //
		/**
		 * 东南
		 * @default
		 */
		public static const SOUTH_EAST:uint=3; //
		/**
		 * 正南
		 * @default
		 */
		public static const SOUTH:uint=4; //
		/**
		 * 西南
		 * @default
		 */
		public static const SOUTH_WEST:uint=5; //
		/**
		 * 正西
		 * @default
		 */
		public static const WEST:uint=6; //
		/**
		 * 西北
		 * @default
		 */
		public static const NORTH_WEST:uint=7; //

		/**
		 * 计算8方向
		 * @param current
		 * @param target
		 * @param isBevel 是否斜角
		 * @return
		 */
		public static function getDirection(current:Point, target:Point):int
		{
			var angle:Number=Math.atan2(target.y - current.y, target.x - current.x) * 180 / Math.PI;
			return (Math.round((angle + 90) / 45) + 8) % 8; //角色面向正北为0  角度+90
		}
	}
}
