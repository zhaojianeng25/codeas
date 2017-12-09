package _Pan3D.skill.vo
{
	import _me.Scene_data;

	public class ShockVo
	{
		
		public var time:int;
		public var amp:Number;
		public var fre:Number;
		public var lasttime:int;
		
		public function ShockVo(data:Object)
		{
			time = data.time * Scene_data.frameTime;
			amp = data.amp;
			fre = data.fre;
			lasttime = data.lasttime * Scene_data.frameTime;
		}
		
	}
}