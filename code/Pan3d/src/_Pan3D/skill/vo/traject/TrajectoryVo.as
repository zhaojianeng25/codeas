package _Pan3D.skill.vo.traject
{
	import flash.geom.Vector3D;
	
	import _Pan3D.skill.vo.SkillKeyVo;
	
	import _me.Scene_data;

	/**
	 * 弹道的数据模型类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class TrajectoryVo extends SkillKeyVo
	{
		/**
		 * 起始点 
		 */		
		public var beginPos:Vector3D;
		/**
		 * 起始类型 0 固定点 1 为socket 
		 */		
		public var beginType:int;
		
		public var beginSocket:String;
		
		/**
		 * 终点类型 
		 * @see _Pan3D.skill.traject.EnumTrajectoryType
		 */		
		public var trajectoryType:int;
		/**
		 * 移动速度 
		 */		
		public var speed:Number;
		/**
		 * 粒子路径 
		 */		
		public var particleUrl:String;
		
		public function TrajectoryVo()
		{
			
		}
		/**
		 * 从Obejct置入数据 
		 * @param obj
		 * 
		 */		
		public function setInfo(obj:Object):void{
			beginType = obj.beginType;
			if(beginType == 0){
				beginPos = new Vector3D(obj.beginPos.x,obj.beginPos.y,obj.beginPos.z);
				beginPos.scaleBy(Scene_data.mainRelateScale);
			}else if(beginType == 1){
				beginSocket = obj.beginSocket;
			}
			trajectoryType = obj.type;
			speed = obj.speed * Scene_data.mainRelateScale;
			particleUrl = Scene_data.fileRoot + obj.particleInfo.particleUrl;
			//particleUrl = Scene_data.particleRoot + "lid" + obj.particleInfo.particleID + ".lyf";
		}
		
		override public function dispose():void{
			super.dispose();
			beginPos = null;
			particleUrl = null;
			
		}
		
	}
}