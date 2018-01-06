package tempest.data.map
{
	
	

	public class MapCreature
	{
		public function MapCreature()
		{
		}
		
		
		/**
		 * 模板id 
		 */		
		public var id:uint;
		
		/**
		 * 坐标x
		 */		
		public var x:Number;
		
		/**
		 * 坐标y 
		 */		
		public var y:Number;
		
		/**
		 * 数量
		 */	
		public var count:uint;
		
		/**
		 * 死亡刷新时间
		 */		
		public var respawnTime:uint;
		
		/**
		 *刷新类型 
		 */		
		public var spawnType:uint;
		
		/**
		 *定时刷新时间1 
		 */		
		public var spawnTime1:uint;
		
		/**
		 *定时刷新时间2 
		 */		
		public var spawnTime2:uint;
		
		/**
		 *定时刷新时间3 
		 */		
		public var spawnTime3:uint;
		
		/**
		 *脚本 
		 */		
		public var scriptName:String="";
		
		/**
		 *走动类型 
		 */		
		public var around:uint;
		
		/**
		 *线路 
		 */		
		public var lineId:uint=0;
		
		/**
		 *npc标识 
		 */		
		public var flag:uint;
		
		/**
		 *npc朝向 
		 */		
		public var toward:Number;
		
		/**
		 * 别名 
		 */		
		public var aliasName:String;
		
		/**
		 * 生物模板
		 */		
//		public var T:Creature_T;
		public var T:Object;
		
	}
}