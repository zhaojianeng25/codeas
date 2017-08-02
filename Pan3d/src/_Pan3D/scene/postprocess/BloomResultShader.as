package _Pan3D.scene.postprocess
{
	import _Pan3D.program.Shader3D;
	
	public class BloomResultShader extends Shader3D
	{
		public static var BLOOM_RESULT_SHADER:String = "BloomResultShader";
		public function BloomResultShader()
		{
			vertex = 
				"mov op, va0 \n"+
				"mov v1, va1";
//			fragment =
//				"tex ft0, v1, fs0 <2d,clamp,linear>\n"+
//				"tex ft1, v1, fs1 <2d,clamp,linear>\n"+
//				"add ft0.xyz,ft0.xyz,ft1.xyz\n" +
//				"mov oc, ft0";
		}
		
		override public function get fragment():String
		{
			//paramAry
			var _usePs:Boolean = paramAry[0];
			
			var useVignette:Boolean = paramAry[1];
			
			var useDistortion:Boolean = paramAry[2];
			
			var preUvStr:String;
			
			if(useDistortion){
				preUvStr = 
					"tex ft2, v1, fs3 <2d,clamp,linear>\n"+
					"add ft2,ft2,v1\n";
			}else{
				preUvStr = "mov ft2,v1\n";
			}
			
			var baseStr:String =
				"tex ft0, ft2, fs0 <2d,clamp,linear>\n"+
				"tex ft1, ft2, fs1 <2d,clamp,linear>\n"+
				"add ft0.xyz,ft0.xyz,ft1.xyz\n";
			var psStr:String;
			if(_usePs){
				psStr = 
					"dp3 ft1.x,ft0.xyz,fc0.xyz \n" +
					"add ft1.x,ft1.x,fc0.w\n" +
					
					"dp3 ft1.y,ft0.xyz,fc1.xyz \n" +
					"add ft1.y,ft1.y,fc1.w\n" +
					
					"dp3 ft1.z,ft0.xyz,fc2.xyz \n" +
					"add ft1.z,ft1.z,fc2.w\n" +
					
					"mov ft0.xyz,ft1.xyz\n";
			}else{
				psStr = new String;
			}
			
			var vigStr:String;
			if(useVignette){
				//"mov ft0.xyz,ft1.xyz\n";
				vigStr = 
					"tex ft1, v1, fs2 <2d,clamp,linear>\n"+
					"mul ft0.xyz,ft0.xyz,ft1.xyz\n";
			}else{
				vigStr = new String;
			}
			
			var endStr:String = 
				"mov oc, ft0";
			
			var str:String = preUvStr + baseStr + psStr + vigStr + endStr;
			
			return str;
		}
		
		
		
	}
}