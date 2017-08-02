package _Pan3D.scene.postprocess
{
	import _Pan3D.program.Shader3D;
	
	public class RenderToTextureShader extends Shader3D
	{
		public static var RENDER_TO_TEXTURESHADER:String = "RenderToTextureShader";
		public function RenderToTextureShader()
		{
			vertex = 
				"mov op, va0 \n"+
				"mov v1, va1";
			fragment =
				"tex ft0, v1, fs0 <2d,clamp,linear>\n"+//nearest linear
				"mov oc, ft0";
		}
	}
}