package _Pan3D.base{

// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	
	public class ObjectUv extends Object {
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		public var a:Number = 0;
		public var b:Number = 0;
		public var w:Number = 0;
		public var id:Number = 0;
		
		public function clone():ObjectUv{
			var obj:ObjectUv = new ObjectUv;
			obj.x = x;
			obj.y = y;
			obj.z = z;
			obj.a = a;
			obj.b = b;
			obj.w = w;
			obj.id = id;
			return obj;
		}

	}
	
}