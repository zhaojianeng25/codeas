package _Pan3D.particle.specialLocus
{
	import _Pan3D.program.Shader3D;
	
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Display3DSpecialLocusShader extends Shader3D
	{
		public static var DISPLAY3DSPECIALLOCUSSHADER:String = "Display3DHightLocusShader";
		public function Display3DSpecialLocusShader()
		{
			vertex = 
				
				"m44 vt0, va0, vc4 \n" +     //这为vc24  对应该的矩阵
				"m44 op, vt0, vc0 \n" +
				
				"mov v2, va2 \n"+
				"mov v1, va1";
			
			fragment =
				
				"mov ft1, v1 \n"+
				"sub ft1.x,ft1.x,fc5.x \n"+
				

		
				
				"mov ft2, v2 \n"+
				"mul ft1.xy,ft1.xy,ft2.xy \n"+//换一下UV,
				"mul ft4.xy, ft1.xy, ft2.z \n"+  //互换UV
				"mul ft5.xy, ft1.xy, ft2.w \n"+
				"add ft1.x, ft4.x,ft5.y \n"+
				"add ft1.y, ft4.y,ft5.x \n"+
				"mul ft1.xy, ft1.xy, v1.zw \n"+   //和UV段数相乘
				"tex ft0, ft1, fs1 <2d,clamp,repeat>\n"+
			
				
				
				
				"tex ft1, v1, fs0 <2d,clamp,repeat>\n"+    //得到渐变颜色
				"mul ft0, ft0, ft1 \n"+
				"mul ft0, ft0, fc6 \n"+     //外部颜色
				"mov oc, ft0";
		}
	}
}