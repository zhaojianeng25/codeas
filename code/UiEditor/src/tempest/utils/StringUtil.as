package tempest.utils
{
	import flash.utils.ByteArray;

	public class StringUtil
	{
		/**
		 * C#格式化字符串
		 * StringUtil.format("{0}好啊","小李")="小李好啊"
		 * @param format
		 * @param params
		 * @return
		 * @throws ArgumentError
		 */
		public static function format(format:String, ... params):String
		{
			if (params.length == 0)
			{
				return format;
			}
			var param:*;
			//=======================================方法一================================================
			var getParam:Function=function(result:String, match:String, position:int, source:String):String
			{
				param=params[match];
				if (param is Number && param == 0)
				{
					return "0";
				}
				return param || "";
			}
			return format.replace(/\{(\d+)\}/g, getParam);
			//=======================================方法二================================================
//			var result:String = format;
//			var numParams:int = params.length;
//			for (var i:int = 0; i < numParams; i++)
//			{
//				result = result.replace(new RegExp("\{" + i + "\\}", "g"), params[i]);
//			}
//			return result;
		}

		/**
		 * C格式化字符串
		 * StringUtil.format2("s%好啊","小李")="小李好啊"
		 * @param format
		 * @param params
		 * @return
		 */
		public static function format2(format:String, ... params):String
		{
			if (params.length == 0)
			{
				return format;
			}
			//=======================================方法一================================================
//			var getParam:Function = function(result:String, match:String, position:int, source:String):String
//			{
//				if (params[match] == null)
//					throw new ArgumentError("参数数量不足");
//				return params[match];
//			}
//			return format.replace(/%[dusi]/g, getParam);
			//=======================================方法二================================================
			var i:int=0;
			var getParam:Function=function():String
			{
				var index:int=parseInt(arguments[1]);
				return params[index] || "";
			}
			return format.replace(/%([0-9]*?)[dusi]/g, getParam);
		}

		/**
		 * 从右侧截取固定长度字符串
		 *
		 * @param str	字符串
		 * @param len	长度
		 * @return
		 *
		 */
		public static function right(str:String, len:int):String
		{
			return str.slice(str.length - len);
		}

		/**
		 * 忽略掉标签截取特定长度htmlText的文字
		 *
		 * @param htmlText	HTML格式文本
		 * @param startIndex	起始
		 * @param len	长度
		 * @return
		 *
		 */
		public static function subHtmlStr(htmlText:String, startIndex:Number=0, len:Number=0x7fffffff):String
		{
			if ((/<.*?>/).test(htmlText))
			{
				var i:int=startIndex;
				var n:int=0;
				while (n < len && i < htmlText.length)
				{
					var result:Array=htmlText.substr(i).match(/^<([\/\w]+).*?>/);
					if (result != null)
					{
						i+=result[0].length;
					}
					else
					{
						i++;
						n++;
					}
				}
				return htmlText.substr(startIndex, i);
			}
			else
			{
				return htmlText.substr(startIndex, len);
			}
		}

		/**
		 * 删除HTML标签
		 *
		 * @param htmlText
		 * @return
		 *
		 */
		public static function removeHTMLTag(htmlText:String):String
		{
			return htmlText.replace(/<.*?>/g, "");
		}

		/**
		 * 删除所有的\r
		 * @param text
		 *
		 */
		public static function removeR(text:String):String
		{
			return text.replace(/\r/g, "");
		}

		/**
		 * 删除所有换行
		 * @param text
		 * @return
		 *
		 */
		public static function removeBR(text:String):String
		{
			return text.replace(/\r|\n|<br>/g, "");
		}

		/**
		 * 插入换行符使得字体可以竖排
		 *
		 * @param str
		 * @return
		 *
		 */
		public static function vertical(str:String):String
		{
			var result:String="";
			for (var i:int=0; i < str.length; i++)
			{
				result+=str.charAt(i);
				if (i < str.length - 1)
					result+="\r";
			}
			return result;
		}

		/**
		 * 替换 startIndex 到 endIndex 之间的字符串
		 * @param input
		 * @param startIndex
		 * @param endIndex
		 * @param replaceWith
		 *
		 */
		public static function replaceByPos(input:String, startIndex:int, endIndex:int, replaceWith:String):String
		{
			var pre:String=startIndex <= 0 ? "" : input.slice(0, startIndex);
			var tail:String=endIndex >= input.length - 1 ? "" : input.slice(endIndex + 1);
			return pre + replaceWith + tail;
		}

		/**
		 * 获得ANSI长度（中文按两个字符计算）
		 * @param data
		 * @return
		 *
		 */
		public static function getANSILen(data:String):uint
		{
			return getCharSetLen(data, "gb2312");
		}

		public static function getCharSetLen(data:String, charSet:String):uint
		{
			var byte:ByteArray=new ByteArray();
			byte.writeMultiByte(data, charSet);
			return byte.length;
		}

		/**
		 * 左填充
		 * @param p_string
		 * @param p_padChar
		 * @param p_length
		 * @return
		 */
		public static function padLeft(p_string:String, p_length:uint, p_padChar:String):String
		{
			var s:String=p_string;
			while (s.length < p_length)
			{
				s=p_padChar + s;
			}
			return s;
		}

		/**
		 * 右填充
		 * @param p_string
		 * @param p_padChar
		 * @param p_length
		 * @return
		 */
		public static function padRight(p_string:String, p_length:uint, p_padChar:String):String
		{
			var s:String=p_string;
			while (s.length < p_length)
			{
				s+=p_padChar;
			}
			return s;
		}

		/**
		 * 比较字符是否相等
		 * @param char1
		 * @param char2
		 * @param ignoreCase 是否忽略大小写
		 * @return
		 */
		public static function equals(char1:String, char2:String, ignoreCase:Boolean=false):Boolean
		{
			if (ignoreCase)
				return char1.toLowerCase() == char2.toLowerCase();
			else
				return char1 == char2;
		}

		/**
		 * 是否为Email地址
		 * @param char
		 * @return
		 */
		public static function isEmail(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char);
			var pattern:RegExp=/(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 是否是数值字符串
		 * @param char
		 * @return
		 */
		public static function isNumber(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			return !isNaN(Number(char));
		}

		/**
		 * 是否为Double型数据
		 * @param char
		 * @return
		 */
		public static function isDouble(char:String):Boolean
		{
			char=trim(char);
			var pattern:RegExp=/^[-\+]?\d+(\.\d+)?$/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 是否为Integer型数据
		 * @param char
		 * @return
		 */
		public static function isInteger(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char);
			var pattern:RegExp=/^[-\+]?\d+$/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 是否是英文
		 * @param char
		 * @return
		 */
		public static function isEnglish(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char);
			var pattern:RegExp=/^[A-Za-z]+$/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 是否是中文
		 * @param char
		 * @return
		 */
		public static function isChinese(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char);
			var pattern:RegExp=/^[\u0391-\uFFE5]+$/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 是否是双字节
		 * @param char
		 * @return
		 */
		public static function isDoubleChar(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char);
			var pattern:RegExp=/^[^\x00-\xff]+$/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 是否含有中文字符
		 * @param char
		 * @return
		 */
		public static function hasChineseChar(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char);
			var pattern:RegExp=/[^\x00-\xff]/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		//注册字符;  
		public static function hasAccountChar(char:String, len:uint=15):Boolean
		{
			if (char == null)
			{
				return false;
			}
			if (len < 10)
			{
				len=15;
			}
			char=trim(char);
			var pattern:RegExp=new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0," + len + "}$", "");
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 是否是URL地址
		 * @param char
		 * @return
		 */
		public static function isURL(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char).toLowerCase();
			var pattern:RegExp=/^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 是否为空白
		 * @param char
		 * @return
		 */
		public static function isWhitespace(char:String):Boolean
		{
			switch (char)
			{
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
				default:
					return false;
			}
		}

		/**
		 * 去首尾空
		 * @param char
		 * @return
		 */
		public static function trim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			//=======================方法一==================================
			return char.replace(/^\s+/, "").replace(/\s+$/, "");
			//=======================方法二==================================
//			return rtrim(ltrim(char));
		}

		/**
		 * 去左空格
		 * @param char
		 * @return
		 */
		public static function ltrim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			return char.replace(/^\s*/, "");
		}

		/**
		 * 去右空格
		 * @param char
		 * @return
		 */
		public static function rtrim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			return char.replace(/\s*$/, "");
		}

		/**
		 * 是否为前缀字符串
		 * @param char
		 * @param prefix
		 * @return
		 */
		public static function beginsWith(char:String, prefix:String):Boolean
		{
			return (prefix == char.substring(0, prefix.length));
		}

		/**
		 * 是否为后缀字符串
		 * @param char
		 * @param suffix
		 * @return
		 */
		public static function endsWith(char:String, suffix:String):Boolean
		{
			return (suffix == char.substring(char.length - suffix.length));
		}

		/**
		 * 去除指定字符串
		 * @param char
		 * @param remove
		 * @return
		 */
		public static function remove(char:String, remove:String):String
		{
			return replace(char, remove, "");
		}

		/**
		 * 字符串替换
		 * @param char
		 * @param replace
		 * @param replaceWith
		 * @return
		 */
		public static function replace(char:String, replace:String, replaceWith:String):String
		{
			return char.split(replace).join(replaceWith);
		}

		/**
		 * utf16转utf8编码
		 * @param char
		 * @return
		 */
		public static function utf16to8(char:String):String
		{
			var out:Array=new Array();
			var len:uint=char.length;
			for (var i:uint=0; i < len; i++)
			{
				var c:int=char.charCodeAt(i);
				if (c >= 0x0001 && c <= 0x007F)
				{
					out[i]=char.charAt(i);
				}
				else if (c > 0x07FF)
				{
					out[i]=String.fromCharCode(0xE0 | ((c >> 12) & 0x0F), 0x80 | ((c >> 6) & 0x3F), 0x80 | ((c >> 0) & 0x3F));
				}
				else
				{
					out[i]=String.fromCharCode(0xC0 | ((c >> 6) & 0x1F), 0x80 | ((c >> 0) & 0x3F));
				}
			}
			return out.join('');
		}

		/**
		 * utf8转utf16编码
		 * @param char
		 * @return
		 */
		public static function utf8to16(char:String):String
		{
			var out:Array=new Array();
			var len:uint=char.length;
			var i:uint=0;
			var char2:int, char3:int;
			while (i < len)
			{
				var c:int=char.charCodeAt(i++);
				switch (c >> 4)
				{
					case 0:
					case 1:
					case 2:
					case 3:
					case 4:
					case 5:
					case 6:
					case 7:
						// 0xxxxxxx  
						out[out.length]=char.charAt(i - 1);
						break;
					case 12:
					case 13:
						// 110x xxxx   10xx xxxx  
						char2=char.charCodeAt(i++);
						out[out.length]=String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
						break;
					case 14:
						// 1110 xxxx  10xx xxxx  10xx xxxx  
						char2=char.charCodeAt(i++);
						char3=char.charCodeAt(i++);
						out[out.length]=String.fromCharCode(((c & 0x0F) << 12) | ((char2 & 0x3F) << 6) | ((char3 & 0x3F) << 0));
						break;
				}
			}
			return out.join('');
		}

		/**
		 * 转换字符编码
		 * @param char
		 * @param charset
		 * @return
		 */
		public static function encodeCharset(char:String, charset:String):String
		{
			var bytes:ByteArray=new ByteArray();
			bytes.writeUTFBytes(char);
			bytes.position=0;
			return bytes.readMultiByte(bytes.length, charset);
		}

		/**
		 * 添加新字符到指定位置
		 * @param char
		 * @param value
		 * @param position
		 * @return
		 */
		public static function addAt(char:String, value:String, position:int):String
		{
			if (position > char.length)
			{
				position=char.length;
			}
			var firstPart:String=char.substring(0, position);
			var secondPart:String=char.substring(position, char.length);
			return (firstPart + value + secondPart);
		}

		/**
		 * 替换指定位置字符
		 * @param char
		 * @param value
		 * @param beginIndex
		 * @param endIndex
		 * @return
		 */
		public static function replaceAt(char:String, value:String, beginIndex:int, endIndex:int):String
		{
			beginIndex=Math.max(beginIndex, 0);
			endIndex=Math.min(endIndex, char.length);
			var firstPart:String=char.substr(0, beginIndex);
			var secondPart:String=char.substr(endIndex, char.length);
			return (firstPart + value + secondPart);
		}

		/**
		 * 删除指定位置字符
		 * @param char
		 * @param beginIndex
		 * @param endIndex
		 * @return
		 */
		public static function removeAt(char:String, beginIndex:int, endIndex:int):String
		{
			return replaceAt(char, "", beginIndex, endIndex);
		}

		/**
		 * 修复双换行符
		 * @param char
		 * @return
		 */
		public static function fixNewlines(char:String):String
		{
			return char.replace(/\r\n/gm, "\n");
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////
//		/**
//		 * 是否是全角字符
//		 * @param input 要检查的字符串
//		 * @return
//		 */
//		public static function isSBC(input:String):Boolean
//		{
//			var re1:RegExp = new RegExp("^([^\u20-\uFF]|[\\r\\n\\t])+$");
//			return re1.test(input);
//		}
		/**
		 * 转全角的函数(SBC case)
		 * 全角空格为12288，半角空格为32
		 * 其他字符半角(33-126)与全角(65281-65374)的对应关系是：均相差65248
		 * @param input 任意字符串
		 * @return 全角字符串
		 */
		public static function toSBC(input:String):String
		{
			//半角转全角： 
			var ret:String="";
			var len:int=input.length;
			var charCode:int;
			for (var i:int=0; i < len; i++)
			{
				charCode=input.charCodeAt(i);
				if (charCode == 32)
				{
					ret+=String.fromCharCode(12288);
					continue;
				}
				if (charCode < 127)
				{
					ret+=String.fromCharCode(charCode + 65248);
				}
				ret+=input.charAt(i);
			}
			return ret;
		}

		/**
		 * 转半角的函数(DBC case)
		 * 全角空格为12288，半角空格为32
		 * 其他字符半角(33-126)与全角(65281-65374)的对应关系是：均相差65248
		 * @param input 任意字符串
		 * @return 半角字符串
		 */
		public static function toDBC(input:String):String
		{
			var ret:String="";
			var len:int=input.length;
			var charCode:int;
			for (var i:int=0; i < len; i++)
			{
				charCode=input.charCodeAt(i);
				if (charCode == 12288)
				{
					ret+=String.fromCharCode(32);
					continue;
				}
				if (charCode > 65280 && charCode < 65375)
				{
					ret+=String.fromCharCode(charCode - 65248);
					continue;
				}
				ret+=input.charAt(i);
			}
			return ret;
		}

		public static function trimArrayElements(value:String, delimiter:String):String
		{
			if (value != "" && value != null)
			{
				var items:Array=value.split(delimiter);
				var len:int=items.length;
				for (var i:int=0; i < len; i++)
				{
					items[i]=trim(items[i]);
				}
				if (len > 0)
				{
					value=items.join(delimiter);
				}
			}
			return value;
		}

		/**
		 * 获取字符串的字节长度
		 * @param str
		 * @return
		 *
		 */
		public static function getStrByteLength(str:String):int
		{
			var bArray:ByteArray=new ByteArray();
			bArray.writeMultiByte(str, "");
			return bArray.length;
		}

		/**
		 * 截取字符串在某字节长度范围内的部分
		 * @param str
		 * @param byteLength
		 * @return
		 *
		 */
		public static function fixStr(str:String, byteLength:int):String
		{
			var len:int=getStrByteLength(str);
			if (len <= byteLength)
			{
				return null;
			}
			var charByteArr:ByteArray=new ByteArray();
			var char:String;
			var sumLen:int=0;
			var valideStr:String="";
			for (var i:int=0; i < str.length; ++i)
			{
				//检查每个字符的字节数，截取刚好可以显示的长度
				char=str.charAt(i);
				charByteArr.clear();
				charByteArr.writeMultiByte(char, "");
				sumLen+=charByteArr.length;
				if (sumLen <= byteLength)
				{
					valideStr=valideStr.concat(char);
				}
				else
				{
					break;
				}
			}
			return valideStr;
		}
	}
}
