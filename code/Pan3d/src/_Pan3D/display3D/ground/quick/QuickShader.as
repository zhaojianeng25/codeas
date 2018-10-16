package _Pan3D.display3D.ground.quick
{
	import _Pan3D.program.Shader3D;
	
	public class QuickShader extends Shader3D
	{
		public static var QUICK_SHADER:String = "QuickShader";
		public function QuickShader()
		{
			version = 2;
			vertex = 
				
				"m44 vt0,va0,vc8 \n"+
				"mov vi2,vt0 \n"+    //点所在的世界坐标
				"m44 vt0,vt0,vc4 \n"+
				"mov vi1, va1 \n"+
				"mov vi0, va0 \n"+
				"m44 vo, vt0,vc0"
			
			fragment =
				"mov ft2, vi2 \n" +   //法线
				"mov ft1, vi1 \n" +   //法线
				"mov ft0, vi0 \n" +   //顶点
				"mov ft0.y,ft0.z \n"+
				"div ft0.xy,ft0.xy,fc0.xy \n"+   // %400
				"tex ft0, ft0, fs0 <2d,miplinear,linear>\n"+   //取纹理
				
				
				"sub ft2,vi2,fc2 \n"+
				"dp3 ft2.x,ft2,ft2 \n"+
				"sqt ft2.x,ft2.x \n"+
				"mov ft3, ft2 \n"+
				"mov ft3.w, ft2.x \n"+
				
				"div ft2.x,ft2.x,fc4.w \n"+    //brushSize
				"sub ft2.x,fc1.w,ft2.x \n"+  //1-(d-w)
				"sat ft2.x,ft2.x \n"+
				"ifg ft2.x,fc2.w\n"+
					"mul ft2.x,ft2.x,fc4.x\n"+
					"sat ft2.x,ft2.x \n"+
					"mul ft2.x,ft2.x,fc4.y \n"+   //*brushPow
				"eif\n"+
				
				
				"sub ft3.x,ft3.w,fc4.z \n"+   //-100
				"abs ft3.x,ft3.x \n"+
				"sub ft3.x,fc1.w,ft3.x \n"+  //1-(d-w)
				"sat ft3.x,ft3.x \n"+
				
				"sub ft3.y,ft3.w,fc4.w \n"+   //-100
				"abs ft3.y,ft3.y \n"+
				"sub ft3.y,fc1.w,ft3.y \n"+  //1-(d-w)
				"sat ft3.y,ft3.y \n"+
				
				"ife fc8.x,fc8.y\n"+
					"add ft0.x,ft0.x,ft2.x \n"+
					"add ft0.xyz,ft0.xyz,ft3.x \n"+
					"add ft0.xyz,ft0.xyz,ft3.y \n"+
				"eif\n"+
				
				
				
				
				"mov fo,ft0"
		}
	}
}