package _Pan3D.shadow.dynamicShadow
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DynamicShadowShader extends Shader3D
	{
		public static var DISPLAY3D_YNAMIC_SHADOW_SHADER:String = "Display3DynamicShadowShader";
		public function Display3DynamicShadowShader()
		{
			vertex = 
				"m44 vt0, va0, vc4 \n" +
				"m44 op, vt0, vc0 \n" +
				
				"m44 vt3, va0, vc8\n"+
				"mul vt3.xy, vt3.xy, vc12.xy \n"+
				"sub vt3.xy, vt3.xy, vc12.zw \n"+
				"mov v3, vt3 ";

			fragment =
		
				"tex ft2, v3, fs1 <2d,linear,repeat>\n"+
				"mul ft0, fc0, ft2.w \n"+
				"mov oc, ft0";
		}
	}
}