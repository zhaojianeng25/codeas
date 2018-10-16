package _Pan3D.display3D.parallel
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DParallelLightShader extends Shader3D
	{
		public static var DISPLAY3D_PARALLEL_LIGHT_SHADER:String = "Display3DParallelLightShader";
		public function Display3DParallelLightShader()
		{
			vertex = 
				
				"m44 vt0, va0, vc8 \n" + 
				"m44 vt0, vt0, vc4 \n" + 
				"m44 vo,  vt0, vc0 \n" + 
				"mov vi1, va1";
			
			fragment =
				"mov ft1, vi1 \n"+
				"tex ft0, ft1, fs0 <2d,linear>\n"+   //取纹理
				"sub ft1.w,ft0.w,fc0.w \n"+
				"kil ft1.w \n"+
				"mul ft0,ft0,fc1 \n"+
				
				"mov fo, ft0 "
			
		}
	}
}