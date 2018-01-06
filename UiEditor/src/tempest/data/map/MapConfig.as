package tempest.data.map
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import tempest.data.map.MapFarData;
	import tempest.data.map.MapWater;
	import tempest.data.map.TrunkPath;
	import tempest.data.map.TrunkPoint;
	import tempest.data.obj.UpdateMask;
	import tempest.data.utils.IMapElement;
	import tempest.data.utils.IMapModel;
	import tempest.utils.Geom;

	/**
	 * 地图配置
	 * @author zhangyong
	 *
	 */
	public class MapConfig implements IMapModel, IMapElement
	{
		public var diagonal:Boolean=true; //是否启用斜向移动
		public static const WALK:int=0; //路点
		public static const MASK:int=1; //阴影
		public static const BLOCK:int=2; //障碍
		public static const SAFE_AREA:int=3; //安全区
		public static const EXP_AREA_1:int=5; //经验区1
		public static const EXP_AREA_2:int=6; //经验区2
		/**场景id*/
		public var id:int;
		/**场景名称*/
		public var name:String;
		/**日期*/
		public var dateStr:String="";
		/**背景音乐*/
		public var bgMusicPath:String;
		/**小地图缩放比*/
		public var thumbScale:Number=1;
		/**小地图加载地址*/
		public var smallMapPath:String;
		/**地图宽度*/
		public var pxWidth:Number=0;
		/**地图高度*/
		public var pxHeight:Number=0;
		/**行*/
		public var row:int=0;
		/**列*/
		public var column:int=0;
		/**切片宽度*/
		public var sliceWidth:int;
		/**切片高度*/
		public var sliceHeight:int;
		/**网格宽*/
		public var tileWidth:int=48;
		/**网格高*/
		public var tileHeight:int=24;
		/**地图类型*/
		public var mapType:int=0;
		/**是否副本*/
		public var isCopyMap:Boolean;
		/**是否有地效*/
		public var useEarth:int=0;
		public var obstacleMask:UpdateMask;
		public var halfTranMask:UpdateMask;
		public var safeAreaMask:UpdateMask;
		public var expAreaMask1:UpdateMask;
		public var expAreaMask2:UpdateMask;
		/**跳跃点*/
		public var jumpMask:Dictionary;
		//////
		/**水层改变*/
		public var watersIsChange:Boolean;
		/**水层*/
		public var waters:Vector.<MapWater>;
		/**远景层*/
		public var farLayers:Vector.<MapFarData>;
		/**主干道***/
		public var trunkPoints:Vector.<TrunkPoint>;
		private var _trunkPDic:Dictionary;
		protected var _trukPath:TrunkPath;
		protected var _singSeparate:String=",";

		public function MapConfig()
		{
			_trukPath=new TrunkPath();
			farLayers=new Vector.<MapFarData>();
			waters=new Vector.<MapWater>();
			obstacleMask=new UpdateMask();
			halfTranMask=new UpdateMask();
			safeAreaMask=new UpdateMask();
			expAreaMask1=new UpdateMask();
			expAreaMask2=new UpdateMask();
			jumpMask=new Dictionary();
		}

		public function get trukPath():TrunkPath
		{
			return _trukPath;
		}

		/**
		//* 解析文本格式地图
		//* 地图格式如下：
		//第一行，基本信息。内容依次为
		//地图ID 				类型uint32
		//地图名称				类型char
		//地图创建时间			类型char
		//像素宽 				类型uint32
		//像素高				类型uint32
		//瓷砖宽				类型uint32
		//瓷砖高				类型uint32
		//逻辑宽				类型uint16
		//逻辑高				类型uint16
		//是否副本地图 			类型uint32
		//父级地图ID			类型uint32
		//场景音乐				类型char[255]
		//影子方向 			类型uint32
		//副本人数 			类型uint32
		//日限制				类型uint32
		//周限制				类型uint32
		//副本类型				类型uint16
		//*小地图缩放比例     thumbScale 类型number
		//第二行，障碍点信息，格式如下
		//将二维坐标转成一维坐标，转换公式为 X+地图宽度*y.然后用一串的32位来代表是否障碍点。如第一个32位的第七位设置为1，代表坐标（7,0）是障碍点。
		//附判断是否障碍点的公式：return ( ( (uint8 *)m_obstacleMask)[ index >> 3 ] & ( 1 << ( index & 0x7 ) )) != 0;
		//m_obstacleMask = 装这一行障碍点信息的数组
		//* @param data
		//*
		//*/
		public function anlyData(data:String,$flagMain:Boolean=true):Array
		{
			var configText:Array=data.split("\n");
			var first:Array=configText[0].split(_singSeparate);
			//第一行 基本配置
			id=parseInt(first[0]), name=first[1], dateStr=first[2], pxWidth=first[3], pxHeight=first[4];
			sliceWidth=int(first[5]) || 512;
			sliceHeight=int(first[6]) || 512;
			column=first[7];
			row=first[8];
			tileWidth=int(first[14]) || 48;
			tileHeight=int(first[15]) || 24;
			isCopyMap=first[9], first[10], bgMusicPath=first[11], first[12], first[13], mapType=first[16], thumbScale=first[17];
			//第二行  路点
			var obstacleInfo:Array=configText[1].split(_singSeparate);
			var len:uint=obstacleInfo.length;
			var i:uint;
			for (i=0; i < len; i++)
			{
				obstacleMask.baseByteArray.writeUnsignedInt(obstacleInfo[i]);
			}
			//第三行  路点
			if (configText.length > 2)
			{
				obstacleInfo=configText[2].split(_singSeparate);
				len=obstacleInfo.length;
				for (i=0; i < len; i++) //直接设置是否透明
				{
					halfTranMask.baseByteArray.writeUnsignedInt(obstacleInfo[i]);
				}
			}

			this.makeAstarItem()
			if($flagMain){
				configText[5]=this.getSSSSSSS()
			}else{
				configText[5]=""
			}
	
			
			return configText
		}
		
		public var astarItem:Array
		private function  makeAstarItem(): void {
			this.astarItem = new Array()
			for (var j: Number = 0; j < this.row; j++) {
				var $arr: Array = new Array
				for (var i: Number = 0; i < this.column; i++) {
					$arr.push(this.isBlock(i, j) ? 0 : 1);
				}
				this.astarItem.push($arr);
			}
			//trace(this.astarItem)
	
		}
		
		private function getSSSSSSS(): String {
			
			var $str: String = "";
			var $strbbbb: String = "";
			var $cccc: String = "";
			
			for (var i: Number = 0; i < this.astarItem.length; i++) {
				for (var j: Number = 0; j < this.astarItem[i].length; j++) {
					//  consoleNumberlog(this.astarItem[i][i]);
					
					if (this.astarItem[i][j] == 1) {
						var kkkkk: Vector.<Point> = this.getFindNextTo(i, j)
						$str += String(kkkkk.length)
						$strbbbb += "1"
						if (kkkkk.length > 0) {
							$cccc += String(j) + "," + String(i) + "," + String(kkkkk.length) + "," + this.getDataByItem(kkkkk) + ",";
						}
					} else {
						$str += "0";
						$strbbbb += "0"
						
					}
					$str += ","
					$strbbbb += ","
					
				}
				$str += "\n"
				$strbbbb += "\n"
			}
		//	trace("-------------------");
			$cccc = $cccc.substr(0, $cccc.length - 1)
		//	trace($cccc);
			return $cccc
		}
		private function getFindNextTo($tx: Number, $ty: Number): Vector.<Point> {
			var $backArr: Vector.<Point> = new Vector.<Point>;
			var $h: Number = this.row;  //24
			var $w: Number = this.column;//27 
			
			
			var $item: Vector.<Point> = new Vector.<Point>;
			//    $item.push(new Vector2D($tx - 1, $ty - 1));
			$item.push(new Point($tx, $ty - 1));
			//    $item.push(new Vector2D($tx + 1, $ty - 1));
			
			$item.push(new Point($tx - 1, $ty));
			$item.push(new Point($tx + 1, $ty));
			
			// $item.push(new Vector2D($tx - 1, $ty + 1));
			$item.push(new Point($tx, $ty + 1));
			//   $item.push(new Vector2D($tx + 1, $ty + 1));
			
			var $num: Number = 0
			for (var i: Number = 0; i < $item.length; i++) {
				var pos: Point = $item[i];
				if (pos.x >= 0 && pos.x < this.astarItem.length && pos.y >= 0 && pos.y < this.astarItem[i].length) {
					//  console.log(pos, this.astarItem[pos.x][pos.y])
					if (this.astarItem[pos.x][pos.y] == 1) {
						$num++
							$backArr.push(new Point(pos.x, pos.y))
						
						
					}
				}
			}
			
			
			
			return $backArr
		}

		private function getDataByItem($arr:Vector.<Point>): String {
			var $str: String = ""
			for (var i: Number = 0; i < $arr.length; i++) {
				$str += String($arr[i].y) + "," + String($arr[i].x) + ",";
			}
			$str = $str.substr(0, $str.length - 1)
			//   $str = "[" + $str + "]";
			return $str
		}

		/**
		 * 获取服务器掩码
		 * @param arr
		 * @param column
		 * @param row
		 * @return
		 *
		 */
		public static function getServerRoad(arr:Array, column:int, row:int):Array
		{
			var tempString:Array=[];
			var value32:uint;
			var _current:int=0;
			var value:int;
			var temp:Array=arr.concat();
			for (var y:int=0; y < row; y++)
			{
				for (var x:int=0; x < column; x++)
				{
					var index:int=y * column + x;
					if (temp[index] && parseInt(temp[index]) == 2)
					{
						value=1
					}
					else
					{
						value=0;
					}
					/////每32位组成一个字符串
					if (value > 0)
					{
						value32+=(1 << _current);
					}
					_current++;
					if (_current > 31)
					{
						tempString.push(value32.toString());
						_current=0;
						value32=0;
					}
				}
			}
			if (_current > 0) //说明最后还有余位 【最后的余位放到高位】
			{
				tempString.push(value32.toString());
			}
			return tempString;
		}

		public function getArounds(x:int, y:int):Array
		{
			var result:Array=[];
			var _x:int;
			var _y:int;
			var canDiagonal:Boolean;
			//右
			_x=x + 1;
			_y=y;
			var canRight:Boolean=!isBlock(_x, _y);
			if (canRight)
				result.push(new Point(_x, _y));
			//下
			_x=x;
			_y=y + 1;
			var canDown:Boolean=!isBlock(_x, _y);
			if (canDown)
				result.push(new Point(_x, _y));
			//左
			_x=x - 1;
			_y=y;
			var canLeft:Boolean=!isBlock(_x, _y);
			if (canLeft)
				result.push(new Point(_x, _y));
			//上
			_x=x;
			_y=y - 1;
			var canUp:Boolean=!isBlock(_x, _y);
			if (canUp)
				result.push(new Point(_x, _y));
			if (diagonal)
			{
				//右下
				_x=x + 1;
				_y=y + 1;
				canDiagonal=!isBlock(_x, _y);
				if (canDiagonal && canRight && canDown)
					result.push(new Point(_x, _y));
				//左下
				_x=x - 1;
				_y=y + 1;
				canDiagonal=!isBlock(_x, _y);
				if (canDiagonal && canLeft && canDown)
					result.push(new Point(_x, _y));
				//左上
				_x=x - 1;
				_y=y - 1;
				canDiagonal=!isBlock(_x, _y);
				if (canDiagonal && canLeft && canUp)
					result.push(new Point(_x, _y));
				//右上
				_x=x + 1;
				_y=y - 1;
				canDiagonal=!isBlock(_x, _y);
				if (canDiagonal && canRight && canUp)
					result.push(new Point(_x, _y));
			}
			return result;
		}

		/**
		 * 添加跳跃点
		 * @param jumpPoint
		 *
		 */
		public function addJumpPoit(jumpPoint:JumpPoint):void
		{
			if (!jumpPoint)
			{
				return;
			}
			jumpMask[jumpPoint.position.x + "_" + jumpPoint.position.y]=jumpPoint;
		}

		/**
		 * 是否遮挡
		 * @param x
		 * @param y
		 * @return
		 */
		public function isMask(x:int, y:int):Boolean
		{
			if (x < 0 || x >= column || y < 0 || y >= row)
				return false;
			return halfTranMask.GetBit(column * y + x);
		}

		/**
		 * 是否为安全区
		 * @param x
		 * @param y
		 * @return
		 *
		 */
		public function isSafeArea(x:int, y:int):Boolean
		{
			if (x < 0 || x >= column || y < 0 || y >= row)
				return false;
			return safeAreaMask.GetBit(column * y + x);
		}

		/**
		 *是否为经验区
		 * @param x
		 * @param y
		 * @return
		 *
		 */
		public function isExpArea1(x:int, y:int):Boolean
		{
			if (x < 0 || x >= column || y < 0 || y >= row)
				return false;
			return expAreaMask1.GetBit(column * y + x);
		}

		/**
		 *是否为水
		 * @param x
		 * @param y
		 * @return
		 *
		 */
		public function isExpArea2(x:int, y:int):Boolean
		{
			if (x < 0 || x >= column || y < 0 || y >= row)
				return false;
			return expAreaMask2.GetBit(column * y + x);
		}

		/**
		 * 是否是墙壁
		 * @param v	目标点
		 * @param cur	当前点
		 * @return
		 *
		 */
		public function isBlock(x:int, y:int):Boolean
		{
			if (x < 0 || x >= column || y < 0 || y >= row)
				return true;
			return obstacleMask.GetBit(column * y + x);
		}

		/**
		 * 获取跳跃点
		 * @param x 坐标x
		 * @param y 坐标y
		 * @return  跳跃点对象
		 *
		 */
		public function isJump(x:int, y:int):JumpPoint
		{
			return jumpMask[x + "_" + y] as JumpPoint;
		}

		/**
		 * 路径是否可以通过
		 * @param path 路径
		 * @return
		 *
		 */
		public function canTransits(path:Vector.<Number>):Boolean
		{
			//当前点的x，y
			var prevPointX:int=path[0];
			var prevPointY:int=path[1];
			//路径长度
			var len:uint=path.length / 2;
			//循环校验
			for (var i:uint=1; i < len; i++)
			{
				var idx:uint=i * 2;
				if (!canTransit(prevPointX, prevPointY, path[idx], path[idx + 1]))
				{
					return false;
				}
				prevPointX=path[idx];
				prevPointY=path[idx + 1];
			}
			return true;
		}

		/**
		 * 两点之间是否穿过指定点
		 * @param points 待检测的点数组
		 * @param startP 起始点
		 * @param endP 目标点
		 * @return
		 *
		 */
		public function hasTroughPoints(points:Array, startP:Point, endP:Point):Boolean
		{
			//过期次数
			var tempP:Point=startP.clone();
			var ttl:int=0;
			var dx:int=Math.abs(endP.x - startP.x);
			var dy:int=-Math.abs(endP.y - startP.y);
			var sx:int=startP.x < endP.x ? 1 : -1;
			var sy:int=startP.y < endP.y ? 1 : -1;
			var err:int=dx + dy;
			var e2:int;
			while (true)
			{
				if (ttl >= maxTTL)
				{
					return false;
				}
				ttl++
				//检查当前点是否在查找列表
				if (hasPoint(points, tempP))
					return true;
				if (startP.x == endP.x && startP.y == endP.y)
					break;
				e2=2 * err;
				if (e2 >= dy)
				{
					err+=dy;
					tempP.x+=sx;
				}
				if (e2 <= dx)
				{
					err+=dx;
					tempP.y+=sy;
				}
			}
			return false;
		}

		/**
		 * 数组中是否包含指定点
		 * @param list
		 * @param p
		 * @return
		 *
		 */
		private function hasPoint(list:Array, p:Point):Boolean
		{
			var tp:Point;
			for each (tp in list)
			{
				if (tp && tp.equals(p))
				{
					return true;
				}
			}
			return false
		}

		//允许最大的过期次数
		public static const maxTTL:uint=3000;


		/**
		 * 两点直线网格碰撞 (是否可通过)
		 * @param x0 起点x
		 * @param y0 起点y
		 * @param x1 终点x
		 * @param y1 终点y
		 * @return 返回是否可以通过
		 *
		 */
		public function hasBlockOnLine(x0:int, y0:int, x1:int, y1:int):Boolean
		{
			var dx:int=Math.abs(x1 - x0);
			var dy:int=-Math.abs(y1 - y0);

			var sx:int=x0 < x1 ? 1 : -1;
			var sy:int=y0 < y1 ? 1 : -1;
			var err:int=dx + dy;
			var e2:int; /* error value e_xy */
			//过期次数
			var ttl:int=0;

			while (true) /* loop */
			{
				if (ttl >= maxTTL)
				{
					return false;
				}
				ttl++
				//如果是路障，表示两点直线不可通过
				if (isBlock(x0, y0))
					return true;
				if (x0 == x1 && y0 == y1)
					break;
				e2=2 * err;
				if (e2 >= dy)
				{
					err+=dy;
					x0+=sx;
				} /* e_xy+e_x > 0 */
				if (e2 <= dx)
				{
					err+=dx;
					y0+=sy;
				} /* e_xy+e_y < 0 */
			}
			return false;
		}

		/**
		 * 动态设置地图掩码
		 * @param points 需要设置的格子坐标数组
		 * @param flag 0 设为路点 1 设为障碍
		 */
		public function setMask(points:Array, flag:int):void
		{
			var p:Point;
			for each (p in points)
			{
				if (p)
				{
					if (p.x < 0 || p.x >= column || p.y < 0 || p.y >= row)
						continue;
					if (flag)
					{
						obstacleMask.SetBit(column * p.y + p.x);
					}
					else
					{
						obstacleMask.UnSetBit(column * p.y + p.x);
					}
				}
			}

		}

		/**
		 * 格子坐标转像素坐标
		 * @param tile 格子坐标
		 * @return 返回像素坐标
		 */
		public function Tile2Pixel(tile:Point):Point
		{
			return new Point(((tile.x + 0.5) * tileWidth) >> 0, ((tile.y + 0.5) * tileHeight) >> 0);
		}

		/**
		 * 像素坐标转格子坐标
		 * @param pixel 像素坐标
		 * @return 返回格子坐标
		 */
		public function Pixel2Tile(pixel:Point):Point
		{
			return new Point((pixel.x / tileWidth) >> 0, (pixel.y / tileHeight) >> 0);
		}

		public function canTransit(param1:int, param2:int, param3:int, param4:int):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}

		/**
		 * 是否畅通
		 * @param startX 起始位置X
		 * @param startY 起始位置Y
		 * @param targetX 目标位置X
		 * @param targetY 目标位置Y
		 * @return
		 */
		public function canPass(startX:int, startY:int, targetX:int, targetY:int):Boolean
		{
			if (startX == targetX && startY == targetY)
			{
				return true;
			}
			var begin:int=(startY < targetY) ? startY : targetY;
			var end:int=(startY > targetY) ? startY : targetY;
			if (startX == targetX)
			{
				for (var y:int=begin; y <= end; y++)
				{
					if (isBlock(targetX, y))
					{
						return false;
					}
				}
			}
			else
			{
				var k:Number=(targetY - startY) / (targetX - startX);
				//				var b:Number=(targetX * startY - targetY * targetX) / (targetX - startX);
				var b:Number=startY - k * startX;
				begin=(startX < targetX) ? startX : targetX;
				end=(startX > targetX) ? startX : targetX;
				for (var x:int=begin; x <= end; x++)
				{
					if (isBlock(x, k * x + b))
					{
						return false;
					}
				}
			}
			return true;
		}

	}
}
