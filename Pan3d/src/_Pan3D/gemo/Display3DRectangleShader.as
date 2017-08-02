package _Pan3D.gemo
{
	import _Pan3D.program.Shader3D;
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DRectangleShader extends Shader3D
	{
		public static var DISPLAY3DRECTANGLESHADER:String = "Display3DRectangleShader";
		public function Display3DRectangleShader()
		{
			vertex = 
				"mov vt0, va0 \n"+
				"mov vt1,vc[va1.z] \n" + 
				"mul vt0.xy, va0.xy,vt1.xy \n"+
				"add vt0.xy, vt0.xy,vt1.zw \n"+
				"mov op, vt0 \n"+
				"mov v0, va1";
			
			fragment =
				"tex ft0, v0, fs0 <2d,clamp,repeat>\n"+
				"mov oc, ft0";
		}
	}
}