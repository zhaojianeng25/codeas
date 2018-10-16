package _Pan3D.particle.ctrl.utils
{
	public class ScaleChange extends BaseAnim
	{
		public var maxNum:Number;
		public var minNum:Number;
		public function ScaleChange()
		{
			super();
			num = 1;
		}
		override public function coreCalculate():void{
			num = 1+speed*time + baseNum;
			if(num < minNum){
				num = minNum;
				//return;
			}else if(num > maxNum){
				num = maxNum;
				//return;
			}
		}
		/**
		 * 
		 * @param value
		 * 
		 */		
		override public function set data(value:Array):void{
			this.beginTime = value[0].value;
			if(value[1].value == -1){
				this.lastTime = int.MAX_VALUE;
			}else{
				this.lastTime = value[1].value;
			}
			this.speed = value[2].value*0.001;
			this.minNum = value[3].value*0.01;
			this.maxNum = value[4].value*0.01;
		}
		override public function getAllNum(allTime:Number):void{
			allTime = Math.min(allTime,lastTime);
			allTime = allTime - beginTime;
			
			var num:Number = speed*allTime;
			baseNum += num;
			if(baseNum < minNum){
				baseNum = minNum;
			}else if(num > maxNum){
				baseNum = maxNum;
			}
			
		}
		
		override public function reset():void{
			_isActiva = false;
			_isDeath = false;
			
			num = 1;
		}
	}
}