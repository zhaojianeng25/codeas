package _Pan3D.particle.ctrl.utils
{
	public class SelfRotation extends BaseAnim
	{
		public function SelfRotation()
		{
		}
		override public function set data(value:Array):void{
			this.beginTime = value[0].value;
			if(value[1].value == -1){
				this.lastTime = int.MAX_VALUE;
			}else{
				this.lastTime = value[1].value;
			}
			this.speed = value[2].value*0.1;
			this.aSpeed = value[3].value*0.1;
		}
	}
}