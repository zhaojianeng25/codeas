package _Pan3D.scene.postprocess
{
	import _Pan3D.program.Shader3D;
	
	public class LumShader extends Shader3D
	{
		public static var LUMSHADER:String = "LumShader";
		public function LumShader()
		{
			vertex = 
				"mov op, va0 \n"+
				"mov v1, va1";
			fragment =
				"tex ft0, v1, fs0 <2d,clamp,linear>\n"+
				"dp3 ft1.x,ft0.xyz,fc0.xyz\n" +
				"mov ft0.xyz,ft1.x\n" +
				"mov oc, ft0";
		}
	}
}