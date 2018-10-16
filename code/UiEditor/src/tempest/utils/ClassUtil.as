package tempest.utils
{

	public class ClassUtil
	{
		/**
		 *通过类名获取对象
		 * @param cls  类名称
		 * @param args 类属性数组
		 * @return
		 *
		 */
		public static function getInstanceByClass(cls:Class, args:Array = null):*
		{
			var _obj:*;
			if (cls == null)
				return null;
			var _propertyNum:int = args ? args.length : 0;
			switch (_propertyNum)
			{
				case 0:
					_obj = new cls();
					break;
				case 1:
					_obj = new cls(args[0]);
					break;
				case 2:
					_obj = new cls(args[0], args[1]);
					break;
				case 3:
					_obj = new cls(args[0], args[1], args[2]);
					break;
				case 4:
					_obj = new cls(args[0], args[1], args[2], args[3]);
					break;
				case 5:
					_obj = new cls(args[0], args[1], args[2], args[3], args[4]);
					break;
				case 6:
					_obj = new cls(args[0], args[1], args[2], args[3], args[4], args[5]);
					break;
				case 7:
					_obj = new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
					break;
				case 8:
					_obj = new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
					break;
				case 9:
					_obj = new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
					break;
				case 10:
					_obj = new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
					break;
				case 11:
					_obj = new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]);
					break;
				case 12:
					_obj = new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11]);
					break;
				case 13:
					_obj = new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12]);
					break;
				case 14:
					_obj = new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]);
					break;
				case 15:
					_obj = new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14]);
					break;
			}
			return _obj;
		}
	}
}
