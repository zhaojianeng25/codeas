package _Pan3D.display3D.model
{
	import _Pan3D.program.Shader3D;
	
	public class ModelShader extends Shader3D
	{
		
		public static var MODEL_SHADER:String = "ModelShader";
		public function ModelShader()
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