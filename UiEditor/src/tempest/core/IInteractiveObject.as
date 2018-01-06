package tempest.core
{
	import flash.ui.ContextMenu;

	public interface IInteractiveObject
	{
		/**
		 * 指定与此对象相关联的上下文菜单。
		 * @return
		 */
		function get contextMenu():ContextMenu;
		function set contextMenu(value:ContextMenu):void;
		/**
		 * 指定此对象是否接收 doubleClick 事件。
		 * @return
		 */
		function get doubleClickEnabled():Boolean;
		function set doubleClickEnabled(value:Boolean):void;
		/**
		 * 指定此对象是否显示焦点矩形。 null 值指示该对象遵循对舞台设置的 stageFocusRect 属性。
		 * @return
		 */
		function get focusRect():Object;
		function set focusRect(value:Object):void;
		/**
		 * 指定此对象是否接收鼠标消息。
		 * @return
		 */
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void;
		/**
		 * 指定此对象是否遵循 Tab 键顺序。
		 * @return
		 */
		function get tabEnabled():Boolean;
		function set tabEnabled(value:Boolean):void;
		/**
		 * 指定 SWF 文件中的对象按 Tab 键顺序排列。
		 * @return
		 */
		function get tabIndex():int;
		function set tabIndex(value:int):void;
	}
}
