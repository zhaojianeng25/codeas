package _Pan3D.display3D.sky
{
	import _Pan3D.program.Shader3D;
	
	public class SkyShader extends Shader3D
	{
		public static var SKY_SHADER:String = "SkyShader";
		public function SkyShader()
		{
			version = 2;
			vertex = 
				"m44 vt0, va0, vc8 \n" +
				"m44 vt0, vt0, vc4 \n" +
				"m44 vo, vt0, vc0 \n" +
				"mov vi1, va1";
			fragment =
				"tex ft1, vi1, fs1 <cube,clamp,linear,miplinear>\n"+
				"mov fo, ft1";
		}
	}
}