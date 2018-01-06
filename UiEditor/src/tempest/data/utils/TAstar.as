package tempest.data.utils
{
	import flash.geom.Point;

	/**
	 * A星寻路算法
	 * 只能用于2维网格寻路，数据源只需要实现getArounds方法
	 */
	public class TAstar
	{
		//
		//横或竖向移动一格的路径评分
		static private const COST_STRAIGHT:int=10;
		//斜向移动一格的路径评分
		static private const COST_DIAGONAL:int=14;
		//(单个)节点数组 节点ID 索引
		static private const NOTE_ID:int=0;
		//(单个)节点数组 是否在开启列表中 索引
		static private const NOTE_OPEN:int=1;
		//(单个)节点数组 是否在关闭列表中 索引
		static private const NOTE_CLOSED:int=2;
		//====================================
		//	Member Variables
		//====================================
		//地图模型
		static private var m_mapTileModel:IMapModel;
		//最大寻路步数，限制超时返回
		static public var maxTry:int=10000;
		//开放列表，存放节点ID
		static private var m_openList:Array;
		//开放列表长度
		static private var m_openCount:int;
		//节点加入开放列表时分配的唯一ID(从0开始)
		//根据此ID(从下面的列表中)存取节点数据
		static private var m_openId:int;
		//节点x坐标列表
		static private var m_xList:Array;
		//节点y坐标列表
		static private var m_yList:Array;
		//节点路径评分列表
		static private var m_pathScoreList:Array;
		//(从起点移动到)节点的移动耗费列表
		static private var m_movementCostList:Array;
		//节点的父节点(ID)列表
		static private var m_fatherList:Array;
		//节点(数组)地图,根据节点坐标记录节点开启关闭状态和ID
		static private var m_noteMap:Array;
		//上一次循环时的开放id
		static private var m_aroundCanNotAllGoList:Array;
		////////////
		private static var _diagCost:Number=Math.SQRT2;
		private static var _straightCost:Number=1.0;
		private static var _end_x:int;
		private static var _end_y:int;
		/**
		 *是否障碍寻路
		 */
		public static var isFoundBlock:Boolean=false;

		/***地图数据**/
		public static var mapModel:IMapModel;

		//====================================
		//	Public Methods
		//====================================
		/**
		 * 开始寻路
		 * @param start
		 * @param end
		 * @return
		 */
		static public function find_p(imapModel:IMapModel, start:Point, end:Point):Array
		{
			return find(imapModel, start.x, start.y, end.x, end.y);
		}

		/**
		 * 开始寻路
		 */
		static public function find(imapModel:IMapModel, start_x:int, start_y:int, end_x:int, end_y:int):Array
		{
			mapModel=imapModel || TAstar.mapModel;
			initLists();
			m_openCount=0;
			m_openId=-1;
			_end_x=end_x;
			_end_y=end_y;
			var currTry:int=0;
			var currId:int;
			var currNoteX:int;
			var currNoteY:int;
			var aroundNotes:Array;
			var checkingId:int;
			var cost:int;
			var score:int;
			cost=((start_x == currNoteX || start_y == currNoteY) ? COST_STRAIGHT : COST_DIAGONAL);
			score=cost + (Math.abs(end_x - start_x) + Math.abs(end_y - start_y)) * COST_STRAIGHT;
			openNote(start_x, start_y, 0, 0, 0);
			while (m_openCount > 0)
			{
				//超时返回
				if (++currTry > maxTry)
				{
					if (isFoundBlock)
					{
						var tempId:int=getMiniDistance(start_x, start_y);
						return getPath(start_x, start_y, tempId);
					}
					else
					{
						destroyLists();
						return null;
					}
				}
				//每次取出开放列表最前面的ID
				currId=m_openList[0];
				//将编码为此ID的元素列入关闭列表
				closeNote(currId);
				currNoteX=m_xList[currId];
				currNoteY=m_yList[currId];
				//如果终点被放入关闭列表寻路结束，返回路径
				if (currNoteX == end_x && currNoteY == end_y)
				{
					return getPath(start_x, start_y, currId);
				}
				//获取周围节点，排除不可通过和已在关闭列表中的
				aroundNotes=mapModel.getArounds(currNoteX, currNoteY);
				if (aroundNotes.length < 7 && currId != 0)
				{
					m_aroundCanNotAllGoList.push(currId);
				}
				//对于周围的每一个节点
				for each (var note:Point in aroundNotes)
				{
					if (isClosed(note.x, note.y))
						continue;
					//计算F和G值
					cost=m_movementCostList[currId] + ((note.x == currNoteX || note.y == currNoteY) ? COST_STRAIGHT : COST_DIAGONAL);
					score=cost + (Math.abs(end_x - note.x) + Math.abs(end_y - note.y)) * COST_STRAIGHT;
					if (isOpen(note.x, note.y)) //如果节点已在播放列表中
					{
						checkingId=m_noteMap[note.y][note.x][NOTE_ID];
						//如果新的G值比节点原来的G值小,修改F,G值，换父节点
						if (cost < m_movementCostList[checkingId])
						{
							m_movementCostList[checkingId]=cost;
							m_pathScoreList[checkingId]=score;
							m_fatherList[checkingId]=currId;
							aheadNote(getIndex(checkingId));
						}
					}
					else //如果节点不在开放列表中
					{
						//将节点放入开放列表
						openNote(note.x, note.y, score, cost, currId);
					}
				}
			}
			if (isFoundBlock)
			{
				var tempId2:int=getMiniDistance(start_x, start_y);
				return getPath(start_x, start_y, tempId2);
			}
			else
			{
				destroyLists();
				return null;
			}
		}

		/**
		 * 获取最小的距离
		 * @param start_x
		 * @param start_y
		 * @return
		 *
		 */
		private static function getMiniDistance(start_x:int, start_y:int):int
		{
			var tempId:int=m_aroundCanNotAllGoList[0];
			var miniDistance:int=diagonal(m_xList[tempId], m_yList[tempId]);
			for each (var i:int in m_aroundCanNotAllGoList)
			{
				var tempDistance:int=diagonal(m_xList[i], m_yList[i]);
				if (tempDistance < miniDistance)
				{
					miniDistance=tempDistance;
					tempId=i;
				}
			}
			return tempId;
		}

		private static function diagonal(start_x:int, start_y:int):Number
		{
			var dx:int=_end_x - start_x > 0 ? _end_x - start_x : start_x - _end_x;
			var dy:int=_end_y - start_y > 0 ? _end_y - start_y : start_y - _end_y;
			var diag:Number=dx < dy ? dx : dy;
			var straight:Number=dx + dy;
//			return straight;
			if (dx <= 0)
				return dy;
			if (dy <= 0)
				return dx;
			//diag拐点
			return _diagCost * diag + _straightCost * (straight - 2 * diag);
		}

		//====================================
		//	Private Methods
		//====================================
		/**
		 * @private
		 * 将节点加入开放列表
		 *
		 * @param p_x		节点在地图中的x坐标
		 * @param p_y		节点在地图中的y坐标
		 * @param P_score	节点的路径评分
		 * @param p_cost	起始点到节点的移动成本
		 * @param p_fatherId	父节点
		 */
		static private function openNote(p_x:int, p_y:int, p_score:int, p_cost:int, p_fatherId:int):void
		{
			m_openCount++;
			m_openId++;
			if (m_noteMap[p_y] == null)
			{
				m_noteMap[p_y]=[];
			}
			m_noteMap[p_y][p_x]=[];
			m_noteMap[p_y][p_x][NOTE_OPEN]=true;
			m_noteMap[p_y][p_x][NOTE_ID]=m_openId;
			m_xList.push(p_x);
			m_yList.push(p_y);
			m_pathScoreList.push(p_score);
			m_movementCostList.push(p_cost);
			m_fatherList.push(p_fatherId);
			m_openList.push(m_openId);
			aheadNote(m_openCount);
		}

		/**
		 * @private
		 * 将节点加入关闭列表
		 */
		static private function closeNote(p_id:int):void
		{
			m_openCount--;
			var noteX:int=m_xList[p_id];
			var noteY:int=m_yList[p_id];
			m_noteMap[noteY][noteX][NOTE_OPEN]=false;
			m_noteMap[noteY][noteX][NOTE_CLOSED]=true;
			if (m_openCount <= 0)
			{
				m_openCount=0;
				m_openList=[];
				return;
			}
			m_openList[0]=m_openList.pop();
			backNote();
		}

		/**
		 * @private
		 * 将(新加入开放别表或修改了路径评分的)节点向前移动
		 */
		static private function aheadNote(p_index:int):void
		{
			var father:int;
			var change:int;
			while (p_index > 1)
			{
				//父节点的位置
				father=Math.floor(p_index / 2);
				//如果该节点的F值小于父节点的F值则和父节点交换
				if (getScore(p_index) < getScore(father))
				{
					change=m_openList[p_index - 1];
					m_openList[p_index - 1]=m_openList[father - 1];
					m_openList[father - 1]=change;
					p_index=father;
				}
				else
				{
					break;
				}
			}
		}

		/**
		 * @private
		 * 将(取出开启列表中路径评分最低的节点后从队尾移到最前的)节点向后移动
		 */
		static private function backNote():void
		{
			//尾部的节点被移到最前面
			var checkIndex:int=1;
			var tmp:int;
			var change:int;
			while (true)
			{
				tmp=checkIndex;
				//如果有子节点
				if (2 * tmp <= m_openCount)
				{
					//如果子节点的F值更小
					if (getScore(checkIndex) > getScore(2 * tmp))
					{
						//记节点的新位置为子节点位置
						checkIndex=2 * tmp;
					}
					//如果有两个子节点
					if (2 * tmp + 1 <= m_openCount)
					{
						//如果第二个子节点F值更小
						if (getScore(checkIndex) > getScore(2 * tmp + 1))
						{
							//更新节点新位置为第二个子节点位置
							checkIndex=2 * tmp + 1;
						}
					}
				}
				//如果节点位置没有更新结束排序
				if (tmp == checkIndex)
				{
					break;
				}
				//反之和新位置交换，继续和新位置的子节点比较F值
				else
				{
					change=m_openList[tmp - 1];
					m_openList[tmp - 1]=m_openList[checkIndex - 1];
					m_openList[checkIndex - 1]=change;
				}
			}
		}

		/**
		 * @private
		 * 判断某节点是否在开放列表
		 */
		static private function isOpen(p_x:int, p_y:int):Boolean
		{
			if (m_noteMap[p_y] == null)
				return false;
			if (m_noteMap[p_y][p_x] == null)
				return false;
			return m_noteMap[p_y][p_x][NOTE_OPEN];
		}

		/**
		 * @private
		 * 判断某节点是否在关闭列表中
		 */
		static private function isClosed(p_x:int, p_y:int):Boolean
		{
			if (m_noteMap[p_y] == null)
				return false;
			if (m_noteMap[p_y][p_x] == null)
				return false;
			return m_noteMap[p_y][p_x][NOTE_CLOSED];
		}

		/**
		 * @private
		 * 获取路径
		 *
		 * @param p_startX	起始点X坐标
		 * @param p_startY	起始点Y坐标
		 * @param p_id		终点的ID
		 *
		 * @return 			路径坐标(Point)数组
		 */
		static private function getPath(p_startX:int, p_startY:int, p_id:int):Array
		{
			var arr:Array=[];
			var noteX:int=m_xList[p_id];
			var noteY:int=m_yList[p_id];
			while (noteX != p_startX || noteY != p_startY)
			{
				arr.unshift(new Point(noteX, noteY));
				p_id=m_fatherList[p_id];
				noteX=m_xList[p_id];
				noteY=m_yList[p_id];
			}
			arr.unshift(new Point(p_startX, p_startY));
			destroyLists();
			return arr;
		}

		/**
		 * @private
		 * 获取某ID节点在开放列表中的索引(从1开始)
		 */
		static private function getIndex(p_id:int):int
		{
			var i:int=1;
			for each (var id:int in m_openList)
			{
				if (id == p_id)
				{
					return i;
				}
				i++;
			}
			return -1;
		}

		/**
		 * @private
		 * 获取某节点的路径评分
		 *
		 * @param p_index	节点在开启列表中的索引(从1开始)
		 */
		static private function getScore(p_index:int):int
		{
			return m_pathScoreList[m_openList[p_index - 1]];
		}

		/**
		 * @private
		 * 初始化数组
		 */
		static private function initLists():void
		{
			m_openList=[];
			m_xList=[];
			m_yList=[];
			m_pathScoreList=[];
			m_movementCostList=[];
			m_fatherList=[];
			m_noteMap=[];
			m_aroundCanNotAllGoList=[];
		}

		/**
		 * @private
		 * 销毁数组
		 */
		static private function destroyLists():void
		{
			m_openList=null;
			m_xList=null;
			m_yList=null;
			m_pathScoreList=null;
			m_movementCostList=null;
			m_fatherList=null;
			m_noteMap=null;
			m_aroundCanNotAllGoList=null;
		}

		/**是否为无效路径**/
		public static function isInvalidPath(path:Array):Boolean
		{
			return !path || path.length < 2;
		}
	}
}


