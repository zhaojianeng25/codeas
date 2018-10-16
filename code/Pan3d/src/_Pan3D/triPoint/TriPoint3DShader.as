package _Pan3D.triPoint
{
	import _Pan3D.program.Shader3D;
	
	public class TriPoint3DShader extends Shader3D
	{
		public static var TRI_POINT3D_SHADER:String = "TriPoint3DShader";
		public function TriPoint3DShader()
		{
			vertex = 
				"mov vt6, va0 \n"+
				"mov vt7, va1 \n"+
				"mov v0,va2 \n"+
				
				"mov vt0, vt6 \n"+ 
				"m44 vt0, vt0, vc4 \n" +
				"div vt2.z,vt0.z, vc10.z \n"+
				"mul vt7.xyz, vt7.xyz, vt2.z \n"+
				
				"m44 vt0, vt6, vc4 \n" +
				"add vt0.xyz, vt0.xyz , vt7.xyz \n"+
				
				"m44 op, vt0, vc0 " 
			fragment =
				"mov ft0,v0 \n"+
				"mov oc, ft0";
		}
	}
}