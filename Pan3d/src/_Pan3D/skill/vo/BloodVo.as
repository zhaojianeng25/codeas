package _Pan3D.skill.vo
{
	import flash.geom.Vector3D;
	
	import _me.Scene_data;

	public class BloodVo
	{
		public var time:int;
		public var pos:Vector3D;
		
		public function BloodVo()
		{
		}
		
		public function setData(obj:Object):void{
			this.time = obj.time * Scene_data.frameTime;
			this.pos = new Vector3D(obj.pos.x,obj.pos.y,obj.pos.z);
		}
		
	}
}