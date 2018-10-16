package _Pan3D.particle.ctrl.utils
{
	public class ColorChange extends BaseAnim
	{
		public var rValue:Number=0;
		public var gValue:Number=0;
		public var bValue:Number=0;
		public var aValue:Number=0;
		public function ColorChange()
		{
			super();
		}
//		override public function coreCalculate():void{
//			//num = speed*time + aSpeed*time*time;
//		}
		override public function set data(value:Array):void{
			this.beginTime = value[0].value;
			if(value[1].value == -1){
				this.lastTime = int.MAX_VALUE;
			}else{
				this.lastTime = value[1].value;
			}
			rValue = Number(value[2].value)*0.001;
			gValue = Number(value[3].value)*0.001;
			bValue = Number(value[4].value)*0.001;
			aValue = Number(value[5].value)*0.001;
			speed = 1;
		}
		
	}
}