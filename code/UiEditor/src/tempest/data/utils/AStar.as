package tempest.data.utils
{
	import tempest.data.map.Direction;

	/**
	 * A* 寻路算法
	 *
	 * @author    eidiot (http://eidiot.net)
	 * @version    1.0
	 * @date    070416
	 */
	public class AStar
	{
		//====================================
		//    Constants
		//====================================
		//横或竖向移动一格的路径评分
		private const COST_STRAIGHT:int=10;
		//斜向移动一格的路径评分
		private const COST_DIAGONAL:int=14;

		//(单个)节点数组 节点ID 索引
		private const NOTE_ID:int=0;
		//(单个)节点数组 是否在开启列表中 索引
		private const NOTE_OPEN:int=1;
		//(单个)节点数组 是否在关闭列表中 索引
		private const NOTE_CLOSED:int=2;
		//====================================
		//    Member Variables
		//====================================
		//地图模型
		private var m_mapTileModel:IMapElement;
		//最大寻路步数，限制超时返回
		private var m_maxTry:int;

		//开放列表，存放节点ID
		private var m_openList:Array;
		//开放列表长度
		private var m_openCount:int;
		//节点加入开放列表时分配的唯一ID(从0开始)
		//根据此ID(从下面的列表中)存取节点数据
		private var m_openId:int;

		//节点x坐标列表
		private var m_xList:Array;
		//节点y坐标列表
		private var m_yList:Array;
		//节点d坐标列表
		private var m_dList:Array;

		//节点路径评分列表
		private var m_pathScoreList:Array;
		//(从起点移动到)节点的移动耗费列表
		private var m_movementCostList:Array;
		//节点的父节点(ID)列表
		private var m_fatherList:Array;

		//节点(数组)地图,根据节点坐标记录节点开启关闭状态和ID
		private var m_noteMap:Array;

		//====================================
		//    Constructor
		//====================================
		/**
		 * Constructor
		 *
		 * @param p_mapTileModel    地图模型，实现 IMapTileModel 接口
		 * @param p_maxTry            最大寻路步数，限制超时返回
		 */
		public function AStar(p_mapTileModel:IMapElement, p_maxTry:int=300)
		{
			this.m_mapTileModel=p_mapTileModel;
			this.m_maxTry=p_maxTry;
		}

		//====================================
		//    Properties
		//====================================
		/**
		 * 最大寻路步数，限制超时返回
		 */
		public function get maxTry():int
		{
			return this.m_maxTry;
		}

		/**
		 * @private
		 */
		public function set maxTry(p_value:int):void
		{
			this.m_maxTry=p_value;
		}


		/**
		 * 是否为无效的路径
		 * @param path 路径数据
		 * @return
		 *
		 */
		public static function isInvalidPath(path:Vector.<Number>):Boolean
		{
			return !path || path.length < 4 || (path.length & 0x01) == 1;
		}


		//====================================
		//    Public Methods
		//====================================
		/**
		 * 开始寻路，返回关键点路径, 根据射线返回
		 *
		 * @param p_startX        起点X坐标
		 * @param p_startY        起点Y坐标
		 * @param p_endX        终点X坐标
		 * @param p_endY        终点Y坐标
		 *
		 * @return                 找到的路径(二维数组 : [p_startX, p_startY, direct], ... , [p_endX, p_endY, direct])
		 */
		public function find3(p_startX:int, p_startY:int, p_endX:int, p_endY:int):Vector.<Number>
		{
			var result:Array=find(p_startX, p_startY, p_endX, p_endY);
			if (!result || result.length < 2)
				return null;
			//路径
			var path:Vector.<Number>=new Vector.<Number>();
			path.push(p_startX, p_startY);

			//开始筛选出关键点
			var index:int=1;
			var fromX:int=p_startX;
			var fromY:int=p_startY;

			//允许最大的过期次数
			const maxTTL:uint=20000;
			//过期次数
			var ttl:int=0;

			while (true) /* loop */
			{
				if (ttl >= maxTTL)
				{
					throw new Error("AStar.find3，TTL超过最大次数：" + maxTTL.toString());
					return null;
				}
				ttl++;

				index++;
				if (index >= result.length)
					break;

				if (m_mapTileModel.canTransit(fromX, fromY, result[index][0], result[index][1]))
				{
					continue;
				}
				else
				{
					//插入到路径里
					var pt:Array=result[index - 1];
					fromX=pt[0];
					fromY=pt[1];
					path.push(pt[0], pt[1]);
				}
			}

			path.push(p_endX, p_endY);
			return path;
		}

		//====================================
		//    Public Methods
		//====================================
		/**
		 * 开始寻路，返回关键点路径
		 *
		 * @param p_startX        起点X坐标
		 * @param p_startY        起点Y坐标
		 * @param p_endX        终点X坐标
		 * @param p_endY        终点Y坐标
		 *
		 * @return                 找到的路径(二维数组 : [p_startX, p_startY, direct], ... , [p_endX, p_endY, direct])
		 */
		public function find2(p_startX:int, p_startY:int, p_endX:int, p_endY:int):Vector.<Number>
		{
			var result:Array=find(p_startX, p_startY, p_endX, p_endY);
			if (!result || result.length < 2)
				return null;

			//路径
			var path:Vector.<Number>=new Vector.<Number>();
			path.push(p_startX, p_startY);

			//开始筛选出关键点
			var index:int=1;
			var prevDirect:int=result[0][2];

			//允许最大的过期次数
			const maxTTL:uint=10000;
			//过期次数
			var ttl:int=0;

			while (true) /* loop */
			{
				if (ttl >= maxTTL)
				{
					throw new Error("MapData.getCanTransitPoint，TTL超过最大次数：" + maxTTL.toString());
					return null;
				}
				ttl++;

				if (index >= (result.length - 1))
					break;

				var curDirect:uint=result[index][2];
				if (curDirect == prevDirect)
				{
					var nxtIdx:uint=index + 1;
					if (nxtIdx < result.length && result[nxtIdx][2] == curDirect)
					{
						result.splice(index, 1);
						continue;
					}
				}
				//插入到路径里
				var pt:Array=result[index];
				path.push(pt[0], pt[1]);

				//设置状态
				prevDirect=curDirect;
				index++;
			}
			path.push(p_endX, p_endY);
			return path;
		}

		//====================================
		//    Public Methods
		//====================================
		/**
		 * 开始寻路
		 *
		 * @param p_startX        起点X坐标
		 * @param p_startY        起点Y坐标
		 * @param p_endX        终点X坐标
		 * @param p_endY        终点Y坐标
		 *
		 * @return                 找到的路径(二维数组 : [p_startX, p_startY, direct], ... , [p_endX, p_endY, direct])
		 */
		public function find(p_startX:int, p_startY:int, p_endX:int, p_endY:int):Array
		{
			//Log.outDebug("AStart.startPoint:"+p_startX+","+p_startY);
			if (!this.m_mapTileModel.isBlock( /*p_startX, p_startY,*/p_endX, p_endY))
			{
				//Log.outDebug("AStart.find寻路算法，目标点为路障[" + p_endX + "," + p_endY + "].");
			}
			this.initLists();
			this.m_openCount=0;
			this.m_openId=-1;

			this.openNote(p_startX, p_startY, 9, 0, 0, 0);

			var currTry:int=0;
			var currId:int;
			var currNoteX:int;
			var currNoteY:int;
			var aroundNotes:Array;

			var checkingId:int;

			var cost:int;
			var score:int;

			const maxTTL:uint=20000;
			var ttl:uint=0;


			while (this.m_openCount > 0)
			{
				ttl++;
				if (ttl > maxTTL)
					throw new Error("循环次数超过最大值：" + maxTTL);

				//超时返回
				if (++currTry > this.m_maxTry)
				{
					this.destroyLists();
					return null;
				}
				//每次取出开放列表最前面的ID
				currId=this.m_openList[0];
				//将编码为此ID的元素列入关闭列表
				this.closeNote(currId);
				currNoteX=this.m_xList[currId];
				currNoteY=this.m_yList[currId];

				//如果终点被放入关闭列表寻路结束，返回路径
				if (currNoteX == p_endX && currNoteY == p_endY)
				{
					return this.getPath(p_startX, p_startY, currId);
				}
				//获取周围节点，排除不可通过和已在关闭列表中的
				aroundNotes=this.getArounds(currNoteX, currNoteY);
				//对于周围的每一个节点
				for each (var note:Array in aroundNotes)
				{
					//计算F和G值
					cost=this.m_movementCostList[currId] + ((note[0] == currNoteX || note[1] == currNoteY) ? COST_STRAIGHT : COST_DIAGONAL);
					score=cost + (Math.abs(p_endX - note[0]) + Math.abs(p_endY - note[1])) * COST_STRAIGHT;
					//                    score = cost;
					if (this.isOpen(note[0], note[1])) //如果节点已在播放列表中
					{
						checkingId=this.m_noteMap[note[1]][note[0]][NOTE_ID];
						//如果新的G值比节点原来的G值小,修改F,G值，换父节点
						if (cost < this.m_movementCostList[checkingId])
						{
							this.m_movementCostList[checkingId]=cost;
							this.m_pathScoreList[checkingId]=score;
							this.m_fatherList[checkingId]=currId;
							//获取某ID节点在开放列表中的索引(去掉先前函数使用数组api查询可使效率提高1/4左右)
							this.aheadNote(m_openList.indexOf(checkingId));
						}
					}
					else //如果节点不在开放列表中
					{
						//将节点放入开放列表
						this.openNote(note[0], note[1], note[2], score, cost, currId);
					}
				}
			}
			//开放列表已空，找不到路径
			this.destroyLists();
			return null;
		}

		//====================================
		//    Private Methods
		//====================================
		/**
		 * @private
		 * 将节点加入开放列表
		 *
		 * @param p_x        节点在地图中的x坐标
		 * @param p_y        节点在地图中的y坐标
		 * @param P_score    节点的路径评分
		 * @param p_cost    起始点到节点的移动成本
		 * @param p_fatherId    父节点
		 */
		private function openNote(p_x:int, p_y:int, p_d:int, p_score:int, p_cost:int, p_fatherId:int):void
		{
			this.m_openCount++;
			this.m_openId++;

			if (this.m_noteMap[p_y] == null)
			{
				this.m_noteMap[p_y]=[];
			}
			this.m_noteMap[p_y][p_x]=[];
			this.m_noteMap[p_y][p_x][NOTE_OPEN]=true;
			this.m_noteMap[p_y][p_x][NOTE_ID]=this.m_openId;

			this.m_xList[this.m_xList.length]=p_x;
			this.m_yList[this.m_yList.length]=p_y;
			this.m_dList[this.m_dList.length]=p_d;
			this.m_pathScoreList[this.m_pathScoreList.length]=p_score;
			this.m_movementCostList[this.m_movementCostList.length]=p_cost;
			this.m_fatherList[this.m_fatherList.length]=p_fatherId;
			this.m_openList[this.m_openList.length]=this.m_openId;

			this.aheadNote(this.m_openCount);
		}

		/**
		 * @private
		 * 将节点加入关闭列表
		 */
		private function closeNote(p_id:int):void
		{
			this.m_openCount--;
			var noteX:int=this.m_xList[p_id];
			var noteY:int=this.m_yList[p_id];
			this.m_noteMap[noteY][noteX][NOTE_OPEN]=false;
			this.m_noteMap[noteY][noteX][NOTE_CLOSED]=true;

			if (this.m_openCount <= 0)
			{
				this.m_openCount=0;
				this.m_openList=[];
				return;
			}
			this.m_openList[0]=this.m_openList.pop();
			this.backNote();
		}

		/**
		 * @private
		 * 将(新加入开放别表或修改了路径评分的)节点向前移动
		 */
		private function aheadNote(p_index:int):void
		{
			var father:int;
			var change:int;
			while (p_index > 1)
			{
				//父节点的位置
				father=Math.floor(p_index / 2);
				//如果该节点的F值小于父节点的F值则和父节点交换
				if (this.getScore(p_index) <= this.getScore(father))
				{
					change=this.m_openList[p_index - 1];
					this.m_openList[p_index - 1]=this.m_openList[father - 1];
					this.m_openList[father - 1]=change;
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
		private function backNote():void
		{
			//尾部的节点被移到最前面
			var checkIndex:int=1;
			var tmp:int;
			var change:int;

			const maxTitl:uint=5000;
			var curTitl:uint=0;

			while (true)
			{
				curTitl++;
				if (curTitl > maxTitl)
				{
					throw new Error("AStar.backNote异常，超过了循环最大限制。");
					return;
				}

				tmp=checkIndex;
				//如果有子节点
				if (2 * tmp <= this.m_openCount)
				{
					//如果子节点的F值更小
					if (this.getScore(checkIndex) > this.getScore(2 * tmp))
					{
						//记节点的新位置为子节点位置
						checkIndex=2 * tmp;
					}
					//如果有两个子节点
					if (2 * tmp + 1 <= this.m_openCount)
					{
						//如果第二个子节点F值更小
						if (this.getScore(checkIndex) > this.getScore(2 * tmp + 1))
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
					change=this.m_openList[tmp - 1];
					this.m_openList[tmp - 1]=this.m_openList[checkIndex - 1];
					this.m_openList[checkIndex - 1]=change;
				}
			}
		}

		/**
		 * @private
		 * 判断某节点是否在开放列表
		 */
		private function isOpen(p_x:int, p_y:int):Boolean
		{
			if (this.m_noteMap[p_y] == null)
				return false;
			if (this.m_noteMap[p_y][p_x] == null)
				return false;
			return this.m_noteMap[p_y][p_x][NOTE_OPEN];
		}

		/**
		 * @private
		 * 判断某节点是否在关闭列表中
		 */
		private function isClosed(p_x:int, p_y:int):Boolean
		{
			if (this.m_noteMap[p_y] == null)
				return false;
			if (this.m_noteMap[p_y][p_x] == null)
				return false;
			return this.m_noteMap[p_y][p_x][NOTE_CLOSED];
		}

		/**
		 * @private
		 * 获取某节点的周围节点，排除不能通过和已在关闭列表中的
		 */
		private function getArounds(p_x:int, p_y:int):Array
		{
			var arr:Array=[];
			var checkX:int;
			var checkY:int;
			var canDiagonal:Boolean;

			//右
			checkX=p_x + 1;
			checkY=p_y;
			var canRight:Boolean=this.m_mapTileModel.isBlock( /*p_x, p_y,*/checkX, checkY);
			if (canRight && !this.isClosed(checkX, checkY))
			{
				arr.push([checkX, checkY, Direction.EAST]);
			}
			//下
			checkX=p_x;
			checkY=p_y + 1;
			var canDown:Boolean=this.m_mapTileModel.isBlock(/*p_x, p_y,*/ checkX, checkY);
			if (canDown && !this.isClosed(checkX, checkY))
			{
				arr.push([checkX, checkY, Direction.SOUTH]);
			}

			//左
			checkX=p_x - 1;
			checkY=p_y;
			var canLeft:Boolean=this.m_mapTileModel.isBlock(/*p_x, p_y,*/ checkX, checkY);
			if (canLeft && !this.isClosed(checkX, checkY))
			{
				arr.push([checkX, checkY, Direction.WEST]);
			}
			//上
			checkX=p_x;
			checkY=p_y - 1;
			var canUp:Boolean=this.m_mapTileModel.isBlock(/*p_x, p_y,*/ checkX, checkY);
			if (canUp && !this.isClosed(checkX, checkY))
			{
				arr.push([checkX, checkY, Direction.NORTH]);
			}
			//右下
			checkX=p_x + 1;
			checkY=p_y + 1;
			canDiagonal=this.m_mapTileModel.isBlock(/*p_x, p_y,*/ checkX, checkY);
			if (canDiagonal && !this.isClosed(checkX, checkY))
			{
				arr.push([checkX, checkY, Direction.SOUTH_EAST]);
			}
			//左下
			checkX=p_x - 1;
			checkY=p_y + 1;
			canDiagonal=this.m_mapTileModel.isBlock(/*p_x, p_y,*/ checkX, checkY);
			if (canDiagonal && !this.isClosed(checkX, checkY))
			{
				arr.push([checkX, checkY, Direction.SOUTH_WEST]);
			}
			//左上
			checkX=p_x - 1;
			checkY=p_y - 1;
			canDiagonal=this.m_mapTileModel.isBlock(/*p_x, p_y, */checkX, checkY);
			if (canDiagonal && !this.isClosed(checkX, checkY))
			{
				arr.push([checkX, checkY, Direction.NORTH_WEST]);
			}
			//右上
			checkX=p_x + 1;
			checkY=p_y - 1;
			canDiagonal=this.m_mapTileModel.isBlock(/*p_x, p_y, */checkX, checkY);
			if (canDiagonal && !this.isClosed(checkX, checkY))
			{
				arr.push([checkX, checkY, Direction.NOTRH_EAST]);
			}

			return arr;
		}

		/**
		 * @private
		 * 获取路径
		 *
		 * @param p_startX    起始点X坐标
		 * @param p_startY    起始点Y坐标
		 * @param p_id        终点的ID
		 *
		 * @return             路径坐标(Point)数组
		 */
		private function getPath(p_startX:int, p_startY:int, p_id:int):Array
		{
			var arr:Array=[];
			var noteX:int=this.m_xList[p_id];
			var noteY:int=this.m_yList[p_id];
			var prve_p_id:int=p_id;


			//允许最大的过期次数
			const maxTTL:uint=20000;
			//过期次数
			var ttl:int=0;

			while (noteX != p_startX || noteY != p_startY)
			{
				ttl++;
				if (ttl >= maxTTL)
				{
					throw new Error("AStar.find3，TTL超过最大次数：" + maxTTL.toString());
					return null;
				}

				arr.unshift([noteX, noteY, this.m_dList[prve_p_id]]);
				prve_p_id=p_id;
				p_id=this.m_fatherList[p_id];
				noteX=this.m_xList[p_id];
				noteY=this.m_yList[p_id];
			}
			arr.unshift([p_startX, p_startY, this.m_dList[prve_p_id]]);
			this.destroyLists();
			return arr;
		}

		/**
		 * @private
		 * 获取某节点的路径评分
		 *
		 * @param p_index    节点在开启列表中的索引(从1开始)
		 */
		private function getScore(p_index:int):int
		{
			return this.m_pathScoreList[this.m_openList[p_index - 1]];
		}

		/**
		 * @private
		 * 初始化数组
		 */
		private function initLists():void
		{
			this.m_openList=[];
			this.m_xList=[];
			this.m_yList=[];
			this.m_dList=[];
			this.m_pathScoreList=[];
			this.m_movementCostList=[];
			this.m_fatherList=[];
			this.m_noteMap=[];
		}

		/**
		 * @private
		 * 销毁数组
		 */
		private function destroyLists():void
		{
			this.m_openList=null;
			this.m_xList=null;
			this.m_yList=null;
			this.m_dList=null;
			this.m_pathScoreList=null;
			this.m_movementCostList=null;
			this.m_fatherList=null;
			this.m_noteMap=null;
		}
	}
}
