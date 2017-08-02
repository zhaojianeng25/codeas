package com.zcp.share
{
	/**
	 * 共享数据对象
	 * */
	public class CountShareData
	{
//		/**共享数据*/
//		public var data:*;
		
		/**引用数量*/
		public var count:int = 0;//这个最开始给0
		public function CountShareData(){}
		
		/**释放(外部需要复写此方法,对该对象执行销毁)*/
		public function destroy():void{
			throw Error("此方法必须被复写")
		}
	}
}