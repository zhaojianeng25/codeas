package tempest.core
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;

	public interface IDisplayObject
	{
		/**
		 * 此显示对象的当前辅助功能选项。
		 * 如果您修改 accessibilityProperties 属性或 accessibilityProperties 内部的任何字段，则必须调用 Accessibility.updateProperties() 方法以使您的更改生效。
		 * @return
		 */
		function get accessibilityProperties():AccessibilityProperties;
		function set accessibilityProperties(value:AccessibilityProperties):void;
		/**
		 * 指示指定对象的 Alpha 透明度值。 有效值为 0（完全透明）到 1（完全不透明）。 默认值为 1。 alpha 设置为 0 的显示对象是活动的，即使它们不可见。
		 * @return
		 */
		function get alpha():Number;
		function set alpha(value:Number):void;
		/**
		 * BlendMode 类中的一个值，用于指定要使用的混合模式。
		 * @return
		 */
		function get blendMode():String;
		function set blendMode(value:String):void;
		/**
		 * 如果设置为 true，则 Flash Player 将缓存显示对象的内部位图表示形式。
		 * @return
		 */
		function get cacheAsBitmap():Boolean;
		function set cacheAsBitmap(value:Boolean):void;
		/**
		 * 包含当前与显示对象关联的每个滤镜对象的索引数组。 flash.filters 包中的多个类定义了可使用的特定滤镜。
		 * @return
		 */
		function get filters():Array;
		function set filters(value:Array):void;
		/**
		 * 指示显示对象的高度，以像素为单位。 高度是根据显示对象内容的范围来计算的。
		 * @return
		 */
		function get height():Number;
		function set height(value:Number):void;
		/**
		 * 返回一个 LoaderInfo 对象，其中包含加载此显示对象所属的文件的相关信息。
		 * @return
		 */
		function get loaderInfo():LoaderInfo;
		/**
		 * 调用显示对象被指定的 mask 对象遮罩。 要确保当舞台缩放时蒙版仍然有效，mask 显示对象必须处于显示列表的活动部分。 但不绘制 mask 对象本身。 将 mask 设置为 null 可删除蒙版。
		 * @return
		 */
		function get mask():DisplayObject;
		function set mask(value:DisplayObject):void;
		/**
		 * 指示鼠标位置的 x 坐标，以像素为单位。
		 * @return
		 */
		function get mouseX():Number;
		/**
		 * 指示鼠标位置的 y 坐标，以像素为单位。
		 * @return
		 */
		function get mouseY():Number;
		/**
		 * 指示 DisplayObject 的实例名称。 通过调用父显示对象容器的 getChildByName() 方法，可以在父显示对象容器的子列表中标识该对象。
		 * @return
		 */
		function get name():String;
		function set name(value:String):void;
		/**
		 * 指定显示对象是否由于具有某种背景颜色而不透明。 透明的位图包含 Alpha 通道数据，并以透明的方式进行绘制。 不透明位图没有 Alpha 通道（呈现速度比透明位图快）。 如果位图是不透明的，则您可以指定要使用的其自己的背景颜色。
		 * @return
		 */
		function get opaqueBackground():Object;
		function set opaqueBackground(value:Object):void;
		/**
		 * 指示包含此显示对象的 DisplayObjectContainer 对象。 使用 parent 属性可以指定高于显示列表层次结构中当前显示对象的显示对象的相对路径。
		 * @return
		 */
		function get parent():DisplayObjectContainer;
		/**
		 * 对于加载的 SWF 文件中的显示对象，root 属性是此 SWF 文件所表示的显示列表树结构部分中的顶级显示对象。 对于代表已加载图像文件的位图对象，root 属性就是位图对象本身。
		 * @return
		 */
		function get root():DisplayObject;
		/**
		 * 指示 DisplayObject 实例距其原始方向的旋转程度，以度为单位。 从 0 到 180 的值表示顺时针方向旋转；从 0 到 -180 的值表示逆时针方向旋转。 对于此范围之外的值，可以通过加上或减去 360 获得该范围内的值。 例如，my_video.rotation = 450语句与 my_video.rotation = 90 是相同的。
		 * @return
		 */
		function get rotation():Number;
		function set rotation(value:Number):void;
		/**
		 * 当前有效的缩放网格。 如果设置为 null，则在应用任何缩放转换时，将正常缩放整个显示对象。
		 * @return
		 */
		function get scale9Grid():Rectangle;
		function set scale9Grid(value:Rectangle):void;
		/**
		 * 指示从注册点开始应用的对象的水平缩放比例 (percentage)。 默认注册点为 (0,0)。 1.0 等于 100% 缩放。
		 * @return
		 */
		function get scaleX():Number;
		function set scaleX(value:Number):void;
		/**
		 * 指示从对象注册点开始应用的对象的垂直缩放比例 (percentage)。 默认注册点为 (0,0)。 1.0 是 100% 缩放。
		 * 缩放本地坐标系统将影响 x 和 y 属性设置，这些设置是以整像素定义的。
		 * @return
		 */
		function get scaleY():Number;
		function set scaleY(value:Number):void;
		/**
		 * 显示对象的滚动矩形范围。 显示对象被裁切为矩形定义的大小，当您更改 scrollRect 对象的 x 和 y 属性时，它会在矩形内滚动。
		 * @return
		 */
		function get scrollRect():Rectangle;
		function set scrollRect(value:Rectangle):void;
		/**
		 * 显示对象的舞台。 Flash 应用程序只有一个 Stage 对象。 例如，您可以创建多个显示对象并加载到显示列表中，每个显示对象的 stage 属性是指相同的 Stage 对象（即使显示对象属于已加载的 SWF 文件）。
		 * @return
		 */
		function get stage():Stage;
		/**
		 * 一个对象，具有与显示对象的矩阵、颜色转换和像素范围有关的属性。
		 * @return
		 */
		function get transform():Transform;
		function set transform(value:Transform):void;
		/**
		 * 显示对象是否可见。 不可见的显示对象已被禁用。 例如，如果 InteractiveObject 实例的 visible=false，则无法单击该对象。
		 * @return
		 */
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		/**
		 * 指示显示对象的宽度，以像素为单位。 宽度是根据显示对象内容的范围来计算的。
		 * @return
		 */
		function get width():Number;
		function set width(value:Number):void;
		/**
		 * 指示 DisplayObject 实例相对于父级 DisplayObjectContainer 本地坐标的 x 坐标。
		 *  如果该对象位于具有变形的 DisplayObjectContainer 内，则它也位于包含 DisplayObjectContainer 的本地坐标系中。
		 *  因此，对于逆时针旋转 90 度的 DisplayObjectContainer，该 DisplayObjectContainer 的子级将继承逆时针旋转 90 度的坐标系。 对象的坐标指的是注册点的位置。
		 * @return
		 */
		function get x():Number;
		function set x(value:Number):void;
		/**
		 * 指示 DisplayObject 实例相对于父级 DisplayObjectContainer 本地坐标的 y 坐标。
		 * 如果该对象位于具有变形的 DisplayObjectContainer 内，则它也位于包含 DisplayObjectContainer 的本地坐标系中。
		 *  因此，对于逆时针旋转 90 度的 DisplayObjectContainer，该 DisplayObjectContainer 的子级将继承逆时针旋转 90 度的坐标系。 对象的坐标指的是注册点的位置。
		 * @return
		 */
		function get y():Number;
		function set y(value:Number):void;
		/**
		 * 返回一个矩形，该矩形定义相对于 targetCoordinateSpace 对象坐标系的显示对象区域。
		 * @param targetCoordinateSpace
		 * @return
		 */
		function getBounds(targetCoordinateSpace:DisplayObject):Rectangle;
		/**
		 * 返回一个矩形，该矩形根据 targetCoordinateSpace 参数定义的坐标系定义显示对象的边界，但不包括形状上的任何笔触。
		 *  getRect() 方法返回的值等于或小于由 getBounds() 方法返回的值。
		 * @param targetCoordinateSpace
		 * @return
		 */
		function getRect(targetCoordinateSpace:DisplayObject):Rectangle;
		/**
		 * 将 point 对象从舞台（全局）坐标转换为显示对象的（本地）坐标。
		 * @param point
		 * @return
		 */
		function globalToLocal(point:Point):Point;
		/**
		 * 计算显示对象，以确定它是否与 obj 显示对象重叠或相交。
		 * @param obj
		 * @return
		 */
		function hitTestObject(obj:DisplayObject):Boolean;
		/**
		 * 计算显示对象，以确定它是否与 x 和 y 参数指定的点重叠或相交。
		 *  x 和 y 参数指定舞台的坐标空间中的点，而不是包含显示对象的显示对象容器中的点（除非显示对象容器是舞台）。
		 * @param x
		 * @param y
		 * @param shapeFlag
		 * @return
		 */
		function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = false):Boolean;
		/**
		 * 将 point 对象从显示对象的（本地）坐标转换为舞台（全局）坐标。
		 * @param point
		 * @return
		 */
		function localToGlobal(point:Point):Point;
	}
}
