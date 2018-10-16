package _Pan3D.particle.cylinder
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DCylinderShader extends Shader3D
	{
		public static var DISPLAY3DCYLINDERSHADER:String = "display3DCylinderShader";
		public function Display3DCylinderShader()
		{
			vertex = 
				"mov vt0,va0 \n" + 
//				"mul vt0.xz,vt0.xz,vc16.x \n" + 
//				"mul vt0.y,vt0.y,vc16.y \n" + 
//				"mul vt0.xz,vt0.xz,va1.z \n" + 
				"m44 vt0, vt0, vc24 \n" +
				"m44 vt0, vt0, vc8 \n" +
				"m44 vt0, vt0, vc4 \n" +
				"m44 op, vt0, vc0 \n" +
				"mov vt1, va1\n" + 
				"add vt1.xy,vt1.xy,vc17.xy\n" + 
				"mov v0,vt1"
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
//				"div ft1.xyz,ft1.xyz,ft1.w \n" + 
				
//				"mul ft1, ft1,fc1 \n" + 
//				"mul ft1.xyz,ft1.xyz,ft1.w\n" +
				"mov oc, ft1";
		}
	}
}