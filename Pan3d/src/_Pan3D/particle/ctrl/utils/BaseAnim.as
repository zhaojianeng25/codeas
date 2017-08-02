package _Pan3D.particle.ctrl.utils
{
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class BaseAnim
	{
		public var baseNum:Number = 0;
		private var _num:Number=0;
		public var time:int;
		public var speed:Number=0;
		public var aSpeed:Number=0;
		public var beginTime:int;
		public var lastTime:int;
		public var baseTime:int;
		protected var _isActiva:Boolean;
		protected var _isDeath:Boolean;
		
		public function BaseAnim()
		{
		}

		public function get num():Number
		{
			return _num;
		}

		public function set num(value:Number):void
		{
			if(value==0){
				_num = 0.001;
			}else{
				_num = value;
			}
	
		}

		public function update(t:int):void{
			if(_isDeath){
				return;
			}
			time = t - baseTime;
			if(_isActiva){
				time = time-beginTime;
				if(time > lastTime){
					time = lastTime - beginTime;
					_isDeath = true;
				}
				coreCalculate();
			}else{
				if(time >= beginTime){
					if(time >= lastTime){
						time = lastTime - beginTime;
						coreCalculate();
						_isDeath = true;
					}else{
						time = time-beginTime;
						coreCalculate();
					}
					_isActiva = true;
				}
			}
			
		}
		public function coreCalculate():void{
			num = speed*time + aSpeed*time*time + baseNum;
		}
		public function reset():void{
			_isActiva = false;
			_isDeath = false;
			
			//time = 0;
			//baseNum = num;
			time = 0;
			num = 0;
		}
		public function depthReset():void{
			_isActiva = false;
			_isDeath = false;
			
			time = 0;
			baseNum = 0;
			num = 0;
		}
		public function set data(value:Array):void{
			
		}

		public function get isDeath():Boolean
		{
			return _isDeath;
		}

		public function set isDeath(value:Boolean):void
		{
			_isDeath = value;
		}
		
		public function getAllNum(allTime:Number):void{
			allTime = Math.min(allTime,lastTime);
			allTime = allTime - beginTime;
			var num:Number = speed*allTime + aSpeed*allTime*allTime;
			baseNum += num;
		}

	}
}