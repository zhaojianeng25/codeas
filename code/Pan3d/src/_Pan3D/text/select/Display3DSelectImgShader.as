package _Pan3D.text.select
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DSelectImgShader extends Shader3D
	{
		public static var DISPLAY3DSELECTIMGSHADER:String = "Display3DSelectImgShader";
		public function Display3DSelectImgShader()
		{
			vertex = 
				"mov vt0, va0 \n"+
				"mul vt0.xy, va0.xy,vc4.xy \n"+
				"add vt0.xy, vt0.xy,vc4.zw \n"+
				"mov op, vt0 \n"+
				"mov v0, va1";
			fragment =
				"tex ft0, v0, fs0 <2d,clamp>\n"+
//				"mov ft0.xyz,fc1.xyz \n" + 
//				"mul ft0.w,ft0.w,fc1.w \n" + 
				"mov oc, ft0";
		}
	}
}