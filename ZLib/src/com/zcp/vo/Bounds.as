package com.zcp.vo
{
	import flash.geom.Rectangle;

	/**
	 * 基本盒子
	 * 本质上是一个简化的Rectangle
	 * 注意：渲染专用，值要用int， 而不能用Number
	 * @author zcp
	 */
	public class Bounds
	{
		public var left:int;
		public var right:int;
		public var top:int;
		public var bottom:int;
		
		
		private static const max:Function = Math.max;
		private static const min:Function = Math.min;
		/**
		 * Bounds
		 * @param $left
		 * @param $right
		 * @param $top
		 * @param $bottom
		 */
		public function Bounds($left:int=0,$right:int=0,$top:int=0,$bottom:int=0)
		{
			left = $left;
			right = $right;
			top = $top;
			bottom = $bottom;
		}
		/**
		 * 范围为一条线(宽度 或 高度 只有一个像素）
		 */
		public function isEmpty() : Boolean
		{
			return right <= left || bottom <= top;
		}

		/**
		 * 面积
		 */
		public function areaSize() : int
		{
			return (right-left)*(bottom-top);
		}
		/**
		 * 是否包含
		 * @param $b
		 */
		public function contains($b:Bounds) : Boolean
		{
			return ($b.left >= left && $b.right <= right && $b.top >= top && $b.bottom <= bottom);
		}
		/**
		 * 是否相等
		 * @param $b
		 */
		public function equals($b:Bounds) : Boolean
		{
			return ($b.left == left && $b.right == right && $b.top == top && $b.bottom == bottom);
		}
		/**
		 * 两个Bounds是否存在交集
		 * @param $b
		 */
		public function intersects($b:Bounds):Boolean
		{
			var i_left:int = max(left,$b.left);
			var i_right:int = min(right,$b.right);
			var i_top:int = max(top,$b.top);
			var i_bottom:int = min(bottom,$b.bottom);
			if(i_left<i_right&&i_top<i_bottom)
			{
				return true;
			}
			return false;
		}
		/**
		 * 求两个Bounds交集
		 * 如无交集则返回 Empty Bounds
		 * @param $b
		 */
		public function intersection($b:Bounds):Bounds
		{
			var i_left:int = max(left,$b.left);
			var i_right:int = min(right,$b.right);
			var i_top:int = max(top,$b.top);
			var i_bottom:int = min(bottom,$b.bottom);
			if(i_left<i_right&&i_top<i_bottom)
			{
				return new Bounds(i_left,i_right,i_top,i_bottom)
			}
			return null;
		}
		/**
		 * 求两个Bounds并集
		 * @param $b
		 */
		public function union($b:Bounds):Bounds
		{
			var i_left:int = min(left,$b.left);
			var i_right:int = max(right,$b.right);
			var i_top:int = min(top,$b.top);
			var i_bottom:int = max(bottom,$b.bottom);
			return	new Bounds(i_left,i_right,i_top,i_bottom)
		}
		
		
		/**
		 * 扩展bounds
		 * @param $b
		 */
		public function extend($b:Bounds):void
		{
			left = min(left,$b.left);
			right = max(right,$b.right);
			top = min(top,$b.top);
			bottom = max(bottom,$b.bottom);
			return;
		}
		

		/**
		 * 将该Bounds转化为Rectangle
		 * @param $b
		 */
		public static function toRectangle($b:Bounds):Rectangle
		{
			return	new Rectangle($b.left,$b.top,$b.right-$b.left,$b.bottom-$b.top);
		}
		/**
		 * 从Rectangle读取数据
		 * @param $rect
		 */
		public static function fromRectangle($rect:Rectangle):Bounds
		{
			return new Bounds($rect.left,$rect.right,$rect.top,$rect.bottom);
		}
		
		/**
		 * 复制一个副本
		 */
		public function clone():Bounds
		{
			return new Bounds(left, right, top, bottom);
		}
	}
}