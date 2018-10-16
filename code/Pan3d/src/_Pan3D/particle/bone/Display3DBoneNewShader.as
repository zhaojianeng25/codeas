package _Pan3D.particle.bone
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DBoneNewShader extends Shader3D
	{
		public static var DISPLAY3D_BONENEW_SHADER:String = "Display3DBoneNewShader";
		public function Display3DBoneNewShader()
		{
			vertex = 
				"m44 vt0, va0,vc[va6.x]\n"+
				"m44 vt1, va1,vc[va6.y]\n"+
				"m44 vt2, va2,vc[va6.z]\n"+
				"m44 vt3, va3,vc[va6.w]\n"+
				
				"mul vt0,vt0,va5.x\n"+
				"mul vt1,vt1,va5.y\n"+
				"mul vt2,vt2,va5.z\n"+
				"mul vt3,vt3,va5.w\n"+
				
				"add vt0,vt0,vt1\n"+
				"add vt0,vt0,vt2\n"+
				"add vt0,vt0,vt3\n"+
				
				"m44 vt5, vt0, vc4 \n" +
				"m44 op, vt5, vc0 \n" +
				"mov v0, va4";
			
			fragment =
				
				//"mov ft2,fc0 \n" +
				"mov ft0, v0 \n"+
				//"mov ft3.x,fc0.y \n" +
				
				//"slt ft3.y,ft3.x,fc0.w \n" +
				//"sge ft3.z,ft3.x,fc0.w \n" +
				//"mul ft3.y,ft3.y,fc0.y \n" +
				//"mul ft3.z,ft3.z,fc0.w \n" +
				//"add ft3.x,ft3.y,ft3.z \n" + 
				
				
				//"div ft3.x,ft3.x,fc0.z \n" +
			
				//"frc ft5.x,ft3.x \n"+  //UV 分段。。4*4
				//"sub ft5.x,ft3.x,ft5.x \n"+ //现在的ft4为整数
				//"div ft6.x,ft5.x,fc3.x \n"+
				//"add ft0.x,ft0.x,ft6.x \n"+
				//"div ft6.x,ft5.x,fc3.x \n"+
				//"frc ft6.w,ft6.x \n"+
				//"sub ft6.y, ft6.x,ft6.w \n"+
				//"div ft6.y,ft6.y,fc3.y \n"+
				//"add ft0.y,ft0.y,ft6.y \n"+

				"tex ft2, ft0, fs2 <2d,linear,repeat> \n"+
				
				//"mul ft6.xy,fc3.xy,fc0.y \n"+  //UV移动  
				"add ft0.xy,ft0.xy,fc0.xy \n"+
				
				"tex ft1, ft0, fs1 <2d,linear,repeat> \n"+
				"div ft1.xyz,ft1.xyz,ft1.w \n" + 
				//"mul ft1, ft1,fc2 \n" + 
				
				
//				"tex ft2, ft2, fs2 <2d,clamp,repeat>\n"+
				"mul ft1, ft1,ft2 \n" + 
				
				"mul ft1, ft1,fc1 \n" + 
				"mul ft1.xyz,ft1.xyz,ft1.w\n" +
				"mov oc, ft1";
		}
	}
}