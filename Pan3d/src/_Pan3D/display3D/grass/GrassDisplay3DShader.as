package _Pan3D.display3D.grass
{
	import _Pan3D.program.Shader3D;
	
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class GrassDisplay3DShader extends Shader3D
	{
		
		public static var GRASS_DISPLAY3D_SHADER:String = "GrassDisplay3DShader";
		public function GrassDisplay3DShader()
		{
			vertex = 
				
				"mov vt0, va0 \n"+    //基本坐标
				"mov vt1, va1 \n"+    
				"mov vt2, va2 \n"+    //偏移位置
				"mov vt3, va3 \n"+

				"m44 vt0, vt0, vc8 \n" + 
				
				"add vt0.xyz, vt0.xyz, vt2.xyz \n" +
				
				"mov vt7, vt0 \n"+   //坐标位置
				"mov vt7.y,vt7.z \n"+
				"mul vt7.xy,vt7.xy,vc12.xy \n"+
				"add vt7.xy,vt7.xy,vc12.zw \n"+
				"mov vi7, vt7 \n"+    //得到lightUv
				
				"m44 vt0, vt0, vc4 \n" + 
				"m44 vo,  vt0, vc0 \n" + 

				"mov vi0, va1";
			
			fragment =

				"tex ft0, vi0, fs0 <2d,miplinear,linear>\n"+   //取纹理
				"tex ft1, vi7, fs1 <2d,linear>\n"+   //取纹理
				
				"mul ft0.xyz, ft0.xyz, ft1.xyz \n"+
				"mul ft0.xyz, ft0.xyz, fc7.w \n"+
				
				"mov fo, ft0 "
		
		}
	}
}