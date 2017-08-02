package _Pan3D.display3D.lightProbe
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DLightProbeItemShader extends Shader3D
	{
		public static var DISPLAY3D_LIGHT_PROBE_ITEM_SHADER:String = "Display3DLightProbeItemShader";
		public function Display3DLightProbeItemShader()
		{
			vertex = 
				"m44 vt0, va0, vc8 \n" +
				"m44 vt0, vt0, vc4 \n" +
				"m44 op, vt0, vc0 \n" +
				"mov v0, va1 \n" +
				//12 base 16 sh
				"mov vt0, va1 \n" +
				"mov vt2, va1 \n" +
				//0
				"mov vt1.x,vc12.x\n" +
				"mul vt1.xyz,vt1.x,vc16.xyz \n" +
				"mov vt2.xyz,vt1.xyz \n" +
				//1
				"mul vt1.x,vc12.y,vt0.y \n" +
				"mul vt1.xyz,vt1.x,vc17.xyz \n" +
				"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
				//2
				"mul vt1.x,vc12.z,vt0.z \n" +
				"mul vt1.xyz,vt1.x,vc18.xyz \n" +
				"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
				//3
				"mul vt1.x,vc12.w,vt0.x \n" +
				"mul vt1.xyz,vt1.x,vc19.xyz \n" +
				"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
				
				//4
				"mul vt1.x,vc13.x,vt0.x \n" +
				"mul vt1.x,vt1.x,vt0.y \n" +
				"mul vt1.xyz,vt1.x,vc20.xyz \n" +
				"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
				
				//5
				"mul vt1.x,vc13.y,vt0.z \n" +
				"mul vt1.x,vt1.x,vt0.y \n" +
				"mul vt1.xyz,vt1.x,vc21.xyz \n" +
				"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
				
				//6
				"mul vt1.x,vt0.z,vt0.z\n" +
				"mul vt1.x,vt1.x,vc14.y\n" +
				"mul vt1.x,vc13.z,vt1.x \n" +
				"mul vt1.xyz,vt1.x,vc22.xyz \n" +
				"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
				//7
				"mul vt1.x,vc13.w,vt0.z \n" +
				"mul vt1.x,vt1.x,vt0.x \n" +
				"mul vt1.xyz,vt1.x,vc23.xyz \n" +
				"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
				//8
				"add vt1.x,vt0.x,vt0.y \n" +
				"sub vt1.y,vt0.x,vt0.y \n" +
				"mul vt1.x,vt1.x,vt1.y \n" +
				"mul vt1.x,vc14.x,vt1.x \n" +
				"mul vt1.xyz,vt1.x,vc24.xyz \n" +
				"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
				
				"mul vt2.xyz,vt2.xyz,vc14.z\n" +
				"mov v1, vt2";
			
			
			fragment =
				"mov oc, v1";
		}
	}
}