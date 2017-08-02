package _Pan3D.skill
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import _Pan3D.display3D.Display3D;
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3DMovie;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.display3D.MovieAction;
	import _Pan3D.display3D.interfaces.IAbsolute3D;
	import _Pan3D.event.LoadCompleteEvent;
	import _Pan3D.event.PlayEvent;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.FlyerEvent;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.skill.custom.PathManager;
	import _Pan3D.skill.effect.EffectDynamicSkill;
	import _Pan3D.skill.effect.EffectFiexSkill;
	import _Pan3D.skill.effect.EffectSkill;
	import _Pan3D.skill.interfaces.ISkill;
	import _Pan3D.skill.traject.Trajectory;
	import _Pan3D.skill.traject.TrajectoryCustom;
	import _Pan3D.skill.traject.TrajectoryDynamicPoint;
	import _Pan3D.skill.traject.TrajectoryFiexPoint;
	import _Pan3D.skill.traject.TrajectoryTarget;
	import _Pan3D.skill.vo.EnumSkillKeyType;
	import _Pan3D.skill.vo.ParamPoint;
	import _Pan3D.skill.vo.ParamTarget;
	import _Pan3D.skill.vo.SkillKeyVo;
	import _Pan3D.skill.vo.SkillTimeLineVo;
	import _Pan3D.skill.vo.effect.EffectSkillVo;
	import _Pan3D.skill.vo.traject.TrajectoryVo;
	
	import _me.Scene_data;
	
	/**
	 * 技能对象
	 * 技能对象对应的时间轴 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class SkillTimeLine extends EventDispatcher
	{
		/**
		 * 唯一ID 
		 */		
		public var id:uint;
		/**
		 * 动作名称 
		 */		
		public var actionName:String;
		//private var _targetX:int;
//		private var keyFrameAry:Vector.<SkillKeyFrame>;
		//private var renderAry:Vector.<SkillKeyFrame>;
		public var frame:int;
		private var _time:Number=0;
		private var _completeNum:int;
		
		public var activeRole:IAbsolute3D;
		public var targetRole:Display3dGameMovie;
		
		/**
		 * 标记此技能线程是否处于死亡状态（重复利用） 
		 */		
		public var isDeath:Boolean;
		
		public var targetFlag:int;
		
		public var particleContainer:Display3DContainer;
		
		/**
		 * 关键帧对象 
		 */		
		private var _keyFrameVec:Vector.<ISkill>;
		/**
		 * 目标列表数组 
		 */		
		private var _targetVec:Vector.<ParamTarget>;
		/**
		 * 目标点数组 
		 */		
		private var _targetPointVec:Vector.<ParamPoint>;
		/**
		 * 技能自身配置信息 
		 */		
		private var _voInfo:SkillTimeLineVo;
		/**
		 * 技能需要的配置类型 
		 */		
		private var _configType:int;
		/**
		 * 正在播放的弹道列表 
		 */		
		private var trajectoryList:Vector.<Trajectory> = new Vector.<Trajectory>;
		/**
		 * 技能播放完成的回调函数 
		 */		
		private var _completeCallBack:Function;
		/**
		 * 强制播放的技能 
		 */		
		private var _enforceActionName:String;
		/**
		 * 是否已经配置 
		 */		
		private var _hasConfig:Boolean;
		/**
		 * 是否装载数据 
		 */		
		private var _hasInfo:Boolean;
		
		private var _cachePool:Vector.<ISkill>;
		
		public var idleTime:int;
		
		private var _visible:Boolean = true;
		/**
		 * 特殊类型 
		 */		
		private var _specialType:int = -1;
		
		private var _hasDispose:Boolean;
		
		public var showPriority:int = 0;
		
		public var isShock:Boolean = false;
		
		private var _bloodTime:int;
		
		public var isblood:Boolean = false;
		
		public function SkillTimeLine()
		{
			super();
			_keyFrameVec = new Vector.<ISkill>;
			_cachePool = new Vector.<ISkill>;
		}
		

		/**
		 * 刷帧逻辑 
		 * @param t
		 * 
		 */		
		public function update(t:Number):void{
			_time += t;
			getKeyTarget();
			//getShock();
			getBlood();
			frame = _time/Scene_data.frameTime;
			
			for(var i:int;i<trajectoryList.length;i++){
				trajectoryList[i].update(t);
			}
			
			if(_time > 1000 * 30){
				timeOutStop();
			}
		}
		
		public function getShock():void{
			if(!isShock && _voInfo && _voInfo.shockVo && Boolean(Scene_data.shockFun)){
				if(_time >= _voInfo.shockVo.beginTime){
					Scene_data.shockFun(_voInfo.shockVo.time,_voInfo.shockVo.amplitude);
					isShock = true;
				}
			}
		}
		
		public function getBlood():void{
			if(!isblood && Boolean(this.bloodFun) && this._voInfo.bloodVo){
				if(_time >= this._bloodTime){
					//弹出掉血
					this.bloodFun(this._voInfo.bloodVo.pos);
					isblood = true;
				}
			}
		}
		
		private function getKeyTarget():void{
			for(var i:int = targetFlag;i<_keyFrameVec.length;){
				if(_keyFrameVec[i].frame*Scene_data.frameTime < _time){
					_keyFrameVec[i].addToRender(_time - _keyFrameVec[i].frame*Scene_data.frameTime);
					if(_keyFrameVec[i] is Trajectory)
						trajectoryList.push(_keyFrameVec[i]);
					i++;
					targetFlag = i;
					//trace(_time)
				}else{
					break;
				}
			}
		}
		
