package modules.hierarchy.h5
{
	import _Pan3D.program.Shader3D;
	
	public class FieldCollisionShader extends Shader3D
	{
		public static var FIELDCOLLISIONSHADER:String = "FieldCollisionShader";
		public function FieldCollisionShader()
		{
			vertex = 
				
				"m44 vt0, va0, vc8 \n" + 
				"m44 vt0, vt0, vc4 \n" + 
				"m44 vo,  vt0, vc0 \n" + 
				"mov vi0, vt0";
			
			fragment =
				"mov ft0, vi0 \n"+
				"mov ft1, vi0 \n"+
				"mov ft2, vi0 \n"+

				"div ft2.z, vi0.z,fc0.x \n"+   //z%255
				"frc ft1.z, ft2.z \n"+         //分
				"sub ft2.z, ft2.z,ft1.z \n"+   //整
				"div ft2.z, ft2.z,fc0.x \n"+
				
				"mov ft0.x,ft1.z \n"+
				"mov ft0.y,ft2.z \n"+
				"mov ft0.z,fc0.w \n"+
				"mov ft0.w,fc0.w \n"+

				"mov fo, ft0 "
			
		}
	}
}