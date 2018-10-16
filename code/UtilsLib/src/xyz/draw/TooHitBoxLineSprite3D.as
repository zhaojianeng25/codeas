package  xyz.draw
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	
	public class TooHitBoxLineSprite3D extends TooLineTri3DSprite
	{
		private var _tempMatrix3D:Matrix3D
		public function TooHitBoxLineSprite3D($context3D:Context3D)
		{
			super($context3D);
		}

		public function get tempMatrix3D():Matrix3D
		{
			return _tempMatrix3D;
		}

		public function set tempMatrix3D(value:Matrix3D):void
		{
			_tempMatrix3D = value;
		}

		public function makeBox():void
		{
			clear();

		
			var a:Vector3D=new Vector3D(-50,+50,-50);
			var b:Vector3D=new Vector3D(+50,+50,-50);
			var c:Vector3D=new Vector3D(+50,+50,+50);
			var d:Vector3D=new Vector3D(-50,+50,+50);
			
			makeLineMode(a,b)
			makeLineMode(b,c)
			makeLineMode(c,d)
			makeLineMode(d,a)
			
			var a1:Vector3D=new Vector3D(-50,-50,-50);
			var b1:Vector3D=new Vector3D(+50,-50,-50);
			var c1:Vector3D=new Vector3D(+50,-50,+50);
			var d1:Vector3D=new Vector3D(-50,-50,+50);
	
			makeLineMode(a1,b1)
			makeLineMode(b1,c1)
			makeLineMode(c1,d1)
			makeLineMode(d1,a1)
			
			uplodToGpu();
		}
	}
}