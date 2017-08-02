package _Pan3D.program.shaders
{
	import _Pan3D.program.Shader3D;
	
	public class Md5NoNormalShader extends Shader3D
	{
		public static var MD5_NO_NORMAL_SHADER:String = "Md5NoNormalShader";
		public function Md5NoNormalShader()
		{
			vertex = 
				
				"m44 vt0, va0,vc[va3.x]\n"+
				"m44 vt1, va0,vc[va3.y]\n"+
				"m44 vt2, va0,vc[va3.z]\n"+
				"m44 vt3, va0,vc[va3.w]\n"+
				
				"mul vt0,vt0,va2.x\n"+
				"mul vt1,vt1,va2.y\n"+
				"mul vt2,vt2,va2.z\n"+
				"mul vt3,vt3,va2.w\n"+
				
				"add vt0,vt0,vt1\n"+
				"add vt0,vt0,vt2\n"+
				"add vt0,vt0,vt3\n"+
				
				"m44 vt0, vt0, vc4 \n" +
				"m44 op, vt0, vc0 \n" +
				
				
				"mov v1, va1";
			fragment =
				"tex ft1, v1, fs1 <2d,linear>\n"+
				"div ft1.xyz,ft1.xyz,ft1.w \n" +
				"mul ft1,ft1,fc5\n" + 
				"mov oc, ft1"
		}
	}
}