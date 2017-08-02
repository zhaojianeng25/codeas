package _Pan3D.core
{
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class MathTween
	{
		public static function easeIn(t:Number,b:Number,c:Number,d:Number):Number{
			return c*(t/=d)*t + b;
		}
		public static function easeOut(t:Number,b:Number,c:Number,d:Number):Number{
			return -c *(t/=d)*(t-2) + b;
		}
		public static function easeInOut(t:Number,b:Number,c:Number,d:Number):Number
		{
			//MathTween.easeInOut(_timer,0,360,50);
			if ((t/=d/2) < 1) {
				return c/2*t*t + b;
			}else{
				return -c/2 * ((--t)*(t-2) - 1) + b;
			}
		}
	}
}