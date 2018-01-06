package tempest.data.utils
{

	/**
	 * 地图类接口
	 * 用于寻路
	 * @author
	 */
	public interface IMapModel
	{
		/**
		 * 提供可遍历的节点
		 *
		 * @param p	当前节点
		 * @return
		 *
		 */
		function getArounds(x:int, y:int):Array;
	}
}
