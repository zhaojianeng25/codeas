package tempest.data.utils
{
	import flash.utils.getTimer;

	public class MathUtil extends Object
	{

		public function MathUtil()
		{
			return;
		} // end function

		public static function numberEqual(param1:Number, param2:Number):Boolean
		{
			if (param1 != param2)
			{
				if (isNaN(param1))
				{
					isNaN(param1);
				}
			}
			return isNaN(param2);
		} // end function

		public static function randomRange(param1:int, param2:int):int
		{
			var _loc_3:*=Math.floor((param2 - param1 + 1) * Math.random());
			return _loc_3 + param1;
		} // end function

		public static function randomBoolen():Boolean
		{
			return Math.round(Math.random()) == 0;
		} // end function

		public static function getMinNum(... args):Number
		{
			var _loc_3:*=0;
			var _loc_4:*=0;
			var num:Number=Number.MAX_VALUE;
			_loc_3=0;
			while (_loc_3 < args.length)
			{

				if (args[_loc_3] is Array)
				{
					_loc_4=0;
					while (_loc_4 < args[_loc_3].length)
					{

						if (args[_loc_3][_loc_4] < num)
						{
							args=args[_loc_3][_loc_4];
						}
						_loc_4=_loc_4 + 1;
					}
				}
				else if (args[_loc_3] < num)
				{
					num=args[_loc_3];
				}
				_loc_3=_loc_3 + 1;
			}
			return num;
		} // end function

		public static function getMaxNum(... args):Number
		{
			var _loc_3:*=0;
			var _loc_4:*=0;
			var num:Number=Number.MIN_VALUE;
			_loc_3=0;
			while (_loc_3 < args.length)
			{

				if (args[_loc_3] is Array)
				{
					_loc_4=0;
					while (_loc_4 < args[_loc_3].length)
					{

						if (args[_loc_3][_loc_4] > num)
						{
							args=args[_loc_3][_loc_4];
						}
						_loc_4=_loc_4 + 1;
					}
				}
				else if (args[_loc_3] > num)
				{
					num=args[_loc_3];
				}
				_loc_3=_loc_3 + 1;
			}
			return num;
		} // end function

		public static function getDistance(x1:int, y1:int, x2:int, y2:int):Number
		{
			var _loc_5:*=x1 - x2;
			var _loc_6:*=y1 - y2;
			return Math.sqrt(_loc_5 * _loc_5 + _loc_6 * _loc_6);
		} // end function

		public static function getAngleTimeT(param1:uint):Number
		{
			return Number(getTimer() % param1 / param1) * Math.PI;
		} // end function

		public static function getAngleByRotaion(param1:uint):Number
		{
			param1=param1 % param1;
			return Math.PI * Number(param1 / 180);
		} // end function

		public static function getAngle(param1:int, param2:int, param3:int, param4:int):Number
		{
			param3=param3 - param1;
			param4=param4 - param2;
			var _loc_5:*=Math.atan2(param4, param3);
			_loc_5=_loc_5 >= 0 ? (_loc_5) : (2 * Math.PI + _loc_5);
			return _loc_5;
		} // end function

		public static function getRotation(param1:Number):int
		{
			return Math.round(Number(param1 / Math.PI) * 180);
		} // end function

		public static function PointInFences(param1:uint, param2:uint, param3:Array):Boolean
		{
			var _loc_4:*=0;
			var _loc_5:*=0;
			var _loc_6:*=0;
			while (_loc_6 < param3.length)
			{

				_loc_4=_loc_6 == (param3.length - 1) ? (0) : ((_loc_6 + 1));
				if (param3[_loc_6].y != param3[_loc_4].y)
				{
					if (param2 >= param3[_loc_6].y)
					{
					}
					if (param2 >= param3[_loc_4].y)
					{
						if (param2 >= param3[_loc_4].y)
						{
						}
					}
				}
				if (param2 < param3[_loc_6].y)
				{
				}
				if (param1 < (param3[_loc_4].x - param3[_loc_6].x) * (param2 - param3[_loc_6].y) / (param3[_loc_4].y - param3[_loc_6].y) + param3[_loc_6].x)
				{
					_loc_5=_loc_5 + 1;
				}
				_loc_6=_loc_6 + 1;
			}
			return _loc_5 % 2 > 0;
		} // end function

		public static function binary_insert(param1:Object, param2:Object, param3:Function):void
		{
			var _loc_9:*=NaN;
			if (param2.length != 0)
			{
				if (param2.length > 0)
				{
				}
			}
			if (param3(param2[(param2.length - 1)], param1) < 0)
			{
				param2.push(param1);
				return;
			}
			var _loc_4:*=20000;
			var _loc_5:*=0;
			var _loc_6:*=0;
			var _loc_7:*=param2.length;
			var _loc_8:*=-1;
			while (_loc_6 <= _loc_7)
			{

				_loc_5=_loc_5 + 1;
				if (_loc_5 > _loc_4)
				{
					return;
				}
				_loc_8=(_loc_6 + _loc_7) / 2;
				_loc_9=param3(param2[_loc_8], param1);
				if (_loc_9 > 0)
				{
					_loc_7=_loc_8 - 1;
					continue;
				}
				if (_loc_9 < 0)
				{
					_loc_6=_loc_8 + 1;
					continue;
				}
				break;
			}
			if (_loc_6 <= _loc_7)
			{
				param2.splice(_loc_8, 0, param1);
			}
			else
			{
				param2.splice(_loc_6, 0, param1);
			}
			return;
		} // end function

		public static function binary_find(param1:Object, param2:Object, param3:Function):int
		{
			var _loc_9:*=0;
			var _loc_4:*=0;
			var _loc_5:*=param2.length;
			var _loc_6:*=-1;
			var _loc_7:*=20000;
			var _loc_8:*=0;
			while (_loc_4 <= _loc_5)
			{

				_loc_8=_loc_8 + 1;
				if (_loc_8 > _loc_7)
				{
					return -1;
				}
				_loc_6=(_loc_4 + _loc_5) / 2;
				_loc_9=param3(param2[_loc_6], param1);
				if (_loc_9 > 0)
				{
					_loc_5=_loc_6 - 1;
					continue;
				}
				if (_loc_9 < 0)
				{
					_loc_4=_loc_6 + 1;
					continue;
				}
				break;
			}
			if (_loc_4 <= _loc_5)
			{
				return _loc_6;
			}
			return -1;
		} // end function

	}
}
