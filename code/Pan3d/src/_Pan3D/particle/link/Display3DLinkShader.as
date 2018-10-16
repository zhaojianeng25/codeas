package _Pan3D.particle.link
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DLinkShader extends Shader3D
	{
		public static var DISPLAY3DLINKSHADER:String = "display3Dlinkshader";
		public function Display3DLinkShader()
		{
			vertex = 
			
				"mov vt0,va0 \n"+
				"mov vt1,vc[va2.x] \n"+
				"m44 vt1,vt1,vc4 \n"+
				"add vt1,vt1,vt0 \n"+
				
				"m44 op, vt1, vc0 \n" +
				"mov v0, va1";
			fragment =
				
				"mov ft2,fc0 \n" +
				"mov ft0, v0 \n"+
				"mov ft3.x,fc0.y \n" +
				
				"slt ft3.y,ft3.x,fc0.w \n" +
				"sge ft3.z,ft3.x,fc0.w \n" +
				"mul ft3.y,ft3.y,fc0.y \n" +
				"mul ft3.z,ft3.z,fc0.w \n" +
				"add ft3.x,ft3.y,ft3.z \n" + 
				
				
				"div ft3.x,ft3.x,fc0.z \n" +
			
				"frc ft5.x,ft3.x \n"+  //UV 分段。。4*4
				"sub ft5.x,ft3.x,ft5.x \n"+ //现在的ft4为整数
				"div ft6.x,ft5.x,fc3.x \n"+
				"add ft0.x,ft0.x,ft6.x \n"+
				"div ft6.x,ft5.x,fc3.x \n"+
				"frc ft6.w,ft6.x \n"+
				"sub ft6.y, ft6.x,ft6.w \n"+
				"div ft6.y,ft6.y,fc3.y \n"+
				"add ft0.y,ft0.y,ft6.y \n"+

			
				
				"mul ft6.xy,fc3.zw,ft3.x \n"+  //UV移动  
				"add ft0.xy,ft0.xy,ft6.xy \n"+
				
				"tex ft1, ft0, fs1 <2d,linear,repeat> \n"+
				"div ft1.xyz,ft1.xyz,ft1.w \n" + 
				//"mul ft1, ft1,fc2 \n" + 
				
				
				"tex ft2, ft2, fs2 <2d,clamp,repeat>\n"+
				"mul ft1, ft1,ft2 \n" + 
				
				"mul ft1, ft1,fc1 \n" + 
				"mul ft1.xyz,ft1.xyz,ft1.w\n" +
				"mov oc, ft1";
		}
	}
}