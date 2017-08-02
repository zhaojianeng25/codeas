package _Pan3D.particle.ctrl.utils
{
	import flash.geom.Vector3D;

	public class Centrifugal extends BaseAnim
	{
		public var center:Vector3D;
		public function Centrifugal()
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
			center = new Vector3D(Number(vc[0])*100,Number(vc[1])*100,Number(vc[2])*100);
			this.speed = value[3].value*0.001;
			this.aSpeed = value[4].value*0.001;
		}
	}
}