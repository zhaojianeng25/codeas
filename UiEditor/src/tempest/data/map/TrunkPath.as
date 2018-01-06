package tempest.data.map
{
	import flash.geom.Point;

	import tempest.data.geom.point;
	import tempest.data.utils.Dijkstra;
	import tempest.data.utils.MathUtil;
	import tempest.data.utils.TAstar;
	import tempest.data.utils.TrunkPathUtil;

	public class TrunkPath
	{
		private var _trunkPoints:Vector.<TrunkPoint>;
		/*节点到其他节点的距离描述 -- 有序的*/
		private var _dijkstra_map:Array
		private var _mapid:uint;

		public function TrunkPath()
		{
		}

		/**
		 * 主干道
		 */
		public function get trunkPoints():Vector.<TrunkPoint>
		{
			return _trunkPoints;
		}

		/**
		 * 初始化
		 * @param lines
		 *
		 */
		public function init(mapid:uint, list:Vector.<TrunkPoint>):void
		{
			_mapid=mapid;

			//数据木有包含
			if (list.length == 0)
				return;
			_trunkPoints=list;
			_dijkstra_map=[];
			for (var i:int=0; i < _trunkPoints.length; i++)
			{
				var part:Array=createdDistanceArr();
				_dijkstra_map[_dijkstra_map.length]=part;
				for (var j:int=0; j < _trunkPoints[i].nextPoints.length; j++)
				{
					var trunkPoint:TrunkPoint=findTrunkPointId(_trunkPoints[i].nextPoints[j]);
					if (trunkPoint && trunkPoint != _trunkPoints[i])
					{
						var distance:int=MathUtil.getDistance(_trunkPoints[i].x, _trunkPoints[i].y, trunkPoint.x, trunkPoint.y);
						part[trunkPoint.id]=distance;
					}
				}
			}
		}

		/**
		 * 创建dijkstra_map需要的距离数组
		 * @return
		 */
		private function createdDistanceArr():Array
		{
			var arr:Array=[];
			for (var i:int=0; i < _trunkPoints.length; i++)
			{
				arr[arr.length]=Dijkstra.NO_PATH;
			}
			return arr;
		}

		/**
		 * 找到关键点
		 * @param p
		 * @return
		 *
		 */
		private function findTrunkPointId(p:point):TrunkPoint
		{
			for (var i:int=0; i < _trunkPoints.length; i++)
			{
				if (_trunkPoints[i].equals(p))
					return _trunkPoints[i];
			}
			return null;
		}

		/**
		 * 查找线段两端最近的点
		 * @param x
		 * @param y
		 * @param refPath 返回x，y 到 该点的路径
		 * @return
		 *
		 */
		private function nearyPoint(x:int, y:int, refPath:Array):Array
		{
			if (!_trunkPoints)
				return null;
			var list:Vector.<TrunkPoint>=_trunkPoints.concat();
			var len:uint=list.length;
			//算出距离
			for (var i:uint=0; i < len; i++)
			{
				var cur:TrunkPoint=list[i];
				cur.distance=MathUtil.getDistance(x, y, cur.x, cur.y);
			}
			//按距离从小到大有序的排列
			list=list.sort(nearyPointCompare);
//			TAstar.maxTry=300
			len=len > 5 ? 5 : len; //最多尝试5次
			for (i=0; i < len; i++)
			{
				//必须可到达
				var path:Array=TAstar.find(null, x, y, list[i].x, list[i].y);
				if (TAstar.isInvalidPath(path))
					continue;
//				refPath.splice(0, refPath.length);
//				refPath.concat(path);
				return [list[i], path];
			}
			//执行到这一句，就是悲剧的时候，说明无法到达，所以只能随便给第一点了
			return [list[0], []];
		}

		private function nearyPointCompare(a:TrunkPoint, b:TrunkPoint):Number
		{
			return a.distance - b.distance;
		}

		/**
		 * 获得路径总里程
		 * @param path 路径
		 * @return
		 *
		 */
		private function getPathMileage(path:Array):Number
		{
			var len:uint=path.length;
			if (len <= 1)
				return 0;
			var nodeX:Number=path[0].x;
			var nodeY:Number=path[0].y;
			var total:Number=0;
			for (var i:uint=1; i < len; i++)
			{
				total+=MathUtil.getDistance(path[i].x, path[i].y, nodeX, nodeY);
				nodeX=path[i].x;
				nodeY=path[i].y;
			}
			return total;
		}

		private function arrayToVectorPath(pathArray:Array):Vector.<Number>
		{
			var path:Vector.<Number>=new Vector.<Number>();
			if (pathArray)
			{
				for (var i:int=0; i < pathArray.length; i++)
				{
					path.push(pathArray[i][0], pathArray[i][1]);
				}
			}

			return path;
		}

		/**
		 * 查找路径
		 * @param startX
		 * @param startY
		 * @param endX
		 * @param endY
		 * @return
		 *
		 */
		public function find(startX:int, startY:int, endX:int, endY:int, NEAREST_ASTART_DISTANCE:uint=15):Array
		{
			///////////////////// 1.如果astar直接可以到达，何苦走干道/////////////////////////////
			TAstar.maxTry=500;
			var astarPath:Array=TAstar.find(null, startX, startY, endX, endY);
			if (!TAstar.isInvalidPath(astarPath))
				return astarPath;
			////////////////////// 2.寻找最近干道入口点 ///////////////////////////////
			var entrAStatPath:Array=[];
			var exitAStatPath:Array=[];
			//寻找离起点最近干道入口点
			var entrResult:Array=nearyPoint(startX, startY, entrAStatPath);
			var entrRamp:TrunkPoint=entrResult[0];
			entrAStatPath=entrResult[1];
			//寻找离终点最近干道出口点
			var exitResult:Array=nearyPoint(endX, endY, exitAStatPath);
			var exitRamp:TrunkPoint=exitResult[0];
			exitAStatPath=exitResult[1];
			//找不到入口点或出口点则返回null
			if (!entrRamp || !exitRamp)
				return null;

			//临时选择的路径
			var choosePath:Array;
			/////////////////////// 3.获得入口和出口的干道路径 //////////////////////////
			//干道的中间路径
			var path:Array=[];
			//////////////////////
			//从干道入口到干道出口的路径
			path=Dijkstra.getShortedPath(_dijkstra_map, entrRamp.id, exitRamp.id).path; //TrunkPathUtil.getShortPath(trunkPoints, entrRamp.id, exitRamp.id);
//			path=TrunkPathUtil.getShortPath(trunkPoints, entrRamp.id, exitRamp.id);
			//从干道入口到干道出口是否有效
			if (TAstar.isInvalidPath(path))
				return null;
			var iter:int;
			while (iter < path.length) //置换成点数组
			{
				var $trunkP:TrunkPoint=trunkPoints[path[iter]];
				path[iter]=new Point($trunkP.x, $trunkP.y);
				iter++;
			}
			//////////////////////// 4.寻找最佳干道入口点 //////////////////////////////
			//////////////////////// 有可能会绕远了，所以有时候可以从干道节点第二点开始查
			//起点不是入口才需要判断干道入口那一段
//			TAstar.maxTry=300;
			var firstDistance:Number=int.MAX_VALUE;
			if (startX != entrRamp.x || startY != entrRamp.y)
			{
				//入口第二点
				var entrRampsencondX:int=path[1].x;
				var entrRampsencondY:int=path[1].y;
				//拿掉前面2个点
				path.splice(0, 2);
				if (startX != entrRampsencondX || startY != entrRampsencondY)
				{
					//astar:(起点- 第一点入口点) -> 第二点入口点 -> 干道（不包含1，2点）		
					if (!TAstar.isInvalidPath(entrAStatPath))
					{
						firstDistance=entrAStatPath.length + MathUtil.getDistance(entrRampsencondX, entrRampsencondY, entrRamp.x, entrRamp.y);
						//插入第二点
						entrAStatPath.push(new Point(entrRampsencondX, entrRampsencondY));
					}
					//astar：（起点- 第二点入口点） -> 干道（不包含1，2点）
					var sencondPath:Array=TAstar.find(null, startX, startY, entrRampsencondX, entrRampsencondY);
					//找不到路径 进不了主干道
					if (TAstar.isInvalidPath(entrAStatPath) && TAstar.isInvalidPath(sencondPath))
						return null;
					//如果第一路径不存在，则选择第二路径
					else if (TAstar.isInvalidPath(entrAStatPath))
						choosePath=sencondPath;
					//如果第二路径不存在，则选择第一路径
					else if (TAstar.isInvalidPath(sencondPath))
						choosePath=entrAStatPath;
					//如果路径都全部存在，则比距离
					else
						//对比两点的距离，取最短路径
						choosePath=firstDistance < sencondPath.length ? entrAStatPath : sencondPath;
					//开始连接在一起
					path=choosePath.concat(path);
				}
			}
			//////////////////////// 5.寻找最佳干道出口点 //////////////////////////////
			//////////////////////// 有可能会绕远了，所以有时候可以从干道节点倒数第二点开始查
			if (endX != exitRamp.x || endY != exitRamp.y)
			{
				//防一下好了，不然-2就出问题了
				if (path.length < 2)
					return null;
				//终点倒数第二点
				var exitRampsencondX:int=path[path.length - 2].x;
				var exitRampsencondY:int=path[path.length - 2].y;
				//干掉后面2个点
				path.splice(path.length - 2, 2);
				if (endX != exitRampsencondX || endY != exitRampsencondY)
				{
					//干道（不包含后面1，2点） -> 倒数第二点 - AStar（倒数第一点出口点-终点）
					exitAStatPath=TAstar.find(null, exitRamp.x, exitRamp.y, endX, endY);
					if (!TAstar.isInvalidPath(exitAStatPath))
					{
						//插入倒数第二点到路径最前面
						firstDistance=exitAStatPath.length + MathUtil.getDistance(exitRamp.x, exitRamp.y, exitRampsencondX, exitRampsencondY);
						exitAStatPath.splice(0, 0, new Point(exitRampsencondX, exitRampsencondY));
					}

					//干道（不包含后面1，2点） -> AStar（倒数第二点出口点-终点）
					sencondPath=TAstar.find(null, exitRampsencondX, exitRampsencondY, endX, endY);
					//找不到路径 进不了主干道
					if (TAstar.isInvalidPath(exitAStatPath) && TAstar.isInvalidPath(sencondPath))
						return null;
					//如果第一路径不存在，则选择第二路径
					else if (TAstar.isInvalidPath(exitAStatPath))
						choosePath=sencondPath;
					//如果第二路径不村则，则选择第一路径
					else if (TAstar.isInvalidPath(sencondPath))
						choosePath=exitAStatPath;
					//如果两条路都村则，则比谁的距离比较近
					else
						//对比两点的距离，取最短路径
						choosePath=firstDistance < sencondPath.length ? exitAStatPath : sencondPath;
					//开始连接在一起
					path=path.concat(choosePath);
				}
			}
			return path;
		}
	}
}
