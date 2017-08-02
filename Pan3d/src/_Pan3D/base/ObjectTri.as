package _Pan3D.base{

// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	
	public class ObjectTri extends Object {
		
		public var id:Number = 0;
		public var t0:Number = 0;
		public var t1:Number = 0;
		public var t2:Number = 0;

		public function clone():ObjectTri{
			var obj:ObjectTri = new ObjectTri;
			obj.t0 = t0;
			obj.t1 = t1;
			obj.t2 = t2;
			obj.id = id;
			return obj;
		}
	}
	
}