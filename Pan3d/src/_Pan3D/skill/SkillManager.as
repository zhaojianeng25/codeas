package _Pan3D.skill
{
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.particle.ctrl.TimeLine;
	import _Pan3D.skill.custom.PathManager;
	import _Pan3D.ui.UIComponent3D;
	import _Pan3D.utils.Log;
	import _Pan3D.utils.Tick;
	import _Pan3D.utils.TickTime;
	
	import _me.Scene_data;
	
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class SkillManager
	{
		private static var _instance:SkillManager;
		
		public static var priority:int = 205;
		
		private var _skillAry:Vector.<SkillTimeLine>;
		private var _time:int;
		private var dic:Object;
		
		public var showNum:int;
		public var otherShowNum:int;
		
		public function SkillManager()
		{
			_skillAry = new Vector.<SkillTimeLine>;
			//Tick.addCallback(update);
			_time = getTimer();
			dic = new Object;
			TickTime.addCallback(dispose);
			
			PathManager.reg();
		}
		public static function getInstance():SkillManager{
			if(!_instance){
				_instance = new SkillManager;
			}
			return _instance;
		}
		/**
		 * 技能播放 
		 * @param skill 要播放的技能
		 * @param visible 是否显示该技能
		 * 
		 */		
		
		private var tempt:int;
		public function playSkill(skill:SkillTimeLine,visible:Boolean = true):void{
			tempt = getTimer();
			skill.visible = visible;
			skill.play();
			removeSkill(skill);
			_skillAry.push(skill);
			skill.addEventListener(Event.COMPLETE,onSkillCom);
		}
		
		public function start():void{
			_time = getTimer();
		}
		
		/**
		 * 技能播放完成，从系统中移除技能 
		 * @param event
		 * 
		 */		
		protected function onSkillCom(event:Event):void{
			//event.target.play();
			//trace("end skill id: " + event.target.id)
			removeSkill(event.target);
			
			//trace("技能播放时间：" + (getTimer() - tempt));
		}
		/**
		 * 移除技能 
		 * @param skill 要移除的技能
		 * 
		 */		
		public function removeSkill(skill:*):void{
			var index:int = _skillAry.indexOf(skill);
			if(index != -1){
				_skillAry.splice(index,1);
			}
			skill.removeEventListener(Event.COMPLETE,onSkillCom);
		}
		/**
		 * 驱动技能播放控制 
		 */		
		public function update():void{
			var t:int = getTimer();
			var time:int = t - _time;
			
			showNum = 0;
			otherShowNum = 0;
			
			for(var i:int;i<_skillAry.length;i++){
				
				if(_skillAry[i].showPriority < 0){
					otherShowNum++;
				}else{
					showNum++;
				}
				
				_skillAry[i].update(time);
			}
			_time = t;
			
			//trace("当前正在播放技能个数 " + showNum  + "," + otherShowNum + " " + _skillAry.length);
		}
		
		public function getCurrentNum():int{
			var num:int;
			for(var i:int;i<_skillAry.length;i++){
				if(_skillAry[i].showPriority >= 0){
					num++;
				}
			}
			return num;
		}
		
		public function getNegativeNum():int{
			var num:int;
			for(var i:int;i<_skillAry.length;i++){
				if(_skillAry[i].showPriority < 0){
					num++;
				}
			}
			return num;
		}
		/**
		 * 获取一个技能对象 
		 * @param url 技能路径
		 * @return 技能对象
		 * 
		 */		
		public function getSkill(url:String,uiContainer:Display3DContainer=null):SkillTimeLine{
			var skill:SkillTimeLine;
			if(dic[url]){
				var ary:Vector.<SkillTimeLine> = dic[url];
				for(var i:int;i<ary.length;i++){
					skill = ary[i];
					if(ary[i].isDeath && skill.particleContainer == uiContainer){
						skill.reset();
						return skill;
					}
				}
				var skilldata:Object = skill.skillObj;
				skill = new SkillTimeLine();
				skill.particleContainer = uiContainer;
				skill.hasLoadAll = true;
				if(skilldata){
					skill.loadObj(skilldata);
				}else{
					skill.load(url);
				}
				
				ary.push(skill);
				return skill;
			}else{
				dic[url] = new Vector.<SkillTimeLine>;
				skill = new SkillTimeLine();
				skill.particleContainer = uiContainer;
				skill.load(url);
				dic[url].push(skill);
				return skill;
			}
		}
		
		public function hasSkill(url:String):Boolean{
			return dic.hasOwnProperty(url)
		}
		
		public function removeAll():void{
			for(var i:int = _skillAry.length-1;i >= 0;i--){
				_skillAry[i].stop();
			}
			_skillAry.length = 0;
		}
		/**
		 * 停止指定容器类型的所有技能 
		 * 
		 */		
		public function stopAllSkillByContainerType($type:int):void{
			var $container:Display3DContainer = UIComponent3D.getRegContainer($type)
			if($container){
				for(var i:int = _skillAry.length-1;i >= 0;i--){
					if(_skillAry[i].particleContainer == $container){
						_skillAry[i].stop();
						_skillAry.splice(i,1);
					}
				}
			}
		}
		
		/**
		 * 重新装载 
		 * 
		 */		
		public function reload():void{
			for(var key:String in dic){
				var skill:SkillTimeLine;
				var ary:Vector.<SkillTimeLine> = dic[key];
				for(var i:int=0;i<ary.length;i++){
					skill = ary[i];
					skill.reload();
				}
			}
		}
		private var flag:int;
		public function dispose():void{
			var allSkillNum:int;
			var allUseSkillNum:int;
			for(var key:String in dic){
				var ary:Vector.<SkillTimeLine>  = dic[key];
				
				allSkillNum++;
				
				var hasUse:Boolean = false;
				
				for(var j:int=0;j<ary.length;j++){
					if(ary[j].isDeath){
						ary[j].idleTime++;
					}else{
						ary[j].idleTime = 0;
						hasUse = true;
					}
					
					if(ary[j].idleTime > Scene_data.cacheSkillTime){
						ary[j].dispose();
						ary.splice(j,1);
						break;
					}
				}
				
				if(hasUse){
					allUseSkillNum++;
				}
				
				if(ary.length == 0){
					delete dic[key];
				}
					
			}
			
			if(allSkillNum > 20){
				Scene_data.cacheSkillTime = 300;
			}else{
				Scene_data.cacheSkillTime = 600;
			}
			
			flag++;
			if(flag == Log.logTime){
				flag = 0;
				for(key in dic){
					ary  = dic[key];
					Log.add(key + " 使用个数：" +ary.length)
				}
				Log.add("^^^^^^^^^^^^^^^^^^^^^^^^^skill分割线^^^^^^^^^^^^^^^^^^^^^^^^^^^" + "所有技能数量" + allSkillNum + "正在使用的技能数" +　allUseSkillNum + "空闲技能" + (allSkillNum-allUseSkillNum));
			}
			
			
		}
		
		public function getAllIdleParticleList():Vector.<String>{
			var strAry:Vector.<String> = new Vector.<String>;
			
			for(var key:String in dic){
				
				var ary:Vector.<SkillTimeLine>  = dic[key];
				
				var hasUse:Boolean = false;
				
				for(var j:int=0;j<ary.length;j++){
					if(!ary[j].isDeath){
						hasUse = true;
						break;
					}
				}
				
				var skill:SkillTimeLine;
				
				if(ary.length){
					skill = ary[0];
				}
				
				if(!hasUse){
					strAry.concat(skill.getParticleUrl());
				}
				
			}
			return strAry;
		}
		/**
		 * 卸载所有空闲的粒子 
		 * 
		 */		
		public function unloadAllIdleParticle():void{
			var strAry:Vector.<String> = new Vector.<String>;
			
			for(var key:String in dic){
				
				var ary:Vector.<SkillTimeLine>  = dic[key];
				
				var hasUse:Boolean = false;
				
				for(var j:int=0;j<ary.length;j++){
					if(!ary[j].isDeath){
						hasUse = true;
						break;
					}
				}
				
				var skill:SkillTimeLine;
				
				if(ary.length){
					skill = ary[0];
				}
				
				if(!hasUse){
					strAry = strAry.concat(skill.getParticleUrl());
				}
				
			}
			
			ParticleManager.getInstance().unloadParticleByUrl(strAry);
			
			Log.add("清理所有空闲技能");
		}
		
		
	}
}