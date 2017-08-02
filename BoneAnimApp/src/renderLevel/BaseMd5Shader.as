package renderLevel
{
	import _Pan3D.program.Shader3D;
	
	public class BaseMd5Shader extends Shader3D
	{
		public static var BASEMD5SHADER:String = "md5shader";
		public function BaseMd5Shader()
		{
			vertex = 
		
				
				getQtStr("vt0","x","va0")+
				getQtStr("vt1","y","va1")+
				getQtStr("vt2","z","va2")+
				getQtStr("vt3","w","va3")+
				
	
				
				"mul vt0,vt0,va5.x\n"+
				"mul vt1,vt1,va5.y\n"+
				"mul vt2,vt2,va5.z\n"+
				"mul vt3,vt3,va5.w\n"+
				
				"add vt0,vt0,vt1\n"+
				"add vt0,vt0,vt2\n"+
				"add vt0,vt0,vt3\n"+
				
				"neg vt0.x,vt0.x \n"+
				
				"m44 vt5, vt0, vc4 \n" +
				"m44 op, vt5, vc0 \n" +
				"mov v1, va4";
			fragment = 
				"tex ft1, v1, fs1 <2d,linear>\n"+
				"div ft1.xyz,ft1.xyz,ft1.w \n" +
				"mul ft1,ft1,fc5\n"+
				"mov oc, ft1"
		}
		private function getQtStr(vt3:String,xyzw:String,va:String):String
		{
			var str:String = 
				"mov "+vt3+".xyz,"+va+".xyz \n"+
				"mov "+vt3+".w,vc15.w \n"+
				"mov vt7,vc15  \n"+  //先得到  -》1,1,1,1]
				"mov vt5,vc15  \n"+  //先得到  -》1,1,1,1]
				"mov vt4,vc15  \n"+  //先得到  -》1,1,1,1]
				"add vt7,vt7,va6,  \n"+  //gpos 的位置
				"mov vt6,vc[va6."+xyzw+"]  \n"+  //quat
				"mov vt7,vc[vt7."+xyzw+"]  \n"+  //gpos
				
				"crs vt5.xyz,vt6.xyz,"+va+".xyz \n"+ //cross(m[0].xyz, v)
				"add vt5.xyz,vt5.xyz,vt5.xyz \n"+   //*2 ==t
				"mul vt4.xyz,vt5.xyz,vt6.w \n"+   //m[0].w * t
				"crs vt5.xyz,vt6.xyz,vt5.xyz \n"+ //cross(m[0].xyz, t)
				"add "+vt3+".xyz,"+vt3+".xyz,vt4.xyz \n"+  //v + m[0].w * t
				"add "+vt3+".xyz,"+vt3+".xyz,vt5.xyz \n"+  //f
				"add "+vt3+".xyz,"+vt3+".xyz,vt7.xyz \n";
			
			return str
			
		}
	}
}