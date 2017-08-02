package proxy.pan3d.cam
{
	import _me.Scene_data;
	
	import proxy.top.ICam;
	
	public class ProxyPan3dCam implements ICam
	{
		private static var _instance:ProxyPan3dCam;
		public static function getInstance():ProxyPan3dCam{
			if(!_instance){
				_instance = new ProxyPan3dCam;
			}
			return _instance;
		}
		public function ProxyPan3dCam()
		{
		}
		
		public function set x(value:Number):void
		{
			Scene_data.cam3D.x=value
		}
		
		public function get x():Number
		{
			return Scene_data.cam3D.x;
		}
		
		public function set y(value:Number):void
		{
			Scene_data.cam3D.y=value
		}
		
		public function get y():Number
		{
			return Scene_data.cam3D.y;
		}
		
		public function set z(value:Number):void
		{
			Scene_data.cam3D.z=value
		}
		
		public function get z():Number
		{
			return Scene_data.cam3D.z;
		}
		
		public function set rotationX(value:Number):void
		{
			Scene_data.cam3D.rotationX=value
		}
		
		public function get rotationX():Number
		{
			return Scene_data.cam3D.rotationX;
		}
		
		public function set rotationY(value:Number):void
		{
			Scene_data.cam3D.rotationY=value
		}
		
		public function get rotationY():Number
		{
			return Scene_data.cam3D.rotationY;
		}
		
		public function set rotationZ(value:Number):void
		{
			Scene_data.cam3D.rotationZ=value
		}
		
		public function get rotationZ():Number
		{
			return Scene_data.cam3D.rotationZ;
		}
	}
}