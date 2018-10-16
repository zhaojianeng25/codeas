package _Pan3D.lineTri
{
	import _Pan3D.program.Shader3D;
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class LineTri3DShader extends Shader3D
	{
		public static var LINE_TRI3D_SHADER:String = "LineTri3DShader";
		public function LineTri3DShader()
		{
			vertex = 
				"mov vt6, va0 \n"+
				"mov vt7, va1 \n"+
				"mov v0,va2 \n"+
	
				"mov vt0, vt6 \n"+ 
				"m44 vt0, vt0, vc4 \n" +
				"div vt2.z,vt0.z, vc10.z \n"+
				"mul vt7.xyz, vt7.xyz, vt2.z \n"+
				"add vt0, vt6.xyz, vt7.xyz \n"+
				"mov vt0.w, vt6.w \n"+
				"m44 vt0, vt0, vc4 \n" +

				"m44 op, vt0, vc0 " 
			fragment =
                "mov ft0,v0 \n"+
				"mov oc, ft0";
		}
	}
}