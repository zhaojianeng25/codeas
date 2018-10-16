package renderLevel.backGround
{
	import _Pan3D.program.Shader3D;
	
	public class BackGroundDisplay3DShader extends Shader3D
	{
		public static var BACK_GROUND_DISPLAY3D_SHADER:String = "BackGroundDisplay3DShader";
		public function BackGroundDisplay3DShader()
		{
			vertex = 
				"mov vt0, va0 \n"+
				"mul vt0.xy, va0.xy,vc4.xy \n"+
				"add vt0.xy, vt0.xy,vc4.zw \n"+
				"mov op, vt0 \n"+
				"mov v0, va1";
			fragment =
				"tex ft0, v0, fs0 <2d,clamp,repeat>\n"+
				"mov oc, ft0";
		}
	}
}