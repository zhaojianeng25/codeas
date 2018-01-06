package tempest.data.map
{
	import flash.geom.Point;

	import tempest.utils.Geom;

	/**
	 * 世界定位
	 */
	public class WorldPostion
	{
		public var _pixelX:int;
		public var _pixelY:int;
		private var _tileX:Number;
		private var _tileY:Number;
		private var _tile:Point;
		private var _pixel:Point;
		/**地图id*/
		public var mapid:uint;
		/**网格宽*/
		public var tileWidth:int=48;
		/**网格高*/
		public var tileHeight:int=24;
		/**朝向*/
		private var _toward:int=0;



		/**方向*/
		public function get toward():int
		{
			return _toward;
		}

		/**
		 * @private
		 */
		public function set toward(value:int):void
		{
			_toward=value;
		}

		public function get tileX():Number
		{
			return _tileX;
		}

		public function set tileX(value:Number):void
		{
			if (value != _tileX)
			{
				_tileX=value;
				_pixelX=(_tileX + 0.5) * tileWidth;
			}
		}



		public function get tileY():Number
		{
			return _tileY;
		}

		public function set tileY(value:Number):void
		{
			if (value != _tileY)
			{
				_tileY=value;
				_pixelY=(_tileY + 0.5) * tileHeight;
			}
		}

		public function get pixelX():int
		{
			return _pixelX;
		}

		public function set pixelX(value:int):void
		{
			if (value != _pixelX)
			{
				_pixelX=value;
				_tileX=_pixelX / tileWidth;
			}
		}


		public function get pixelY():int
		{
			return _pixelY;
		}

		public function set pixelY(value:int):void
		{
			if (value != _pixelY)
			{
				_pixelY=value;
				_tileY=_pixelY / tileHeight;
			}
		}


		public var instanceid:uint;

		/**
		 * 相对于主玩家的距离，只有在tab键按下时才更新此字段
		 */
		public var distancebyMPlayer:Number;


		/**
		 * 构造游戏世界定位点，里面包含坐标，高宽，朝向及实例ID
		 *
		 */
		public function WorldPostion(tileWidth:int, tileHeight:int, px:Number=Number.NaN, py:Number=Number.NaN)
		{
			this.tileWidth=tileWidth;
			this.tileHeight=tileHeight;
			tileX=px;
			tileY=py;
		}

		/**
		 * 以弧度为单位计算并返回角度值 0 - 2PI之间
		 * @param dstX 目标y
		 * @param dstY 目标x
		 * @return
		 *
		 */
		public function getAngle(dstX:Number, dstY:Number):Number
		{
			dstX-=tileX;
			dstY-=tileY;

			var ang:Number=Math.atan2(dstY, dstX);
			ang=(ang >= 0) ? ang : 2 * Math.PI + ang;
			ang=int(ang * 1000000) / 1000000;
			Geom.getAngle(ang);
			return ang;
		}

		private var temp:Point=new Point();

		public function getTileDir(dstX:Number, dstY:Number):int
		{
			temp.x=dstX;
			temp.y=dstY;
			return Direction.getDirection(tile, temp);
		}

		public function getPixelDir(dstX:Number, dstY:Number):int
		{
			temp.x=dstX;
			temp.y=dstY;
			return Direction.getDirection(pixel, temp);
		}

		/**
		 * 通过xy获得距离
		 * @param dstX
		 * @param dstY
		 * @return
		 *
		 */
		public function getDistance(dstX:Number, dstY:Number):Number
		{
			dstX-=tileX;
			dstY-=tileY;

			return Math.sqrt(dstX * dstX + dstY * dstY);
		}

		/**
		 * 计算实际象素的角度，以弧度为单位计算并返回角度值 0 - 2PI之间
		 * @param dstX 目标y
		 * @param dstY 目标x
		 * @return
		 *
		 */
		public function getPxAngle(dstX:Number, dstY:Number):Number
		{
			dstX-=tileX;
			dstY-=tileY;

			dstX*=tileWidth;
			dstY*=tileHeight;

			var ang:Number=Math.atan2(dstY, dstX);
			ang=(ang >= 0) ? ang : 2 * Math.PI + ang;
			ang=int(ang * 1000000) / 1000000;
			return ang;
		}

		/**
		 * 计算实际象素距离
		 * @param dstX 目标y
		 * @param dstY 目标x
		 * @return
		 *
		 */
		public function getPxDistance(dstX:Number, dstY:Number):Number
		{
			dstX-=tileX;
			dstY-=tileY;

			dstX*=tileWidth;
			dstY*=tileHeight;

			return Math.sqrt(dstX * dstX + dstY * dstY);
		}

		/**
		 * 获取逻辑坐标
		 * @return
		 *
		 */
		public function get tile():Point
		{
			if (!_tile)
			{
				_tile=new Point();
			}
			_tile.x=_tileX;
			_tile.y=_tileY;
			return _tile;
		}

		/**
		 * 获取像素坐标
		 * @return
		 *
		 */
		public function get pixel():Point
		{
			if (!_pixel)
			{
				_pixel=new Point();
			}
			_pixel.x=_pixelX;
			_pixel.y=_pixelY;
			return _pixel;
		}

		/**
		 * 是否镜像方向
		 * @return
		 *
		 */
		public function get horizontalFlip():Boolean
		{
			return toward > 4;
		}

		/**
		 * 深度复制
		 * @return
		 *
		 */
		public function clone():WorldPostion
		{
			var wpos:WorldPostion=new WorldPostion(this.tileWidth,this.tileHeight);
			wpos.mapid=mapid;
			wpos.toward=toward;
			wpos.tileX=tileX;
			wpos.tileY=tileY;
			wpos.instanceid=instanceid;
			return wpos;
		}
	}
}
