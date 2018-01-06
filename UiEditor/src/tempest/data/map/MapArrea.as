package tempest.data.map
{
	

	/**
	 * 地图区域数据
	 */
	public class MapArrea
	{
		private static const ARREA_FLAG_SAFETY	:uint = 0x01;		/*安全区*/
		private static const ARREA_FLAG_STALL		:uint = 0x02;		/*摆摊区*/
		private static const ARREA_FLAG_NOT_STALL	:uint = 0x04;		/*不可摆摊区*/
		private static const ARREA_FLAG_CITY		:uint = 0x08;		/*城内区*/
		private static const ARREA_FLAG_LOTTERY	:uint = 0x10;		/*彩票触发区*/
		private static const ARREA_FLAG_XSCA:uint	= 0x11;				/*新手村1区*/
		private static const ARREA_FLAG_XSCB:uint   = 0x12;			/*新手村2区*/
		private static const ARREA_FLAG_XYA:uint	= 0x13;				/*新野1区*/
		private static const ARREA_FLAG_XYB:uint    = 0x14;			/*新野2区*/
		private static const data:Array = [
			//区域总数
			5,
			//区域类型标志 长度 ,标志
			2,		ARREA_FLAG_STALL,ARREA_FLAG_CITY,
			//区域数据  地图id 点长度 点数据 
			5,		6,		185,140,	315,220,	245,282,	250,345,	205,345,	40,230,
			
			//区域类型标志 长度 ,标志
			1,		ARREA_FLAG_NOT_STALL,
			//区域数据  地图id 点长度 点数据 
			5,		4,		160,200,	189,181,	218,200,	189,220	,
			
			//区域类型标志 长度 ,标志
			1,		ARREA_FLAG_LOTTERY,
			//区域数据  地图id 点长度 点数据 
			4,		4,		75,25,	95,25,	95,65,	75,65,
			
			//区域类型标志 长度 ,标志
			2,		ARREA_FLAG_XSCA,ARREA_FLAG_XSCB,
			//区域数据  地图id 点长度 点数据 
			1,		8,		0,0,	121,0,		115,29,		136,46,		55,82,	92,111,		78,143,		0,142,
			
			//区域类型标志 长度 ,标志
			2,		ARREA_FLAG_XYA,ARREA_FLAG_XYB,
			//区域数据  地图id 点长度 点数据 
			17,		10,		6,9,	77,54,	124,40,	 186,82,	117,92,	 159,133,   190,154,   204,149,   204,181,  0,181,
		];//
		
		private static const _arreaList:Vector.<Arrea> = new Vector.<Arrea>();
		
		init();		
		private static function init():void
		{
			//拿出区域个数
			var arreaLen:uint = data.shift();
			for(var i:int = 0; i < arreaLen; i ++){
				//创建区域
				var arrea:Arrea = new Arrea();
				//拿出类型标志数据
				var flagLen:uint = data.shift();
				for(var j:int = 0; j < flagLen; j ++){
					arrea.setFlag(data.shift());
				}
				//拿出地图id
				arrea.mapId = data.shift();
				//拿出区域点数据
				var pointLen:uint = data.shift();
				for(var k:int = 0; k < pointLen; k ++){
					arrea.addPoint(data.shift(), data.shift());
				}
				_arreaList[_arreaList.length] = arrea;
			}
		}
		
		/**
		 * 是否在安全区
		 * @param mapid
		 * @param x
		 * @param y
		 * @return 
		 */
		public static function inSafetyArrea(mapid:uint,x:uint,y:uint):Boolean{
			var len:uint = _arreaList.length;
			for(var i:int = 0; i < len; i ++){
				if(_arreaList[i].isFlag(ARREA_FLAG_SAFETY)  && _arreaList[i].contains(mapid, x, y))
					return true;
			}
			return false;
		}
		
		/**
		 *是否在新手村A区 
		 * @param mapid
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public static function inXscA(mapid:uint,x:uint,y:uint):Boolean{
			var len:uint = _arreaList.length;
			for(var i:int = 0; i < len; i ++){
				if(_arreaList[i].isFlag(ARREA_FLAG_XSCA)  && _arreaList[i].contains(mapid, x, y))
					return true;
			}
			return false;
		}
		
		public static function inXyA(mapid:uint,x:uint,y:uint):Boolean{
			var len:uint = _arreaList.length;
			for(var i:int = 0; i < len; i ++){
				if(_arreaList[i].isFlag(ARREA_FLAG_XYA)  && _arreaList[i].contains(mapid, x, y))
					return true;
			}
			return false;
		}
		
	}
}
