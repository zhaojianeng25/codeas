package _Pan3D.utils.materialShow
{
	import _Pan3D.program.Shader3D;
	
	public class MaterialShowShader extends Shader3D
	{
		
		public static var TEXTURE_SHOW_SHADER:String = "TextureShowShader";
		public function MaterialShowShader()
		{
			vertex = 
				
				"m44 vt0, va0, vc8 \n" + 
				"m44 vt0, vt0, vc4 \n" + 
				"m44 vo,  vt0, vc0 \n" + 
				"mov vi1, va1";
			
			fragment =
				"mov ft1, vi1 \n"+
				"mov fo, fc0 "
			
		}
	}
}