package render.atf.shader
{
	import _Pan3D.program.Shader3D;
	
	public class AftMinTextureShader extends Shader3D
	{
		public static var AFT_MINTEXTURE_SHADER:String = "AftMinTextureShader";
		public function AftMinTextureShader()
		{
			vertex = 
				
				"m44 vt0,va0,vc8 \n"+
				"m44 vt0,vt0,vc4 \n"+
				
				"mov vi1, va1 \n"+
				"mov vi0, va0 \n"+
				"m44 vo, vt0,vc0"
			
			fragment =
				"mov ft1, vi1 \n" +   //法线
				"mov ft0, vi0 \n" +
				"tex ft0, vi1, fs0 <2d,miplinear,linear>\n"+
				"mov fo,ft0"
		}
	}
}