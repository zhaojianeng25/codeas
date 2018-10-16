package com.zcp.utils
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * ZMath
	 * @author zcp
	 */
	public class ZMath
	{
        private static var abs:Function = Math.abs;
        private static var sin:Function = Math.sin;
        private static var cos:Function = Math.cos;
        private static var sqrt:Function = Math.sqrt;
        private static var PI:Number = Math.PI;
        
        public static var toDeg:Number = 180 / PI;
        public static var toRad:Number = PI / 180;
		public function ZMath()
		{
		}
		/**
		 * 获取范围内随机整数
		 * @param $min
		 * @param $max
		 * @return 
		 * 
		 */	
		public static function randomInt($min:int, $max:int):int {
			return Math.round($min + Math.random() * ($max - $min));
		}
		/**
		 * 获取平面两点间距离的平方
		 * @param $x1
		 * @param $y1
		 * @param $x2
		 * @param $y2
		 * @return 
		 * 
		 */	
		public static function getDisSquare($x1:Number,$y1:Number,$x2:Number,$y2:Number):Number {
			return ($x1-$x2)*($x1-$x2)+($y1-$y2)*($y1-$y2);
		}			

		/**
		 * 获取点$p1相对于$p0点旋转$angle角度之后的点的坐标点(不会改变原来的点)
		 * @param $p1
		 * @param $p0
		 * @param $angle 角度		(负数是逆时针旋转,  正数是顺时针)
		 * @return 
		 * 
		 */		
		public static function getRotPoint($p1:Point,$p0:Point,$angle:Number):Point
		{	
			$angle = $angle*ZMath.toRad		
			
			var p1:Point = new Point();
			p1.x = Math.cos($angle)*($p1.x-$p0.x) - Math.sin($angle)*($p1.y-$p0.y) + $p0.x;
			p1.y = Math.cos($angle)*($p1.y-$p0.y) + Math.sin($angle)*($p1.x-$p0.x) + $p0.y;
			return p1;
		}
		
		/**
		 * 取得两点所组成的线段的角度
		 * @param $p0 起点
		 * @param $p1 终点
		 * @return  角度
		 * 
		 */		
		public static function getTowPointsAngle($p0:Point, $p1:Point):Number {
			var angle:Number = Math.atan2($p1.y - $p0.y, $p1.x - $p0.x);
			if (angle < 0) {
				angle = angle + 2 * Math.PI;
			}
			return angle * 180 / Math.PI;
		}
		
		/**
		 * 取得与指定角度最接近的合法整数角度值（该合法角度==360/$average）
		 * @param $angle 角度
		 * @param $average 圆周均分份数
		 * @return 
		 * 
		 */		
		public static function getNearAngel($angle:Number,$average:int=8):int {
			$angle = ($angle%360+360)%360;//保证$angle位于0到360之间
			var an:Number = 360/$average;//每份角度
			var i:int = Math.floor($angle/an);//$angle角度对应的份数下限
			var min:Number = i*an;//最小合法角度
			var max:Number = (i+1)*an;//最大合法角度
			return (($angle-min<=max-$angle)?min:max)%360;
		}
		
		
		/**
		 * 求两点组成的线段中, 距离起点一定距离的点的坐标
		 * @param $p1			起点
		 * @param $p2			终点
		 * @param $ratio		0< $ratio <1的数字, 表示"未知点到起点的距离" 与 "线段总距离" 的比值
		 */		
		public static function getPointBetweenTwoPointLine($p1:Point, $p2:Point, $ratio:Number):Point
		{
			//用距离起点的距离, 除以距离终点的距离 求出比值
			var rat:Number = $ratio / (1-$ratio);
			
			var p:Point = new Point();
			//向量代数
			p.x = ($p1.x + rat * $p2.x) / (1 + rat);
			p.y = ($p1.y + rat * $p2.y) / (1 + rat);
			
			return p;
		}
		
		/**
		 * 求两点连线方向上, 距离起点 任意距离的点的坐标
		 * @param $p1				起点
		 * @param $p2				终点
		 * @param $disFromP1		距离起点的像素距离
		 */		
		public static function getPointFarAwayTwoPointLine($p1:Point, $p2:Point, $disFromP1:Number):Point
		{
			var p:Point = new Point();
			//角度
			var angle:Number = Math.atan2( ($p2.y-$p1.y), ($p2.x-$p1.x) );
			p.x = $p1.x + $disFromP1 * Math.cos( angle );
			p.y = $p1.y + $disFromP1 * Math.sin( angle );
			return p;
		}
		
		//关于2的整数次幂
		//====================================================================================
		/**
		 * 判断一个数字是否是2的整数次幂
		 * 因为一个数如果是2的整数幂，那么它的2进制表示里面肯定只有一个1, 并且是最高位，当然不考虑负数。 
		 * @param $num
		 * @return 
		 * 
		 */		
		private static function isPower($num:int):Boolean {
			if ($num < 2) {
				return false;
			} else {
				var  temp:String = $num.toString(2);
				if (temp.lastIndexOf("1") !=0) {
					return false;
				} else {
					return true;
				}
			}
		}
		/**
		 * 取得比传入值小并且最接近传入值的2的整数次幂
		 * @param $num
		 * @return 
		 * 
		 */		
		private static function getLowPowerNum($num:int):int {
			var i:int=32;
			while(--i>0)
			{
				if(($num>>i)>0)
				{
					return ($num>>i)<<i;
				}
			}
			return 2;
		}
		/**
		 * 取得比传入值大并且最接近传入值的2的整数次幂
		 * @param $num
		 * @return 
		 * 
		 */	
		private static function getHighPowerNum($num:int):int {
			var i:int=0;
			var n:int = 1;
			while(++i<32)
			{
				n *= 2;
				if(n>=$num)
				{
					return n;
				}
			}
			return 2;
		}
		/**
		 * @private
		 * 得到2的整数次幂的图像
		 * @param $bd
		 * @return 
		 * 
		 */	
		public static function getPowerBitmapData($bd:BitmapData):BitmapData
		{
			var w:int = $bd.width;
			var h:int = $bd.height;
			
			var changed:Boolean;
			var newW:int;
			var newH:int;
			if(!isPower(w))
			{
				changed = true;
				newW = getHighPowerNum(w);
			}
			if(!isPower(h))
			{
				changed = true;
				newH = getHighPowerNum(h);
			}
			if(changed)
			{
				var ma:Matrix = new Matrix();
				ma.scale(newW/w,newH/h);
				var bd:BitmapData = new BitmapData(newW,newH,true,0);
				bd.draw($bd,ma);
				return  bd;
			}
			else
			{
				return $bd;
			}
			return null;
		}
		/**
		 * @private
		 * 得到2的整数次幂的图像
		 * @param $w
		 * @param $h
		 * @return 
		 * 
		 */	
		public static function getPowerBitmapData2($w:int, $h:int):BitmapData
		{
			if(!isPower($w))
			{
				$w = getHighPowerNum($w);
			}
			if(!isPower($h))
			{
				$h = getHighPowerNum($h);
			}
			var bd:BitmapData = new BitmapData($w,$h,true,0);
			return  bd;
		}
		//====================================================================================
		
	}
}