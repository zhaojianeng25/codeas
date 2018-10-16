package tempest.core
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;

	public interface ISprite
	{
		/**
		 * 指定此 sprite 的按钮模式。
		 * @return
		 */
		function get buttonMode():Boolean;
		function set buttonMode(value:Boolean):void;
		/**
		 * 指定拖动 sprite 时经过的显示对象，或放置 sprite 的显示对象。
		 * @return
		 */
		function get dropTarget():DisplayObject;
		/**
		 * 指定属于此 sprite 的 Graphics 对象，在此 sprite 中可执行矢量绘画命令。
		 * @return
		 */
		function get graphics():Graphics;
		/**
		 * 指定一个 sprite 用作另一个 sprite 的点击区域。
		 * @return
		 */
		function get hitArea():Sprite;
		function set hitArea(value:Sprite):void;
		/**
		 * 控制此 sprite 中的声音。
		 * @return
		 */
		function get soundTransform():SoundTransform;
		function set soundTransform(value:SoundTransform):void;
		/**
		 * 布尔值，指示当鼠标滑过其 buttonMode 属性设置为 true 的 sprite 时是否显示手指形（手形光标）。
		 * @return
		 */
		function get useHandCursor():Boolean;
		function set useHandCursor(value:Boolean):void;
		/**
		 * 允许用户拖动指定的 Sprite。
		 * @param lockCenter
		 * @param bounds
		 */
		function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void;
		/**
		 * 结束 startDrag() 方法。
		 */
		function stopDrag():void;
	}
}
