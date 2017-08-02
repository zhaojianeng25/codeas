package _Pan3D.texture
{
	import _Pan3D.program.Shader3D;
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class TextureToBmpShader extends Shader3D
	{
		public static var TEXTURE_TO_BMP_SHADER:String = "TextureToBmpShader";
		public function TextureToBmpShader()
		{
			vertex = 
				
				"mov op, va0 \n"+
				"mov v1, va1";
			fragment =
				"mov ft7, v1\n"+
				"tex ft0, v1, fs0 <2d,nearest ,2d>\n"+
				"mov oc, ft0";
		}
	}
}