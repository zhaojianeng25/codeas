package _Pan3D.skill.vo
{
	public class ShockVo
	{
		
		public var beginTime:int;
		public var amplitude:Number;
		public var time:int;
		
		public function ShockVo(data:Object)
		{
			beginTime = data.beginTime;
			amplitude = data.amplitude;
			time = data.time;
		}
		
	}
}