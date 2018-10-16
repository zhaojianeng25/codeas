package _Pan3D.base{
	import flash.geom.Matrix3D;

// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	
	public class ObjectBone extends Object {
		
		public var tx:Number = 0;
		public var ty:Number = 0;
		public var tz:Number = 0;
		public var tw:Number = 0;
		public var qx:Number = 0;
		public var qy:Number = 0;
		public var qz:Number = 0;
		public var qw:Number = 0;
		public var changtype:Number=0;
		public var name:String="";
		public var father:Number=0;
		public var startIndex:int;
		public var matrix:Matrix3D;
	    public function toString():String
		{
			return " tx:"+String(tx)+" ty:"+String(ty)+" tz:"+String(tz)+" qx:"+String(qx)+" qy:"+String(qy)+" qz:"+String(qz);
		}
		
		public function clone():ObjectBone{
			var newBone:ObjectBone = new ObjectBone;
			
			newBone.tx = tx;
			newBone.ty = ty;
			newBone.tz = tz;
			newBone.tw = tw;
			newBone.qx = qx;
			newBone.qy = qy;
			newBone.qz = qz;
			newBone.qw = qw;
			newBone.changtype = changtype;
			newBone.name = name;
			newBone.father = father;
			newBone.startIndex = startIndex;
			newBone.matrix = matrix;
			
			return newBone;
		}

	}
	
}