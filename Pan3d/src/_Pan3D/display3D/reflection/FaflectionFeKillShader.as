package _Pan3D.display3D.reflection
{
	import _Pan3D.program.Shader3D;

	public class FaflectionFeKillShader  extends Shader3D
	{
		public static var FA_FLECTIONFE_KILL_SHADER:String = "FaflectionFeKillShader";
		public function FaflectionFeKillShader()
		{
			vertex = 
				
				"m44 vt0, va0, vc8 \n" + 
				"mov vt2, vt0 \n"+
				"sub vt2.y,vt2.y,vc12.y \n"+
				"mov vi3, vt2 \n"+
				
				"m44 vt0, vt0, vc4 \n" + 
				"m44 vo,  vt0, vc0 \n" + 
				"mov vi2, va2 \n"+
				"mov vi1, va1";
			
			fragment =
				"mov ft3, vi3 \n"+
				"kil ft3.y \n"+
				
				"mov ft0, vi1 \n"+
				
				"tex ft1, vi2, fs1 <2d,linear>\n"+   //灯光图
				"tex ft0, vi1, fs0 <2d,linear>\n"+   //取纹理
	
				"sub ft3.w,ft0.w,fc9.w \n"+
				"kil ft3.w \n"+
				
				"mul ft0.xyz, ft0.xyz, ft1.xyz \n"+
				"mul ft0.xyz, ft0.xyz, fc9.xyz \n"+
				
				"mov fo, ft0 "
			
		}
	}
}