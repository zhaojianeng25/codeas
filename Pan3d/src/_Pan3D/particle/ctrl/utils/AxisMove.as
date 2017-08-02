package _Pan3D.particle.ctrl.utils
{
	import flash.geom.Vector3D;

	public class AxisMove extends BaseAnim
	{
		public var axis:Vector3D;
		public function AxisMove()
		{
			
		}
		override public function set data(value:Array):void{
			this.beginTime = value[0].value;
			if(value[1].value == -1){
				this.lastTime = int.MAX_VALUE;
			}else{
				this.lastTime = value[1].value;
			}
			
			var vc:Array = String(value[2].value).split("|");
			axis = new Vector3D(vc[0],vc[1],vc[2]);
			axis.normalize();
			
			this.speed = value[3].value*0.1;
			this.aSpeed = value[4].value*0.001;
		}
	}
}