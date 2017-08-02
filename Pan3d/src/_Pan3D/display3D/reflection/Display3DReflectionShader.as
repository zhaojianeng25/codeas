package _Pan3D.display3D.reflection
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DReflectionShader extends Shader3D
	{
		public static var DISPLAY3D_REFLECTION_SHADER:String = "Display3DReflectionShader";
		public function Display3DReflectionShader()
		{
			vertex = 
				
				"m44 vt0, va0, vc8 \n" + 
				"m44 vt0, vt0, vc4 \n" + 
				"m44 vo,  vt0, vc0 \n" + 
				"mov vi1, va1";
			
			fragment =
				"mov ft1, vi1 \n"+

				"mov fo, fc0 "
			
		}
	}
}