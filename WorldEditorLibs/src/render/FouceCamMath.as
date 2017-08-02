package render
{
	import com.greensock.TweenLite;
	
	import flash.geom.Vector3D;
	
	import _me.Scene_data;
	
	

	public class FouceCamMath
	{
		private static var instance:FouceCamMath;
		public function FouceCamMath()
		{
	
		}
		public static function getInstance():FouceCamMath{
			if(!instance){
				instance = new FouceCamMath();
			}
			return instance;
		}
		private var _lastPostion:Vector3D=new Vector3D
		public function FouceTo($p:Vector3D):void
		{
		
			TweenLite.to(Scene_data.focus3D, 0.4, {x:$p.x, y:$p.y,z:$p.z}); 
		
			_lastPostion=$p.clone()
				
		}
	}
}