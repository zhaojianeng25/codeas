package tempest.data.utils
{
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	import __AS3__.vec.Vector;

	public class StringUtils extends Object
	{

		public function StringUtils()
		{
			 
		}  

		public static function equalsIgnoreCase(param1:String, param2:String):Boolean
		{
			return param1.toLowerCase() == param2.toLowerCase();
		} // end function

		public static function equals(param1:String, param2:String):Boolean
		{
			return param1 == param2;
		} // end function

		public static function isEmail(param1:String):Boolean
		{
			if (param1 == null)
			{
				return false;
			}
			param1=trim(param1);
			var _loc_2:*=/(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			var _loc_3:*=_loc_2.exec(param1);
			if (_loc_3 == null)
			{
				return false;
			}
			return true;
		} // end function

		public static function isNumber(param1:String):Boolean
		{
			if (param1 == null)
			{
				return false;
			}
			return !isNaN(Number(param1));
		} // end function

		public static function isDouble(param1:String):Boolean
		{
			param1=trim(param1);
			var _loc_2:*=/^[-\+]?\d+(\.\d+)?$/;
			var _loc_3:*=_loc_2.exec(param1);
			if (_loc_3 == null)
			{
				return false;
			}
			return true;
		} // end function

		public static function isInteger(param1:String):Boolean
		{
			if (param1 == null)
			{
				return false;
			}
			param1=trim(param1);
			var _loc_2:*=/^[-\+]?\d+$/;
			var _loc_3:*=_loc_2.exec(param1);
			if (_loc_3 == null)
			{
				return false;
			}
			return true;
		} // end function

		public static function isEnglish(param1:String):Boolean
		{
			if (param1 == null)
			{
				return false;
			}
			param1=trim(param1);
			var _loc_2:*=/^[A-Za-z]+$/;
			var _loc_3:*=_loc_2.exec(param1);
			if (_loc_3 == null)
			{
				return false;
			}
			return true;
		} // end function

		public static function isChinese(param1:String):Boolean
		{
			if (param1 == null)
			{
				return false;
			}
			param1=trim(param1);
			var _loc_2:*=/^[Α-￥]+$/;
			var _loc_3:*=_loc_2.exec(param1);
			if (_loc_3 == null)
			{
				return false;
			}
			return true;
		} // end function

		public static function isDoubleChar(param1:String):Boolean
		{
			if (param1 == null)
			{
				return false;
			}
			param1=trim(param1);
			var _loc_2:*=/^[^\x00-\xff]+$/;
			var _loc_3:*=_loc_2.exec(param1);
			if (_loc_3 == null)
			{
				return false;
			}
			return true;
		} // end function

		public static function hasChineseChar(param1:String):Boolean
		{
			if (param1 == null)
			{
				return false;
			}
			param1=trim(param1);
			var _loc_2:*=/[^\x00-\xff]/;
			var _loc_3:*=_loc_2.exec(param1);
			if (_loc_3 == null)
			{
				return false;
			}
			return true;
		} // end function

		public static function hasAccountChar(param1:String, param2:uint=15):Boolean
		{
			if (param1 == null)
			{
				return false;
			}
			if (param2 < 10)
			{
				param2=15;
			}
			param1=trim(param1);
			var _loc_3:*=new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0," + param2 + "}$", "");
			var _loc_4:*=_loc_3.exec(param1);
			if (_loc_4 == null)
			{
				return false;
			}
			return true;
		} // end function

		public static function isURL(param1:String):Boolean
		{
			if (param1 == null)
			{
				return false;
			}
			param1=trim(param1).toLowerCase();
			var _loc_2:*=/^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
			var _loc_3:*=_loc_2.exec(param1);
			if (_loc_3 == null)
			{
				return false;
			}
			return true;
		} // end function

		public static function isNameStr(param1:String):Boolean
		{
			if (param1 == null)
			{
				return false;
			}
			var _loc_2:*=/^[一-龥A-Za-z0-9]+$/g;
			var _loc_3:*=_loc_2.exec(param1);
			if (_loc_3 == null)
			{
				return false;
			}
			return true;
		} // end function

		public static function isWhitespace(param1:String):Boolean
		{
			switch (param1)
			{
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
				{
					return true;
				}
				default:
				{
					return false;
					break;
				}
			}
		} // end function

		public static function isContainsChar(param1:String, ... args):Boolean
		{
			if (param1 == null)
			{
				return false;
			}
			args=args;
			var _loc_4:*=0;
			while (_loc_4 < args.length)
			{

				if (param1.indexOf(args[_loc_4]) >= 0)
				{
					return true;
				}
				_loc_4=_loc_4 + 1;
			}
			return false;
		} // end function

		public static function isContainsChars(param1:String, param2:Vector.<String>):Boolean
		{
			var _loc_4:*=null;
			var _loc_5:*=0;
			if (param1 == null)
			{
				return false;
			}
			var _loc_3:*=0;
			while (_loc_3 < param2.length)
			{

				if (param1.indexOf(param2[_loc_3]) >= 0)
				{
					return true;
				}
				_loc_3=_loc_3 + 1;
			}
			_loc_3=0;
			while (_loc_3 < param1.length)
			{

				_loc_4=urlencodeGBK(param1.charAt(_loc_3));
				_loc_5=0;
				while (_loc_5 < param2.length)
				{

					if (_loc_4.indexOf(urlencodeGBK(param2[_loc_3])) >= 0)
					{
						return true;
					}
					_loc_5=_loc_5 + 1;
				}
				_loc_3=_loc_3 + 1;
			}
			return false;
		} // end function

		private static function urlencodeGBK(param1:String):String
		{
			var _loc_4:*=0;
			var _loc_2:*="";
			var _loc_3:*=new ByteArray();
			_loc_3.clear();
			_loc_3.writeMultiByte(param1, "gbk");
			while (_loc_4 < _loc_3.length)
			{

				_loc_2=_loc_2 + escape(String.fromCharCode(_loc_3[_loc_4]));
				_loc_4=_loc_4 + 1;
			}
			return _loc_2;
		} // end function

		public static function isEmpty(param1:String):Boolean
		{
			if (!param1)
			{
				return true;
			}
			return param1.length == 0;
		} // end function

		public static function trim(param1:String):String
		{
			if (param1 == null)
			{
				return null;
			}
			return rtrim(ltrim(param1));
		} // end function

		public static function ltrim(param1:String):String
		{
			if (param1 == null)
			{
				return null;
			}
			var _loc_2:*=/^\s*/;
			return param1.replace(_loc_2, "");
		} // end function

		public static function rtrim(param1:String):String
		{
			if (param1 == null)
			{
				return null;
			}
			var _loc_2:*=/\s*$/;
			return param1.replace(_loc_2, "");
		} // end function

		public static function beginsWith(param1:String, param2:String):Boolean
		{
			return param2 == param1.substring(0, param2.length);
		} // end function

		public static function endsWith(param1:String, param2:String):Boolean
		{
			return param2 == param1.substring(param1.length - param2.length);
		} // end function

		public static function remove(param1:String, param2:String):String
		{
			return replace(param1, param2, "");
		} // end function

		public static function replace(param1:String, param2:String, param3:String):String
		{
			return param1.split(param2).join(param3);
		} // end function

		public static function utf16to8(param1:String):String
		{
			var _loc_5:*=0;
			var _loc_2:*=new Array();
			var _loc_3:*=param1.length;
			var _loc_4:*=0;
			while (_loc_4 < _loc_3)
			{

				_loc_5=param1.charCodeAt(_loc_4);
				if (_loc_5 >= 1)
				{
				}
				if (_loc_5 <= 127)
				{
					_loc_2[_loc_4]=param1.charAt(_loc_4);
				}
				else if (_loc_5 > 2047)
				{
					_loc_2[_loc_4]=String.fromCharCode(224 | _loc_5 >> 12 & 15, 128 | _loc_5 >> 6 & 63, 128 | _loc_5 >> 0 & 63);
				}
				else
				{
					_loc_2[_loc_4]=String.fromCharCode(192 | _loc_5 >> 6 & 31, 128 | _loc_5 >> 0 & 63);
				}
				_loc_4=_loc_4 + 1;
			}
			return _loc_2.join("");
		} // end function

		public static function utf8to16(param1:String):String
		{
			var _loc_5:*=0;
			var _loc_6:*=0;
			var _loc_7:*=0;
			var _loc_2:*=new Array();
			var _loc_3:*=param1.length;
			var _loc_4:*=0;
			while (_loc_4 < _loc_3)
			{

				_loc_7=param1.charCodeAt(_loc_4++);
				switch (_loc_7 >> 4)
				{
					case 0:
					case 1:
					case 2:
					case 3:
					case 4:
					case 5:
					case 6:
					case 7:
					{
						_loc_2[_loc_2.length]=param1.charAt((_loc_4 - 1));
						break;
					}
					case 12:
					case 13:
					{
						_loc_5=param1.charCodeAt(_loc_4++);
						_loc_2[_loc_2.length]=String.fromCharCode((_loc_7 & 31) << 6 | _loc_5 & 63);
						break;
					}
					case 14:
					{
						_loc_5=param1.charCodeAt(_loc_4++);
						_loc_6=param1.charCodeAt(_loc_4++);
						_loc_2[_loc_2.length]=String.fromCharCode((_loc_7 & 15) << 12 | (_loc_5 & 63) << 6 | (_loc_6 & 63) << 0);
						break;
					}
					default:
					{
						break;
					}
				}
			}
			return _loc_2.join("");
		} // end function

		public static function encodeCharset(param1:String, param2:String):String
		{
			var _loc_3:*=new ByteArray();
			_loc_3.writeUTFBytes(param1);
			_loc_3.position=0;
			return _loc_3.readMultiByte(_loc_3.length, param2);
		} // end function

		public static function getByteLength(param1:String, param2:String="utf-8"):int
		{
			var _loc_3:*=new ByteArray();
			_loc_3.writeMultiByte(param1, param2);
			return _loc_3.length;
		} // end function

		public static function subByLength(param1:String, param2:uint, param3:String="utf-8"):String
		{
			var _loc_5:*=null;
			var _loc_6:*=0;
			var _loc_4:*=new ByteArray();
			_loc_4.writeMultiByte(param1, param3);
			if (_loc_4.length > param2)
			{
				_loc_5=new ByteArray();
				_loc_6=0;
				while (_loc_6 < param1.length)
				{

					_loc_4.clear();
					_loc_4.writeMultiByte(param1.charAt(_loc_6), param3);
					if (_loc_5.length + _loc_4.length <= param2)
					{
						_loc_5.writeBytes(_loc_4, 0, _loc_4.length);
					}
					else
					{
						_loc_5.position=0;
						param1=_loc_5.readMultiByte(_loc_5.length, param3);
						break;
					}
					_loc_6=_loc_6 + 1;
				}
			}
			return param1;
		} // end function

		public static function addAt(param1:String, param2:String, param3:int):String
		{
			if (param3 > param1.length)
			{
				param3=param1.length;
			}
			var _loc_4:*=param1.substring(0, param3);
			var _loc_5:*=param1.substring(param3, param1.length);
			return _loc_4 + param2 + _loc_5;
		} // end function

		public static function replaceAt(param1:String, param2:String, param3:int, param4:int):String
		{
			param3=Math.max(param3, 0);
			param4=Math.min(param4, param1.length);
			var _loc_5:*=param1.substr(0, param3);
			var _loc_6:*=param1.substr(param4, param1.length);
			return _loc_5 + param2 + _loc_6;
		} // end function

		public static function removeAt(param1:String, param2:int, param3:int):String
		{
			return StringUtils.replaceAt(param1, "", param2, param3);
		} // end function

		public static function fixNewlines(param1:String):String
		{
			return param1.replace(/\r\n/gm, "\n");
		} // end function

		public static function PaddingLeft(param1:String, param2:String, param3:int):String
		{
			var _loc_4:*=param3 - param1.length;
			if (_loc_4 <= 0)
			{
				return param1;
			}
			param1=new String(param1);
			var _loc_5:*=0;
			while (_loc_5 < _loc_4)
			{

				param1=param2 + param1;
				_loc_5=_loc_5 + 1;
			}
			return param1;
		} // end function

		public static function DateTimeToString(param1:Date):String
		{
			var _loc_2:*=PaddingLeft(param1.getFullYear().toString(), "0", 2);
			var _loc_3:*=PaddingLeft(((param1.getMonth() + 1)).toString(), "0", 2);
			var _loc_4:*=PaddingLeft(param1.getDate().toString(), "0", 2);
			var _loc_5:*=PaddingLeft(param1.getHours().toString(), "0", 2);
			var _loc_6:*=PaddingLeft(param1.getMinutes().toString(), "0", 2);
			var _loc_7:*=PaddingLeft(param1.getSeconds().toString(), "0", 2);
			var _loc_8:*=_loc_2 + "-" + _loc_3 + "-" + _loc_4 + " " + _loc_5 + ":" + _loc_6 + ":" + _loc_7;
			return _loc_8;
		} // end function

		public static function shieldhtml(param1:String):String
		{
			var _loc_2:*=/</g;
			var _loc_3:*=/>/g;
			param1=param1.replace(_loc_2, "&lt;");
			param1=param1.replace(_loc_3, "&gt;");
			return param1;
		} // end function

		public static function substitute(param1:String, ... args):String
		{
			var _loc_4:*=null;
			if (param1 == null)
			{
				return "";
			}
			var $args:int=args.length;
			if ($args == 1)
			{
			}
			if (args[0] is Array)
			{
				_loc_4=args[0] as Array;
				$args=_loc_4.length;
			}
			else
			{
				_loc_4=args;
			}
			var _loc_5:*=0;
			while (_loc_5 < $args)
			{

				param1=param1.replace(new RegExp("\\{" + _loc_5 + "\\}", "g"), _loc_4[_loc_5]);
				_loc_5=_loc_5 + 1;
			}
			return param1;
		} // end function

		public static function printByteArray(param1:ByteArray):String
		{
			var _loc_2:*="";
			param1.position=0;
			var _loc_3:*=0;
			while (_loc_3 < param1.length)
			{

				_loc_2=_loc_2 + (param1.readByte().toString() + ",");
				_loc_3=_loc_3 + 1;
			}
			param1.position=0;
			return _loc_2;
		} // end function

		public static function print64Bit(param1:Number):String
		{
			var _loc_2:*="0x";
			var _loc_3:*=new ByteArray();
			_loc_3.writeDouble(param1);
			_loc_3.position=0;
			var _loc_4:*=0;
			while (_loc_4 < 8)
			{

				_loc_2=_loc_2 + PaddingLeft(_loc_3.readUnsignedByte().toString(16), "0", 2);
				_loc_4=_loc_4 + 1;
			}
			return _loc_2;
		} // end function

		public static function printfByteArrayHex(param1:ByteArray, param2:uint=0, param3:uint=0):void
		{
			param3=param3 == 0 ? (param1.length) : (0);
			var _loc_4:*="printfByteArrayHex[" + param2 + "," + param3 + "]:";
			var _loc_5:*=param2;
			while (_loc_5 < param3)
			{

				_loc_4=_loc_4 + (param1[_loc_5].toString(16) + ",");
				_loc_5=_loc_5 + 1;
			}
//			Log.outDebug(_loc_4);
			return;
		} // end function

		public static function printBit(param1:ByteArray):void
		{
			var _loc_4:*=0;
			var _loc_2:*="";
			var _loc_3:*=0;
			while (_loc_3 < param1.length)
			{

				_loc_4=0;
				while (_loc_4 < 8)
				{

					if (param1[_loc_3] & 1 << 7 >> _loc_4)
					{
						_loc_2=_loc_2 + "1";
					}
					else
					{
						_loc_2=_loc_2 + "0";
					}
					_loc_4=_loc_4 + 1;
				}
				_loc_3=_loc_3 + 1;
			}
//			Log.outDebug(_loc_2);
			return;
		} // end function

		public static function getParam(param1:String, param2:Object):String
		{
			var _loc_3:*=param1;
			switch (Capabilities.playerType)
			{
				case "External":
				case "Desktop":
				{
					return param1;
				}
				case "ActiveX":
				case "PlugIn":
				case "StandAlone":
				{
				}
				default:
				{
					_loc_3=param1 + createdParam(param2);
					break;
				}
			}
			return _loc_3;
		} // end function

		private static function createdParam(param1:Object):String
		{
			var _loc_3:*=null;
			var _loc_2:*="?";
			for (_loc_3 in param1)
			{

				_loc_2=_loc_2 + (_loc_3 + "=" + param1[_loc_3]);
			}
			return _loc_2;
		} // end function

	}
}
