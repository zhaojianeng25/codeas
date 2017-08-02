package com.zcp.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.utils.ByteArray;

	/**
	 * Fun
	 * @author zcp
	 */
	public class Fun
	{
		/**
		 * 清空容器
		 * @param $dobj
		 * @param $disposeChildren
		 * @param $recursion 是否递归清空子元素
		 * @return 
		 * 
		 */		
        public static function clearChildren($dobj:DisplayObject, $disposeChildren:Boolean = false, $recursion:Boolean=true) : void
        {            
			if ($dobj == null)
			{
				return;
			}
			if ($dobj is DisplayObjectContainer)
			{
				var numChildren:int= ($dobj as DisplayObjectContainer).numChildren;
				while (numChildren-->0)
				{
					if($recursion)clearChildren(($dobj as DisplayObjectContainer).getChildAt(numChildren), $disposeChildren,$recursion);
					if(!($dobj is Loader))($dobj as DisplayObjectContainer).removeChildAt(numChildren);
				}
			}
			else if ($disposeChildren && ($dobj is Bitmap) && ($dobj as Bitmap).bitmapData)
			{
				($dobj as Bitmap).bitmapData.dispose();
			}
            return;
        }
		
		/**
		 * 取得所有父元素的集合(不包含$dobj自身)
		 * @param $dobj
		 * @return 
		 * 
		 */		
		public static function parentList($dobj:DisplayObject):Array {
			var dobjList:Array = [];
			while($dobj.parent!=null)
			{
				dobjList.push($dobj.parent);
				$dobj = $dobj.parent;
			}
			return dobjList;
		}
		/**
		 * 取得所有子元素的集合(不包含$container自身)
		 * @param container
		 * @return 
		 * 
		 */		
		public static function childList($container:DisplayObjectContainer):Array {
			var dobjList:Array = [];
			var childrenCount:int = $container.numChildren;
			for (var i:int=childrenCount-1; i >=0; i--) {
				//添加本身
				var dobj:DisplayObject = $container.getChildAt(i);
				dobjList.push(dobj);
				//递归添加子
				if (dobj is DisplayObjectContainer) {
					dobjList = dobjList.concat(childList(dobj as DisplayObjectContainer));
				}
			}
			return dobjList;
		}
//		/**
//		 * 添加元素
//		 * @param $parent
//		 * @param $child
//		 * @param $top 是否在最顶层
//		 * @return
//		 * 
//		 */
//		public static function addChild($parent:DisplayObjectContainer, $child:DisplayObject, $top:Boolean=true):void {
//			if($parent!=null && $child!=null)
//			{
//				if($top || $child.parent!=$parent)
//				{
//					$parent.addChild($child);
//				}
//			}
//		}
		/**
		 * 移除元素
		 * @param $parent
		 * @param $child
		 * @return
		 * 
		 */
		public static function removeChild($child:DisplayObject):void {
			if($child!=null && $child.parent!=null)$child.parent.removeChild($child);
		}
		
		/**
		 * 获取参数1否是参数2的长辈（若判断是相同对象或者长辈，请用$parent.contains($child)）
		 * @param $parent
		 * @param $child
		 * @return 
		 * 
		 */
		public static function isParentChild($parent:DisplayObjectContainer, $child:DisplayObject):Boolean {
			if($child==null||$parent==null||$child.parent==null)
				return false;
			else if($child.parent==$parent)
				return true;
			else
				return isParentChild($parent,$child.parent);
			return false;
		}

		/**
		 * 获取是否显示在舞台上了
		 * @param $dobj
		 * @return 
		 * 说明：此函数只是简单判断了下面的条件1和3
		 * 		元素可不可见至少需要5个条件：
		 * 		1.$dobj和$dobj的所有的parent visilbe = true 
		 * 		2.$dobj和$dobj所有的parent alpha!=0
		 * 		3.$dobj.stage!=null
		 * 		4.$dobj在屏幕可见范围内
		 * 		5.$dobj上面没有完全能够遮挡住$dobj的层
		 */
		public static function isVisible($dobj:DisplayObject):Boolean {
		    if($dobj==null||$dobj.visible==false)
		    	return false;
		    else if($dobj is Stage)
			    return true;	
		    else
		    	return isVisible($dobj.parent);
		    return false;
		}	
		/**
		 * 判断BitmapData是否被dispose了
		 * @param $bd BitmapData 不能为null
		 */
		public static function bitmapDataDisposed($bd:BitmapData):Boolean {
			try{
				$bd.width;
				return false;
			}
			catch(e:Error){
				return true;
			}
			return false;
		}	
		/**
		 * 对象拷贝（深度拷贝）
		 * @param value
		 * @return 
		 * 
		 */		
		public static function copy(value:Object):Object
		{
			
			var buffer:ByteArray = new ByteArray();
			buffer.writeObject(value);
			buffer.position = 0;
			var result:Object = buffer.readObject();
			return result;
		}
		/**
		 * ByteArray复制(和BitmapData一样，尽量少复制副本，以免占用太多内存空间)
		 * @param value
		 * @return 
		 * 
		 */		
		public static function copyByteArray(value:ByteArray):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeBytes(value);
			return bytes;
		}
//		/**
//		 * 强制执行垃圾回收
//		 * 
//		 */	
//		public static function doGC() : void
//		{
//			try
//			{
//				new LocalConnection().connect("foo");
//				new LocalConnection().connect("foo");
//			}catch(error : Error){}
//		}
	}
}