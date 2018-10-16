package tempest.data.map
{
	
	/**
	 * 传送点 
	 * @author 林碧致
	 * 
	 */	
	public class Teleport
	{
		/**
		 * 来源坐标 X,Y
		 */		
		public var srcPortX:uint;
		public var srcPortY:uint;
		/**
		 * 目的地图id
		 */
		public var dstMapid:uint;
		/**
		 * 目的坐标X,Y
		 */
		public var dstPortX:uint;
		public var dstPortY:uint;
		/**
		 * 传送点名称 
		 */		
		public var name:String;
		/**
		 * 模板id 
		 */		
		public var tempId:uint;
		
		public function Teleport()
		{
			
		}
		
	}
}