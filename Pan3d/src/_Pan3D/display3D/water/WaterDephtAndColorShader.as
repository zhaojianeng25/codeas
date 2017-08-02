package _Pan3D.display3D.water
{
	import _Pan3D.program.Shader3D;
	
	public class WaterDephtAndColorShader extends Shader3D
	{
		public static var WATER_DEPHTAND_COLOR_SHADER:String = "WaterDephtAndColorShader";
		public function WaterDephtAndColorShader()
		{
			vertex = 
				
		
				"mov vo,  va0 \n" + 
				"mov vi1, va1";
			
			fragment =
	
				"tex ft0, vi1, fs0 <2d,linear>\n"+   //id
				"tex ft1, vi1, fs1 <2d,linear>\n"+   //id
				"mov ft0.w,ft1.z \n"+
				"mov fo, ft0 "
			
		}
	}
}