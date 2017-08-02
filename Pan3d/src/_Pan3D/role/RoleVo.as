package _Pan3D.role
{
	public class RoleVo
	{
		public static var WALK:String    = "walk";
		public static var RUN:String     = "run";
		public static var RIDE:String    = "ride";
		public static var ATTACK:String  = "attack";
		public static var STAND:String   = "stand";
		public static var DEATH:String   = "death";
		
		public var name:String;
		public var scale:Number = 1;
		public var type:String;
		public var equipment:Object;
		public var action:Object;
		public function RoleVo()
		{
		}
	}
}