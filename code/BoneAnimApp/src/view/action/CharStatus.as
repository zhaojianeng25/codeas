package view.action
{
	/**
	 * 角色状态类型,  
	 * <li>	跟骨骼文件的状态必须匹配. 骨骼文件可以比这个少, 但是不能出现这里没定义的.
	 * @author nick
	 * Email : 7105647@QQ.com
	 */		
	public class CharStatus
	{		
		//=============人跟坐骑都会有的状态==========================
		/**
		 * 空闲1 
		 */		
		public static const IDLE1:String = "idea";
		/**
		 * 空闲2 
		 */		
		public static const IDLE2:String = "idea2";
		
		/**
		 * 站立
		 */	
		public static const STAND:String = "stand";
		/**
		 * 行走
		 */	
		public static const WALK:String = "walk";
		/**
		 * 普通攻击
		 */	
		public static const ATTACK:String = "attack";
		/**
		 * 受伤
		 */	
		public static const INJURED:String = "injured";
		
		/**
		 * 特殊攻击动作1
		 */	
		public static const ATTACK_1:String = "attack_01"; 
		/**
		 * 特殊攻击动作2
		 */	
		public static const ATTACK_2:String = "attack_02"; 
		/**
		 * 特殊攻击动作3
		 */	
		public static const ATTACK_3:String = "attack_03"; 
		/**
		 * 特殊攻击动作4
		 */	
		public static const ATTACK_4:String = "attack_04"; 
		/**
		 * 特殊攻击动作5
		 */	
		public static const ATTACK_5:String = "attack_05"; 
		/**
		 * 特殊攻击动作6
		 */	
		public static const ATTACK_6:String = "attack_06"; 
		/**
		 * 特殊攻击动作7
		 */	
		public static const ATTACK_7:String = "attack_07"; 
		/**
		 * 特殊攻击动作8
		 */	
		public static const ATTACK_8:String = "attack_08"; 
		/**
		 * 特殊攻击动作9
		 */	
		public static const ATTACK_9:String = "attack_09"; 
		/**
		 * 特殊攻击动作10
		 */	
		public static const ATTACK_10:String = "attack_10"; 
		
		
		//=============人 独有的状态   ==========================
		/**
		 * 跳跃
		 * 坐骑没有跳跃状态, 当人跳跃时, 坐骑会跑过去,或者瞬移过去
		 */	
		public static const JUMP:String = "jump"; 
		
		public static const JUMP2:String = "jump2"; 
		/**
		 * 打坐
		 * 打坐时 会自动收起坐骑和武器
		 */	
		public static const SIT:String = "sit";
		/**
		 * 双修
		 * 打坐时 会自动收起坐骑和武器
		 */	
		public static const SHUANG_XIU:String = "sit_01";
		/**
		 * 死亡
		 * 死亡时 会自动收起坐骑
		 */	
		public static const DEATH:String = "death";
		
		
		//=============骑乘状态下,人的状态==========================
		/**
		 * 骑乘 站立
		 */	
		public static const STAND_MOUNT:String = "stand_mount";
		/**
		 * 骑乘 行走
		 */	
		public static const WALK_MOUNT:String = "walk_mount";
		/**
		 * 骑乘 攻击
		 */	
		public static const ATTACK_MOUNT:String = "attack_mount";
		/**
		 * 骑乘 特殊攻击动作1			
		 */	
		public static const ATTACK_MOUNT_1:String = "attack_mount_01"; 
		/**
		 * 骑乘 特殊攻击动作2
		 */	
		public static const ATTACK_MOUNT_2:String = "attack_mount_02"; 
		/**
		 * 骑乘 特殊攻击动作3
		 */	
		public static const ATTACK_MOUNT_3:String = "attack_mount_03"; 
		/**
		 * 骑乘 特殊攻击动作4
		 */	
		public static const ATTACK_MOUNT_4:String = "attack_mount_04"; 
		/**
		 * 骑乘 特殊攻击动作5
		 */	
		public static const ATTACK_MOUNT_5:String = "attack_mount_05"; 
		
		/**
		 * 骑乘 特殊攻击动作1			
		 */	
		public static const ATTACK_MOUNT_6:String = "attack_mount_06"; 
		/**
		 * 骑乘 特殊攻击动作2
		 */	
		public static const ATTACK_MOUNT_7:String = "attack_mount_07"; 
		/**
		 * 骑乘 特殊攻击动作3
		 */	
		public static const ATTACK_MOUNT_8:String = "attack_mount_08"; 
		/**
		 * 骑乘 特殊攻击动作4
		 */	
		public static const ATTACK_MOUNT_9:String = "attack_mount_09"; 
		/**
		 * 骑乘 特殊攻击动作5
		 */	
		public static const ATTACK_MOUNT_10:String = "attack_mount_10"; 
		
		/**
		 * 骑乘 受伤
		 */	
		public static const INJURED_MOUNT:String = "injured_mount";
		
		
		//=============游泳时,人的状态(游泳时候无攻击动作)==========================
		/**
		 * 游泳 站立
		 */	
		public static const STAND_SWIM:String = "stand_swim";
		/**
		 * 游泳 行走
		 */	
		public static const WALK_SWIM:String = "walk_swim";
		/**
		 * 游泳 受伤
		 */	
		public static const INJURED_SWIM:String = "injured_swim";
		/**
		 * 游泳 死亡
		 */	
		public static const DEATH_SWIM:String = "death_swim";
		
		//=============水上飞 时,人的状态(注意 攻击使用陆地攻击动作即可)==========================
		/**
		 * 水上飞 站立
		 */	
		public static const STAND_SWIM_ABOVE:String = "stand_swim_above";
		/**
		 * 水上飞 行走
		 */	
		public static const WALK_SWIM_ABOVE:String = "walk_swim_above";
		/**
		 * 水上飞  受伤
		 */	
		public static const INJURED_SWIM_ABOVE:String = "injured_swim_above";
		
		
		public static const REPEL:String = "repel";
		
		public static const ATTACK_BACK1:String = "attack_back1";
		
		public static const ATTACK_BACK2:String = "attack_back2";
		
		public static const ATTACK_BACK3:String = "attack_back3";
		
		public static const STAND_IN_FIGHT:String = "stand_in_fight";
		
		
		//=============下面几个是预留的    *******************   ==========================
		/**
		 * 瞬移(!!无换装)(这个暂时不用)
		 */	
		public static const BLINK:String = "blink";
		
		
		
		
		
		
		//如果以后还有更多的动作  就继续往后加!
		
		
		
		//statusList
		//====================================================================================================
		/**
		 * player的所有状态类型		(目前人的受伤动作没有使用)
		 * (攻击类型多给几个.用的到的就用, 用不到的也不会加载)
		 */
		public static const playerStatusList:Array = [IDLE1, IDLE2, STAND, WALK, ATTACK, INJURED, SIT, SHUANG_XIU, DEATH, JUMP, 			//普通
													STAND_SWIM, WALK_SWIM, INJURED_SWIM, DEATH_SWIM,			//游泳
													STAND_MOUNT, WALK_MOUNT, ATTACK_MOUNT, INJURED_MOUNT,		//骑乘时
													STAND_SWIM_ABOVE, WALK_SWIM_ABOVE, INJURED_SWIM_ABOVE,		//水上飞
													ATTACK_1, ATTACK_2, ATTACK_3, ATTACK_4, ATTACK_5,			//特殊攻击
													ATTACK_6, ATTACK_7, ATTACK_8, ATTACK_9, ATTACK_10,
													ATTACK_MOUNT_1, ATTACK_MOUNT_2, ATTACK_MOUNT_3, ATTACK_MOUNT_4, ATTACK_MOUNT_5,JUMP2,
													REPEL,STAND_IN_FIGHT,
													ATTACK_MOUNT_6, ATTACK_MOUNT_7, ATTACK_MOUNT_8, ATTACK_MOUNT_9, ATTACK_MOUNT_10];		//骑乘时特殊攻击
		
		/**
		 * 坐骑的所有状态类型	
		 */
		public static const mountStatusList:Array = [
														IDLE1, IDLE2, STAND, WALK, ATTACK
													];
		
		/**
		 * 宠物的所有状态类型	
		 */
		public static const PetStatusList:Array = [
														IDLE1, IDLE2, 
														STAND, STAND_SWIM, 
														WALK, WALK_SWIM, WALK_SWIM_ABOVE, 
														DEATH, DEATH_SWIM
													];
		
		
		/**
		 * monster的所有状态类型	(攻击类型多给几个.用的到的就用, 用不到的也不会加载)
		 */
		public static const monsterStatusList:Array = [IDLE1, IDLE2, STAND, WALK, ATTACK, INJURED, DEATH,
														ATTACK_1, ATTACK_2, ATTACK_3, ATTACK_4, ATTACK_5,
														ATTACK_6, ATTACK_7, ATTACK_8, ATTACK_9, ATTACK_10];
		
		/**
		 *采集物的所有状态类型 
		 */		
		public static const collectionStatusList:Array	=	[STAND];
		/**
		 * npc的所有状态类型	
		 */
		public static const npcStatusList:Array = [IDLE1, IDLE2, STAND,ATTACK];
		
		/**
		 * 根据charType 返回拥有的动作列表 
		 * @param $type
		 * @return actionList
		 */		
		

		/**
		 * 获取基础状态, 比如  ATTACK_MOUNT 的基础状态是  ATTACK,     INJURED_SWIM 的基础状态是 INJURED 等等
		 * <li> 主要用于当服务器通知客户端 当某角色的技能状态发生变化时,需要检测地形或者坐骑,并且重新设置状态, 此时就需要先拿到基础状态, 再根据地形或者坐骑 转换成合适的状态
		 */		
		public static function getBaseStatus( $curStatus:String ):String
		{
			var baseStatus:String = $curStatus;
			
			//特殊动作 要还原成基础动作,   如果本身就是基础动作, 则直接return
			switch($curStatus)
			{
				case STAND_MOUNT:
				case STAND_SWIM:
				case STAND_SWIM_ABOVE:
					baseStatus = STAND;
					break;
				case WALK_MOUNT:
				case WALK_SWIM:
				case WALK_SWIM_ABOVE:
					baseStatus = WALK;
					break;
				case INJURED_MOUNT:
				case INJURED_SWIM:
				case INJURED_SWIM_ABOVE:
					baseStatus = INJURED;
					break;
				case ATTACK_MOUNT:
					baseStatus = ATTACK;
					break;
				case DEATH_SWIM:
					baseStatus = DEATH;
					break;
				case ATTACK_MOUNT_1:
					baseStatus = ATTACK_1;
					break;
				case ATTACK_MOUNT_2:
					baseStatus = ATTACK_2;
					break;
				case ATTACK_MOUNT_3:
					baseStatus = ATTACK_3;
					break;
				case ATTACK_MOUNT_4:
					baseStatus = ATTACK_4;
					break;
				case ATTACK_MOUNT_5:
					baseStatus = ATTACK_5;
					break;
			}
			return baseStatus;
		}
		

		
		/**
		 * 是否在播放一遍之后  停在最后一帧
		 * <li>目前只有     "跳 / 死亡"  是停在最后一帧</li>
		 * @return
		 */	
		public static function getIsStayAtEnd($status:String):Boolean
		{
			if(
				$status==JUMP
				||
				getIsDeath( $status )
			)
				return true;
			
			return false;
		}
	
		

		/**
		 * 是否是行走类型的状态(只判断当前动作帧   不判断真正的数据)
		 * @return
		 */	
		public static function getIsWalk($status:String):Boolean
		{
			if(
				$status==WALK
				||
				$status==WALK_MOUNT
				||
				$status==WALK_SWIM
				||
				$status==WALK_SWIM_ABOVE
			)
				return true;
			
			return false;
		}
		
		/**
		 * 是否是站立类型的状态(只判断当前动作帧   不判断真正的数据)
		 * @return
		 */	
		public static function getIsStand($status:String):Boolean
		{
			if(
				$status==STAND
				||
				$status==STAND_MOUNT
				||
				$status==STAND_SWIM
				||
				$status==STAND_SWIM_ABOVE
			)
				return true;
			
			return false;
		}
		
		/**
		 * 是否是受伤类型的状态(只判断当前动作帧   不判断真正的数据)
		 * @return
		 */	
		public static function getIsInjured($status:String):Boolean
		{
			if(
				$status==INJURED
				||
				$status==INJURED_MOUNT
				||
				$status==INJURED_SWIM
				||
				$status==INJURED_SWIM_ABOVE
			)
				return true;
			
			return false;
		}
		
		/**
		 * 是否是死亡类型的状态(只判断当前动作帧   不判断真正的数据)
		 * @return
		 */	
		public static function getIsDeath($status:String):Boolean
		{
			if(
				$status==DEATH
				||
				$status==DEATH_SWIM
			)
				return true;
			
			return false;
		}
		
		
		/**
		 * 是否是打坐类型的状态(只判断当前动作帧   不判断真正的数据)
		 * @return
		 */	
		public static function getIsSit($status:String):Boolean
		{
			if(
				$status==SIT
				||
				$status==SHUANG_XIU
			)
				return true;
			
			return false;
		}
		
		public static const status_aj2:Object = { 
			0 : IDLE1, 
			1 : IDLE2, 
			2 : STAND, 
			3 : WALK, 
			4 : ATTACK, 
			5 : INJURED, 
			6 : SIT, 
			7 : SHUANG_XIU, 
			8 : DEATH, 
			9 : JUMP, 
			10 : STAND_SWIM, 
			11 : WALK_SWIM,
			12 : INJURED_SWIM, 
			13 : DEATH_SWIM, 
			14 : STAND_MOUNT, 
			15 : WALK_MOUNT, 
			16 : ATTACK_MOUNT, 
			17 : INJURED_MOUNT, 
			18 : STAND_SWIM_ABOVE, 
			19 : WALK_SWIM_ABOVE, 
			20 : INJURED_SWIM_ABOVE, 
			21 : ATTACK_1, 
			22 : ATTACK_2, 
			23 : ATTACK_3, 
			24 : ATTACK_4, 
			25 : ATTACK_5, 
			26 : ATTACK_6, 
			27 : ATTACK_7, 
			28 : ATTACK_8, 
			29 : ATTACK_9, 
			30 : ATTACK_10, 
			31 : ATTACK_MOUNT_1, 
			32 : ATTACK_MOUNT_2, 
			33 : ATTACK_MOUNT_3, 
			34 : ATTACK_MOUNT_4, 
			35 : ATTACK_MOUNT_5 
		};
		
		public static const status_fm:Object = { 
			0 : IDLE1, 
			1 : IDLE2, 
			2 : STAND, 
			3 : WALK, 
			4 : ATTACK, 
			5 : INJURED, 
			6 : SIT, 
			7 : SHUANG_XIU, 
			8 : DEATH, 
			9 : JUMP, 
			10 : STAND_SWIM, 
			11 : WALK_SWIM,
			12 : INJURED_SWIM, 
			13 : DEATH_SWIM, 
			14 : STAND_MOUNT, 
			15 : WALK_MOUNT, 
			16 : ATTACK_MOUNT, 
			17 : INJURED_MOUNT, 
			18 : STAND_SWIM_ABOVE, 
			19 : WALK_SWIM_ABOVE, 
			20 : INJURED_SWIM_ABOVE, 
			21 : ATTACK_1, 
			22 : ATTACK_2, 
			23 : ATTACK_3, 
			24 : ATTACK_4, 
			25 : ATTACK_5, 
			26 : ATTACK_6, 
			27 : ATTACK_7, 
			28 : ATTACK_8, 
			29 : ATTACK_9, 
			30 : ATTACK_10, 
			31 : ATTACK_MOUNT_1, 
			32 : ATTACK_MOUNT_2, 
			33 : ATTACK_MOUNT_3, 
			34 : ATTACK_MOUNT_4, 
			35 : ATTACK_MOUNT_5,
			36:JUMP2,
			37:REPEL,
			38:ATTACK_BACK1,
			39:ATTACK_BACK2,
			40:ATTACK_BACK3
		};
		public static const STAND_FLY:String = "stand_fly";
		public static const WALK_FLY:String = "walk_fly";
		public static const UP_FLY:String = "up_fly";
		public static const DOWN_FLY:String = "down_fly";
		
		public static const status_fs2:Object = { 
			0 : IDLE1, 
			1 : IDLE2, 
			2 : STAND, 
			3 : WALK, 
			4 : ATTACK, 
			5 : INJURED, 
			6 : SIT, 
			7 : SHUANG_XIU, 
			8 : DEATH, 
			9 : JUMP, 
			10 : STAND_SWIM, 
			11 : WALK_SWIM,
			12 : INJURED_SWIM, 
			13 : DEATH_SWIM, 
			14 : STAND_MOUNT, 
			15 : WALK_MOUNT, 
			16 : ATTACK_MOUNT, 
			17 : INJURED_MOUNT, 
			18 : STAND_SWIM_ABOVE, 
			19 : WALK_SWIM_ABOVE, 
			20 : INJURED_SWIM_ABOVE, 
			21 : ATTACK_1, 
			22 : ATTACK_2, 
			23 : ATTACK_3, 
			24 : ATTACK_4, 
			25 : ATTACK_5, 
			26 : ATTACK_6, 
			27 : ATTACK_7, 
			28 : ATTACK_8, 
			29 : ATTACK_9, 
			30 : ATTACK_10, 
			31 : ATTACK_MOUNT_1, 
			32 : ATTACK_MOUNT_2, 
			33 : ATTACK_MOUNT_3, 
			34 : ATTACK_MOUNT_4, 
			35 : ATTACK_MOUNT_5,
			37 : STAND_IN_FIGHT,
			38 : ATTACK_MOUNT_6, 
			39 : ATTACK_MOUNT_7, 
			40 : ATTACK_MOUNT_8, 
			41 : ATTACK_MOUNT_9, 
			42 : ATTACK_MOUNT_10,
			43 : STAND_FLY,
			44 : WALK_FLY,
			45 : UP_FLY,
			46 : DOWN_FLY
		};
		
	}
}