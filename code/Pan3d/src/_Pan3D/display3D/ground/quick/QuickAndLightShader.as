package _Pan3D.display3D.ground.quick
{
	import _Pan3D.program.Shader3D;
	
	public class QuickAndLightShader extends Shader3D
	{
		public static var QUICK_AND_LIGHT_SHADER:String = "QuickAndLightShader";
		public function QuickAndLightShader()
		{
			version = 2;
			vertex = 
				
				"m44 vt0,va0,vc8 \n"+
				"m44 vt0,vt0,vc4 \n"+
				"mov vi0, va1 \n"+
				"m44 vo, vt0,vc0"
			
			fragment =

				"mov ft0, vi0 \n" +   //uv
				"tex ft1, ft0, fs1 <2d,linear>\n"+   //灯光
				"tex ft0, ft0, fs0 <2d,linear>\n"+   //取纹理
				"mul ft0.xyz, ft0.xyz, ft1.xyz \n"+
				"mov fo,ft0"
		}
	}
}