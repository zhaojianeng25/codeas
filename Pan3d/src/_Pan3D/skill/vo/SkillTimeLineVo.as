package _Pan3D.skill.vo
{
	import _Pan3D.skill.vo.effect.EffectSkillVo;
	import _Pan3D.skill.vo.traject.EnumTrajectoryType;
	import _Pan3D.skill.vo.traject.TrajectoryDynamicPointVo;
	import _Pan3D.skill.vo.traject.TrajectoryDynamicTargetVo;
	import _Pan3D.skill.vo.traject.TrajectoryFiexPointVo;
	import _Pan3D.skill.vo.traject.TrajectoryVo;
	
	import _me.Scene_data;

	/**
	 * 技能时间轴数据 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class SkillTimeLineVo
	{
		/**
		 * 动作名称 
		 */		
		public var action:String;
		/**
		 * 关键帧列表 
		 */		
		public var infoVec:Vector.<SkillKeyVo>;
		
		public var urlList:Vector.<String>;
		
		public var shockVo:ShockVo;
		
		public var bloodVo:BloodVo;
		
		public function SkillTimeLineVo()
		{
		}
		
		/**
		 * 设置信息 
		 * @param obj
		 * 
		 */		
		public function setInfo(obj:Object):void{
			action = obj.action;
			
			if(obj.shock){
				shockVo = new ShockVo(obj.shock);
			}else{
				shockVo = null;
			}
			
			var ary:Array = obj.infoAry;
			
			infoVec = new Vector.<SkillKeyVo>;
			
			urlList = new Vector.<String>;
			
			for(var i:int;i < ary.length;i++){
				var data:Object;
				if(ary[i].type == EnumSkillKeyType.TRAJECTORY){//弹道类
					
					data = ary[i].data;
					
					var trajectoryVo:TrajectoryVo;
					if(data.type == EnumTrajectoryType.dynamicTarget){
						trajectoryVo = new TrajectoryDynamicTargetVo;
						addUrl(TrajectoryDynamicTargetVo(trajectoryVo).endParticleUrl);
					}else if(data.type == EnumTrajectoryType.FixedPoint){
						trajectoryVo = new TrajectoryFiexPointVo;
					}else if(data.type == EnumTrajectoryType.dynamicPoint){
						trajectoryVo = new TrajectoryDynamicPointVo
					}
					addUrl(trajectoryVo.particleUrl);
					trajectoryVo.type = EnumSkillKeyType.TRAJECTORY;
					trajectoryVo.frame = ary[i].frameNum;
					trajectoryVo.setInfo(data);
					
					infoVec.push(trajectoryVo);
				}else if(ary[i].type == EnumSkillKeyType.EFFECT){//效果类
					data = ary[i].data;
					
					var effectVo:EffectSkillVo = new EffectSkillVo;
					effectVo.type = EnumSkillKeyType.EFFECT;
					effectVo.frame = ary[i].frameNum;
					effectVo.setInfo(data);
					
					addUrl(effectVo.particleUrl);
					
					infoVec.push(effectVo);
				}
				
			}
			
			//this.bloodTime = obj.blood * Scene_data.frameTime;
			if(obj.blood){
				this.bloodVo = new BloodVo();
				this.bloodVo.setData(obj.blood);
			}else{
				this.bloodVo = null;
			}
			
		}
		
		public function addUrl(url:String):void{
			if(url == null){
				return;
			}
			for(var i:int;i<urlList.length;i++){
				if(urlList[i] == url){
					return;
				}
			}
			
			urlList.push(url);
		}
		
		public function toString():String{
			var str:String = new String;
			for(var i:int;i<urlList.length;i++){
				str += urlList[i] + "\n";
			}
			return str;
		}
		
		
	}
}