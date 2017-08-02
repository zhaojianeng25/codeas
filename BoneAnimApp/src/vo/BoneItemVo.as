package vo
{
	import _Pan3D.base.ObjectBone;
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 * </p>骨骼vo
	 */	
	public dynamic class BoneItemVo
	{
		/**
		 * 骨骼数 
		 */		
		public var boneNum:int;
		/**
		 * 骨骼帧数据 
		 */		
		public var data:Array;
		/**
		 * 文件名（动作的关键字 ）
		 */		
		public var fileName:String;
		/**
		 * 帧数 
		 */
		public var frameNum:int;
		/**
		 * 骨骼的基础数值 
		 */		
		public var hierarchy:Vector.<ObjectBone>;
		/**
		 * 内循环帧数 
		 */		
		public var inLoop:int;
		/**
		 * 要插值的帧数 
		 */		
		public var interAry:Array;
		/**
		 * 路径Url 
		 */		
		public var url:String
		/**
		 * 对应文件的字符串数据 
		 */		
		public var str:String;
		/**
		 * 在系统文件的绝对路径 
		 */		
		public var nativePath:String;
		
		/**
		 *  文件名字（文件名+扩展名）
		 */		
		public var name:String;
		/**
		 *  字符串第一次拆分后的数组
		 */		
		public var strAry:String;
		/**
		 * 源数据（原始解析数据） 
		 */		
		public var source:String;

		public function BoneItemVo()
		{
		}
	}
}