package renderLevel
{
	import _Pan3D.program.Shader3D;
	
	public class NewMd5Shader extends Shader3D
	{
		public static var NewMd5Shader:String = "NewMd5Shader";
		public function NewMd5Shader()
		{
			vertex = 
				
				"m44 vt0, va0,vc[va3.x]\n"+
				"m44 vt1, va0,vc[va3.y]\n"+
				"m44 vt2, va0,vc[va3.z]\n"+
				"m44 vt3, va0,vc[va3.w]\n"+
				
				"mul vt0,vt0,va2.x\n"+
				"mul vt1,vt1,va2.y\n"+
				"mul vt2,vt2,va2.z\n"+
				"mul vt3,vt3,va2.w\n"+
				
				"add vt0,vt0,vt1\n"+
				"add vt0,vt0,vt2\n"+
				"add vt0,vt0,vt3\n"+
				
				"m44 vt0, vt0, vc4 \n" +
				"m44 op, vt0, vc0 \n" +
				
				"m44 vt0, va4,vc[va3.x]\n"+
				"m44 vt1, va4,vc[va3.y]\n"+
				"m44 vt2, va4,vc[va3.z]\n"+
				"m44 vt3, va4,vc[va3.w]\n"+
				
				"mul vt0,vt0,va2.x\n"+
				"mul vt1,vt1,va2.y\n"+
				"mul vt2,vt2,va2.z\n"+
				"mul vt3,vt3,va2.w\n"+
				
				"add vt0,vt0,vt1\n"+
				"add vt0,vt0,vt2\n"+
				"add vt0,vt0,vt3\n"+
				
				"m44 vt0, vt0, vc4 \n" +
				
				"nrm vt0.xyz,vt0.xyz \n" +
				
				//"m44 vt1, vc8, vc4 \n" +
				
				"dp3 vt0.x,vt0.xyz,vc8.xyz\n"+
				
				"sub vt0.x,vt0.x,vc9.y\n" +
				"mul vt0.x,vt0.x,vc9.x\n"+
				"max vt0.x,vt0.x,vc9.w\n" +
				"add vt0.x,vt0.x,vc9.z\n" +
				
				
				
				//"add vt0.x,vt0.x,vc9.y\n" +
				
				"mov v2,vt0\n"+
				
				
				
				"mov v1, va1";
			fragment =
				"tex ft1, v1, fs1 <2d,linear,repeat>\n"+
				/*
				"dp3 ft0.x,v2.xyz,fc8.xyz\n"+
				
				"mul ft0.x,ft0.x,fc9.x\n"+
				
				"add ft0.x,ft0.x,fc9.y\n" +
				*/
				
				"tex ft2, v1, fs2 <2d,linear,repeat>\n"+
				
				"mul ft2.xyz,ft2.xyz,v2.x \n" +
				
				"add ft1.xyz,ft1,xyz,ft2.xyz\n" +
				
				"mov oc, ft1";
		}
	}
}