package com.zcp.pool
{
	/**
	 * 池存储数据接口
	 * @author zcp
	 */	
	public interface IPoolClass
	{
		/**释放*/
		function dispose():void;
		/**
		 * 重置
		 * @param $parameters 构造函数的参数数组
		 */
		function reSet($parameters:Array):void;
	}
}