package _Pan3D.program.shaders
{
	import _Pan3D.program.Shader3D;
	
	public class MaterialShader extends Shader3D
	{
		
		public static var MODEL_SHADER:String = "ModelShader";
		public function MaterialShader()
		{
			vertex = 

				"m44 vt0, va0, vc8 \n" + 
				"m44 vt0, vt0, vc4 \n" + 
				"m44 op,  vt0, vc0 \n" + 
				"mov v2, va2 \n" + // uv
				"mov v0, va1";//lightuv
			
			fragment =
				"mov ft1, v0 \n"+
				"mov oc, fc0 "
			
		}
		
		override public function get vertex():String{
			var baseStr:String
			var usePbr:Boolean = paramAry[0];
			var useNormal:Boolean = paramAry[1];
			var hasFresnel:Boolean = paramAry[2];
			var useDynamicIBL:Boolean = paramAry[3];
			var lightProbe:Boolean = paramAry[4];
			var directLight:Boolean = paramAry[5];
			var noLight:Boolean = paramAry[6];
			var fogMode:int = paramAry[7];
			if(usePbr){
				if(useNormal){
					baseStr = 
						"m44 vt0,va0,vc8 \n" + 
						"mov v1,vt0\n" + //入射光方向 I
						
						"m44 vt3,va4,vc16\n" + 
						"m44 vt4,va5,vc16\n" +
						"m44 vt5,va3,vc16\n";
					if(hasFresnel){
						baseStr += "mov v7,vt5\n";
					}
					baseStr += 	
						"mov v4.x,vt3.x\n" +
						"mov v4.y,vt4.x\n" +
						"mov v4.z,vt5.x\n" +
						"mov v4.w,vc0.x\n" +
						
						"mov v5.x,vt3.y\n" +
						"mov v5.y,vt4.y\n" +
						"mov v5.z,vt5.y\n" +
						"mov v5.w,vc0.x\n" +
						
						"mov v6.x,vt3.z\n" +
						"mov v6.y,vt4.z\n" +
						"mov v6.z,vt5.z\n" +
						"mov v6.w,vc0.x\n" +
						
						"m44 vt0, vt0, vc4 \n" + 
						"m44 vt0, vt0, vc0 \n" + 
						"mov op, vt0 \n" +
						"mov v0, va1 \n"// uv
						//"mov v0, va1";//lightuv
				}else{
					baseStr = 
						"m44 vt0,va0,vc8 \n" + 
						"mov v7 vt0 \n" + 
						"m44 v4,va3,vc16\n" +

						"mov v1,vt0\n" +
						
						"m44 vt0, vt0, vc4 \n" + 
						"m44 vt0, vt0, vc0 \n" + 
						"mov op, vt0 \n" +
						"mov v0, va1 \n"// uv
						//"mov v0, va1";//lightuv
				}
					
			}else{
				if(hasFresnel){
					baseStr = 
						"m44 vt0, va0, vc8 \n" + 
						"mov v1,vt0\n" + //入射光方向 I
						"m44 vt0, vt0, vc4 \n" + 
						"m44 vt0, vt0, vc0 \n" + 
						"mov op, vt0 \n" +
						"m44 v4,va3,vc16\n" +
						"mov v0, va1 \n" // uv
						//"mov v0, va1";//lightuv
				}else{
					baseStr = 
						"m44 vt0, va0, vc8 \n" + 
						getFogStr(fogMode) + 
						"m44 vt0, vt0, vc4 \n" + 
						"m44 vt0, vt0, vc0 \n" + 
						"mov op, vt0 \n" +
						"mov v0, va1 \n"// uv
						//"mov v0, va1";//lightuv
				}
				
			}
			
			baseStr += getDiffuseShader(lightProbe,directLight,noLight);
			
			if(useDynamicIBL){
				var reStr:String = 
					"mov v7 vt0";
				var str:String = 
					"m44 vt0 va0,vc8\n" +
					"m44 vt0 vt0,vc12\n" +
					"m44 vt0 vt0,vc0\n" +
					"mov v3 vt0";
				baseStr += "\n" + reStr + "\n" + str;
			}
			
			trace(baseStr);
			return baseStr;
		}
		
		public function getFogStr(fogMode:int):String{
			if(fogMode == 0){
				return "";
			}else if(fogMode == 1){
				return "mov v1, vt0 \n"
			}else if(fogMode == 2){
				return "mov v1, vt0 \n"
			}
			return "";
		}
		public function getDiffuseShader(lightProbe:Boolean,directLight:Boolean,noLight:Boolean):String{
			var str:String;
			if(lightProbe){
				str =	
					"m44 vt0,va3,vc16\n" +
					//12 base 16 sh
					"mov vt2, va1 \n" +
					//0
					"mov vt1.x,vc12.x\n" +
					"mul vt1.xyz,vt1.x,vc20.xyz \n" +
					"mov vt2.xyz,vt1.xyz \n" +
					//1
					"mul vt1.x,vc12.y,vt0.y \n" +
					"mul vt1.xyz,vt1.x,vc21.xyz \n" +
					"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
					//2
					"mul vt1.x,vc12.z,vt0.z \n" +
					"mul vt1.xyz,vt1.x,vc22.xyz \n" +
					"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
					//3
					"mul vt1.x,vc12.w,vt0.x \n" +
					"mul vt1.xyz,vt1.x,vc23.xyz \n" +
					"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
					
					//4
					"mul vt1.x,vc13.x,vt0.x \n" +
					"mul vt1.x,vt1.x,vt0.y \n" +
					"mul vt1.xyz,vt1.x,vc24.xyz \n" +
					"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
					
					//5
					"mul vt1.x,vc13.y,vt0.z \n" +
					"mul vt1.x,vt1.x,vt0.y \n" +
					"mul vt1.xyz,vt1.x,vc25.xyz \n" +
					"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
					
					//6
					"mul vt1.x,vt0.z,vt0.z\n" +
					"mul vt1.x,vt1.x,vc14.y\n" +
					"sub vt1.x,vt1.x,vc14.z\n" +
					"mul vt1.x,vc13.z,vt1.x \n" +
					"mul vt1.xyz,vt1.x,vc26.xyz \n" +
					"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
					//7
					"mul vt1.x,vc13.w,vt0.z \n" +
					"mul vt1.x,vt1.x,vt0.x \n" +
					"mul vt1.xyz,vt1.x,vc27.xyz \n" +
					"add vt2.xyz,vt2.xyz,vt1.xyz \n" +
					//8
					"add vt1.x,vt0.x,vt0.y \n" +
					"sub vt1.y,vt0.x,vt0.y \n" +
					"mul vt1.x,vt1.x,vt1.y \n" +
					"mul vt1.x,vc14.x,vt1.x \n" +
					"mul vt1.xyz,vt1.x,vc28.xyz \n" +
					"add vt2.xyz,vt2.xyz,vt1.xyz \n"+
					//"mul vt2.xyz,vt2.xyz,vc14.z\n" +
					"mov v2, vt2";
			}else if(directLight){
				str =
					"m44 vt0,va3,vc16\n" +
					"dp3 vt1.x,vt0.xyz,vc12.xyz\n" +
					"mov vt0.xyz,vc13.xyz\n" +
					"mul vt0.xyz,vt0.xyz,vt1.x\n" +
					"add vt0.xyz,vt0.xyz,vc14.xyz\n" +
					"mov v2, vt0";
				
			}else if(noLight){
				str = "";
			}else{
				str = "mov v2, va2";
			}
			return str;
			
		}
		
	}
}