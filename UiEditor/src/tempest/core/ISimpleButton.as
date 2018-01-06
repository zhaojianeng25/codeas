package tempest.core
{
	import flash.display.DisplayObject;
	import flash.media.SoundTransform;

	public interface ISimpleButton
	{
		/**
		 * 指定一个用作按钮“按下”状态（当用户单击 hitTestState 对象时，按钮所处的状态）的可视对象的显示对象。
		 * @return
		 */
		function get downState():DisplayObject;
		function set downState(value:DisplayObject):void;
		/**
		 * 布尔值，指定按钮是否处于启用状态。
		 *  按钮被禁用时（enabled 属性设置为 false），该按钮虽然可见，但不能被单击。 默认值为 true。
		 * @return
		 */
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		/**
		 * 指定一个用作按钮的点击测试对象的显示对象。
		 * 对于基本按钮，将 hitTestState 属性设置为与 overState 属性相同的显示对象。
		 * 如果没有设置 hitTestState 属性，则 SimpleButton 处于非活动状态 -- 它不对鼠标和键盘事件进行响应。
		 * @return
		 */
		function get hitTestState():DisplayObject;
		function set hitTestState(value:DisplayObject):void;
		/**
		 * 指定一个用作按钮经过状态（当鼠标位于按钮上方时，按钮所处的状态）的可视对象的显示对象。
		 * @return
		 */
		function get overState():DisplayObject;
		function set overState(value:DisplayObject):void;
		/**
		 * 分配给此按钮的 SoundTransform 对象。
		 *  SoundTransform 对象包含用于设置音量、平移、左扬声器指定和右扬声器指定的属性。
		 *  SoundTransform 对象适用于按钮的所有状态。 SoundTransform 对象仅影响嵌入的声音。
		 * @return
		 */
		function get soundTransform():SoundTransform;
		function set soundTransform(value:SoundTransform):void;
		/**
		 * 指示属于 SimpleButton 或 MovieClip 对象的其它显示对象是否可以接收鼠标释放事件。
		 * @return
		 */
		function get trackAsMenu():Boolean;
		function set trackAsMenu(value:Boolean):void;
		/**
		 * 指定一个用作按钮弹起状态（当鼠标没有位于按钮上方时，按钮所处的状态）的可视对象的显示对象。
		 * @return
		 */
		function get upState():DisplayObject;
		function set upState(value:DisplayObject):void;
		/**
		 * 一个布尔值，当设置为 true 时，指示鼠标指针滑过按钮上方时 Flash Player 是否显示手形光标。
		 * 如果此属性设置为 false，则将改用箭头指针。 默认值为 true。
		 * @return
		 */
		function get useHandCursor():Boolean;
		function set useHandCursor(value:Boolean):void;
	}
}
