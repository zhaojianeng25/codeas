package _Pan3D.particle.hightLocus
{
	import _Pan3D.program.Shader3D;
	
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Display3DHightLocusShader extends Shader3D
	{
		public static var DISPLAY3DHIGHTLOCUSSHADER:String = "Display3DHightLocusShader";
		public function Display3DHightLocusShader()
		{
			vertex = 

				"mov vt0, va0 \n"+
				"mov vt1, va1 \n"+
				"mov vt2, va2 \n"+
				"mov vt3, va3 \n"+
				
				/*************************/
				
				"m44 vt6, vt3, vc4 \n" +     //这为vc24  对应该的矩阵
				"mov vt2, va2 \n"+       //这个为下一下点所在的位置
				"m44 vt2, vt2, vc4 \n"+
				"sub vt2.xy, vt2.xy,vt6.xy \n"+
				"mul vt2.xy, vt2.xy,vc8.xy \n"+
				
				
				"mov vt4, vt2 \n"+

				"mul vt5.xy,vt2.xy,vt2.xy \n"+
				"add vt5.z, vt5.x, vt5.y \n"+
				"sqt vt5.z, vt5.z \n"+
				"div vt5.w, vc8.w,vt5.z \n"+    //w/h
				
				
				"mul vt4.xy, vt4.xy,vt5.w \n"+   //
				
				"mul vt3.x, vt4.y,vt1.x \n"+   //这里是乘于正负1来区别两个顶点 位置关系
				"mul vt3.y, vt4.x,vt1.y \n"+
				
				"m44 vt0, vt0, vc4 \n" +     //这为vc24  对应该的矩阵
				
				"add vt0.xy, vt0.xy, vt3.xy \n"+
				
				"m44 op, vt0, vc0 \n" +
				
				
				/*************************/

	
					
				"mov v2, va5 \n"+
				"mov v1, va4";
			
			fragment =
				
				"mov ft1, v1 \n"+
				"sub ft1.x,ft1.x,fc5.x \n"+
				
				"neg ft5.w,ft1.x \n"+  //大于0的部份不显示
				"kil ft5.w \n"+
				"sub ft5.w,ft1.x,fc5.w \n"+  //小于最后周期
				"kil ft5.w \n"+
				
				"div ft5.w, ft1.x, fc5.z \n"+   //计算拖尾的渐变色
				"abs ft5.w, ft5.w \n"+
				"sat ft5.w, ft5.w \n"+
				"sub ft5.w, fc5.y, ft5.w \n"+
				
				"mov ft2, v2 \n"+
				"mul ft1.xy,ft1.xy,ft2.xy \n"+//换一下UV,
				"mul ft4.xy, ft1.xy, ft2.z \n"+  //互换UV
				"mul ft5.xy, ft1.xy, ft2.w \n"+
				"add ft1.x, ft4.x,ft5.y \n"+
				"add ft1.y, ft4.y,ft5.x \n"+
				"mul ft1.xy, ft1.xy, v1.zw \n"+   //和UV段数相乘
				"tex ft0, ft1, fs1 <2d,clamp,repeat>\n"+
				"mul ft0, ft0, ft5.w \n"+
				
				"mov ft1, v1 \n"+
	
				
				"tex ft1, ft1, fs0 <2d,clamp,repeat>\n"+    //得到渐变颜色
				"mul ft0, ft0, ft1 \n"+
				"mul ft0, ft0, fc6 \n"+     //外部颜色
				"mov oc, ft0";
		}
	}
}