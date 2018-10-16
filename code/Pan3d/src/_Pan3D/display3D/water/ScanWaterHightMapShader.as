package _Pan3D.display3D.water
{
	import _Pan3D.program.Shader3D;
	
	public class ScanWaterHightMapShader extends Shader3D
	{
		public static var SCAN_WATER_HIGHT_MAP_SHADER:String = "ScanWaterHightMapShader";
		public function ScanWaterHightMapShader()
		{
			vertex = 
				
				"m44 vt0, va0, vc8 \n" + 
				"m44 vt0, vt0, vc4 \n" + 
				"m44 vt0, vt0, vc0 \n" + 
				
				"mov vi0, vt0 \n"+
				"sat vt0.z,vt0.z \n"+
				"mov vo, vt0";
			
			fragment =
				"mov ft0, vi0 \n"+
				"sat ft0.z,ft0.z \n"+
				"mov ft0.x,ft0.z \n"+
				"mov ft0.y,ft0.z \n"+
	
				"mov fo, ft0 "
			
		}
	}
}