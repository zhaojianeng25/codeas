package _Pan3D.text
{
	import _Pan3D.program.Shader3D;
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DynamicTextShader extends Shader3D
	{
		public static var DISPLAY3DYNAMICTEXTSHADER:String = "display3dynamictextshader";
		public function Display3DynamicTextShader()
		{
			vertex = 
				"mov vt0, va0 \n"+
				
				"mov vt1,vc[va1.z] \n" + 
				"mul vt1,vt1,va2 \n"+
				"add vt1.xy,vt1.xy,vt1.zw \n"+
				
				"mul vt0.xy,va0.xy,vc4.xy \n"+
				"div vt2.xy,vt1.xy,vc6.xy \n"+
				"add vt2.xy,vt2.xy,vc6.zw \n"+
				"add vt0.xy, vt0.xy,vt2.xy \n"+
				"mov op, vt0 \n"+
				"mov v0, va1";
			
			fragment =
				"tex ft0, v0, fs0 <2d,clamp>\n"+
				"mov oc, ft0";
		}
	}
}