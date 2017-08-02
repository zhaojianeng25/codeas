package _Pan3D.display3D.water
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DWaterShader extends Shader3D
	{
		
		public static var DISPLAY3D_WATER_SHADER:String = "Display3DWaterShader";
		public function Display3DWaterShader()
		{
			version = 2;
			vertex = 
				
				"m44 vt0, va0, vc8 \n" + 
			
				"m44 vt4, vt0, vc4 \n" + 
				"m44 vt4, vt4, vc0 \n" + 
				"mov vi4, vt4 \n"+
				
				"m44 vt0, vt0, vc4 \n" + 
				"m44 vo,  vt0, vc0 \n" + 
				"mov vi1, va1";
			
			fragment =
				"mov ft4, vi4 \n"+
				"div ft4.xy,ft4.xy,ft4.z \n"+
				"add ft4.xy,ft4.xy,fc0.xy \n"+
				"div ft4.xy,ft4.xy,fc0.zw \n"+

				"tex ft0, ft4, fs0 <2d,linear>\n"+   //id
				"mov ft1, vi1 \n"+
				
				"mov fo, ft0 "
			
		}
	}
}