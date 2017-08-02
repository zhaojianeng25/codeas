package _Pan3D.scene.postprocess
{
	import _Pan3D.program.Shader3D;
	
	public class BloomYFilterShader extends Shader3D
	{
		public static var Bloom_Y_FilterShader:String = "BloomYFilterShader";
		public function BloomYFilterShader()
		{
			vertex = 
				"mov op, va0 \n"+
				"mov v1, va1";
			fragment =
				"mov ft0,v1\n" +
				
				"tex ft1, ft0, fs0 <2d,clamp,linear>\n"+
				"mul ft1,ft1,fc0.x\n" +
				
				getAllStr() +
				
				
				
				"mov oc, ft1";
		}
		
		private function getAllStr():String{
			var str:String = new String;
			for(var i:int = -7;i <= 7; i++){
				if(i == 0){
					continue;
				}
				str += getKey(i);
			}
		
			return str;
		}
		
		private function getKey(offset:int):String{
			var str:String =
				"mov ft2.xy,ft0.xy\n" + 
				getUv(offset) +
				"tex ft2, ft2.xy, fs0 <2d,clamp,linear>\n"+
				"mul ft2,ft2," + getStep(Math.abs(offset)) + "\n" +
				"add ft1.xyz,ft1.xyz,ft2.xyz\n"
			return str;
		}
		
		private function getUv(key:int):String{
			
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,2,Vector.<Number>([1/(_bloomWidth),2/(_bloomWidth),3/(_bloomWidth),4/(_bloomWidth)]));
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,3,Vector.<Number>([5/(_bloomWidth),6/(_bloomWidth),7/(_bloomWidth),8/(_bloomWidth)]));
			
			var perStr:String;
			if(key > 0){
				perStr = "add ";
			}else{
				perStr = "sub ";
			}
			key = Math.abs(key);
			var nextStr:String; 
			if(key == 1){
				nextStr = "fc2.x";
			}else if(key == 2){
				nextStr = "fc2.y";
			}else if(key == 3){
				nextStr = "fc2.z";
			}else if(key == 4){
				nextStr = "fc2.w";
			}else if(key == 5){
				nextStr = "fc3.x";
			}else if(key == 6){
				nextStr = "fc3.y";
			}else if(key == 7){
				nextStr = "fc3.z";
			}else if(key == 8){
				nextStr = "fc3.w";
			}
			return perStr + "ft2.y,ft2.y," + nextStr + "\n";
		}
		
		private function getStep(key:int):String{
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([0.14775640014867877,0.13796194236277726,0.11230479402381788,0.07970091148260411]));
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,Vector.<Number>([0.04931218855185363,0.026599364703187196,0.012508759642692832,0.005128415782612627]));
			if(key == 1){
				return "fc0.y";
			}else if(key == 2){
				return "fc0.z";
			}else if(key == 3){
				return "fc0.w";
			}else if(key == 4){
				return "fc1.x";
			}else if(key == 5){
				return "fc1.y";
			}else if(key == 6){
				return "fc1.z";
			}else if(key == 7){
				return "fc1.w";
			}
			return "";
		}
	}
}