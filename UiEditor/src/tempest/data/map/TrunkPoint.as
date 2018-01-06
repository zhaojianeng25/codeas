package tempest.data.map
{
	import flash.utils.Dictionary;
	
	import tempest.data.geom.point;

	public class TrunkPoint extends point
	{
		/**
		 * 关键点id
		 */
		public var id:uint;
		/**
		 * 下一点的节点数据
		 */
		public var nextPoints:Vector.<point>=new Vector.<point>();

		public var nextDistances:Dictionary=new Dictionary();

		/**
		 * 临时变量，距离
		 */
		public var distance:Number;
	}
}
