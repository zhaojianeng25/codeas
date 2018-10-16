package xyz.base
 {
	import flash.geom.Vector3D;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class TooObject3D extends Vector3D{
		public var angle_x : Number = 0;
		public var angle_y : Number = 0;
		public var angle_z : Number = 0;
		private var _scale : Number = 1;
		public var scale_x:Number = 1;
		public var scale_y:Number = 1;
		public var scale_z:Number = 1;
		public var rx : Number = 0;
		public var ry : Number = 0;
		public var rz : Number = 0;
		
		public var rotationX : Number = 0;
		public var rotationY : Number = 0;
		public var rotationZ : Number = 0;

		public function TooObject3D(_x : Number = 0, _y : Number = 0, _z : Number = 0) : void {
			super(_x, _y, _z);
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
			scale_x = value;
			scale_y = value;
			scale_z = value;
		}

		public function setData(obj:Object):void{
			for(var key:String in obj){
				this[key] = obj[key];
			}
		}
	}
}