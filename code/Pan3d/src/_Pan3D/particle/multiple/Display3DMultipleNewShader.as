package _Pan3D.particle.multiple
{
	import _Pan3D.program.Shader3D;
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Display3DMultipleNewShader extends Shader3D
	{
		public static var DISPLAY3DMULTIPLENEWSHADER:String = "Display3DMultipleNewShader";

		public function Display3DMultipleNewShader()
		{
			vertex = 
				"mov vt0,va0\n" + 
				
				
				
				/**当前时间***********/
				"sub vt1.x,vc12.x,va2.w\n"+//vt1.x为当前帧数(时间)
				/**控制粒子按顺序发射*******/
				"sge vt1.y,vc13.y,vt1.x\n" +
				
				"mul vt1.y,vt1.y,vc13.x\n" +
				"add vt0.y,vt0.y,vt1.y\n"+
				
				"div vt1.y,vt1.x,vc12.y\n" +
				"frc vt1.y,vt1.y\n"+
				"mul vt1.y,vc12.y,vt1.y\n" +
				
				"mul vt2.x,vt1.y,vc8.x\n" +
				"mul vt2.y,vt1.x,vc8.y\n" +
				"add vt1.x,vt2.x,vt2.y\n" +
				
				"slt vt1.z,vc12.y,vt1.x\n" +
				"mul vt1.y,vt1.z,vc13.x\n" +
				"add vt0.y,vt0.y,vt1.y\n"+
				
				
				/**比例变化部分***********/
				"mul vt2.x,vt1.x,vc12.z\n" +
				"mul vt2.y,vt1.x,vc9.x\n" +
				"sin vt2.y,vt2.y\n" +
				"mul vt2.y,vt2.y,vc9.y\n" +
				"add vt2.x,vt2.x,vt2.y\n" +
				
				"slt vt3.x,vt2.x,vc15.z\n" +
				"sge vt3.y,vt2.x,vc15.z\n" +
				"mul vt3.x,vt2.x,vt3.x\n" +
				"mul vt3.y,vc15.z,vt3.y\n" +
				"add vt2.x,vt3.x,vt3.y\n" + 
				
				"sge vt3.x,vt2.x,vc15.w\n" +
				"slt vt3.y,vt2.x,vc15.w\n" +
				"mul vt3.x,vt2.x,vt3.x\n" +
				"mul vt3.y,vc15.w,vt3.y\n" +
				"add vt2.x,vt3.x,vt3.y\n" + 
					
				"mov vt2.y,vt2.x\n" +
				"mul vt2.xy,vt2.xy,vc15.xy\n" +
				"add vt2.xy,vt2.xy,vc13.w\n" +
				
				"mul vt0.xy,vt0.xy,vt2.xy\n" +
				
				
				
				
				//"add vt0.xyz,vt0.xyz,va2.xyz \n" + 
				
				/**匀速运动部分***********/
				"mul vt2.xyz,va3.xyz,vt1.x\n" +
				//"add vt0.xyz,vt0.xyz,vt2.xyz\n" +
				"add vt4.xyz,vt2.xyz,va2.xyz\n" +
				
				/**加速度部分***********/
				"nrm vt2.xyz,va3.xyz\n" +
				"mul vt2.xyz,vt2.xyz,vc13.z\n" + 
				"add vt2.xyz,vt2.xyz,vc14.xyz\n" +
				"mul vt1.y,vt1.x,vt1.x\n"+
				"mul vt2.xyz,vt2.xyz,vt1.y\n" +
				//"add vt0.xyz,vt0.xyz,vt2.xyz\n" +	
				"add vt4.xyz,vt4.xyz,vt2.xyz\n" +
				"mov vt4.w,vt0.w\n" +
				
				/************************/
				
				
				//"mul vt0.xy,vt0.xy,vc24.xy\n" +
				//"mul vt0.y,vt0.y,vc11.z\n" +
				
				//"sub vt5,vt4,vc24\n"+
				
				"m44 vt5,vt4,vc4\n" +
				
				/*
				"nrm vt1.xyz,vt4.xyz\n" +
				"mul vt1.y,vt1.y,vc11.y\n" +
				"mul vt2.xy,vt1.xy,vt1.xy\n" +
				"add vt2.x,vt2.x,vt2.y\n" +
				"sqt vt1.z,vt2.x\n" +
				"div vt2,xy,vt1.xy,vt1.z\n" +
				"mul vt3.xy,vt2.yx,vt0.x\n" +
				"mul vt3.x,vt3.x,vc14.w\n" +
				
				"nrm vt1.xyz,vt4.xyz\n" +
				"mul vt1.y,vt1.y,vc11.w\n" +
				"mul vt2.xy,vt1.xy,vt1.xy\n" +
				"add vt2.x,vt2.x,vt2.y\n" +
				"sqt vt1.z,vt2.x\n" +
				"div vt2,xy,vt1.xy,vt1.z\n" +
				
				"mul vt2.xy,vt2.xy,vt0.y\n" +
				
				"add vt1.xy,vt3.xy,vt2.xy\n" +
				
				*/
				
				/**基础旋转部分***********/
				"mov vt2,vc24\n " +
				"m44 vt2,vt2,vc4\n" +
				"sub vt2,vt5,vt2\n" +
				"nrm vt2.xyz,vt2.xyz\n" +
				"mul vt2.y,vt2.y,vc11.y\n" +
				"mul vt3.xy,vt2.xy,vt2.xy\n" +
				"add vt3.z,vt3.x,vt3.y\n" +
				"sqt vt3.z,vt3.z\n" +
				"div vt3,xy,vt2.xy,vt3.z\n" +
				
				"mul vt2.x,vt3.y,vt0.y\n" + //b.y = cos_z * a.y - sin_z * a.x;
				"mul vt2.y,vt3.x,vt0.x\n" +
				"sub vt2.z,vt2.x,vt2.y\n" +
				"mul vt2.x,vt3.x,vt0.y\n" + //b.x = sin_z * a.y + cos_z * a.x;
				"mul vt2.y,vt3.y,vt0.x\n" +
				"add vt0.x,vt2.x,vt2.y\n" +
				"mov vt0.y,vt2.z\n" +
				
				/**面向视点***********/
				"m44 vt0,vt0,vc16\n" +
					
				"add vt0.xyz,vt0.xyz,vt4.xyz\n" +
					
				"m44 vt0,vt0,vc4\n" +
					
				//"add vt4.xy,vt0.xy,vt4.xy\n" +
				
				
				//"add vt4.xy,vt4.xy,vt0.xy\n" +
				
				"m44 op, vt0, vc0 \n" + 
				
				/**uv部分**********************/
				"mov vt2,va1\n" +
				"mov vt4.x,vt1.x\n"+
				"div vt1.x,vt1.x,vc10.w \n" +
				"frc vt1.y,vt1.x \n"+
				"sub vt1.x,vt1.x,vt1.y \n"+//vt1为当前动画帧数
				"div vt3.x,vt1.x,vc10.x \n"+
				"add vt2.x,vt2.x,vt3.x \n"+
				"frc vt3.y,vt3.x \n"+
				"sub vt3.x,vt3.x,vt3.y \n"+
				"div vt3.x,vt3.x,vc10.y \n"+
				"add vt2.y,vt2.y,vt3.x \n"+
				
				"mul vt3.xy,vc9.zw,vt4.x\n" +
				"add vt2.xy,vt2.xy,vt3.xy\n" +
				"mov v0, vt2\n"+
				
				"div vt1.x,vt4.x,vc12.y\n" + 
				"mov vt1.y,vc8.z\n"+
				"mov vt1.z,va1.z\n" +
				"mov vt1.w,vc8.w\n"+
				"mov v1,vt1";
				
			fragment =
				"tex ft0, v0.xy, fs1 <2d,linear,repeat>\n"+
				
				"tex ft1, v1.xy, fs0 <2d,linear>\n"+
				
				"mul ft0,ft0,ft1\n" +
				
				"tex ft2, v1.zw, fs0 <2d,linear>\n"+
				
				"mul ft0,ft0,ft2\n" +
				
				"mov oc ft0 ";
		}
	}
}