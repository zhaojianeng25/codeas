package _Pan3D.skill.vo
{
	import _Pan3D.core.MathCore;
	import _Pan3D.skill.Skill3DPoint;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * 动态点参数  
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class ParamPoint
	{
		private var _targetPoint:Point;
		
		/**
		 * 目标点3D坐标 
		 */		
		public var targetV3d:Vector3D = new Vector3D;
		
		public var targetAbsolute:Skill3DPoint = new Skill3DPoint;
		/**
		 * 延时 
		 */		
		public var timeout:int;
		/**
		 * 击中回调函数 
		 */		
		public var callBackFun:Function;

		public function ParamPoint()
		{
			
		}
		
		/**
		 * 目标 
		 */
		public function set targetPoint(value:Point):void
		{
			_targetPoint = value;
			
			var p:Vector3D=MathCore.math2Dto3Dwolrd(_targetPoint.x,_targetPoint.y);
			targetV3d.x = p.x;
			targetV3d.z = p.z;
			
			targetAbsolute.absoluteX = targetV3d.x;
			targetAbsolute.absoluteZ = targetV3d.z;
		}
		
		public function dispose():void{
			_targetPoint = null;
			
			targetV3d = null;
			
			targetAbsolute = null;
			
			callBackFun = null;
		}
	}
}