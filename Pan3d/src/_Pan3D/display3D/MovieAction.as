package _Pan3D.display3D
{
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 * 动作对象
	 */	
	public class MovieAction
	{
		public static var STAND:String = "stand";
		public static var RUN:String = "run";
		/**
		 * 动作名称
		 */		
		public var name:String;
		/**
		 *动作路径 
		 */		
		public var url:String;
		
		public var needPerLoad:Boolean = false;
		public function MovieAction()
		{
			
		}
		
	}
}