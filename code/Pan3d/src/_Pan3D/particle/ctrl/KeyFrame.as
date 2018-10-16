package _Pan3D.particle.ctrl
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 *
	 * 关键帧对象
	 */		
	public class KeyFrame
	{
		//public var isBegin:Boolean;//是否是起始帧
		//public var isEnd:Boolean;//是否是结束帧
		public var frameNum:int;//当前帧数
		//private var _keyWidth:int = 8;//每帧所占的宽度
		
		public var preKeyFrame:KeyFrame;//前一个关键帧
		public var nextKeyFrame:KeyFrame;//后一个关键帧
		
		private var _animData:Array;//运动信息数据
		public var baseValue:Array;
		public function KeyFrame()
		{
			super();
		}
		
//		public function get frameNum():int
//		{
//			return _frameNum;
//		}
		/**
		 * 设置帧数
		 * @param value 帧数
		 * 
		 */		
//		public function set frameNum(value:int):void
//		{
//			_frameNum = value;
//		}
		
		/**
		 * 运动信息数据 
		 * @return 运动信息
		 * 
		 */		
		public function get animData():Array
		{
			return _animData;
		}
		/**
		 * 设置运动信息并重绘 
		 * @param value 运动信息
		 * 
		 */		
		public function set animData(value:Array):void
		{
			_animData = value;
		}
		
		
		/**
		 * 获取运动信息+对应帧数 
		 * @return 所有关键信息
		 * 
		 */		
		public function getAllInfo():Object{
			var obj:Object = new Object;
			obj.animdata = _animData;
			obj.frameNum = frameNum;
			obj.baseValue = baseValue;
			return obj;
		}
		
		

	}
}