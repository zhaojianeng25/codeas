package _Pan3D.particle.ctrl.utils
{
	import _me.Scene_data;
	
	import flash.geom.Vector3D;

	public class CameraShake
	{
		public var isOpen:Boolean;
		
		private var _baseVector:Vector3D = new Vector3D;
		private var _addVector:Vector3D = new Vector3D;
		private var _timer:Number;
		private var _beginTime:Number = 0;
		private var _endTime:Number = 1000;
		private var _amplitude:Number = 50;
		private var _attenuation:Number = 100;
		public function CameraShake()
		{
			_addVector = Scene_data.shake3D;
			_baseVector.x = 100*Math.random();
			_baseVector.y = 100*Math.random();
			_baseVector.z = 100*Math.random();
		}
		
		public function beginShank():void{
			_addVector.x = _addVector.y = _addVector.z = 0;
			_timer = 0;
		}
		
		public function update(t:Number):void{
			if(!isOpen)
				return;
			
			_timer += t;
			if(_timer >= _endTime || _timer < _beginTime){
				_addVector.x = _addVector.y = _addVector.z = 0;
				return;
			}
			var num:Number = _amplitude - _attenuation*(_timer-_beginTime)/(_endTime-_beginTime);
			if(num < 0)
				num = 0;
			
			_addVector.x = num*Math.sin(_timer + _baseVector.x);
			_addVector.y = num*Math.cos(_timer + _baseVector.y);
			_addVector.z = num*Math.sin(_timer + _baseVector.z);
		}

		public function get beginTime():Number
		{
			return _beginTime;
		}

		public function set beginTime(value:Number):void
		{
			_beginTime = value;
		}

		public function get endTime():Number
		{
			return _endTime;
		}

		public function set endTime(value:Number):void
		{
			_endTime = value;
		}

		public function get amplitude():Number
		{
			return _amplitude;
		}

		public function set amplitude(value:Number):void
		{
			_amplitude = value;
		}

		public function get attenuation():Number
		{
			return _attenuation;
		}

		public function set attenuation(value:Number):void
		{
			_attenuation = value;
		}
		
		public function setAllInfo(obj:Object):void{
			if(!obj){
				reset();
				return;
			}
			for(var key:String in obj){
				this[key] = obj[key];
			}
		}
		
		public function reset():void{
			_amplitude = 0;
			_attenuation = 0;
			_beginTime = 0;
			_endTime = 0;
			isOpen = false;
		}
		
		public function getAllInfo():Object{
			var obj:Object = new Object;
			obj.amplitude = _amplitude;
			obj.attenuation = _attenuation;
			obj.beginTime = _beginTime;
			obj.endTime = _endTime;
			obj.isOpen = isOpen;
			return obj;
		}
		
		
		
		
	}
}