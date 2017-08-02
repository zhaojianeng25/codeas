package _Pan3D.program.shaders
{
	import _Pan3D.program.Shader3D;
	
	public class NormalShader extends Shader3D
	{
		public static var NORMALSHADER:String = "normalshader";
		public function NormalShader()
		{
			vertex = 
				"m44 vt0, va0, vc4 \n" +
				"m44 vt1, vt0, vc0 \n" +
				
				"mov op, vt1 \n" +
				"mov v0, va1 \n" + 
				"mov v2, va2";
			fragment =
				"tex ft0, v0, fs1 <2d,clamp,repeat>\n"+
				"dp3 ft2.x,fc0,v2\n"+
				"mul ft2.x,ft2.x,fc1.w\n"+
				"mul ft2,ft0,ft2.x\n"+
				"add ft0,ft0,ft2\n"+
				"add ft0,ft0,fc1\n"+
				"mov oc, ft0"
				//"mov ft6,v2\n"+
				
				//"mov ft1,ft0\n"+
				//"mov ft3,fc0\n"+
				//"mov ft2,fc0\n"+
				
				//"dp3 ft2.y,ft3,ft3\n"+
				//"dp3 ft2.z,ft6,ft6\n"+
				
				//"sqt ft2.y,ft2.y\n"+
				//"sqt ft2.z,ft2.z\n"+
				//"div ft2.x,ft2.x,ft2.y\n"+
				//"div ft2.x,ft2.x,ft2.z\n"+
				
				
				
				//"add ft0.x,ft0.x,fc1.x\n"+
				//"add ft0.y,ft0.y,fc1.y\n"+
				//"add ft0.z,ft0.z,fc1.z\n"+
				
				
		}
	}
}