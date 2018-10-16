package tempest.core
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.text.TextSnapshot;

	public interface IDisplayObjectContainer
	{
		/**
		 * 确定对象的子项是否支持鼠标。
		 * @return
		 */
		function get mouseChildren():Boolean;
		function set mouseChildren(value:Boolean):void;
		/**
		 * 返回此对象的子项数目。
		 * @return
		 */
		function get numChildren():int;
		/**
		 * 确定对象的子项是否支持 Tab 键。 为对象的子项启用或禁用 Tab 切换。 默认值为 true。
		 * @return
		 */
		function get tabChildren():Boolean;
		function set tabChildren(value:Boolean):void;
		/**
		 * 返回此 DisplayObjectContainer 实例的 TextSnapshot 对象。
		 * @return
		 */
		function get textSnapshot():TextSnapshot;
		/**
		 * 将一个 DisplayObject 子实例添加到该 DisplayObjectContainer 实例中。
		 * @param child
		 * @return
		 */
		function addChild(child:DisplayObject):DisplayObject;
		/**
		 * 将一个 DisplayObject 子实例添加到该 DisplayObjectContainer 实例中。
		 * @param child
		 * @param index
		 * @return
		 */
		function addChildAt(child:DisplayObject, index:int):DisplayObject;
		/**
		 * 指示安全限制是否会导致出现以下情况：在列表中忽略了使用指定 point 点调用 DisplayObjectContainer.getObjectsUnderPoint() 方法时返回的所有显示对象。
		 * @param point
		 * @return
		 */
		function areInaccessibleObjectsUnderPoint(point:Point):Boolean;
		/**
		 * 确定指定显示对象是 DisplayObjectContainer 实例的子项还是该实例本身。
		 * @param child
		 * @return
		 */
		function contains(child:DisplayObject):Boolean;
		/**
		 * 返回位于指定索引处的子显示对象实例。
		 * @param index
		 * @return
		 */
		function getChildAt(index:int):DisplayObject;
		/**
		 * 返回具有指定名称的子显示对象。
		 * @param name
		 * @return
		 */
		function getChildByName(name:String):DisplayObject;
		/**
		 * 返回 DisplayObject 的 child 实例的索引位置。
		 * @param child
		 * @return
		 */
		function getChildIndex(child:DisplayObject):int;
		/**
		 * 返回对象的数组，这些对象位于指定点下，并且是该 DisplayObjectContainer 实例的子项（或孙子项，依此类推）。
		 * @param point
		 * @return
		 */
		function getObjectsUnderPoint(point:Point):Array;
		/**
		 * 从 DisplayObjectContainer 实例的子列表中删除指定的 child DisplayObject 实例。
		 * @param child
		 * @return
		 */
		function removeChild(child:DisplayObject):DisplayObject;
		/**
		 * 从 DisplayObjectContainer 的子列表中指定的 index 位置删除子 DisplayObject。
		 * @param index
		 * @return
		 */
		function removeChildAt(index:int):DisplayObject;
		/**
		 * 更改现有子项在显示对象容器中的位置。
		 * @param child
		 * @param index
		 */
		function setChildIndex(child:DisplayObject, index:int):void;
		/**
		 * 交换两个指定子对象的 Z 轴顺序（从前到后顺序）。
		 * @param child1
		 * @param child2
		 */
		function swapChildren(child1:DisplayObject, child2:DisplayObject):void;
		/**
		 * 在子级列表中两个指定的索引位置，交换子对象的 Z 轴顺序（前后顺序）。
		 * @param index1
		 * @param index2
		 */
		function swapChildrenAt(index1:int, index2:int):void;
	}
}
