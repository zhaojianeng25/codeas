package _Pan3D.base {
	import flash.geom.Vector3D;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Focus3D extends Vector3D {
		public var angle_x : Number = 0;
		public var angle_y : Number = 0;
		public var willgo_x : Number = 0;
		public var willgo_y : Number = 0;
		public var willgo_z : Number = 0;
		public var _to_x : Number = 0;
		public var _to_y : Number = 0;
		public var _to_z : Number = 0;
		public var willgo_angle_y : Number = 0;
		public var old_x : Number = 0;
		public var old_y : Number = 0;
		public var old_z : Number = 0;
		public var old_angle_x : Number = 0;
		public var old_angle_y : Number = 0;

	    public function cloneFocus3D() : Focus3D {
			var focus3D : Focus3D = new Focus3D();
			focus3D.x=x;
			focus3D.y=y;
			focus3D.z=z;
			focus3D.angle_x=angle_x;
			focus3D.angle_y=angle_y;
			return  focus3D;
		}
		
	}
}