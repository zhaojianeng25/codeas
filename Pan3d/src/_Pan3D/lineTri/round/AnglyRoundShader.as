package _Pan3D.lineTri.round
{
	import _Pan3D.program.Shader3D;
	
	public class AnglyRoundShader extends Shader3D
	{
		public static var ANGLY_ROUND_SHADER:String = "AnglyRoundShader";
		public function AnglyRoundShader()
		{
			vertex = 
				"m44 vt0, va0, vc4 \n" +
				"m44 op, vt0, vc0 \n" +
				"mov v1, va1";
			fragment =
				"mov ft1,v1 \n"+
				"mul ft1,ft1,fc1 \n"+
				"mov oc, ft1";
		}
	}
}