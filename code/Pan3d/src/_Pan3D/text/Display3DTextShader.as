package _Pan3D.text
{
	import _Pan3D.program.Shader3D;
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DTextShader extends Shader3D
	{
		public static var Display3DTextShader:String = "Display3DTextShader";
		public function Display3DTextShader()
		{
			vertex = 
				"mov vt0, va0 \n"+
				
				"mov vt1,vc[va1.z] \n" + 
				
				"mul vt2.xy,vc4.xy,vt1.zw \n"+
				"mul vt0.xy,va0.xy,vt2.xy \n"+
				
				"div vt2.xy,vt1.xy,vc6.xy \n"+
				"add vt2.xy,vt2.xy,vc6.zw \n"+
				
				"add vt0.xy, vt0.xy,vt2.xy \n"+
				"mov op, vt0 \n"+
				
				"mov vt0, vc[va1.w] \n"+
				
				"div vt1.xy,vt1.zw,vc4.zw \n" + 
				"mul vt1.xy,va1.xy,vt1.xy \n" +
				//"mul vt1.xy,va1.xy,vt0.zw \n"+
				
				"add vt1.xy,vt1.xy,vt0.xy \n"+
				"mov vt1.z, vt0.z \n" + 
				"mov v0, vt1";
				
				//"mov v0, va1";
			
			fragment =
				"tex ft0, v0, fs0 <2d,clamp>\n"+
				"mul ft0.w,ft0.w,v0.z \n" +
				"mov oc, ft0";
		}
	}
}