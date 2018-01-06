package tempest.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public final class Geom
	{
		private static const RAD_2_RANGLE:Number=180 / Math.PI; //弧度到角度转换比
		public static const RAD_RANGLE:Number=Math.PI / 180;

		/**
		 * 初始化对象
		 * 解决某些嵌入对象宽高为0
		 * @param obj
		 */
		public static function initSize(obj:DisplayObject):void
		{
			var _rect:Rectangle=obj.getRect(obj);
			obj.width=_rect.width;
			obj.height=_rect.height;
		}

		/**
		 * 让对象在范围内居中
		 *
		 * @param obj	显示对象
		 * @param cotainer	容器区域
		 *
		 */
		public static function centerIn(obj:DisplayObject, cotainer:DisplayObjectContainer):void
		{
			moveCenterTo(obj, center(cotainer));
		}

		/**
		 * 获得中心点
		 *
		 * @param obj	显示对象或者矩形
		 * @return
		 *
		 */
		public static function center(obj:*):Point
		{
			if (obj is Rectangle)
				return new Point(obj.width / 2, obj.height / 2);
			var rect:Rectangle=obj.getRect(obj);
			return new Point(rect.width / 2, rect.height / 2);
		}

		/**
		 * 移动中心点至某个坐标
		 *
		 * @param obj	显示对象
		 * @param target	目标父对象坐标
		 *
		 */
		public static function moveCenterTo(obj:*, target:Point):void
		{
			var center:Point=center(obj);
			obj.x+=target.x - center.x;
			obj.y+=target.y - center.y;
		}

		/**
		 * 获取两点间距离
		 * @param p1
		 * @param p2
		 * @return
		 */
		public static function getDistance(p1:Point, p2:Point):Number
		{
			return Math.sqrt(Math.pow(p1.x - p2.x, 2) + Math.pow(p1.y - p2.y, 2));
		}

		/**
		 *通过两点之间的坐标值来获取两点间距离
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return
		 *
		 */
		public static function getDistance2(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			return Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
		}

		/**
		 * 获取两点之间的弧度
		 * @param p1
		 * @param p2
		 * @return
		 */
		public static function getTwoPointRadian(p1:Point, p2:Point):Number
		{
			return Math.atan2(p1.y - p2.y, p1.x - p2.x);
		}

		/**
		 * 弧度转角度
		 * @param radian
		 * @return
		 */
		public static function getAngle(radian:Number):Number
		{
			return radian * RAD_2_RANGLE;
		}

		/**
		 * 获取两点角度
		 * @param p1
		 * @param p2
		 */
		public static function GetRotation(p1:Point, p2:Point):Number
		{
			return Math.atan2(p2.y - p1.y, p2.x - p1.x) * RAD_2_RANGLE;
		}

		/**
		 * 获取两点角度
		 * @param p1
		 * @param p2
		 */
		public static function getTwoPointAngle(p1:Point, p2:Point):Number
		{
			return Math.atan2(p1.y - p2.y, p1.x - p2.x) * RAD_2_RANGLE;
		}

		/**
		 *获取指定小于某个数的值
		 * @param currentNum
		 * @param maxValue
		 * @return
		 *
		 */
		public static function getNumSmall(currentNum:Number, maxValue:int):Number
		{
			return (currentNum >= maxValue) ? maxValue : currentNum;
		}

		/**
		 *获取指定大于某个数的值
		 * @param currentNum
		 * @param minValue
		 * @return
		 *
		 */
		public static function getNumBig(currentNum:Number, minValue:int):Number
		{
			return (currentNum > minValue) ? currentNum : minValue;
		}

		/**
		 * 目标点是否在指定圆范围内
		 * @param target 目标点
		 * @param center 中心点
		 * @param radius 半径
		 * @return
		 */
		public static function inCircle(target:Point, center:Point, radius:Number):Boolean
		{
			return getDistance(center, target) <= radius;
		}

		/**
		 * 得到闪烁滤镜
		 * @param r   0-255
		 * @param g   0-255
		 * @param b   0-255
		 * @param alphaV
		 * @return
		 *
		 */
		public static function getColorFilter(arr:Array):ColorMatrixFilter
		{
			var filter:ColorMatrixFilter=new ColorMatrixFilter();
			var matrix:Array=[];
			matrix=matrix.concat([arr[0], 0, 0, 0, 0]); // red
			matrix=matrix.concat([0, arr[1], 0, 0, 0]); // green
			matrix=matrix.concat([0, 0, arr[2], 0, 0]); // blue
			matrix=matrix.concat([0, 0, 0, arr[3] / 10, 0]); // alpha
			filter.matrix=matrix;
			return filter;
		}

		/**
		 *根据点和半径获取新的随机点
		 * @param p
		 * @param radius
		 * @return
		 *athor enger
		 */
		public static function GetRondomPoint(p:Point, radius:Number):Point
		{
			return new Point(Random.range(p.x - radius, p.x + radius), Random.range(p.y - radius * 0.5, p.y + radius * 0.5));
		}

		/**
		 *根据起始点、鼠标点击点和距离计算结束点
		 * @param beginPoint
		 *athor enger
		 */
		public static function GetEndPoint(beginPoint:Point, mousePoint:Point, distance:Number):Point
		{
			if (Geom.getDistance(beginPoint, mousePoint) < distance)
				return mousePoint;
			var angle:Number=Geom.GetRotation(beginPoint, mousePoint) * RAD_RANGLE;
			var p:Point=new Point(Math.cos(angle) * distance + beginPoint.x, Math.sin(angle) * distance + beginPoint.y);
			return p;
		}

		/**
		 *围绕指定点旋转
		 * @param p   指定点
		 *athor enger
		 */
		public static function Rotation(Coordinate:Point, rotatePoint:Point, angle:Number):Point
		{
			var cos:Number=Math.cos(angle);
			var sin:Number=Math.sin(angle);
			var x1:Number=Coordinate.x - rotatePoint.x; //计算差值  x1也就是dx 舞台中心为旋转中心
			var y1:Number=Coordinate.y - rotatePoint.y;
			var x2:Number=cos * x1 - sin * y1 //计算相对位置
			var y2:Number=cos * y1 + sin * x1
			return new Point(rotatePoint.x + x2, rotatePoint.y + y2);
		}

		/**
		 *设置中心点
		 * @param W
		 * @param H
		 * @return
		 *athor enger
		 */
		public static function Translate(W:Number, H:Number):Matrix
		{
			var matrix:Matrix=new Matrix();
			matrix.translate(-1 * W / 2, -1 * H / 2);
			return matrix;
		}

		/**
		 * 	两点之间的加速度计算
		 * @param p1
		 * @param p2
		 * @param speed
		 * @return
		 *athor enger
		 */
		public static function Speed(p1:Point, p2:Point, speed:Number):Number
		{
			return Geom.getDistance(p1, p2) * speed;
		}

		/**
		 * 矩阵转换计算
		 * @param rotaAngle
		 * @param tranX
		 * @param tranY
		 * @param scaleX
		 * @param scaleY
		 * @param isInvert
		 * @return
		 *athor enger
		 */
		public static function MatrixTransform(rotaAngle:Number=0, tranX:Number=0, tranY:Number=0, scaleX:Number=1, scaleY:Number=1, isInvert:Boolean=false):Matrix
		{
			var m:Matrix=new Matrix();
			m.rotate(rotaAngle * (Math.PI / 180)); //旋转
			m.translate(tranX, tranY); //平移
			m.scale(scaleX, scaleY); //缩放
			if (isInvert)
				m.invert();
			return m;
		}

		/**
		 *获取一组矩形的最大占位
		 * @param rcs 最大脏距矩形
		 * @return
		 *
		 */
		public static function getMaxRectangle(rcs:Array):Rectangle
		{
			if (rcs.length == 0)
			{
				return null;
			}
			var rect:Rectangle=null;
			var tempRect:Rectangle=null;
			rect=rcs.pop();
			if (rect)
			{
				for each (tempRect in rcs)
				{
					if (tempRect)
					{
						rect.union(tempRect);
					}
				}
				return rect;
			}
			return null;
		}

		/**
		 *获取位图的像素边缘
		 * @param bitmapData
		 * @return
		 *
		 */
		public static function getBoundRectangle(bitmapData:BitmapData):Rectangle
		{
			return bitmapData.getColorBoundsRect(0xff000000, 0x00000000, false);
		}

		/**
		 *根据方向获取旋转角度
		 * @param orient
		 * @return
		 *
		 */
		public static function getRotationByOrient(orient:int):int
		{
			switch (orient)
			{
				case 0:
					return 270;
					break;
				case 1:
					return 315;
					break;
				case 2:
					return 0;
					break;
				case 3:
					return 45;
					break;
				case 4:
					return 90;
					break;
				case 5:
					return 135;
					break;
				case 6:
					return 180;
					break;
				case 7:
					return 225;
					break;
			}
			return 0;
		}
	}
}
