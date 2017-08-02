package _Pan3D.base {
	import flash.geom.Vector3D;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Object3D extends Vector3D{
//		private var _angle_x : Number = 0;
//		private var _angle_y : Number = 0;
//		private var _angle_z : Number = 0;
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

		public function Object3D(_x : Number = 0, _y : Number = 0, _z : Number = 0) : void {
			super(_x, _y, _z);
		}

		public function get angle_z():Number
		{
			return rotationZ;
		}

		public function set angle_z(value:Number):void
		{
			rotationZ = value;
		}

		public function get angle_y():Number
		{
			return rotationY;
		}

		public function set angle_y(value:Number):void
		{
			rotationY = value;
		}

		public function get angle_x():Number
		{
			return rotationX;
		}

		public function set angle_x(value:Number):void
		{
			rotationX = value;
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