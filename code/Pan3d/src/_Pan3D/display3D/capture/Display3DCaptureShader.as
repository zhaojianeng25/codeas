package _Pan3D.display3D.capture
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DCaptureShader extends Shader3D
	{
		public static var DISPLAY3D_CAPTURE_SHADER:String = "Display3DCaptureShader";
		public function Display3DCaptureShader()
		{
			vertex = 
				
				"m44 vt0, va0, vc8 \n" + 
				"m44 vt0, vt0, vc4 \n" + 
				"m44 vo,  vt0, vc0 \n" + 
				"mov vi1, va1";
			
			fragment =
				"mov ft1, vi1 \n"+
				"tex ft0, vi1, fs0 <2d,linear>\n"+   //id
				"mov fo, ft0 "
			
		}
	}
}