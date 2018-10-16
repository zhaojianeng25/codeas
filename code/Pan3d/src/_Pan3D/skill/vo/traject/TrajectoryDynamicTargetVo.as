package _Pan3D.skill.vo.traject
{
	import _Pan3D.display3D.Display3DBindMovie;
	
	import _me.Scene_data;

	/**
	 * 动态目标类型弹道模型数据 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class TrajectoryDynamicTargetVo extends TrajectoryVo
	{
		/**
		 * 距离地面的高度 
		 */		
		public var height:int;
		/**
		 * 最大的飞行距离 
		 */		
		public var maxDistance:int;
		/**
		 * 弹道结束技能效果 
		 */		
		public var endParticleUrl:String;
		
		public var hitSocket:String;
		
		public function TrajectoryDynamicTargetVo()
		{
			super();
		}
		
		override public function setInfo(obj:Object):void{
			super.setInfo(obj);
			height = obj.typeInfo.height * Scene_data.mainRelateScale;
			maxDistance = obj.typeInfo.distance;
			
			if(obj.typeInfo.endParticle){
				//endParticleUrl = Scene_data.particleRoot + "lid" + obj.typeInfo.endParticle.particleID + ".lyf";
				endParticleUrl = Scene_data.fileRoot + obj.typeInfo.endParticle.particleUrl;
			}else{
				endParticleUrl = null;
			}
			
			if(obj.typeInfo.hitSocket){
				hitSocket = obj.typeInfo.hitSocket;
			}else{
				hitSocket = null;
			}
			
		}
		
		override public function dispose():void{
			super.dispose();
			endParticleUrl = null;
		}
	}
}