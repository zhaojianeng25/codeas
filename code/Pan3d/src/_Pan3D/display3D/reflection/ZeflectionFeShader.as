package _Pan3D.display3D.reflection
{
	import _Pan3D.program.Shader3D;
	
	public class ZeflectionFeShader extends Shader3D
	{
		public static var REFLECTIONFE_SHADER:String = "ReflectionFeShader";
		public function ZeflectionFeShader()
		{
			version = 2;
			vertex = 
				
				"m44 vt0, va0, vc8 \n" + 
				
				"ifl vc12.y,vt0.y \n"+
					"mov vt0.y,vc12.y \n"+
				"eif\n"+
				
				"m44 vt0, vt0, vc4 \n" + 
				"m44 vo,  vt0, vc0 \n" + 
				"mov vi2, va2 \n"+
				"mov vi1, va1";
			
			fragment =
	

				"tex ft1, vi2, fs1 <2d,linear>\n"+   //灯光图
				"tex ft0, vi1, fs0 <2d,linear>\n"+   //取纹理
				"mul ft0.xyz, ft0.xyz, ft1.xyz \n"+
				"mul ft0.xyz, ft0.xyz, fc9.xyz \n"+
				
				"mov fo, ft0 "
			
		}
	}
}