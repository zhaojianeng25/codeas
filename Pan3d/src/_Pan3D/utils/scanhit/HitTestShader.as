package _Pan3D.utils.scanhit
{
	/**
	 * @author Pan3d.me
	 */
	import _Pan3D.program.Shader3D;
	
	public class HitTestShader extends Shader3D
	{
		public static var HIT_TEST_SHADER:String = "HitTestShader";
		public function HitTestShader()
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
				"tex ft1, v1, fs1 <2d,repeat,linear>\n"+

				"mov oc, fc4"
				
		}
	}
}