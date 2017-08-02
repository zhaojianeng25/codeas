package _Pan3D.skill.vo.traject
{
	import _me.Scene_data;
	
	import flash.geom.Vector3D;

	/**
	 * 固定点目标类型的弹道模型数据 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class TrajectoryFiexPointVo extends TrajectoryVo
	{
		/**
		 * 目标固定点坐标 
		 */		
		public var endPos:Vector3D;
		public function TrajectoryFiexPointVo()
		{
			super();
		}
		override public function setInfo(obj:Object):void{
			super.setInfo(obj);
			endPos = new Vector3D(obj.typeInfo.pos.x,obj.typeInfo.pos.y,obj.typeInfo.pos.z);
			endPos.scaleBy(Scene_data.mainRelateScale)
		}
		override public function dispose():void{
			super.dispose();
			endPos = null;
		}
	}
}