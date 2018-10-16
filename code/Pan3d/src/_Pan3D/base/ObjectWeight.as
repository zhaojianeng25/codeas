package _Pan3D.base{

// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	
	public class ObjectWeight extends Object {
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		public var w:Number = 0;
		public var weight:Number = 0;
		public var boneId:Number = 0;
		public var id:Number = 0;
		
		public function clone():ObjectWeight{
			var obj:ObjectWeight = new ObjectWeight;
			obj.x = x;
			obj.y = y;
			obj.z = z;
			obj.w = w;
			obj.weight = weight;
			obj.boneId = boneId;
			obj.id = id;
			return obj;
		}

	}
	
}