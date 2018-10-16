package _Pan3D.skill
{
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.interfaces.IAbsolute3D;
	
	import flash.geom.Vector3D;
	
	/**
	 * 技能虚拟释放点 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Skill3DPoint implements IAbsolute3D
	{
		private var _rotationY:Number = 0;
		private var _absoluteX:Number = 0;
		private var _absoluteY:Number = 0;
		private var _absoluteZ:Number = 0;
		
		private var _x:int;
		private var _y:int;
		
		public function Skill3DPoint($x:Number=0,$y:Number = 0,$z:Number=0)
		{
		}
		
		public function get rotationY():Number
		{
			return _rotationY;
		}
		/**
		 * 旋转 
		 * @param value
		 * 
		 */		
		public function set rotationY(value:Number):void
		{
			_rotationY = value;
		}

		public function get absoluteX():Number
		{
			return _absoluteX;
		}

		public function set absoluteX(value:Number):void
		{
			_absoluteX = value;
		}

		public function get absoluteY():Number
		{
			return _absoluteY;
		}

		public function set absoluteY(value:Number):void
		{
			_absoluteY = value;
		}

		public function get absoluteZ():Number
		{
			return _absoluteZ;
		}

		public function set absoluteZ(value:Number):void
		{
			_absoluteZ = value;
		}
		
		private function setXY():void{
			var P:Vector3D=MathCore.math2Dto3Dwolrd(_x,_y);
			_absoluteX=P.x;
			_absoluteZ=P.z;
		}
		
		public function get x():int
		{
			return _x;
		}
		/**
		 * x坐标 
		 * @param value
		 * 
		 */		
		public function set x(value:int):void
		{
			_x = value;
			setXY();
		}

		public function get y():int
		{
			return _y;
		}
		/**
		 * y坐标 
		 * @param value
		 * 
		 */		
		public function set y(value:int):void
		{
			_y = value;
			setXY();
		}


	}
}