package tempest.core
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;

	public interface ITextField
	{
		/**
		 * 如果设置为 true 且文本字段没有焦点，Flash Player 将以灰色突出显示文本字段中的所选内容。
		 * 如果设置为 false 且文本字段没有焦点，则 Flash Player 不会突出显示文本字段中的所选内容。
		 * @return
		 */
		function get alwaysShowSelection():Boolean;
		function set alwaysShowSelection(value:Boolean):void;
		/**
		 * 用于此文本字段的消除锯齿类型。
		 * 将 flash.text.AntiAliasType 常数用于此属性。
		 * 仅在字体为嵌入（即 embedFonts 属性设置为 true）时可以控制此设置。
		 *  默认设置为 flash.text.AntiAliasType.ADVANCED。
		 * @return
		 */
		function get antiAliasType():String;
		function set antiAliasType(value:String):void;
		/**
		 * 控制文本字段的自动大小调整和对齐。
		 * TextFieldAutoSize 常数的可接受值为 TextFieldAutoSize.NONE（默认值）、TextFieldAutoSize.LEFT、TextFieldAutoSize.RIGHT 和 TextFieldAutoSize.CENTER。
		 * @return
		 */
		function get autoSize():String;
		function set autoSize(value:String):void;
		/**
		 * 指定文本字段是否具有背景填充。
		 *  如果为 true，则文本字段具有背景填充。
		 * 如果为 false，则文本字段没有背景填充。
		 * 使用 backgroundColor 属性来设置文本字段的背景颜色。
		 * @return
		 */
		function get background():Boolean;
		function set background(value:Boolean):void;
		/**
		 * 文本字段背景的颜色。 默认值为 0xFFFFFF（白色）。
		 * 即使当前没有背景，也可检索或设置此属性，但只有当文本字段已将 background 属性设置为 true 时，才可以看到颜色。
		 * @return
		 */
		function get backgroundColor():uint;
		function set backgroundColor(value:uint):void;
		/**
		 * 指定文本字段是否具有边框。
		 *  如果为 true，则文本字段具有边框。 如果为 false，则文本字段没有边框。
		 *  使用 borderColor 属性来设置边框颜色。
		 * @return
		 */
		function get border():Boolean;
		function set border(value:Boolean):void;
		/**
		 * 文本字段边框的颜色。 默认值为 0x000000（黑色）。
		 * 即使当前没有边框，也可检索或设置此属性，但只有当文本字段已将 border 属性设置为 true 时，才可以看到颜色。
		 * @return
		 */
		function get borderColor():uint;
		function set borderColor(value:uint):void;
		/**
		 * 一个整数（从 1 开始的索引），指示指定文本字段中当前可以看到的最后一行。
		 * 可将文本字段看作文本块上的一个窗口。 scrollV 属性是此窗口中最顶端可见行的从 1 开始的索引。
		 * @return
		 */
		function get bottomScrollV():int;
		/**
		 * 插入点（尖号）位置的索引。
		 * 如果没有显示任何插入点，则在将焦点恢复到字段时，值将为插入点所在的位置（通常为插入点上次所在的位置，如果字段不曾具有焦点，则为 0）。
		 * @return
		 */
		function get caretIndex():int;
		/**
		 * 一个布尔值，它指定是否应删除具有 HTML 文本的文本字段中的额外空白（空格、换行符等）。 默认值为 false。
		 * condenseWhite 属性只影响使用 htmlText 属性（而非 text 属性）设置的文本。 如果使用 text 属性设置文本，则忽略 condenseWhite。
		 * @return
		 */
		function get condenseWhite():Boolean;
		function set condenseWhite(value:Boolean):void;
		/**
		 * 指定应用于新插入文本（例如，使用 replaceSelectedText() 方法插入的文本或用户输入的文本）的格式。
		 * @return
		 */
		function get defaultTextFormat():TextFormat;
		function set defaultTextFormat(value:TextFormat):void;
		/**
		 * 指定文本字段是否是密码文本字段。
		 *  如果此属性的值为 true，则文本字段被视为密码文本字段，并使用星号而不是实际字符来隐藏输入的字符。
		 * @return
		 */
		function get displayAsPassword():Boolean;
		function set displayAsPassword(value:Boolean):void;
		/**
		 * 指定是否使用嵌入字体轮廓进行呈现。 如果为 false，则 Flash Player 使用设备字体呈现文本字段。
		 * @return
		 */
		function get embedFonts():Boolean;
		function set embedFonts(value:Boolean):void;
		/**
		 * 用于此文本字段的网格固定类型。
		 * 仅在文本字段的 flash.text.AntiAliasType 属性设置为 flash.text.AntiAliasType.ADVANCED 时才应用此属性。
		 * @return
		 */
		function get gridFitType():String;
		function set gridFitType(value:String):void;
		/**
		 * 包含文本字段内容的 HTML 表示形式。
		 * @return
		 */
		function get htmlText():String;
		function set htmlText(value:String):void;
		/**
		 * 文本字段中的字符数。
		 * 如 tab (\t) 之类的字符视为一个字符。
		 * @return
		 */
		function get length():int;
		/**
		 * 文本字段中最多可包含的字符数（即用户输入的字符数）。
		 *  脚本可以插入比 maxChars 允许的字符数更多的文本；
		 *  maxChars 属性仅指示用户可以输入多少文本。 如果此属性的值为 0，则用户可以输入无限数量的文本。
		 * @return
		 */
		function get maxChars():int;
		function set maxChars(value:int):void;
		/**
		 * scrollH 的最大值。
		 * @return
		 */
		function get maxScrollH():int;
		/**
		 * 一个布尔值，指示当用户单击某个文本字段且用户滚动鼠标滚轮时，Flash Player 是否应自动滚动多行文本字段。
		 *  默认情况下，此值为 true。 如果您想让文本字段在用户滚动鼠标滚轮时不随之滚动，或要实现您自己的文本字段滚动方式，可以使用此属性。
		 * @return
		 */
		function get mouseWheelEnabled():Boolean;
		function set mouseWheelEnabled(value:Boolean):void;
		/**
		 * 指示文本字段是否为多行文本字段。
		 * 如果值为 true，则文本字段为多行文本字段；如果值为 false，则文本字段为单行文本字段。
		 * @return
		 */
		function get multiline():Boolean;
		function set multiline(value:Boolean):void;
		/**
		 * 定义多行文本字段中的文本行数。 如果 wordWrap 属性设置为 true，则在文本自动换行时会增加行数。
		 * @return
		 */
		function get numLines():int;
		/**
		 * 指示用户可输入到文本字段中的字符集。
		 * 如果 restrict 属性的值为 null，则可以输入任何字符。 如果 restrict 属性的值为空字符串，则不能输入任何字符。
		 * @param value
		 */
		function get restrict():String;
		function set restrict(value:String):void;
		/**
		 * 当前水平滚动位置。
		 * 如果 scrollH 属性为 0，则不能水平滚动文本。 此属性值是一个以像素为单位表示水平位置的整数。
		 * @return
		 */
		function get scrollH():int;
		function set scrollH(value:int):void;
		/**
		 * 文本在文本字段中的垂直位置。
		 * scrollV 属性可帮助用户定位到长篇文章的特定段落，还可用于创建滚动文本字段。
		 * @return
		 */
		function get scrollV():int;
		function set scrollV(value:int):void;
		/**
		 * 一个布尔值，指示文本字段是否可选。
		 * 值 true 表示文本可选。
		 * selectable 属性控制文本字段是否可选，而不控制文本字段是否可编辑。 动态文本字段即使不可编辑，它也可能是可选的。 如果动态文本字段是不可选的，则用户不能选择其中的文本。
		 * @return
		 */
		function get selectable():Boolean;
		function set selectable(value:Boolean):void;
		/**
		 * 当前所选内容中第一个字符从零开始的字符索引值。
		 * @return
		 */
		function get selectionBeginIndex():int;
		/**
		 * 当前所选内容中最后一个字符从零开始的字符索引值。
		 * @return
		 */
		function get selectionEndIndex():int;
		/**
		 * 此文本字段中字型边缘的清晰度。
		 * @return
		 */
		function get sharpness():Number;
		function set sharpness(value:Number):void;
		/**
		 * 将样式表附加到文本字段。
		 * @return
		 */
		function get styleSheet():StyleSheet;
		function set styleSheet(value:StyleSheet):void;
		/**
		 * 作为文本字段中当前文本的字符串。
		 * @return
		 */
		function get text():String;
		function set text(value:String):void;
		/**
		 * 文本字段中文本的颜色（采用十六进制格式）。
		 * 十六进制颜色系统使用六位数表示颜色值。
		 * @return
		 */
		function get textColor():uint;
		function set textColor(value:uint):void;
		/**
		 * 文本的高度，以像素为单位。
		 * @return
		 */
		function get textHeight():Number;
		/**
		 * 文本的宽度，以像素为单位。
		 * @return
		 */
		function get textWidth():Number;
		/**
		 * 此文本字段中字型边缘的粗细。
		 * 仅在 flash.text.AntiAliasType 设置为 flash.text.AntiAliasType.ADVANCED 时才可应用此属性。
		 * @return
		 */
		function get thickness():Number;
		function set thickness(value:Number):void;
		/**
		 * 文本字段的类型。
		 *  以下 TextFieldType 常数中的任一个：TextFieldType.DYNAMIC（指定用户无法编辑的动态文本字段），或 TextFieldType.INPUT（指定用户可以编辑的输入文本字段）。
		 * @return
		 */
		function get type():String;
		function set type(value:String):void;
		/**
		 * 指定在复制和粘贴文本时是否同时复制和粘贴其格式。
		 * @return
		 */
		function get useRichTextClipboard():Boolean;
		function set useRichTextClipboard(value:Boolean):void;
		/**
		 * 一个布尔值，指示文本字段是否自动换行。
		 * @return
		 */
		function get wordWrap():Boolean;
		function set wordWrap(value:Boolean):void;
		/**
		 * 将 newText 参数指定的字符串追加到文本字段的文本的末尾。
		 * @param newText
		 */
		function appendText(newText:String):void;
		/**
		 * 返回一个矩形，该矩形是字符的边框。
		 * @param charIndex
		 * @return
		 */
		function getCharBoundaries(charIndex:int):Rectangle;
		/**
		 * 在 x 和 y 参数指定的位置返回从零开始的字符索引值。
		 * @param x
		 * @param y
		 * @return
		 */
		function getCharIndexAtPoint(x:Number, y:Number):int;
		/**
		 * 如果给定一个字符索引，则返回同一段落中第一个字符的索引。
		 * @param charIndex
		 * @return
		 */
		function getFirstCharInParagraph(charIndex:int):int;
		/**
		 * 返回给定 id 或已使用 img 标签添加到 HTML 格式文本字段中的图像或 SWF 文件的 DisplayObject 引用。
		 * @param id
		 * @return
		 */
		function getImageReference(id:String):DisplayObject;
		/**
		 * 在 x 和 y 参数指定的位置返回从零开始的行索引值。
		 * @param x
		 * @param y
		 * @return
		 */
		function getLineIndexAtPoint(x:Number, y:Number):int;
		/**
		 * 返回 charIndex 参数指定的字符所在的行的索引值（从零开始）。
		 * @param charIndex
		 * @return
		 */
		function getLineIndexOfChar(charIndex:int):int;
		/**
		 * 返回特定文本行中的字符数。
		 * @param lineIndex
		 * @return
		 */
		function getLineLength(lineIndex:int):int;
		/**
		 * 返回给定文本行的度量信息。
		 * @param lineIndex
		 * @return
		 */
		function getLineMetrics(lineIndex:int):TextLineMetrics;
		/**
		 * 返回 lineIndex 参数指定的行中第一个字符的字符索引。
		 * @param lineIndex
		 * @return
		 */
		function getLineOffset(lineIndex:int):int;
		/**
		 * 返回 lineIndex 参数指定的行的文本。
		 * @param lineIndex
		 * @return
		 */
		function getLineText(lineIndex:int):String;
		/**
		 * 如果给定一个字符索引，则返回包含给定字符的段落的长度。
		 * @param charIndex
		 * @return
		 */
		function getParagraphLength(charIndex:int):int;
		/**
		 * 返回 TextFormat 对象，其中包含 beginIndex 和 endIndex 参数指定的文本范围的格式信息。
		 * @param beginIndex
		 * @param endIndex
		 * @return
		 */
		function getTextFormat(beginIndex:int = -1, endIndex:int = -1):TextFormat;
		/**
		 * 使用 value 参数的内容替换当前所选内容。
		 *  使用当前默认字符格式和默认段落格式，在当前所选内容的所在位置插入文本。
		 * 不将该文本视为 HTML。
		 * @param value
		 */
		function replaceSelectedText(value:String):void;
		/**
		 * 使用 newText 参数的内容替换 beginIndex 和 endIndex 参数指定的字符范围。
		 * @param beginIndex
		 * @param endIndex
		 * @param newText
		 */
		function replaceText(beginIndex:int, endIndex:int, newText:String):void;
		/**
		 * 将第一个字符和最后一个字符的索引值（使用 beginIndex 和 endIndex 参数指定）指定的文本设置为所选内容。
		 * 如果两个参数值相同，则此方法会设置插入点，这一点与您设置 caretIndex 属性相同。
		 * @param beginIndex
		 * @param endIndex
		 */
		function setSelection(beginIndex:int, endIndex:int):void;
		/**
		 * 将 format 参数指定的文本格式应用于文本字段中的指定文本。
		 * @param format
		 * @param beginIndex
		 * @param endIndex
		 */
		function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void;
	}
}