//		private function getTarget():void{
//			for(var i:int = targetFlag;i<keyFrameAry.length;){
//				if(keyFrameAry[i].frameNum*Scene_data.frameTime < _time){
//					if(!keyFrameAry[i].bindFly){
//						keyFrameAry[i].addToRender(_time);
//						
//					}
//					i++;
//					targetFlag = i;
//				}else{
//					break;
//				}
//			}
//		}
		
		public function reset():void{
			_time = 0;
			for(var i:int;i<_keyFrameVec.length;i++){
				_keyFrameVec[i].reset();
			}
			trajectoryList.length = 0;
			frame = 0;
			targetFlag = 0;
			_completeNum = 0;
			isShock = false;
			//_hasConfig = false;
			//resetCache();
			isblood = false;
			isDeath = false;
		}
		
		public function stop():void{
			_time = 0;
			for(var i:int;i<_keyFrameVec.length;i++){
				_keyFrameVec[i].stop();
			}
			trajectoryList.length = 0;
			frame = 0;
			targetFlag = 0;
			_completeNum = 0;
			//_hasConfig = false;
			//resetCache();
			isDeath = true;
		}
		/**
		 * 超时自动停止 
		 * 
		 */		
		public function timeOutStop():void{
			stop();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function resetCache():void{
			
			if(_hasDispose){
				return;
			}
			
			for(var i:int;i<_cachePool.length;i++){
				_cachePool[i].used = false;
				_cachePool[i].reset();
			}
		}
		
/*		public function reset():void{
			_time = 0;
			for(var i:int;i<keyFrameAry.length;i++){
				keyFrameAry[i].reset();
			}
			frame = 0;
			targetFlag = 0;
			_completeNum = 0;
		}*/
		
		public function clearReset():void{
			activeRole = null;
			targetRole = null;
			reset();
		}
		/**
		 * 播放技能 
		 * 
		 */		
		public function play():void{
			this.reset();
			if(activeRole){
//				var role:Display3DMovie = activeRole as Display3DMovie;
//				if(role){
//					if(_enforceActionName == ""){
//						role.play(actionName,2);
//					}else{
//						role.play(_enforceActionName,2);
//					}
//					
//				}
			}
			if(_voInfo){
				ParticleManager.getInstance().uploadParticleByUrl(_voInfo.urlList);
			}
		}
		
		public var bloodFun:Function;
		/**
		 * 刷入外部数据，设置所有信息
		 * @param obj 
		 * 
		 */		
		public function setAllInfo(obj:SkillTimeLineVo):void{
			actionName = obj.action;

			
			_voInfo = obj;
			_hasInfo = true;
			if(_hasConfig){
				configTrajectoryEffect();
			}
			
			//this._bloodTime = obj.bloodTime;
			
			if(obj.bloodVo){
				this._bloodTime = obj.bloodVo.time;
			}

		}
		
		public function getParticleUrl():Vector.<String>{
			return _voInfo.urlList;
		}
		
		/**
		 * 移除已经播放完成的弹道 
		 * @param trajectory
		 * 
		 */		
		private function removeKeySkill(keySkill:ISkill):void{
			var index:int = trajectoryList.indexOf(keySkill);
			if(index != -1){
				trajectoryList.splice(index,1);
			}
			_completeNum++;
			if(_completeNum == _keyFrameVec.length){
				//trace("技能播放完成");
				if(Boolean(_completeCallBack)){
					_completeCallBack();
				}
				isDeath = true;
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 根据初始数据 和动态数据配置最终技能时间轴信息 
		 * 
		 */		
		private function configTrajectoryEffect():void{
			if(!_hasInfo){
				return;
			}
			resetCache();
			_keyFrameVec.length = 0;
			var trajectory:Trajectory;
			var effectSkill:EffectSkill;
			var j:int = 0;
			for(var i:int;i<_voInfo.infoVec.length;i++){
				if(_voInfo.infoVec[i].type == EnumSkillKeyType.TRAJECTORY){
					if(_configType == 1){
						if(_specialType != -1){
							for(j=0;j<_targetVec.length;j++){
								trajectory = getKeySkill(_voInfo.infoVec[i],_specialType) as Trajectory;
								if(trajectory is TrajectoryCustom){
									var keySkillCustom:TrajectoryCustom = trajectory as TrajectoryCustom;
									//keySkillCustom.pathCls = PathManager.getPath(_specialType);
									keySkillCustom.target = _targetVec[j].target;
									keySkillCustom.targetParam = _targetVec[j].targetParam;//添加目标参数配置
									keySkillCustom.active = activeRole;
									keySkillCustom.addFrame = _targetVec[j].timeout/Scene_data.frameTime;
									keySkillCustom.completeFun = _targetVec[j].callBackFun;
									keySkillCustom.removeCallFun = removeKeySkill;
									_keyFrameVec.push(keySkillCustom);
								}else {
									trace("数据和传入参数不一致a");
								}
							}
						}else{
							for(j=0;j<_targetVec.length;j++){
								trajectory = getKeySkill(_voInfo.infoVec[i]) as Trajectory;
								if(trajectory is TrajectoryTarget){
									var keySkill:TrajectoryTarget = trajectory as TrajectoryTarget;
									keySkill.target = _targetVec[j].target;
									keySkill.active = activeRole;
									keySkill.addFrame = _targetVec[j].timeout/Scene_data.frameTime;
									keySkill.completeFun = _targetVec[j].callBackFun;
									keySkill.removeCallFun = removeKeySkill;
									_keyFrameVec.push(keySkill);
								}else {
									trace("数据和传入参数不一致b");
								}
							}
						}
						
						
					}else if(_configType == 2){
						//trajectory = Trajectory.getTrajectory(_voInfo.infoVec[i] as TrajectoryVo);
						trajectory = getKeySkill(_voInfo.infoVec[i]) as Trajectory;
						if(trajectory is TrajectoryFiexPoint){
							var keySkillFiexPoint:TrajectoryFiexPoint = trajectory as TrajectoryFiexPoint;
							keySkillFiexPoint.active = activeRole;
							//keySkillFiexPoint.frame += _targetVec[j].timeout;
							keySkillFiexPoint.removeCallFun = removeKeySkill;
							_keyFrameVec.push(keySkillFiexPoint);
						}else{
							trace("数据和传入参数不一致c");
						}
					}else if(_configType == 3){
						
						if(_specialType != -1){
							for(j=0;j<_targetPointVec.length;j++){
								trajectory = getKeySkill(_voInfo.infoVec[i],_specialType) as Trajectory;
								if(trajectory is TrajectoryCustom){
									keySkillCustom = trajectory as TrajectoryCustom;
									//keySkillCustom.pathCls = PathManager.getPath(_specialType);
									keySkillCustom.target = _targetPointVec[j].targetAbsolute;
									keySkillCustom.active = activeRole;
									keySkillCustom.addFrame = _targetPointVec[j].timeout/Scene_data.frameTime;
									keySkillCustom.completeFun = _targetPointVec[j].callBackFun;
									keySkillCustom.removeCallFun = removeKeySkill;
									_keyFrameVec.push(keySkillCustom);
								}else {
									trace("数据和传入参数不一致d");
								}
							}
						}else{
							for(j=0;j<_targetPointVec.length;j++){
								//trajectory = Trajectory.getTrajectory(_voInfo.infoVec[i] as TrajectoryVo);
								trajectory = getKeySkill(_voInfo.infoVec[i]) as Trajectory;
								if(trajectory is TrajectoryDynamicPoint){
									var keySkillDynamicPoint:TrajectoryDynamicPoint = trajectory as TrajectoryDynamicPoint;
									keySkillDynamicPoint.active = activeRole;
									keySkillDynamicPoint.targetV3d = _targetPointVec[j].targetV3d;
									keySkillDynamicPoint.addFrame = _targetPointVec[j].timeout/Scene_data.frameTime;
									keySkillDynamicPoint.completeFun = _targetPointVec[j].callBackFun;
									keySkillDynamicPoint.removeCallFun = removeKeySkill;
									_keyFrameVec.push(keySkillDynamicPoint);
								}else{
									trace("数据和传入参数不一致e");
								}
							}
						}
					}else{
						trace("数据和传入参数不一致f");
					}
				}else if(_voInfo.infoVec[i].type == EnumSkillKeyType.EFFECT){
					if(_configType == 4){
						//effectSkill = EffectSkill.getEffectSkill(_voInfo.infoVec[i] as EffectSkillVo);
						effectSkill = getKeySkill(_voInfo.infoVec[i]) as EffectSkill;
						if(effectSkill is EffectFiexSkill){
							var keySkillFiexEffect:EffectFiexSkill = effectSkill as EffectFiexSkill;
							keySkillFiexEffect.active = activeRole;
							//keySkillFiexPoint.frame += _targetVec[j].timeout;
							keySkillFiexEffect.removeCallFun = removeKeySkill;
							_keyFrameVec.push(keySkillFiexEffect);
						}else{
							trace("数据和传入参数不一致g");
						}
					}else if(_configType == 5){
						for(j=0;j<_targetPointVec.length;j++){
							//effectSkill = EffectSkill.getEffectSkill(_voInfo.infoVec[i] as EffectSkillVo);
							effectSkill = getKeySkill(_voInfo.infoVec[i]) as EffectSkill;
							if(effectSkill is EffectDynamicSkill){
								var keySkillDynamicEffcet:EffectDynamicSkill = effectSkill as EffectDynamicSkill;
								keySkillDynamicEffcet.targetV3d = _targetPointVec[j].targetV3d;
								keySkillDynamicEffcet.addFrame(_targetPointVec[j].timeout/Scene_data.frameTime);
								keySkillDynamicEffcet.completeFun = _targetPointVec[j].callBackFun;
								keySkillDynamicEffcet.removeCallFun = removeKeySkill;
								_keyFrameVec.push(keySkillDynamicEffcet);
							}else{
								trace("数据和传入参数不一致h");
							}
							
						}
					}else{
						trace("未知的数据类型");
					}
				}       
			}
			
			_keyFrameVec.sort(sort);
			_completeNum = 0;
			addLoadEvent();
			this.visible = _visible;
		}
		
		private var sourceNum:int;
		private var allSourceNum:int;
		public var hasLoadAll:Boolean;
		private var loadDic:Object = new Object;
		private function addLoadEvent():void{
			if(hasLoadAll){
				return;
			}
			sourceNum = 0;
			for(var i:int;i<_keyFrameVec.length;i++){
				if(!loadDic[Object(_keyFrameVec[i]).data.particleUrl]){
					allSourceNum++;
					EventDispatcher(_keyFrameVec[i]).addEventListener(LoadCompleteEvent.LOAD_COMPLETE,onSourceLoadCom);
					loadDic[Object(_keyFrameVec[i]).data.particleUrl] = true;
				}
			}
		}
		
		private function onSourceLoadCom(evt:LoadCompleteEvent):void{
			evt.target.removeEventListener(LoadCompleteEvent.LOAD_COMPLETE,onSourceLoadCom);
			sourceNum++;
			
			if(sourceNum == allSourceNum){
				this.dispatchEvent(new LoadCompleteEvent(LoadCompleteEvent.LOAD_COMPLETE));
				hasLoadAll = true;
			}
		}
		
		private function getKeySkill(skillKeyVo:SkillKeyVo,$specialType:int = -1):ISkill{
			for(var i:int;i<_cachePool.length;i++){
				if(!_cachePool[i].used){
					_cachePool[i].used = true;
					return _cachePool[i];
				}
			}
			var keySkill:ISkill;
			if(skillKeyVo.type == EnumSkillKeyType.TRAJECTORY){
				keySkill = Trajectory.getTrajectory(skillKeyVo as TrajectoryVo,$specialType,particleContainer);
			}else if(skillKeyVo.type == EnumSkillKeyType.EFFECT){
				keySkill = EffectSkill.getEffectSkill(skillKeyVo as EffectSkillVo,particleContainer);
			}
			_cachePool.push(keySkill);
			keySkill.used = true;
			return keySkill;
		}
		
		/**
		 * 关键帧按帧数排序函数
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		private function sort(a:ISkill,b:ISkill):int{
			if(a.frame > b.frame){
				return 1;
			}else if(a.frame < b.frame){
				return -1;
			}else{
				return 0;
			}
		}
		
//		private function getFlyBykey(str:String):SkillKeyFrame{
//			for(var i:int;i<keyFrameAry.length;i++){
//				if(keyFrameAry[i].info.fly && keyFrameAry[i].info.fly.idStr == str){
//					return keyFrameAry[i];
//				}
//			}
//			return null;
//		}
		/**
		 * 加载技能 
		 * @param url 技能路径
		 * 
		 */		
		private var _url:String;
		public function load(url:String):void{
			_url = url;
			//url = "../../res/data/res3d_2/skill/10.zzwskill"
			var loaderinfo : LoadInfo = new LoadInfo(url, LoadInfo.BYTE, onSkillLoad,SkillManager.priority);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		/**
		 * 技能加载完成 
		 * @param byte
		 * 
		 */		
		private function onSkillLoad(byte:ByteArray):void{
			skillObj = byte.readObject();
			//setAllInfo(obj);
			var vo:SkillTimeLineVo = new SkillTimeLineVo();
			vo.setInfo(skillObj);
			
			setAllInfo(vo);
		}
		
		public function loadObj(obj:Object):void{
			skillObj = obj;
			//setAllInfo(obj);
			var vo:SkillTimeLineVo = new SkillTimeLineVo();
			vo.setInfo(skillObj);
			
			setAllInfo(vo);
		}
		
		public var skillObj:Object;
		
//		private function onPlayCom(event:Event):void{
//			_completeNum++;
//			if(_completeNum == keyFrameAry.length){
//				this.dispatchEvent(event);
//				isDeath = true;
//			}
//			if(_completeNum > keyFrameAry.length){
//				trace(this.id)
//			}
//		}
		
		public function clone():SkillTimeLine{
			var skillTimeLine:SkillTimeLine = new SkillTimeLine();
			
			skillTimeLine.actionName = actionName;
			
//			for(var i:int;i<keyFrameAry.length;i++){
//				var keyFrame:SkillKeyFrame = keyFrameAry[i].clone()
//				skillTimeLine.keyFrameAry.push(keyFrame);
//				keyFrame.parent = skillTimeLine;
//			}
			//skillTimeLine.resetRelation();
			//trace("_completeNum " + skillTimeLine._completeNum)
			return skillTimeLine;
		}
		/**
		 * 配置动态目标（弹道跟随） (showType=1)
		 * @param $activeRole 出手者
		 * @param $targetVec 目标者数组
		 * @param $completeCallBack 播放完成回调函数
		 * @param $action 角色动作
		 * @param $specialType 特殊弹道类型 -1 为默认没有特殊 
		 */				
		public function configTaget($activeRole:IAbsolute3D,$targetVec:Vector.<ParamTarget>,$completeCallBack:Function=null,$action:String="",$specialType:int = -1):void{
			this.activeRole = $activeRole;
			this._targetVec = $targetVec;
			_configType = 1;
			_specialType = $specialType;
			configTrajectoryEffect();
			_enforceActionName = $action;
			_completeCallBack = $completeCallBack;
			_hasConfig = true;
		}
		/**
		 * 配置固定点 (showType=2)
		 * @param $activeRole 出手点
		 * @param $completeCallBack 播放完成回调函数
		 * @param $action 角色动作 
		 */		
		public function configFixPoint($activeRole:IAbsolute3D,$completeCallBack:Function=null,$action:String=""):void{
			this.activeRole = $activeRole;
			_configType = 2;
			configTrajectoryEffect();
			_enforceActionName = $action;
			_completeCallBack = $completeCallBack;
			_hasConfig = true;
		}
		/**
		 * 配置动态目标点 (showType=3)
		 * @param $activeRole 出手点
		 * @param $targetPointVec 目标点数组
		 * @param $completeCallBack 播放完成回调函数
		 * @param $action 角色动作
		 * @param $specialType 特殊弹道类型 -1 为默认没有特殊 
		 */		
		public function configDynamicPoint($activeRole:IAbsolute3D,$targetPointVec:Vector.<ParamPoint>,$completeCallBack:Function=null,$action:String="",$specialType:int = -1):void{
			this.activeRole = $activeRole;
			this._targetPointVec = $targetPointVec;
			_configType = 3;
			_specialType = $specialType;
			configTrajectoryEffect();
			_enforceActionName = $action;
			_completeCallBack = $completeCallBack;
			_hasConfig = true;
		}
		/**
		 * 配置固定点效果 (showType=4)
		 * @param $activeRole 出手点
		 * @param $completeCallBack 播放完成回调函数
		 * @param $action 角色动作
		 */		
		public function configFiexEffect($activeRole:IAbsolute3D,$completeCallBack:Function=null,$action:String=""):void{
			this.activeRole = $activeRole;
			_configType = 4;
			configTrajectoryEffect();
			_enforceActionName = $action;
			_completeCallBack = $completeCallBack;
			_hasConfig = true;
		}
		/**
		 * 配置动态点效果 (showType=5)
		 * @param $targetPointVec 目标点
		 * @param $completeCallBack 播放完成回调函数
		 * @param $action 角色动作 
		 */		
		public function configDynamicEffect($targetPointVec:Vector.<ParamPoint>,$completeCallBack:Function=null,$action:String=""):void{
			this._targetPointVec = $targetPointVec;
			_configType = 5;
			configTrajectoryEffect();
			_enforceActionName = $action;
			_completeCallBack = $completeCallBack;
			_hasConfig = true;
		}
		
		public function reload():void{
			for(var i:int;i<_keyFrameVec.length;i++){
				_keyFrameVec[i].reload();
			}
		}
		
		public function dispose():void{
			for(var i:int;i<_cachePool.length;i++){
				_cachePool[i].dispose();
			}
			
			
			_keyFrameVec.length = 0;
			_keyFrameVec = null;
			_cachePool.length = 0;
			_cachePool = null;
			
			for(i=0;i<trajectoryList.length;i++){
				trajectoryList[i].dispose();
			}
			trajectoryList.length = 0;
			trajectoryList = null;
			
			
			actionName = null;
			
			activeRole = null;
			targetRole = null;
			
			if(_targetVec){
				for(i=0;i<_targetVec.length;i++){
					_targetVec[i].dispose();
				}
				_targetVec.length = 0;
				_targetVec = null;
			}
			
			if(_targetPointVec){
				for(i=0;i<_targetPointVec.length;i++){
					_targetPointVec[i].dispose();
				}
				_targetPointVec.length = 0;
				_targetPointVec = null;
			}
			
			_voInfo = null;
				
			_completeCallBack = null;
			 _enforceActionName = null;
			loadDic = null;
			
			skillObj = null;
			
			particleContainer = null;
			
			_hasDispose = true;
		}

		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			_visible = value;
			for(var i:int=0;i<_keyFrameVec.length;i++){
				_keyFrameVec[i].visible = _visible;
			}
		}
		
		
	}
}