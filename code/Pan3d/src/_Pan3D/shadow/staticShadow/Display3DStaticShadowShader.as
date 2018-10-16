package _Pan3D.shadow.staticShadow
{
	import _Pan3D.program.Shader3D;
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DStaticShadowShader extends Shader3D
	{
		public static var DISPLAY3DSTATICSHADOWSHADER:String = "display3dstaticshadowshader";
		public function Display3DStaticShadowShader()
		{
			vertex = 
				"mov vt0, va0 \n"+
				
				"mov vt1,vc[va1.z] \n" + 
				"mul vt1,vt1,va2 \n"+
				"add vt1.xy,vt1.xy,vt1.zw \n"+
				
				"mul vt0, vt0, vc4 \n" +
				"add vt0.xz, vt0.xz,vt1.xy \n"+
				"m44 vt0, vt0, vc8 \n" +
				"m44 op, vt0, vc0 \n" +
				"mov v0, va1";
			
			fragment =
				"tex ft0, v0, fs0 <2d,clamp,repeat>\n"+
				"mov oc, ft0";
		}
	}
}