package _Pan3D.lineTri.box
{
	import _Pan3D.program.Shader3D;
	
	public class BoxShader extends Shader3D
	{
		public static var BOX_SHADER:String = "BoxShader";
		public function BoxShader()
		{
			vertex = 
		
				"mov vt7, va0 \n"+
				"mov vt0, vc8 \n"+ 
				"m44 vt0, vt0, vc4 \n" +
				"div vt2.z,vt0.z, vc10.z \n"+
				"mul vt7.xyz, vt7.xyz, vt2.z \n"+
				"add vt0, vc8.xyz, vt7.xyz \n"+
				"mov vt0.w, vc8.w \n"+
				"m44 vt0, vt0, vc4 \n" +
				
				"mov v1, va1 \n"+
				"m44 op, vt0, vc0 " 
			fragment =
				"mov ft1, v1 \n"+
				"mov ft1.w,fc0.w \n"+//不透明
				"mul ft1.xyz,ft1.xyz,fc1.xyz \n"+
				"mov oc, ft1";
		}
	}
}