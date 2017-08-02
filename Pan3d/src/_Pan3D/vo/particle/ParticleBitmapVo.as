package _Pan3D.vo.particle
{
	import flash.display.BitmapData;
	/**
	 * 通过粒子生成的序列帧数据 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class ParticleBitmapVo
	{
		/**
		 * 宽 
		 */		
		public var width:int;
		/**
		 * 高 
		 */		
		public var height:int;
		/**
		 * 帧数 
		 */		
		public var frameNum:int;
		/**
		 * 帧间隔时间 
		 */		
		public var frameTime:int;
		/**
		 * 序列帧bitmapdata数据 
		 */		
		public var bitmapdataAry:Vector.<BitmapData>;
		/**
		 * 粒子路径 
		 */		
		public var url:String;
		
		public function ParticleBitmapVo()
		{
		}
	}
}