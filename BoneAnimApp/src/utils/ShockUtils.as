package utils
{
	import _Pan3D.core.MathCore;
	
	import _me.Scene_data;
	
	import com.zcp.timer.TimerHelper;
	
	import flash.geom.Vector3D;
	
	import renderLevel.backGround.BackGroundLevel;
	
	public class ShockUtils
	{
		public function ShockUtils()
		{
			
		}
		
		public static function screen_shake($time:Number=400, $intensity:Number=50):void 
		{
			
			var dobj:BackGroundLevel  = AppDataBone.backLevel;
			var originalY:Number = dobj.y;
			
			
			//开震
			TimerHelper.createExactTimer($time, 0,1,onUpdate,onComplete);
			function onUpdate(per:Number):void
			{
				
				var ranY:Number = (Math.random()-0.5)*$intensity
				
				dobj.y = originalY + ranY;
				
				var v3d:Vector3D = MathCore.math2Dto3Dwolrd(0,-ranY);
				
				Scene_data.focus3D.x = v3d.x;
				Scene_data.focus3D.y = v3d.y;
				Scene_data.focus3D.z = v3d.z;
				
			}
			function onComplete():void
			{
				//dobj.x = originalX;
				dobj.y = originalY;
				
				var v3d:Vector3D = MathCore.math2Dto3Dwolrd(0,0);
				
				Scene_data.focus3D.x = v3d.x;
				Scene_data.focus3D.y = v3d.y;
				Scene_data.focus3D.z = v3d.z;
				
			}
		}
	}
}