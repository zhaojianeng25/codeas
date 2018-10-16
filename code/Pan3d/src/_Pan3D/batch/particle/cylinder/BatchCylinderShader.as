package _Pan3D.batch.particle.cylinder
{
	import _Pan3D.program.Shader3D;
	
	public class BatchCylinderShader extends Shader3D
	{
		public static var BATCH_CYLINDER_SHADER:String = "BatchCylinderShader";
		public function BatchCylinderShader()
		{
			vertex = 
				"mov vt0,va0 \n" + 
				"mul vt0.xz,vt0.xz,vc[va2.y].z \n" + 
				"mul vt0.y,vt0.y,vc[va2.y].w \n" + 
				"mul vt0.xz,vt0.xz,va1.z \n" + 
				"m44 vt0, vt0, vc[va2.x] \n" +
				"m44 op, vt0, vc0 \n" +
				
				"mov vt1, va1 \n"+
				"mov vt2, vc[va2.y] \n" +
				"add vt1.xy,vt1.xy,vt2.xy \n" + 
				
				"mov v1, vc[va2.z] \n" +
				"mov v0, vt1";
			fragment =
				
//				"mov ft2,fc0 \n" +
//				"mov ft0, v0 \n"+
//				"mov ft3.x,fc0.y \n" +
//				
//				"frc ft5.x,ft3.x \n"+  //UV 分段。。4*4
//				"sub ft5.x,ft3.x,ft5.x \n"+ //现在的ft4为整数
//				"div ft6.x,ft5.x,fc3.x \n"+
//				"add ft0.x,ft0.x,ft6.x \n"+
//				"div ft6.x,ft5.x,fc3.x \n"+
//				"frc ft6.w,ft6.x \n"+
//				"sub ft6.y, ft6.x,ft6.w \n"+
//				"div ft6.y,ft6.y,fc3.y \n"+
//				"add ft0.y,ft0.y,ft6.y \n"+
//			
//				
//				"mul ft6.xy,fc3.zw,ft3.x \n"+  //UV移动  
//				"add ft0.xy,ft0.xy,ft6.xy \n"+
				
				"tex ft1, v0, fs1 <2d,linear,repeat> \n"+
				
				"mul ft1.xyz, ft1.xyz,v1.xyz \n" + 
				"mul ft1.xyz, ft1.xyz,v1.w \n" + 
				//"div ft1.xyz,ft1.xyz,ft1.w \n" + 
				//"mul ft1, ft1,fc2 \n" + 
//				"tex ft2, ft2, fs2 <2d,clamp,repeat>\n"+
//				"mul ft1, ft1,ft2 \n" + 
//				
//				"mul ft1, ft1,fc1 \n" + 
				//"mul ft1.xyz,ft1.xyz,ft1.w\n" +
				"mov oc, ft1";
		}
	}
}