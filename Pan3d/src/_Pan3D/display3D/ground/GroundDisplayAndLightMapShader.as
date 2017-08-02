package _Pan3D.display3D.ground
{
	import flash.display3D.Context3DProgramType;
	
	import _Pan3D.program.Shader3D;
	
	public class GroundDisplayAndLightMapShader extends Shader3D
	{
		public static var GROUND_DISPLAY_AND_LIGHTMAP_SHADER:String = "GroundDisplayAndLightMapShader";
		
		public function GroundDisplayAndLightMapShader()
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
				"add ft0, ft1,ft3 \n"+
				
				
				
				"tex ft7, ft7, fs0 <2d,linear>\n"+   //取法线
				
				//"mov ft1, ft2 \n"+
				
				
				
				"mov ft1, vi0 \n" +   //顶点
				"mov ft1.y,ft1.z \n"+
				"div ft7.xy,ft1.xy,fc3.xy \n"+   // %400
				"tex ft1, ft7, fs5 <2d,linear>\n"+   //id
				
				"mul ft0.xyz, ft0.xyz, ft1.xyz \n"+
				"mul ft0.xyz, ft0.xyz, fc7.w \n"+
				
			//	_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 7, Vector.<Number>([0,0.5,1,2]));
				
				"mov fo,ft0"
		}
	}
}