package  xyz.base
{
	import flash.geom.Vector3D;

	public class TooObjectHitBox extends TooObject3D
	{
        public var beginx:Number;
        public var beginy:Number;
        public var beginz:Number;
        public var endx:Number;
        public var endy:Number;
        public var endz:Number;

		public var id:uint
		
		public var pointVec:Vector.<Vector3D>;

		public function initPointList():void{
			pointVec = new Vector.<Vector3D>;
			
			var min:Vector3D = new Vector3D(beginx,beginy,beginz);
			var max:Vector3D = new Vector3D(endx,endy,endz);
			
			var b1:Vector3D = new Vector3D(min.x,min.y,min.z);
			var b2:Vector3D = new Vector3D(max.x,min.y,min.z);
			var b3:Vector3D = new Vector3D(max.x,max.y,min.z);
			var b4:Vector3D = new Vector3D(min.x,max.y,min.z);
			
			var a1:Vector3D = new Vector3D(min.x,min.y,max.z);
			var a2:Vector3D = new Vector3D(max.x,min.y,max.z);
			var a3:Vector3D = new Vector3D(max.x,max.y,max.z);
			var a4:Vector3D = new Vector3D(min.x,max.y,max.z);
			
			pointVec.push(b1,b2,b3,b4,a1,a2,a3,a4);
		}
		
		public function scaleClone(scale_x:Number, scale_y:Number, scale_z:Number):TooObjectHitBox
		{
			var ret:TooObjectHitBox = new TooObjectHitBox();
			ret.beginx = beginx * scale_x;
			ret.beginy = beginy * scale_y;
			ret.beginz = beginz * scale_z;
			ret.endx = endx * scale_x;
			ret.endy = endy * scale_y;
			ret.endz = endz * scale_z;
			ret.x = x;
			ret.y = y;
			ret.z = z;
			ret.angle_x=angle_x;
			ret.angle_y=angle_y;
			ret.angle_z=angle_z;
			ret.initPointList();
			return ret;
		}
	}
}