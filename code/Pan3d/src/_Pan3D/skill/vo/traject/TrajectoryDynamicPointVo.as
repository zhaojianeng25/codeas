package _Pan3D.skill.vo.traject
{
	import _me.Scene_data;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * 目标动态点的弹道数据模型 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class TrajectoryDynamicPointVo extends TrajectoryVo
	{
//		/**
//		 * 最终计算出的结果点 
//		 */		
//		public var endPos:Vector3D;
//		/**
//		 * 在2d模式下给定的点 
//		 */		
//		public var end2dPoint:Point;
		/**
		 * 高度
		 */		
		public var height:int;
		/**
		 * 固定距离 
		 */		
		public var constDistance:int;
		
		public function TrajectoryDynamicPointVo()
		{
			super();
		}
		
		override public function setInfo(obj:Object):void{
			super.setInfo(obj);
			constDistance = obj.typeInfo.distance;
			height = obj.typeInfo.height * Scene_data.mainRelateScale;
			//endPos = new Vector3D(obj.typeInfo.pos.x,obj.typeInfo.pos.y,obj.typeInfo.pos.z);
		}
		
	}
}