package tempest.data.utils
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import tempest.data.geom.point;
	import tempest.data.map.TrunkPoint;

	public class TrunkPathUtil
	{
		private static var _startTime:Number=0;
		private static var _findedPath:Dictionary;

		public function TrunkPathUtil()
		{
		}

		public static function getShortPath(trunkPath:Vector.<TrunkPoint>, startId:int, endId:int):Array
		{
			var tkp:TrunkPoint=trunkPath[startId]
			var resultList:Array=[];
			var searched:Vector.<int>=new Vector.<int>();
			searched.push(startId);
			_startTime=Time.getTimer();
			_findedPath=new Dictionary();
			search(trunkPath, startId, endId, searched, [new Point(tkp.x, tkp.y)], 0, resultList);
			if (resultList.length != 0)
			{
//				resultList.sortOn("dis", Array.NUMERIC);
				return resultList[0].list;
			}
			else
			{
				return null;
			}
		}

		private static function search(trunkPath:Vector.<TrunkPoint>, start:int, end:int, searched:Vector.<int>, tempResult:Array, distance:Number, result:Array):void
		{
			var tkp:TrunkPoint=trunkPath[start];
			var nextTkp:Vector.<point>=tkp.nextPoints;
			for each (var _tkp:TrunkPoint in nextTkp)
			{
				var id:int=_tkp.id;
				if (searched.indexOf(id) == -1)
				{
					var _tempResult:Array=tempResult.concat();
					_tempResult.push(new Point(_tkp.x, _tkp.y));
					var $distance:Number=distance;
					$distance+=tkp.nextDistances[_tkp.id];
					var $key:String=tkp.id < id ? tkp.id + "_" + id : id + "_" + tkp.id;
					var $findedDis:Object=_findedPath[$key];
					if ($findedDis != null && $distance >= int($findedDis))
					{
						continue;
					}
					_findedPath[$key]=$distance;
					var obj:Object=result[0];
					if (obj && $distance >= obj["dis"])
					{
						continue;
					}
					if (id == end)
					{
						result[0]={dis: $distance, list: _tempResult};
						break;
					}
					else
					{
						var seachedTemp:Vector.<int>=searched.concat();
						for each (var __tkp:TrunkPoint in nextTkp)
						{
							seachedTemp.push(__tkp.id);
						}
						search(trunkPath, id, end, seachedTemp, _tempResult, $distance, result);
					}
				}
			}
		}
	}
}
