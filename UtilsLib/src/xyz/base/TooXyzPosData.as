package  xyz.base
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class TooXyzPosData extends Vector3D
	{
		public function TooXyzPosData()
		{
		}
		public var scale_x:Number = 1;
		public var scale_y:Number = 1;
		public var scale_z:Number = 1;

		public var oldx:Number
		public var oldy:Number
		public var oldz:Number
		public var angle_x : Number
		public var angle_y : Number 
		public var angle_z : Number 
		public var fun:Function
		public var type:uint
		public var id:Number
		public var oldangle_x : Number
		public var oldangle_y : Number 
		public var oldangle_z : Number 
		public var pointItem:Array;
		public var hitBoxItem:Vector.<TooObjectHitBox>;
		
		public var modeMatrx3D:Matrix3D;
		//public var boxAngleY:Number;
	
		public static function getTemapXyzPosData(_id:uint,_x:Number,_y:Number,_z:Number):TooXyzPosData
		{
			var xyzPosData:TooXyzPosData=new TooXyzPosData()
			xyzPosData.id=_id;
			xyzPosData.x=_x;
			xyzPosData.y=_y;
			xyzPosData.z=_z;
			xyzPosData.type=1
			return xyzPosData ;
			
			
		}
	}
}