package tempest.data.map
{
	

	public class MapIndex
	{		
		/*分隔*/
		private static const CLEARANCE:String = ",";
		/*版本号*/
		public var mapDataVersion:uint;
		
		/**
		 * 索引数据
		 * 结构为：向量数组[mapid] = 传送点列表 
		 */		
		private var _data:Vector.<Vector.<Teleport>>;
		
		/*关闭列表*/
		private var _closeList:Vector.<uint> = new Vector.<uint>();
		
		public function MapIndex()
		{
		}
		
		public function init(value:String):void{
			var tempArray:Array = value.split(CLEARANCE);
			//版本号
			mapDataVersion = uint(tempArray.shift());
			//地图个数
			var len:uint = uint(tempArray.shift());
			_data = new Vector.<Vector.<Teleport>>(len);
			
			for(var i:uint = 0; i < len; i++)
			{
				//地图id
				var mapid:uint = uint(tempArray.shift());
				//冗余，设置数组长度
				if(mapid >= _data.length)
					_data.length = mapid + 1;
				
				//获得传送点长度
				var telportLen:uint = uint(tempArray.shift());
				//传送点列表
				var mapTeleports:Vector.<Teleport> = new Vector.<Teleport>(telportLen, true);
				for(var j:uint = 0; j<telportLen; j++)
				{
					var teleport:Teleport = new Teleport();
					//坐标
					teleport.srcPortX =  uint(tempArray.shift());
					teleport.srcPortY =  uint(tempArray.shift());
					//目标地图id
					teleport.dstMapid = tempArray.shift();
					//目标坐标
					teleport.dstPortX = uint(tempArray.shift());
					teleport.dstPortY = uint(tempArray.shift());
					mapTeleports[j] = teleport;
				}
				
				_data[mapid] = mapTeleports;
			}	
		}
		
		/**
		 * 跨地图寻路算法
		 * @param srcMapid 来源地图id
		 * @param dstMapid 目标地图id
		 * @return 如果找不到各地图传送点数组，则返回空
		 * 
		 */	
		public function find(srcMapid:uint, dstMapid:uint):Array
		{
			_closeList.length = 0;
			var ref:Array = [];
			//如果搜索得到路径，则返回路径，否则返回空
			if(searching(srcMapid, dstMapid, ref)){
				ref = ref.reverse();
				return ref;
			}
			return null;
		}
		
		/**
		 * 递归搜索路径 
		 * @param firstMapid 进入点
		 * @param exitMapid 退出点
		 * @param ref 返回路径
		 * @return  返回是否搜索到
		 * 
		 */	
		private function searching(firstMapid:uint, exitMapid:uint, ref:Array):Boolean
		{
			//尝试过的点加入列表
			_closeList[_closeList.length] = firstMapid;
			
			//找到了点
			if(firstMapid == exitMapid)
				return true;
			
			//开始遍历所有传送点的目的地查找
			var teleports:Vector.<Teleport> = _data[firstMapid];
			for(var i:uint = 0; i<teleports.length;i++)
			{
				var telport:Teleport = teleports[i];
				//该地图还未遍历过
				if(_closeList.indexOf(telport.dstMapid)==-1)
				{
					//找到匹配，则递归要回家了。
					if(searching(telport.dstMapid, exitMapid, ref))
					{
						ref[ref.length] = telport;
						return true;
					}	
				}
			}
			return false;
		}
		
		public function load(value:String):void{
			init(value);
		}
	}
}