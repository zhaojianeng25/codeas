package _Pan3D.texture
{
	import _Pan3D.program.Shader3D;
	
	public class TextureMulTextureShader extends Shader3D
	{
		public static const TEXTURE_MUL_TEXTURE_SHADER:String = "TextureMulTextureShader";
		
		public function TextureMulTextureShader()
		{
			super();
			vertex = 
				"mov op, va0 \n"+
				"mov v1, va1";
			
			fragment =
				"mov ft2, v1\n"+
				"tex ft0, ft2, fs0 <2d,nearest ,2d>\n"+    //RGBA
				"tex ft1, ft2, fs1 <2d,nearest ,2d>\n"+ 		//rgba
                 
				"mul ft0.xyz, ft0.xyz, ft1.xyz \n"+//rgba+RGB(1-a)
				
				"mov oc, ft0";
		}
	}
}