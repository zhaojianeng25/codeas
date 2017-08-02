package com.zcp._special.drag
{
	import flash.display.DisplayObject;

	/**
	 * 拖放到的目标接口 
	 * @author zcp
	 * 
	 */	
	public interface IDropInTarget
	{
		/**
		 * 被拖放到的显示对象提供的处理函数
		 * @param $data 拖拽数据
		 * return 如果是所需处理则返回true,否则返回false
		 */		
		function dropIn($data:DropInData=null):Boolean;
	}
}