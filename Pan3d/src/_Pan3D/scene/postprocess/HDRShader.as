package _Pan3D.scene.postprocess
{
	import _Pan3D.program.Shader3D;
	
	public class HDRShader extends Shader3D
	{
		public static var HDR_SHADER:String = "HDRShader";
		public function HDRShader()
		{
			vertex = 
				"mov op, va0 \n"+
				"mov v1, va1";
			fragment =
				"tex ft0, v1, fs0 <2d,clamp,linear>\n"+
				"tex ft1, v1, fs1 <2d,clamp,linear>\n"+
				
//				"dp3 ft2.x,ft0.xyz,fc0.xyz\n" +
//				"div ft2.x,ft2.x,fc1.x\n" +
//				"mul ft2.x,ft2.x,fc1.y\n" +
//				"mul ft0.xyz,ft0.xyz,ft2.x\n" +
				"mul ft0.xyz,ft0.xyz,fc1.y\n" +

				
				//return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
				//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,2,Vector.<Number>([A,C*B,D*E,B]));
				//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,3,Vector.<Number>([D*F,E/F,whiteScale,0]));

				"mul ft2.xyz,ft0.xyz,fc2.x \n" + //A*x
				
				"add ft3.xyz,ft2.xyz,fc2.y \n" + //(A*x+C*B)
				"mul ft3.xyz,ft3.xyz,ft0.xyz \n" + //x*(A*x+C*B)
				"add ft3.xyz,ft3.xyz,fc2.z \n" + //(x*(A*x+C*B)+D*E)
				
				"add ft4.xyz,ft2.xyz,fc2.w \n" + //A*x+B
				"mul ft4.xyz,ft4.xyz,ft0.xyz \n" + //x*(A*x+B)
				"add ft4.xyz,ft4.xyz,fc3.x \n" +//x*(A*x+B)+D*F)
				
				"div ft3.xyz,ft3.xyz,ft4.xyz\n" +
				"sub ft3.xyz,ft3.xyz,fc3.y \n" +
				"mul ft0.xyz,ft3.xyz,fc3.z \n" +
				
				//"pow ft0.xyz,ft0.xyz,fc1.z \n" +
				
				
				"add ft0.xyz,ft0.xyz,ft1.xyz\n" +
				
				"mov oc, ft0";
		}
	}
}