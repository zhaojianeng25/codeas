package tempest.core
{
	/**
	 * 对象池对象的接口
	 * @author wy
	 */
	public interface IPoolsObject
	{
		
		/**
		 * 进池 （相当于对象dispose函数）
		 */
		function intoPool(...arg):void;
		/**
		 * 出池 （相当于对象初始化函数）
		 */		
		function outPool(...arg):void;
	}
}