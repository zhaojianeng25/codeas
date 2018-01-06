package tempest.data.map
{
	
	
	/**
	 * 地图区域类型
	 */
	public class Arrea
	{
		/**
		 * 地图id 
		 */		
		public var mapId:uint;
		/**
		 * 区域id
		 */		
		public var id:uint;
		/**
		 * 类型
		 */		
		public var typeFlag:uint;
		/**
		 * 动作 
		 */		
		public var action:uint;
		/**
		 * 区域 
		 */		
		public var area:Vector.<int> = new Vector.<int>();
		
		public function Arrea()
		{
		}
		
		/**
		 * 设置类型标志
		 * @param value
		 * 
		 */
		public function setFlag(value:uint):void{
			typeFlag |= value;
		}
		
		/**
		 * 判断区域类型
		 * @param value
		 * @return 
		 * 
		 */
		public function isFlag(value:uint):Boolean{
			return (typeFlag & value) == value;
		}
		
		/**
		 * 设置区域点
		 * @param pt
		 * 
		 */
		public function addPoint(x:int, y:int):void{
			var len:int = area.length;
			area[len] = x
			area[len+1] = y;
		}
		
		/**
		 * 判断有没再区域内
		 * @param x
		 * @param y
		 * @return 
		 */
		public function contains(mapid:uint,x:int,y:int):Boolean{
			if(mapId != mapid)
				return false;
			var i:uint = 0;
			var j:uint = 0;
			var cnt:uint = 0;
			var size:uint = area.length/2;
			for (i=0; i < size; i ++)
			{
				j = (i == size - 1) ? 0 : i + 1;
				
				var xOffsetI:int = i * 2;
				var yOffsetI:int = xOffsetI + 1;
				
				var xOffsetJ:int = j * 2;
				var yOffsetJ:int = xOffsetJ + 1;
				
				if ( area[yOffsetI]!=area[yOffsetJ] &&
					(y >= area[yOffsetI] && y< area[yOffsetJ] || y >= area[yOffsetJ] && y < area[yOffsetI] )&& 
					x < (area[xOffsetJ] - area[xOffsetI]) * (y - area[yOffsetI]) / (area[yOffsetJ] - area[yOffsetI]) + area[xOffsetI]) 
					cnt++;
			}
			return cnt%2>0;
		}
	}
}
