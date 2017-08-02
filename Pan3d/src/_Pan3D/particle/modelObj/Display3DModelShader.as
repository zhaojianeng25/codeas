package _Pan3D.particle.modelObj
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DModelShader extends Shader3D
	{
		public static var DISPLAY3DMODELSHADER:String = "Display3DModelShader";
		public function Display3DModelShader()
		{
			vertex = 
				"m44 vt0, va0, vc24 \n" +
				"m44 vt0, vt0, vc8 \n" +
				"m44 vt0, vt0, vc4 \n" +
				"m44 op, vt0, vc0 \n" +
				"mov vt1, va1 \n" + 
				"add vt1.xy, vt1.xy,vc13.xy \n" + 
				"mov v0, vt1";
			fragment =
				
				"tex ft1, v0, fs1 <2d,linear,repeat> \n"+
				"mov oc, ft1";
		}
	}
}