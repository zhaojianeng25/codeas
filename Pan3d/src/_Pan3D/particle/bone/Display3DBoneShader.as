package _Pan3D.particle.bone
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DBoneShader extends Shader3D
	{
		public static var DISPLAY3D_BONE_SHADER:String = "Display3DBoneShader";
		public function Display3DBoneShader()
		{
			vertex = 

				/*
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
				
				*/
				//注意粒子没有法线内容
				"mov vt0,va0 \n" +
				"mov vt0,va0 \n" +
				"mov vt0,va0 \n" +
				"mov vt0,va0 \n" +
				
				getMatrixOrQuat("vt0","va0")+
		
				"m44 vt5, vt0, vc4 \n" +
				"m44 op, vt5, vc0 \n" +
				"mov vt1,va1\n" +
				"add vt1,vt1,vc8\n" + 
				"mov v0, vt1";
			
			fragment =
				
				"tex ft1, v0, fs1 <2d,linear,repeat> \n"+
				
				"mov oc, ft1";
		}

		private function getMatrixOrQuat($vt6:String,$va0:String):String
		{
			
			var str:String = 
				
				getQtStr("vt0","x","va0")+
				getQtStr("vt1","y","va0")+
				getQtStr("vt2","z","va0")+
				getQtStr("vt3","w","va0")+
				
				
				"mul vt0,vt0,va2.x\n"+
				"mul vt1,vt1,va2.y\n"+
				"mul vt2,vt2,va2.z\n"+
				"mul vt3,vt3,va2.w\n"+
				
				"add vt0,vt0,vt1\n"+
				"add vt0,vt0,vt2\n"+
				"add vt0,vt0,vt3\n"+
				
				"neg vt0.x,vt0.x \n"+
				
				"mov "+$vt6+",vt0 \n"
			
			
			return str;
		}
		private function getQtStr(vt3:String,xyzw:String,va:String):String
		{
			var str:String = 
				"mov "+vt3+".xyz,"+va+".xyz \n"+
				"mov "+vt3+".w,vc15.w \n"+
				//	"mov vt7,vc15  \n"+  //先得到  -》1,1,1,1]
				//	"mov vt5,vc15  \n"+  //先得到  -》1,1,1,1]
				//	"mov vt4,vc15  \n"+  //先得到  -》1,1,1,1]
				"add vt7,va3,vc15  \n"+  //gpos 的位置
				"mov vt6,vc[va3."+xyzw+"]  \n"+  //quat
				"mov vt7,vc[vt7."+xyzw+"]  \n"+  //gpos
				
				"crs vt5.xyz,vt6.xyz,"+va+".xyz \n"+ //cross(m[0].xyz, v)
				"add vt5.xyz,vt5.xyz,vt5.xyz \n"+   //*2 ==t
				"mul vt4.xyz,vt5.xyz,vt6.w \n"+   //m[0].w * t
				"crs vt5.xyz,vt6.xyz,vt5.xyz \n"+ //cross(m[0].xyz, t)
				"add "+vt3+".xyz,"+vt3+".xyz,vt4.xyz \n"+  //v + m[0].w * t
				"add "+vt3+".xyz,"+vt3+".xyz,vt5.xyz \n";  //f
			
			
				str+="add "+vt3+".xyz,"+vt3+".xyz,vt7.xyz \n";   //正常需要加上移移
		
			return str
			
		}

	}
}