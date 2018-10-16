package _Pan3D.particle.ctrl.utils
{
	public class ScaleNoise extends BaseAnim
	{
		public var amplitude:Number;
		//public var wavelength:Number;
		
		public function ScaleNoise()
		{
			super();
		}
		override public function coreCalculate():void{
			num = amplitude + amplitude * Math.sin(speed*time);
		}
		override public function set data(value:Array):void{
			this.beginTime = value[0].value;
			if(value[1].value == -1){
				this.lastTime = int.MAX_VALUE;
			}else{
				this.lastTime = value[1].value;
			}
			this.amplitude = value[2].value;
			this.speed = value[3].value*0.01;
		}
		override public function getAllNum(allTime:Number):void{
			baseNum = amplitude + amplitude * Math.sin(speed*allTime)
		}
		
		override public function reset():void{
			_isActiva = false;
			_isDeath = false;
			
			num = 1;
		}
	}
}