package _Pan3D.particle.followLocus
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DFollowLocusShader extends Shader3D
	{
		public static var DISPLAY3DFOLLOWLOCUSSHADER:String = "Display3DFollowLocusShader";
		// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
		public function Display3DFollowLocusShader()
		{
			vertex = 
				"mov vt0,va0 \n"+
				"m44 vt0, vt0, vc4 \n" +
				"m44 vt0, vt0, vc[va1.z] \n" +
				"m44 vt0, vt0, vc12 \n" +
				"m44 op, vt0, vc0 \n" +
				
				"mov v1, va1";
			fragment =
				"mov ft1, v1 \n"+

				"tex ft0, ft1, fs1 <2d,linear,repeat> \n"+
				"div ft0.xyz,ft0.xyz,ft0.w \n" + 
				
				"mov ft2,fc0 \n" +
//				"tex ft2, ft2, fs2 <2d,clamp,repeat>\n"+
//				"mul ft0, ft0,ft2 \n" + 
				
				"mul ft0, ft0,fc1 \n" + 
				"mul ft0.xyz,ft0.xyz,ft0.w\n" +
				"mov oc, ft0";
		}
		
		
		override public function get vertex():String{
			var watchPosStr:String = 

				"mov vt0,vc[va0.x] \n" +
				"sub vt1.xyz,vc12.xyz,vt0.xyz\n" +
				"nrm vt1.xyz,vt1.xyz\n" +
				"mov vt2,vc[va0.y] \n" +
				"crs vt2.xyz,vt1.xyz,vt2.xyz\n" +
				"nrm vt2.xyz,vt2.xyz\n" + 
				"mul vt2.xyz,vt2.xyz,va0.z \n" +
				"add vt0.xyz,vt2.xyz,vt0.xyz \n" +
				
				"m44 vt0, vt0, vc8 \n" + 
				"m44 op, vt0, vc0";
			
			var uvStr:String=
				"mul vt1.xy, vt1.xy, vc16.xy \n"+//换一下UV,
				"mul vt4.xy, vt1.xy, vc16.z \n"+  //互换UV
				"mul vt5.xy, vt1.xy, vc16.w \n"+
				"add vt1.x, vt4.x,vt5.y \n"+
				"add vt1.y, vt4.y,vt5.x";
			var outUv:String=
				"mov v0, va1 ";
			
			
			
			return watchPosStr + LN + outUv;
		}
		
	}
}