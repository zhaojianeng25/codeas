package _Pan3D.ui
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DBoardSLinerhader extends Shader3D
	{
		public static var DISPLAY3DBOARDSLINERHADER:String = "Display3DBoardSLinerhader";
		public function Display3DBoardSLinerhader()
		{
			vertex = 
				"mov vt0, va0 \n"+
				"mul vt0.xy, va0.xy,vc4.xy \n"+
				"add vt0.xy, vt0.xy,vc4.zw \n"+
				"mov op, vt0 \n"+
				"mov v0, va1";
			fragment =
				"tex ft0, v0, fs0 <2d>\n"+
				"mul ft0,ft0,fc1\n" + 
				"mov oc, ft0";
		}
	}
}