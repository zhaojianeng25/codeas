package _Pan3D.batch.particle.locus
{
	import _Pan3D.program.Shader3D;
	
	public class BatchLocusShader extends Shader3D
	{
		public static var BATCH_LOCUS_SHADER:String = "BatchLocusShader";
		public function BatchLocusShader()
		{
			vertex = 
				"mov vt4, vc4 \n"+                  //存入1,2,4,24用于相加
				"mul vt7.x,va3.x,vc4.z \n"+         //vcIndex*4    
				"add vt7.x,vt7.x,vc4.w \n"+        //+24   从24开始
				"m44 vt0, va0, vc[vt7.x] \n" +     //这为vc24  对应该的矩阵
				"m44 op, vt0, vc0 \n" +
				"mov v2, va2 \n"+
				
				"mul vt7.x,va3.x,vc4.y \n"+         //vcIndex*2      =0
				"add vt7.x,vt7.x,vc4.z \n"+         //因为开始是从5开始，先加一个4。  0+4=4
				"add vt7.x,vt7.x,vc4.x \n"+         //再加一个1。  4+1=5
				"mov v5, vc[vt7.x] \n"+  //UV移动参数
				"add vt7.x,vt7.x,vc4.x \n"+         //再加一个1。  5+1=6
				"mov v6, vc[vt7.x] \n"+  //父级颜色
				"mov v3, va3 \n"+      //传VCindex过去
				"mov v1, va1";
			
			fragment =
				
				"mov ft1, v1 \n"+
				"sub ft1.x,ft1.x,v5.x \n"+
				
				"neg ft5.w,ft1.x \n"+  //大于0的部份不显示
				"kil ft5.w \n"+
				"sub ft5.w,ft1.x,v5.w \n"+  //小于最后周期
				"kil ft5.w \n"+
				
				"div ft5.w, ft1.x, v5.z \n"+   //计算拖尾的渐变色
				"abs ft5.w, ft5.w \n"+
				"sat ft5.w, ft5.w \n"+
				"sub ft5.w, v5.y, ft5.w \n"+
				
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
				"mov ft3, v3 \n"+
				"mul ft1.y,ft3.x,fc0.x \n"+   //将纹理分为 *1/32;

				"tex ft1, ft1, fs0 <2d,clamp,repeat>\n"+    //得到渐变颜色
				"mul ft0, ft0, ft1 \n"+
				"mul ft0, ft0, v6 \n"+     //外部颜色
				"mov oc, ft0";
		}
	}
}