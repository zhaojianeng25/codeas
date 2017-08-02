package _Pan3D.program.shaders
{
	import _Pan3D.program.Shader3D;
	
	public class Md5LightShader extends Shader3D
	{
		public static var MD5_LIGHT_SHADER:String = "Md5LightShader";
		public function Md5LightShader()
		{
			vertex = 
				"m44 vt0, va0,vc[va6.x]\n"+
				"m44 vt1, va1,vc[va6.y]\n"+
				"m44 vt2, va2,vc[va6.z]\n"+
				"m44 vt3, va3,vc[va6.w]\n"+
				
				"mul vt0,vt0,va5.x\n"+
				"mul vt1,vt1,va5.y\n"+
				"mul vt2,vt2,va5.z\n"+
				"mul vt3,vt3,va5.w\n"+
				
				"add vt0,vt0,vt1\n"+
				"add vt0,vt0,vt2\n"+
				"add vt0,vt0,vt3\n"+
				
				"m44 vt5, vt0, vc4 \n" +
				"m44 op, vt5, vc0 \n" +
				"mov v1, va4";
			fragment = 
				"tex ft1, v1, fs1 <2d,linear>\n"+
				//"mul ft1.w,ft1.w,fc5.y\n" + 
				"div ft1.xyz,ft1.xyz,ft1.w \n" +
				
				"add ft2, fc2, v1\n" + 
				"tex ft2, ft2, fs2 <2d,linear,repeat>\n"+
				"add ft1.xyz,ft1.xyz,ft2.xyz\n"+
				
				"mul ft1,ft1,fc5\n" + 
				
				"mov oc, ft1"
		}
	}
}