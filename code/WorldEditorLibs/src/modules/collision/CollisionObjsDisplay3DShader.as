package modules.collision
{
	import _Pan3D.program.Shader3D;
	
	public class CollisionObjsDisplay3DShader extends Shader3D
	{
		public static var COLLISIONOBJSDISPLAY3DSHADER:String = "CollisionObjsDisplay3DShader";
		public function CollisionObjsDisplay3DShader()
		{
			vertex = 
				
				"m44 vt0, va0, vc8 \n" + 
				"m44 vt0, vt0, vc4 \n" + 
				"m44 vo,  vt0, vc0 \n" + 
				"mov vi1, va1";
			
			fragment =
				"mov ft1, vi1 \n"+
				"mov ft2, vi1 \n"+
				"dp3 ft2.w, ft1, fc0 \n"+
				
			
				"add ft2.w,ft2.w,fc1.x \n"+
				"div ft2.w,ft2.w,fc1.y \n"+
				
				"mov ft1.x,ft2.w \n"+
				"mov ft1.y,ft2.w \n"+
				"mov ft1.z,ft2.w \n"+
				
				
				"mov fo, ft1 "
			
		}
	}
}