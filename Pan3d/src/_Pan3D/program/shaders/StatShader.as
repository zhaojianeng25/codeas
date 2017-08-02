package _Pan3D.program.shaders
{
	import _Pan3D.program.Shader3D;
	
	public class StatShader extends Shader3D
	{
		public static var STATSHADER:String = "statshader";
		public function StatShader()
		{
			vertex = 
				"m44 vt0, va0, vc4 \n" +
				"m44 op, vt0, vc0 \n" +
				"mov v1, va1";
			fragment =
				"tex ft1, v1, fs1 <2d,linear,repeat>\n"+
				"mov oc, ft1";
		}
	}
}