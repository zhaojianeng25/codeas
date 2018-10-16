package _Pan3D.vo.anim
{
	import flash.geom.Vector3D;
	/**
	 * 骨骼打包解析后的全部信息
	 * @author liuyanfei QQ:421537900
	 */	
	public class AnimVo
	{
		/**
		 * 关键字 
		 */		
		public var key:String;
		/**
		 * 包围盒信息 
		 */		
		public var bounds:Vector.<Vector3D>;
		/**
		 * 帧数信息 
		 */		
		public var frames:Array;
		/**
		 * 循环帧 
		 */		
		public var inLoop:int;
		/**
		 * 插值帧 
		 */		
		public var inter:Array;
		/**
		 * 名字高度 
		 */		
		public var nameHeight:int;
		/**
		 * 使用次数 
		 */		
		public var useNum:int;
		/**
		 * 空闲时间 
		 */		
		public var idleTime:int;
		/**
		 * 每帧对应的移动位置 
		 */		
		public var pos:Vector.<Vector3D>;
		
		public var scale:Number;
		
		public function AnimVo()
		{
			
		}
		
	}
}