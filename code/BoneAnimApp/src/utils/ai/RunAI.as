package utils.ai
{
	import _Pan3D.display3D.Display3D;
	import _Pan3D.utils.Tick;

	public class RunAI
	{
		private var _target:Display3D;
		
		private var _x:int;
		private var _z:int;
		
		private var _angle:Number = 0;
		
		public var speed:Number = 0.003;
		public var distance:Number = 0;
		public function RunAI()
		{
			
		}
		
		public function config(target:Display3D):void{
			_target = target;
			Tick.addCallback(run);
			_angle = 360 * Math.random();
		}
		
		public function run():void{
//			_target.z = 400;
//			return;
			_angle += speed;
			_x = distance * Math.sin(_angle);
			_z = distance * Math.cos(_angle);
			_target.x = _x;
			_target.z = _z;
			if(speed > 0){
				_target.rotationY = _angle/Math.PI * 180 + 90;
			}else{
				_target.rotationY = _angle/Math.PI * 180 - 90;
			}
			
		}
		
		
		
	}
}