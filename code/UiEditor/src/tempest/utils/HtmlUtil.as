package tempest.utils
{

	public class HtmlUtil
	{
		public static const END_LINE:String = "<br>";

		public function HtmlUtil()
		{
		}

		public static function styleSheet(styleSheetName:String, content:String, endLine:Boolean = false):String
		{
			return tag("span", [{key: "class", value: styleSheetName}], content, endLine);
		}

		/**
		 *  构造带href标签的字符串
		 * @param eventData 指定TextLink事件触发时携带的参数
		 * @param content 文本内容
		 * @param underLine 是否加上下划线
		 * @param endLine 标签结束后是否加上换行（<br>）
		 * @return
		 *
		 */
		public static function link(eventData:String, content:String, underLine:Boolean = true, endLine:Boolean = false):String
		{
			if (underLine)
				content = "<u>" + content + "</u>";
			return tag("a", [{key: "href", value: "event:" + eventData}], content, endLine);
		}

		/**
		 * 构造带color标签的字符串
		 * @param color 颜色字符串如#FF0000
		 * @param content 文本内容
		 * @param endLine 标签结束后是否加上换行（<br>）
		 * @return
		 *
		 */
		public static function color(color:String, content:String, endLine:Boolean = false):String
		{
			return tag("font", [{key: "color", value: color}], content, endLine);
		}

		/**
		 * 构造size标签的字符串
		 * @param size 字符的大小
		 * @param content 文本内容
		 * @param endLine 标签结束后是否加上换行(<br>)
		 * @return
		 *
		 */
		public static function size(size:int, content:String, endLine:Boolean = false):String
		{
			return tag("font", [{key: "size", value: size}], content, endLine)
		}

		/**
		 * 构造带HTML标签的字符串
		 * @param tag 标签名
		 * @param propertyList 标签属性列表，格式如：{key:src, value:"img/1.jpg"}
		 * @param content 文本内容
		 * @param endLine 标签结束后是否加上换行（<br>）
		 * @return
		 *
		 */
		public static function tag(tag:String, propertyList:Array, content:String, endLine:Boolean = false):String
		{
			var propertys:String = "";
			for each (var property:Object in propertyList)
			{
				if (propertys != "")
					propertys += " ";
				propertys += property.key + "='" + property.value + "'";
			}
			return "<" + tag + " " + propertys + ">" + content + "</" + tag + ">" + (endLine ? "<br>" : "");
		}

		/**
		 *加粗
		 * @param string
		 * @return
		 *
		 */
		public static function bold(string:String):String
		{
			return "<b>" + string + "</b>";
		}

		public static function italic(string:String):String
		{
			return "<i>" + string + "</i>";
		}
	}
}
