package  _Pan3D.display3D.ground
{
	import _Pan3D.program.Shader3D;
	
	public class GroundDisplayShader extends Shader3D
	{
		public static var GROUND_DISPLAY_SHADER:String = "GroundDisplayShader";
		
		public function GroundDisplayShader()
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
				"mov ft7, vi2 \n" +   //法线
				"mov ft6, vi2 \n" +   //法线
				"mov ft5, vi2 \n" +   //法线
				"mov ft2, vi2 \n" +   //法线
				"mov ft1, vi1 \n" +   //法线
				"mov ft0, vi0 \n" +   //顶点
				"mov ft0.y,ft0.z \n"+
				"div ft7.xy,ft0.xy,fc3.xy \n"+   // %400
				"mov ft6,ft7 \n"+
				
				
				"tex ft3, ft7, fs1 <2d,clamp>\n"+   //id
				"mul ft3, ft3,fc40.x \n"+  //*255
				
				
				
				/*********1111******/
			
			"mov ft4, fc43 \n"+
				"div ft4.y,ft3.x,fc43.w \n"+    //%16
				"tex ft4, ft4, fs4 <2d,clamp>\n"+   //UV密度的纹理
				"mul ft4, ft4,fc40.x \n"+  //*255
				
				"mul ft6.xy,ft7.xy,ft4.x \n"+
				"frc ft6.xy,ft6.xy \n"+
				"mov ft6.w, ft6.y \n"+
				
				"add ft6.y, ft6.w, ft3.x \n"+    //第第一个通道
				"div ft6.y, ft6.y, fc40.w \n"+
				"tex ft1, ft6.xy, fs3 <2d,clamp>\n"+   //sixteen
				
				/*********2222******/
			
			"mov ft4, fc43 \n"+
				"div ft4.y,ft3.y,fc43.w \n"+    //%16
				"tex ft4, ft4, fs4 <2d,clamp>\n"+   //UV密度的纹理
				"mul ft4, ft4,fc40.x \n"+  //*255
				
				"mul ft6.xy,ft7.xy,ft4.x \n"+
				"frc ft6.xy,ft6.xy \n"+
				"mov ft6.w, ft6.y \n"+
				
				"add ft6.y, ft6.w, ft3.y \n"+    //第第一个通道
				"div ft6.y, ft6.y, fc40.w \n"+
				"tex ft2, ft6.xy, fs3 <2d,clamp>\n"+   //sixteen
				
				/*********3333******/
			
			
			"mov ft4, fc43 \n"+
				"div ft4.y,ft3.z,fc43.w \n"+    //%16
				"tex ft4, ft4, fs4 <2d,clamp>\n"+   //UV密度的纹理
				"mul ft4, ft4,fc40.x \n"+  //*255
				
				"mul ft6.xy,ft7.xy,ft4.x \n"+
				"frc ft6.xy,ft6.xy \n"+
				"mov ft6.w, ft6.y \n"+
				
				"add ft6.y, ft6.w, ft3.z \n"+    //第第一个通道
				"div ft6.y, ft6.y, fc40.w \n"+
				"tex ft3, ft6.xy, fs3 <2d,clamp>\n"+   //sixteen
				
				
				/*********************************/
			
			"tex ft6, ft7, fs2 <2d,clamp>\n"+   //info
				
				"mul ft1, ft1,ft6.x \n"+
				"mul ft2, ft2,ft6.y \n"+
				"mul ft3, ft3,ft6.z \n"+
				
				"add ft1, ft1,ft2 \n"+
				"add ft1, ft1,ft3 \n"+
				
				
				
				"tex ft7, ft7, fs0 <2d,linear>\n"+   //取法线
				
				//"mov ft1, ft2 \n"+
				
				"sub ft7.xyz, ft7.xyz,fc7.y \n"+     //法线都减0.5
				"dp3 ft7.w, ft7, fc1 \n" +    //得到所在点的法线
				"sat ft7.w, ft7.w \n"+
				"mul ft0.xyz,fc0.xyz,ft7.w \n"+
				
				"mul ft0, ft1, ft0 \n"+
				"mul ft7, ft1, fc5 \n"+         //环境色和其基础颜色
				"add ft0.xyz,ft0.xyz,ft7.xyz \n"+
				
				//"mov ft0,ft7 \n"+
				
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