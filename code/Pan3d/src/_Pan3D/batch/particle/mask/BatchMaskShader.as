package _Pan3D.batch.particle.mask
{
	import _Pan3D.program.Shader3D;
	
	public class BatchMaskShader extends Shader3D
	{
		public static var BATCH_MASK_SHADER:String = "BatchMaskShader";
		public function BatchMaskShader()
		{
			vertex = 
				"m44 vt0, va0, vc[va2.x] \n" +
//				"m44 vt0, vt0, vc[va2.z] \n" +
				"m44 op, vt0, vc0 \n" +
				
//				"mov vt3.x,vc12.y \n" +
//				"slt vt3.y,vt3.x,vc12.w \n" +
//				"sge vt3.z,vt3.x,vc12.w \n" +
//				"mul vt3.y,vt3.y,vc12.y \n" +
//				"mul vt3.z,vt3.z,vc12.w \n" +
//				"add vt3.x,vt3.y,vt3.z \n" + 
//				"div vt3.x,vt3.x,vc12.z \n" +
				
				"mov vt1, va1 \n"+
				"mov vt2, vc[va2.y] \n" +
				"add vt1.xy,vt1.xy,vt2.xy \n" + 
//				"add vt1.xy,vt1.xy,vt2.zw \n" + 
				
//				"frc vt5.x,vt3.x \n"+  //UV 分段。。4*4
//				"sub vt5.x,vt3.x,vt5.x \n"+ //现在的ft4为整数
//				"div vt6.x,vt5.x,vc13.x \n"+
//				"add vt4.x,vt4.x,vt6.x \n"+
//				"div vt6.x,vt5.x,vc13.x \n"+
//				"frc vt6.w,vt6.x \n"+
//				"sub vt6.y,vt6.x,vt6.w \n"+
//				"div vt6.y,vt6.y,vc13.y \n"+
//				"add vt4.y,vt4.y,vt6.y \n"+
//				
//				"mul vt6.xy,vc13.zw,vt3.x \n"+  //UV移动  
//				"add vt4.xy,vt4.xy,vt6.xy \n"+
//                "mov vt4.z,vc12.x \n"+
				"mov v1, vc[va2.z] \n" +
				"mov v0, vt1";
			fragment =
				
				"tex ft1, v0, fs1 <2d,linear,repeat> \n"+
//				"div ft1.xyz,ft1.xyz,ft1.w \n" + 
                 
//				"tex ft2, v0.zw, fs2 <2d,clamp,repeat>\n"+
//				"mul ft1, ft1,ft2 \n" + 
				"mul ft1.xyz, ft1.xyz,v1.xyz \n" + 
				"mul ft1.xyz, ft1.xyz,v1.w \n" + 
//				"mul ft1.xyz, ft1.xyz,v1 \n" + 
//				"mul ft1.xyz,ft1.xyz,ft1.w\n" +
				
				"tex ft2, v0.zw, fs2 <2d,clamp,repeat>\n"+
				"mul ft1.xyz,ft1.xyz,ft2.xyz\n" +
				
				"mov oc, ft1";
		}
	}
}