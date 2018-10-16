package _Pan3D.program.shaders
{
	import _Pan3D.program.Shader3D;
	
	public class Md5SwimShader extends Shader3D
	{
		public static var MD5SWIMSHADER:String = "Md5SwimShader";
		public function Md5SwimShader()
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
				"mov v1, va4 \n"+
				"sub vt0.y, vt0.y,vc8.x \n" +
				//				"mul vt0.y, vt0.y,vc8.y \n" +
				"slt vt1.x,vt0.y,vc8.z \n" + //1,0
				"sge vt1.y,vt0.y,vc8.z \n" + //0,1
				
				"mul vt2.x,vt1.x,vc8.w \n" +
				"add vt2.x,vt2.x,vt1.y \n" +
				
				"mov v2, vt2 ";
			
			fragment = 
				"tex ft1, v1, fs1 <2d,linear>\n"+
				"mul ft1.w,ft1.w,v2.x \n" + 
				"mul ft1,ft1,fc5\n" +
				"mov oc, ft1";
		}
	}
}