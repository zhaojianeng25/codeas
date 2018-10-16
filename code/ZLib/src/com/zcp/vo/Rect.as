package com.zcp.vo
{
	import flash.geom.Rectangle;
	
	/**
	 * 本质上是一个Rectangle
	 * 注意：增加了area属性
	 * 另外属性都是int值
	 * @author zcp
	 */
	public class Rect extends Rectangle
	{
		public function Rect(x:int=0, y:int=0, width:int=0, height:int=0)
		{
			super(x, y, width, height);
		}
		/**面积*/
		public function get area():int
		{
			return width*height;
		}
		/**
		 * 复制一个副本
		 */
		override public function clone():Rectangle
		{
			return new Rect(x, y, width, height);
		}
	}
}