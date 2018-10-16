package _Pan3D.particle
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DPartilceShader extends Shader3D
	{
		public static var DISPLAY3DPARTILCESHADER:String = "display3DPartilceShader";
		public function Display3DPartilceShader()
		{
			vertex = 
				//位置
				"mov vt0,vc[va0.x]\n" +
				"m44 vt0, vt0, vc24 \n" +
				"m44 vt0, vt0, vc8 \n" +
				"m44 vt0, vt0, vc4 \n" +
				"m44 op, vt0, vc0 \n" +
				
				//uv
				"mov vt4, vc[va0.y] \n"+
				"add vt4.xy,vt4.xy,vc13.xy \n"+
				
                //"mov vt4.z,vc12.x \n"+
				
				"mov v0, vt4";
			fragment =
				
				"tex ft1, v0, fs1 <2d,linear,repeat> \n"+
				"div ft1.xyz,ft1.xyz,ft1.w \n" + 
                 
				"mul ft1, ft1,fc1 \n" + 
				
				"mul ft1.xyz,ft1.xyz,ft1.w\n" +
				"mov oc, ft1";
		}
	}
}