package _Pan3D.display3D.collision
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DCollisionShader extends Shader3D
	{
		public static var DISPLAY3DCOLLISIONSHADER:String = "Display3DCollisionShader";
		public function Display3DCollisionShader()
		{
			vertex = 
				
				"m44 vt0, va0, vc8 \n" + 
				"m44 vt0, vt0, vc4 \n" + 
				"m44 vo,  vt0, vc0 \n" + 
				"mov vi1, va0";
			
			fragment =
				"mov ft1, vi1 \n"+
				"mov fo, fc0 "
			
		}
	}
}