package _Pan3D.program.shaders
{
	import _Pan3D.program.Shader3D;
	
	public class Md5SelectShader extends Shader3D
	{
		public static var MD5_SELECT_SHADER:String = "Md5SelectShader";
		public function Md5SelectShader()
		{
			vertex = 
				"mov vt0, va0 \n"+
				"mov vt1, va1 \n"+
				"mov vt2, va2 \n"+
				"mov vt3, va3 \n"+
				
				"nrm vt0.xyz, vt0.xyz\n" + 
				"nrm vt1.xyz, vt1.xyz\n" + 
				"nrm vt2.xyz, vt2.xyz\n" + 
				"nrm vt3.xyz, vt3.xyz\n" + 
				
				"mul vt0.xyz,vt0.xyz ,vc8.w \n"+
				"mul vt1.xyz,vt1.xyz ,vc8.w \n"+
				"mul vt2.xyz,vt2.xyz ,vc8.w \n"+
				"mul vt3.xyz,vt3.xyz ,vc8.w \n"+
				
				"add vt0.xyz,vt0.xyz, va0.xyz \n"+
				"add vt1.xyz,vt1.xyz, va1.xyz \n"+
				"add vt2.xyz,vt2.xyz, va2.xyz \n"+
				"add vt3.xyz,vt3.xyz, va3.xyz \n"+
				
				"m44 vt0, vt0,vc[va6.x]\n"+
				"m44 vt1, vt1,vc[va6.y]\n"+
				"m44 vt2, vt2,vc[va6.z]\n"+
				"m44 vt3, vt3,vc[va6.w]\n"+
				
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
				"tex ft1, v1, fs1 <2d,repeat,linear>\n"+
				"mul ft1, fc1, ft1.w \n"+
				"mov oc, ft1"
			
		}
	}
}