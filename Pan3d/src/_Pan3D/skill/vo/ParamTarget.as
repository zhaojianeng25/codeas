package _Pan3D.skill.vo
{
	import _Pan3D.display3D.Display3D;
	import _Pan3D.display3D.Display3DMovie;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.display3D.interfaces.IAbsolute3D;

	/**
	 * 动态目标参数 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class ParamTarget
	{
		/**
		 * 目标 
		 */		
		public var target:IAbsolute3D;
		
		public var targetParam:Object;
		
		/**
		 * 延时 
		 */		
		public var timeout:int;
		/**
		 * 击中回调函数 
		 */		
		public var callBackFun:Function;
		
		public function ParamTarget()
		{
		}
		
		public function dispose():void{
			target = null;
			callBackFun = null;
			targetParam = null;
		}
		
	}
}