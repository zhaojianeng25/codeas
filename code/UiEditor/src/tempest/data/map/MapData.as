package tempest.data.map
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	import tempest.data.geom.Circle;
	import tempest.data.geom.SRectangle;
	import tempest.data.geom.point;
	import tempest.data.obj.UpdateMask;
	import tempest.data.utils.AStar;
	import tempest.data.utils.IMapElement;
	import tempest.data.utils.MathUtil;
	import tempest.data.utils.StringUtils;

	/**
	 * 地图路障
	 * @author QiHei
	 *
	 */
	public class MapData extends EventDispatcher implements IMapElement
	{
		/**
		 * 影子左右拉伸值
		 */
		public static var SHADOW_MATX_C:Number=0.4;
		/**
		 * 影子上下高矮值
		 */
		public static var SHADOW_MATX_D:Number=-0.4;
		/**
		 * 影子整体偏移x
		 */
		public static var SHADOW_MATX_OFFSETX:int=-2;
		/**
		 * 影子整体偏移y
		 */
		public static var SHADOW_MATX_OFFSETY:int=0;
		/**
		 * 影子透明度
		 */
		public static var SHADOW_ALPHA:Number=0.5;
		/**
		 * 影子朝向 左边
		 */
		public static const SHADOW_TOWARD_LEFT:uint=0;

		/**
		 * 影子朝向 右边
		 */
		public static const SHADOW_TOWARD_RIGHT:uint=1;

		/**
		 * 副本类型
		 */
		public static const INSTANCE_TYPE_NONE:uint=0; //不是副本
		public static const INSTANCE_TYPE_ACTIVITY:uint=1; //活动副本
		public static const INSTANCE_TYPE_SINGLE:uint=2; //单人副本
		public static const INSTANCE_TYPE_FAMILY:uint=3; //家族副本
		public static const INSTANCE_TYPE_BATTle:uint=4; //家族战场

		/**
		 *地图ID
		 */
		public var id:uint;
		/**
		 *地图名称
		 */
		public var name:String;
		/**
		 *地图创建日期
		 */
		public var date:String;
		/**
		 *地图像素宽
		 */
		public var pxWidth:uint;
		/**
		 *地图像素高
		 */
		public var pxHeight:uint;
		/**
		 *地图瓷砖宽
		 */
		public var floorWidth:uint;
		/**
		 *地图瓷砖高
		 */
		public var floorHeight:uint;
		/**
		 *地图逻辑宽
		 */
		public var logicWidth:uint;
		/**
		 *地图逻辑高
		 */
		public var logicHeight:uint;
		/**
		 *是否副本
		 */
		public var isInstance:uint;
		/**
		 * 父级地图id
		 */
		public var parentID:uint
		/**
		 *场景音乐
		 */
		public var sound:String;
		/**
		 *影子方向
		 */
		public var shadow:uint;
		/**
		 * 副本人数
		 */
		public var count:uint;
		/**
		 * 日限制
		 */
		public var dayLimit:uint;
		/**
		 * 周限制
		 */
		public var weekLimit:uint;
		/**
		 * 副本类型
		 */
		public var instanceType:uint;
		/**
		 *障碍点
		 */
		public var obstacleMask:UpdateMask;

		/**
		 * 半透明掩码
		 */
		public var halfTranMask:UpdateMask;

		/**
		 * 水倒影掩码
		 */
		public var waterMask:UpdateMask;

		/**
		 * 复活点
		 */
		public var raiseds:Vector.<Raised>;
		/**
		 * 传送点
		 */
		public var teleports:Vector.<Teleport>;

		/*A星*/
		private var _aStar:AStar;
		/**
		 * 主干道路经
		 */
		public var trukPath:TrunkPath;

		/**
		 *声源层
		 */
		public var musics:Vector.<Musics>;
		/**
		 *光源层
		 */
		public var lights:Vector.<Light>;
		/**
		 *动态层
		 */
		public var dynamics:Vector.<MapDynamic>;

		/**
		 * 所有生物
		 */
		public var creatures:Vector.<MapCreature>;

		/**
		 * 所有游戏对象
		 */
		public var gameobjects:Vector.<MapCreature>;

		/**
		 * 所有怪物线路
		 */
		public var creatureLines:Vector.<CreatureLine>;

		/**
		 * 所有水层
		 */
		public var waters:Vector.<MapWater>;

		/**
		 * 水域发生改变，用于编辑器
		 */
		public var watersIsChange:Boolean=false;

		/**
		 * 动态层发生改变，用于编辑器
		 */
		public var dynamicsIsChange:Boolean=false;

		/**
		 *  远景层
		 */
		public var farLayers:Vector.<MapFarData>;

		/*障碍区域列表*/
		private var _obstacleRangle:Vector.<SRectangle>;
		private var _obstacleCircle:Vector.<Circle>;
		//非路障区域
		private var _noObsCircle:Vector.<Circle>;

		private var _singWrap:String="\n";
		private var _singSeparate:String=",";
		private var trunkPoints:Vector.<TrunkPoint>;

		public function MapData(data:String)
		{
			_aStar=new AStar(this);
			trukPath=new TrunkPath( /*_aStar*/);
			read(data);
		}

		private function read(data:String):void
		{
			var lines:Array=data.split(_singWrap);
			//读取基本信息 0
			var basicInfo:Array=lines[0].split(_singSeparate);
			id=basicInfo.shift();
			name=basicInfo.shift();
			date=basicInfo.shift();
			pxWidth=basicInfo.shift();
			pxHeight=basicInfo.shift();
			floorWidth=basicInfo.shift();
			floorHeight=basicInfo.shift();
			logicWidth=basicInfo.shift();
			logicHeight=basicInfo.shift();
			isInstance=basicInfo.shift();
			parentID=basicInfo.shift();
			sound=basicInfo.shift();
			shadow=basicInfo.shift();
			count=basicInfo.shift();
			dayLimit=basicInfo.shift();
			weekLimit=basicInfo.shift();
			instanceType=basicInfo.shift();

			var len:uint;
			var i:int;
			var port:point;
			var p:point;
			//路障 1
			var obstacleInfo:Array=lines[1].split(_singSeparate);
			obstacleMask=new UpdateMask();
			len=obstacleInfo.length;
			for (i=0; i < len; i++)
				obstacleMask.baseByteArray.writeUnsignedInt(obstacleInfo[i]);

			//透明 2
			var transparentInfo:Array=lines[2].split(_singSeparate);
			halfTranMask=new UpdateMask();
			len=transparentInfo.length / 2;
			var isW:Boolean=false;
			for (i=0; i < len; i++)
			{
				var posX:uint=uint(transparentInfo[i * 2]);
				var posY:uint=uint(transparentInfo[i * 2 + 1]);
				var idx:uint=posY * logicWidth + posX;
				halfTranMask.SetBit(idx);
			}

			//复活 3
			var raisedInfo:Array=lines[3].split(_singSeparate);
			len=raisedInfo.length / 3;
			raiseds=new Vector.<Raised>(len, true);
			for (i=0; i < len; i++)
			{
				var raised:Raised=new Raised();
				raised.x=raisedInfo.shift();
				raised.y=raisedInfo.shift();
				raised.faction=raisedInfo.shift();
				raiseds[i]=raised;
			}

			//传送点 4
			var teleportInfo:Array=lines[4].split(_singSeparate);
			len=teleportInfo.length / 7;
			teleports=new Vector.<Teleport>(len, true);
			var teleport:Teleport;
			for (i=0; i < len; i++)
			{
				teleport=new Teleport();
				teleport.srcPortX=teleportInfo.shift();
				teleport.srcPortY=teleportInfo.shift();
				teleport.tempId=teleportInfo.shift();
				teleport.name=teleportInfo.shift();

				teleport.dstMapid=teleportInfo.shift();
				teleport.dstPortX=teleportInfo.shift();
				teleport.dstPortY=teleportInfo.shift();
				teleports[i]=teleport;
			}

			//主干道 5
			var trunkInfo:Array=lines[5].split(_singSeparate);
			trunkPoints=new Vector.<TrunkPoint>();
			while (trunkInfo.length)
			{
				if (trunkInfo[0] == "")
				{
					trunkInfo.shift();
					continue;
				}
				var tkpt:TrunkPoint=new TrunkPoint();
				tkpt.id=trunkPoints.length;
				tkpt.x=uint(trunkInfo.shift());
				tkpt.y=uint(trunkInfo.shift());
				var nextLen:uint=uint(trunkInfo.shift());
				for (var j:uint=0; j < nextLen; j++)
				{
					tkpt.nextPoints.push(new point(uint(trunkInfo.shift()), uint(trunkInfo.shift())));
				}
				trunkPoints[trunkPoints.length]=tkpt;
			}
			trukPath.init(id, trunkPoints);

			//声源 6
			var musicInfo:Array=lines[6].split(_singSeparate);
			len=musicInfo.length / 5;
			musics=new Vector.<Musics>(len, true);
			var music:Musics;
			for (i=0; i < len; i++)
			{
				music=new Musics();
				music.x=musicInfo.shift();
				music.y=musicInfo.shift();
				music.soundName=musicInfo.shift();
				music.playNum=musicInfo.shift();
				music.interval=musicInfo.shift();
				musics[i]=music;
			}

			//光源 7
			var lightInfo:Array=lines[7].split(_singSeparate);
			len=lightInfo.length / 3;
			lights=new Vector.<Light>(len, true);
			var light:Light;
			for (i=0; i < len; i++)
			{
				light=new Light();
				light.x=lightInfo.shift();
				light.y=lightInfo.shift();
				light.size=lightInfo.shift();
				lights[i]=light;
			}

			//动态层 8
			var dynamicInfo:Array=lines[8].split(_singSeparate);
			//版本兼容判断
			var unitLen:uint=9;
			if (dynamicInfo.length >= 10 && (dynamicInfo[9] == 0 || dynamicInfo[9] == 1))
			{
				unitLen=10;
			}
			len=dynamicInfo.length / unitLen;
			dynamics=new Vector.<MapDynamic>(len);
			var dyn:MapDynamic;
			for (i=0; i < len; i++)
			{
				dyn=new MapDynamic(48, 24);
				dyn.filename=dynamicInfo.shift();
				dyn.x=dynamicInfo.shift();
				dyn.y=dynamicInfo.shift();
				dyn.regX=dynamicInfo.shift();
				dyn.regY=dynamicInfo.shift();
				dyn.rotation360=dynamicInfo.shift();
				dyn.frameRate=dynamicInfo.shift();
				dyn.blendMode=dynamicInfo.shift();
				dyn.atBottom=dynamicInfo.shift() == 1;
				//新版本才支持水平翻转
				if (unitLen == 10)
					dyn.flipHorizontal=dynamicInfo.shift() == 1;
				dynamics[i]=dyn;
			}

			//所有生物 9
			var creatureInfo:Array=lines[9].split(_singSeparate);
			len=creatureInfo.length / 15;
			creatures=new Vector.<MapCreature>(len);
			var creature:MapCreature;
			for (i=0; i < len; i++)
			{
				creature=new MapCreature();
				creature.id=uint(creatureInfo.shift());
				creature.x=Number(creatureInfo.shift());
				creature.y=Number(creatureInfo.shift());
				creature.count=uint(creatureInfo.shift());
				creature.spawnType=uint(creatureInfo.shift());
				creature.respawnTime=uint(creatureInfo.shift());
				creature.spawnTime1=uint(creatureInfo.shift());
				creature.spawnTime2=uint(creatureInfo.shift());
				creature.spawnTime3=uint(creatureInfo.shift());
				creature.scriptName=String(creatureInfo.shift());
				creature.around=uint(creatureInfo.shift());
				creature.lineId=uint(creatureInfo.shift());
				creature.flag=uint(creatureInfo.shift());
				creature.toward=Number(creatureInfo.shift());
				creature.aliasName=String(creatureInfo.shift());
//				creature.T = Template.getCreature_T(creature.id);
				creatures[i]=creature;
			}

			//游戏对象点 10
			var gameObjectInfo:Array=lines[10].split(_singSeparate);
			len=gameObjectInfo.length / 12;
			gameobjects=new Vector.<MapCreature>(len);
			var gameobject:MapCreature;
			for (i=0; i < len; i++)
			{
				gameobject=new MapCreature();
				gameobject.id=uint(gameObjectInfo.shift());
				gameobject.x=Number(gameObjectInfo.shift());
				gameobject.y=Number(gameObjectInfo.shift());
				gameobject.count=uint(gameObjectInfo.shift());
				gameobject.spawnType=uint(gameObjectInfo.shift());
				gameobject.respawnTime=uint(gameObjectInfo.shift());
				gameobject.spawnTime1=uint(gameObjectInfo.shift());
				gameobject.spawnTime2=uint(gameObjectInfo.shift());
				gameobject.spawnTime3=uint(gameObjectInfo.shift());
				gameobject.scriptName=String(gameObjectInfo.shift());
				gameobject.toward=Number(gameObjectInfo.shift());
				gameobject.aliasName=String(gameObjectInfo.shift());
				gameobjects[i]=gameobject;
			}

			//怪物路线层 11
			var creatureLineInfo:Array=lines[11].split(_singSeparate);
			creatureLines=new Vector.<CreatureLine>();
			var creatureLine:CreatureLine;
			while (creatureLineInfo.length > 0)
			{
				if (creatureLineInfo[0] == "")
				{
					creatureLineInfo.shift();
					continue;
				}
				creatureLine=new CreatureLine();
				creatureLine.id=int(creatureLineInfo.shift());
				var lineNum:int=int(creatureLineInfo.shift());
				for (i=0; i < lineNum; i++)
				{
					var ptx:Number=Number(creatureLineInfo.shift());
					var pty:Number=Number(creatureLineInfo.shift());
					creatureLine.points.push(ptx, pty);
				}
				creatureLines.push(creatureLine);
			}

			//水掩码 line 12
			var invingInfo:Array=lines[12].split(_singSeparate);
			waterMask=new UpdateMask();
			len=invingInfo.length / 2;
			for (i=0; i < len; i++)
			{
				posX=uint(invingInfo[i * 2]);
				posY=uint(invingInfo[i * 2 + 1]);
				waterMask.SetBit(posY * logicWidth + posX);
			}

			//考虑版本兼容
			farLayers=new Vector.<MapFarData>();
			waters=new Vector.<MapWater>();

			//远景 line 13
			if (lines.length <= 13)
				return;
			var farInfo:Array=lines[13].split(_singSeparate);
			len=farInfo.length / 5;
			for (i=0; i < len; i++)
			{
				var farLayer:MapFarData=new MapFarData("1,1,1,1,1,1,1");
//				farLayer.name = String(farInfo.shift());
//				farLayer.width = uint(farInfo.shift());
//				farLayer.height = uint(farInfo.shift());
//				farLayer.xMoveRate = Number(farInfo.shift());
//				farLayer.yMoveRate = Number(farInfo.shift());
//				farLayer.x = int(farInfo.shift());
//				farLayer.y = int(farInfo.shift());
				farLayers.push(farLayer);
			}

			//所有水域 line 14
			if (lines.length <= 14)
				return;
			var waterInfo:Array=lines[14].split(_singSeparate);
			waters=new Vector.<MapWater>();
			len=waterInfo.length / 11;
			for (i=0; i < len; i++)
			{
				var water:MapWater=new MapWater("1,1,1,1,1,1,1,1,1,1,1");
//				water.name = String(waterInfo.shift());
//				water.x =  int(waterInfo.shift());
//				water.y =  int(waterInfo.shift());
//				water.width = uint(waterInfo.shift());
//				water.height = uint(waterInfo.shift());
//				water.atBottom = uint(waterInfo.shift()) == 1;
//				water.waveHeight= uint(waterInfo.shift());
//				water.waveLength= uint(waterInfo.shift());
//				water.waveBreadth= uint(waterInfo.shift());
//				water.streamDirect= uint(waterInfo.shift());
//				water.streamSpeed= Number(waterInfo.shift());
				waters.push(water);
			}

		}

		private function wirteLine(lines:Array, line:String):void
		{
			if (StringUtils.endsWith(line, _singSeparate))
			{
				line=line.substr(0, line.length - 1);
			}
			lines.push(line);
		}

		private function writeLineArg(lines:Array, ... arg):void
		{
			var line:String="";
			for (var i:int=0; i < arg.length; i++)
			{
				line+=arg[i] + _singSeparate;
			}
			wirteLine(lines, line);
		}

		public function save():String
		{
			var line:String="";
			var lines:Array=new Array();
			//写入基本信息 line0
			writeLineArg(lines, id, name, date, pxWidth, pxHeight, floorWidth, floorHeight, logicWidth, logicHeight, isInstance, parentID, sound, shadow, count, dayLimit, weekLimit, instanceType);

			var len:uint;
			var i:int;
			var port:point;
			var p:point;

			//路障	line1
			line="";
			len=obstacleMask.GetCount() / 32;
			obstacleMask.baseByteArray.position=0;
			for (i=0; i < len; i++)
			{
				var v:uint=obstacleMask.baseByteArray.readUnsignedInt();
				line+=v + _singSeparate;
			}
			wirteLine(lines, line);

			//透明	line2
			line="";
			len=halfTranMask.GetCount();
			for (i=0; i < len; i++)
			{
				if (halfTranMask.GetBit(i))
				{
					var posX:uint=i % logicWidth;
					var posY:uint=i / logicWidth;
					line+=posX + _singSeparate + posY + _singSeparate;
				}
			}
			wirteLine(lines, line);

			//复活	line3
			line="";
			len=raiseds.length;
			for (i=0; i < len; i++)
			{
				var raised:Raised=raiseds[i];
				line+=raised.x + _singSeparate + raised.y + _singSeparate + raised.faction + _singSeparate;
			}
			wirteLine(lines, line);

			//传送点	line4
			line="";
			len=teleports.length;
			for (i=0; i < len; i++)
			{
				var teleport:Teleport=teleports[i];
				line+=teleport.srcPortX + _singSeparate + teleport.srcPortY + _singSeparate + teleport.tempId + _singSeparate + teleport.name + _singSeparate +

					teleport.dstMapid + _singSeparate + teleport.dstPortX + _singSeparate + teleport.dstPortY + _singSeparate;
			}
			wirteLine(lines, line);

			//主干道 line5
			line="";
			len=trunkPoints.length;
			for (i=0; i < len; i++)
			{
				var tkpt:TrunkPoint=trunkPoints[i];
				var nextLen:uint=tkpt.nextPoints.length;
				line+=tkpt.x + _singSeparate + tkpt.y + _singSeparate + nextLen + _singSeparate;
				//写入下一个结点x和y
				for (var j:uint=0; j < nextLen; j++)
				{
					p=tkpt.nextPoints[j];
					line+=p.x + _singSeparate + p.y + _singSeparate;
				}
			}
			wirteLine(lines, line);

			//声源	line6
			line="";
			len=musics.length;
			for (i=0; i < len; i++)
			{
				var music:Musics=music[i];
				line+=music.x + _singSeparate + music.y + _singSeparate + music.soundName + _singSeparate + music.playNum + _singSeparate + music.interval + _singSeparate;
			}
			wirteLine(lines, line);

			//光源	line7
			line="";
			len=lights.length;
			for (i=0; i < len; i++)
			{
				var light:Light=new Light();
				line+=light.x + _singSeparate + light.y + _singSeparate + light.size + _singSeparate;
			}
			wirteLine(lines, line);

			//动态层	line8
			line="";
			len=dynamics.length;
			for (i=0; i < len; i++)
			{
				var movie:MapDynamic=dynamics[i];
				line+=movie.filename + _singSeparate + movie.x + _singSeparate + movie.y + _singSeparate + movie.regX + _singSeparate + movie.regY + _singSeparate + movie.rotation360 + _singSeparate + movie.frameRate + _singSeparate + movie.blendMode + _singSeparate + (movie.atBottom ? 1 : 0) + _singSeparate + (movie.flipHorizontal ? 1 : 0) + _singSeparate;
			}
			wirteLine(lines, line);

			//所有生物	line9
			line="";
			len=creatures.length;
			for (i=0; i < len; i++)
			{
				var creature:MapCreature=creatures[i];
				line+=creature.id + _singSeparate + creature.x + _singSeparate + creature.y + _singSeparate + creature.count + _singSeparate + creature.spawnType + _singSeparate + creature.respawnTime + _singSeparate + creature.spawnTime1 + _singSeparate + creature.spawnTime2 + _singSeparate + creature.spawnTime3 + _singSeparate + creature.scriptName + _singSeparate + creature.around + _singSeparate + creature.lineId + _singSeparate + creature.flag + _singSeparate + creature.toward + _singSeparate + creature.aliasName + _singSeparate;
			}
			wirteLine(lines, line);

			//游戏对象点 	line10
			line="";
			len=gameobjects.length;
			for (i=0; i < len; i++)
			{
				var gameobject:MapCreature=gameobjects[i];
				line+=gameobject.id + _singSeparate + gameobject.x + _singSeparate + gameobject.y + _singSeparate + gameobject.count + _singSeparate + gameobject.spawnType + _singSeparate + gameobject.respawnTime + _singSeparate + gameobject.spawnTime1 + _singSeparate + gameobject.spawnTime2 + _singSeparate + gameobject.spawnTime3 + _singSeparate + gameobject.scriptName + _singSeparate + gameobject.toward + _singSeparate + gameobject.aliasName + _singSeparate;
			}
			wirteLine(lines, line);

			//怪物路线层 11
			line="";
			len=creatureLines.length;
			for (i=0; i < len; i++)
			{
				var creatureLine:CreatureLine=creatureLines[i];
				var pointsLen:uint=creatureLine.points.length / 2;
				line+=creatureLine.id + _singSeparate + pointsLen + _singSeparate;
				for (j=0; j < creatureLine.points.length; j++)
				{
					line+=creatureLine.points[j] + _singSeparate;
				}
			}
			wirteLine(lines, line);

			//水掩码	line12
			line="";
			len=waterMask.GetCount();
			for (i=0; i < len; i++)
			{
				if (waterMask.GetBit(i))
				{
					posX=i % logicWidth;
					posY=i / logicWidth;
					line+=posX + _singSeparate + posY + _singSeparate;
				}
			}
			wirteLine(lines, line);

			//远景层	line13
			line="";
			len=farLayers.length;
			for (i=0; i < len; i++)
			{
				var farLayer:MapFarData=farLayers[i];
				line+=farLayer.name + _singSeparate + farLayer.width + _singSeparate + farLayer.height + _singSeparate + farLayer.xMoveRate + _singSeparate + farLayer.yMoveRate + _singSeparate + farLayer.x + _singSeparate + farLayer.y + _singSeparate;
			}
			wirteLine(lines, line);

			//所有水层	line14
			line="";
			len=waters.length;
			for (i=0; i < len; i++)
			{
				var water:MapWater=waters[i];

				line+=water.name + _singSeparate + water.x + _singSeparate + water.y + _singSeparate + water.width + _singSeparate + water.height + _singSeparate + (water.atBottom ? 1 : 0) + _singSeparate + water.waveHeight + _singSeparate + water.waveLength + _singSeparate + water.waveBreadth + _singSeparate + water.streamDirect + _singSeparate + water.streamSpeed + _singSeparate;

			}
			wirteLine(lines, line);

			//组织所有行
			var content:String="";
			for (var k:int=0; k < lines.length; k++)
			{
				content+=lines[k] + _singWrap;
			}

			content=content.substr(0, content.length - 1);
			return content;
		}

		/**
		 * 获得两点直线，可通过的最后一个点坐标
	   * @param x0 起点x
					 * @param y0 起点y
		 * @param x1 终点x
		 * @param y1 终点y
		 * @return 如果完全通过，则返回null
		 *
		 */
		public function getCanTransitPoint(x0:int, y0:int, x1:int, y1:int):Point
		{
			var dx:int=Math.abs(x1 - x0);
			var dy:int=-Math.abs(y1 - y0);

			var sx:int=x0 < x1 ? 1 : -1;
			var sy:int=y0 < y1 ? 1 : -1;
			var err:int=dx + dy;
			var e2:int; /* error value e_xy */

			var pt:Point;

			//允许最大的过期次数
			const maxTTL:uint=20000;
			//过期次数
			var ttl:int=0;

			while (true) /* loop */
			{
				if (ttl >= maxTTL)
				{
					throw new Error("MapData:MapData.getCanTransitPoint,TTL more than MAX:" + maxTTL.toString());
					return null;
				}
				ttl++;

				//如果是路障，表示两点直线不可通过
				if (isObstacle(x0, y0))
					return pt;
				if (!pt)
					pt=new Point();
				pt.x=x0;
				pt.y=y0;

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
			return null;
		}

		/**
		 * 两点直线网格碰撞 (是否可通过)
		 * @param x0 起点x
		 * @param y0 起点y
		 * @param x1 终点x
		 * @param y1 终点y
		 * @return 返回是否可以通过
		 *
		 */
		public function canTransit(x0:int, y0:int, x1:int, y1:int):Boolean
		{
			var dx:int=Math.abs(x1 - x0);
			var dy:int=-Math.abs(y1 - y0);

			var sx:int=x0 < x1 ? 1 : -1;
			var sy:int=y0 < y1 ? 1 : -1;
			var err:int=dx + dy;
			var e2:int; /* error value e_xy */

			//允许最大的过期次数
			const maxTTL:uint=3000;
			//过期次数
			var ttl:int=0;

			while (true) /* loop */
			{
				if (ttl >= maxTTL)
				{
					throw new Error("MapData:MapData.canTransit,TTL more than MAX:" + maxTTL.toString());
					return null;
				}
				ttl++

				//如果是路障，表示两点直线不可通过
				if (isObstacle(x0, y0))
					return false;

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
			return true;
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
		 * 获得指定点周围无路障的点
		 * @param refPoint 输入点和返回点
		 * @param max_r 最大半径
		 *
		 */
		public function getRoundNotObs(refPoint:Point, max_r:uint):void
		{
			if (max_r >= 500)
			{
				throw new Error("MapData.getRoundNotObs,max_r more than MAX:500");
				return;
			}
			var distance:uint=1;
			//当前尝试的圈数
			var circle:uint=0;

			const maxTTL:uint=20000;
			var ttl:uint=0;

			while (true)
			{
				ttl++;
				if (ttl > maxTTL)
					throw new Error("MapData.getRoundNotObs,maxTTL more than MAX:" + maxTTL);

				//如果看是否能寻找到
				if (getCircleNotObs(refPoint.x, refPoint.y, distance, refPoint))
					break;
				distance++;
				circle++;

				//不得超过10圈
				if (circle > max_r)
					break;
			}
		}

		/**
		 * 获得圆形非路障点
		 * @param xm 圆心x
		 * @param ym 圆心y
		 * @param r 半径
		 * @param refResult 返回的点
		 * @return
		 *
		 */
		private function getCircleNotObs(xm:int, ym:int, r:int, refResult:Point):Boolean
		{
			var x:int=-r;
			var y:int=0;
			var err:int=2 - 2 * r; /* II. Quadrant */

			const maxTTL:uint=20000;
			var ttl:uint=0;

			do
			{
				ttl++;
				if (ttl > maxTTL)
					throw new Error("MapData.getCircleNotObs,maxTTL more than MAX:" + maxTTL);

				var hitX:int;
				var hitY:int;

				/*   I. Quadrant */
				hitX=xm - x;
				hitY=ym + y;
				if (!isObstacle(hitX, hitY))
				{
					refResult.x=hitX;
					refResult.y=hitY;
					return true;
				}

				/*  II. Quadrant */
				hitX=xm - y;
				hitY=ym - x;
				if (!isObstacle(hitX, hitY))
				{
					refResult.x=hitX;
					refResult.y=hitY;
					return true;
				}

				/* III. Quadrant */
				hitX=xm + x;
				hitY=ym - y;
				if (!isObstacle(hitX, hitY))
				{
					refResult.x=hitX;
					refResult.y=hitY;
					return true;
				}

				/*  IV. Quadrant */
				hitX=xm + y;
				hitY=ym + x;
				if (!isObstacle(hitX, hitY))
				{
					refResult.x=hitX;
					refResult.y=hitY;
					return true;
				}

				r=err;
				if (r > x)
					err+=++x * 2 + 1; /* e_xy+e_x > 0 */
				if (r <= y)
					err+=++y * 2 + 1; /* e_xy+e_y < 0 */
			} while (x < 0);

			return false;
		}


		//A* 寻路相关
		public function isBlock( /*curX:int, curY:int,*/nextX:int, nextY:int):Boolean
		{
			if (nextX < 0 || nextY < 0)
				return false;
			return !isObstacle(nextX, nextY);
		}

		/**
		 * 是否障碍
		 * @param x x
		 * @param y y
		 * @return
		 *
		 */
		public function isObstacle(x:int, y:int):Boolean
		{
			//地图边缘判断
			if (y < 0 || x < 0 || y >= logicHeight || x >= logicWidth)
				return true;

			//非路障区域判断
			if (_noObsCircle)
			{
				for (var i:int=0; i < _noObsCircle.length; i++)
				{
					var circle:Circle=_noObsCircle[i];
					if (MathUtil.getDistance(x, y, circle.x, circle.y) > circle.radius)
						return true;
				}
			}

			//矩形障碍区域判断
			if (_obstacleRangle)
			{
				for (i=0; i < _obstacleRangle.length; i++)
				{
					if (_obstacleRangle[i].contains(x, y))
						return true;
				}
			}

			//原型障碍区
			if (_obstacleCircle)
			{
				for (i=0; i < _obstacleCircle.length; i++)
				{
					circle=_obstacleCircle[i];
					if (MathUtil.getDistance(x, y, circle.x, circle.y) <= circle.radius)
						return true;
				}
			}
			//地图障碍数据判断
			return obstacleMask.GetBit(y * logicWidth + x);
		}

		/**
		 * 是否半透明
		 * @param x
		 * @param y
		 * @return
		 *
		 */
		public function isTran(x:int, y:int):Boolean
		{
			if (y < 0 || x < 0 || y >= logicHeight || x >= logicWidth)
				return true;
			//地图障碍数据判断
			return halfTranMask.GetBit(y * logicWidth + x);
		}

		/**
		 * 是否水倒影
		 * @param x
		 * @param y
		 * @return
		 *
		 */
		public function isWater(x:int, y:int):Boolean
		{
			if (y < 0 || x < 0 || y >= logicHeight || x >= logicWidth)
				return true;
			return waterMask.GetBit(y * logicWidth + x);
		}

		/**
		 * 增加障碍区域，目前只支持一个障碍区域，今后有需求在考虑多个障碍区域
		 * @param cx 区域中心点x 或者 圆的x点
		 * @param cy 区域中心点y 或者 圆的y点
		 * @param round 周围直线区域 或者圆的半径
		 * @param isRect 是否为矩形，false则是原型
		 * @return 返回路障区域对象指针
		 *
		 */
		public function addObstacleRangle(cx:uint, cy:uint, round:uint, isRect:Boolean=true):*
		{
			if (isRect)
			{
				//矩形障碍
				if (!_obstacleRangle)
					_obstacleRangle=new Vector.<SRectangle>();
				var rect:SRectangle=new SRectangle(cx - round, cy - round, round * 2, round * 2);
				_obstacleRangle.push(rect);
				return rect;
			}
			else
			{
				//圆形障碍
				if (!_obstacleCircle)
					_obstacleCircle=new Vector.<Circle>();
				var circle:Circle=new Circle(cx, cy, round);
				_obstacleCircle.push(circle);
				return circle;
			}
		}

		/**
		 * 增加矩形障碍区域
		 * @param ax
		 * @param ay
		 * @param aw
		 * @param ah
		 * @return 返回路障区域对象指针
		 *
		 */
		public function addObstacleRangle1(ax:uint, ay:uint, aw:uint, ah:uint):*
		{
			if (!_obstacleRangle)
				_obstacleRangle=new Vector.<SRectangle>();
			var rect:SRectangle=new SRectangle(ax, ay, aw, ah);
			_obstacleRangle.push(rect);
			return rect;
		}

		/**
		 * 清楚障碍区域
		 *
		 */
		public function removeObsRangle(obsPtr:*=null):void
		{
			var idx:int;
			if (!obsPtr)
			{
				_obstacleRangle=null;
				_obstacleCircle=null;
			}
			else if (obsPtr is SRectangle)
			{
				if (!_obstacleRangle)
					return;
				idx=_obstacleRangle.indexOf(obsPtr);
				if (idx >= 0)
					_obstacleRangle.splice(idx, 1);
			}
			else if (obsPtr is Circle)
			{
				if (!_obstacleCircle)
					return;
				idx=_obstacleCircle.indexOf(obsPtr);
				if (idx >= 0)
					_obstacleCircle.splice(idx, 1);
			}
			else
			{
				throw new Error("MapData:obsPtr Type is error");
			}
		}



		/**
		 * 加上非路障
		 * @param cx
		 * @param cy
		 * @param radius
		 * @return
		 *
		 */
		public function addNoObsCircle(cx:uint, cy:uint, radius:uint):Circle
		{
			//圆形障碍
			if (!_noObsCircle)
				_noObsCircle=new Vector.<Circle>();
			var circle:Circle=new Circle(cx, cy, radius);
			_noObsCircle.push(circle);
			return circle;
		}

		/**
		 * 清理非路障
		 * @param ptr 指针
		 * @return
		 *
		 */
		public function removeNoObsCircle(ptr:Circle):void
		{
			var idx:int;
			if (!ptr)
			{
				_noObsCircle=null;
			}
			else
			{
				if (!_noObsCircle)
					return;
				idx=_noObsCircle.indexOf(ptr);
				if (idx >= 0)
					_noObsCircle.splice(idx, 1);
			}
		}

		/**
		 * 根据离点2的距离获得点1到点2之间的非障碍格子
		 * @param mapID
		 * @param p1
		 * @param dstX
		 * @param dstY
		 * @param distance
		 */
		public function getAdjacent(p1:WorldPostion, dstX:Number, dstY:Number, distance:Number=3.3):Point
		{
			var point:Point=new Point();
			//得到以自己为圆心的角度
			var angle:Number=p1.getAngle(dstX, dstY);
			//要求站的位置距离两格
			var dis:Number=p1.getDistance(dstX, dstY) - distance;

			point.x=p1.tileX + Math.cos(angle) * dis;
			point.y=p1.tileY + Math.sin(angle) * dis;
			//如果是路障，则环绕四周寻找非障碍点
			if (isObstacle(point.x, point.y))
			{
				point.x=dstX;
				point.y=dstY;
				//查找以目标点为轴心的圆形非障碍点
				getRoundNotObs(point, 15);
			}
			return point;
		}

	}
}
