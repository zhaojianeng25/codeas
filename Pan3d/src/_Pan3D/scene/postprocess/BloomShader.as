package _Pan3D.scene.postprocess
{
	import _Pan3D.program.Shader3D;
	
	public class BloomShader extends Shader3D
	{
		public static var BLOOM_SHADER:String = "BloomShader";
		public function BloomShader()
		{
			vertex = 
				"mov op, va0 \n"+
				"mov v1, va1";
			fragment =
				"tex ft0, v1, fs0 <2d,clamp,linear>\n"+
				"dp3 ft1.x,ft0.xyz,fc0.xyz\n" +
				//"mul ft1.x,ft1.x,ft1.x\n" +
				//"mul ft1.x,ft1.x,fc1.x \n" +
				//"mul ft0.xyz,ft0.xyz,ft1.x\n" +
				"sub ft1.x,ft1.x,fc1.y\n" +
				"max ft1.x,ft1.x,fc1.z\n" +
				"mul ft1.x,ft1.x,fc1.x \n" +
				"mul ft0.xyz,ft0.xyz,ft1.x\n" +
				"mov oc, ft0";
		}
	}
}