package _Pan3D.program.shaders
{
	public class Md5MatrialShader extends MaterialShader
	{
		public static var MD5_MATRIAL_SHADER:String = "Md5MatrialShader";
		public function Md5MatrialShader()
		{
			vertex = 
				
				"m44 vt0, va0,vc[va3.x]\n"+
				"m44 vt1, va0,vc[va3.y]\n"+
				"m44 vt2, va0,vc[va3.z]\n"+
				"m44 vt3, va0,vc[va3.w]\n"+
				
				"mul vt0,vt0,va2.x\n"+
				"mul vt1,vt1,va2.y\n"+
				"mul vt2,vt2,va2.z\n"+
				"mul vt3,vt3,va2.w\n"+
				
				"add vt0,vt0,vt1\n"+
				"add vt0,vt0,vt2\n"+
				"add vt0,vt0,vt3\n"+
				
				"m44 vt0, vt0, vc4 \n" +
				"m44 op, vt0, vc0 \n" +
				
				"m44 vt0, va4,vc[va3.x]\n"+
				"m44 vt1, va4,vc[va3.y]\n"+
				"m44 vt2, va4,vc[va3.z]\n"+
				"m44 vt3, va4,vc[va3.w]\n"+
				
				"mul vt0,vt0,va2.x\n"+
				"mul vt1,vt1,va2.y\n"+
				"mul vt2,vt2,va2.z\n"+
				"mul vt3,vt3,va2.w\n"+
				
				"add vt0,vt0,vt1\n"+
				"add vt0,vt0,vt2\n"+
				"add vt0,vt0,vt3\n"+
				
				"m44 vt0, vt0, vc4 \n" +
				
				"nrm vt0.xyz,vt0.xyz \n" +
				
				//"m44 vt1, vc8, vc4 \n" +
				
				"dp3 vt0.x,vt0.xyz,vc8.xyz\n"+
				
				"sub vt0.x,vt0.x,vc9.y\n" +
				"mul vt0.x,vt0.x,vc9.x\n"+
				"max vt0.x,vt0.x,vc9.w\n" +
				"add vt0.x,vt0.x,vc9.z\n" +
				
				"mov v2,vt0\n"+
				
				
				"mov v1, va1";
			fragment =
				"tex ft1, v1, fs1 <2d,linear,repeat>\n"+
				
				"tex ft2, v1, fs2 <2d,linear,repeat>\n"+
				
				"mul ft2.xyz,ft2.xyz,v2.x \n" +
				
				"add ft1.xyz,ft1,xyz,ft2.xyz\n" +
				
				"mov oc, ft1";
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
			if(usePbr){
				if(useNormal){
					baseStr = 
						getMd5Vertex() +
						"m44 vt0,vt0,vc8 \n" + 
						//						"mov v7 vt0 \n" + 
						"mov v1,vt0\n" +
						"m44 vt0, vt0, vc4 \n" + 
						"m44 vt0, vt0, vc0 \n" + 
						"mov op, vt0 \n" +
						
						getMd5NormalMap();
					if(hasFresnel){
						baseStr += "mov v7,vt4\n";
					}
					baseStr += 	
						"mov v4.x,vt4.x\n" +
						"mov v4.y,vt5.x\n" +
						"mov v4.z,vt6.x\n" +
						"mov v4.w,vc0.x\n" +
						
						"mov v5.x,vt4.y\n" +
						"mov v5.y,vt5.y\n" +
						"mov v5.z,vt6.y\n" +
						"mov v5.w,vc0.x\n" +
						
						"mov v6.x,vt4.z\n" +
						"mov v6.y,vt5.z\n" +
						"mov v6.z,vt6.z\n" +
						"mov v6.w,vc0.x\n" +
						
						"mov v0, va1 \n"// uv
				}else{
					baseStr = 
						getMd5Vertex() +
						"m44 vt0,vt0,vc8 \n" + 
		
						"mov v1,vt0\n" +
						"m44 vt0, vt0, vc4 \n" + 
						"m44 vt0, vt0, vc0 \n" + 
						"mov op, vt0 \n" +
						getMd5Normal() +
						"m44 v4,vt0,vc16\n" +
						
						"mov v0, va1 \n"// uv
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
				}else{
					
					baseStr = 
						getMd5Vertex() +
						"m44 vt0, vt0, vc8 \n" + 
						"m44 vt0, vt0, vc4 \n" + 
						"m44 vt0, vt0, vc0 \n" + 
						"mov op, vt0 \n" +
						"mov v0, va1 \n";
					if(!noLight){
						baseStr +=
							getMd5Normal() +
							"mov v4, vt0\n" // uv
					}
					
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
		
		private function getMd5Vertex():String{
		
		
			return getMatrixOrQuat("vt0","va0")
			
		}

		private function getMatrixStr($vt0:String,$va0:String):String
		{
			var str:String = 
				"m44 vt0, "+$va0+",vc[va3.x]\n"+
				"m44 vt1, "+$va0+",vc[va3.y]\n"+
				"m44 vt2, "+$va0+",vc[va3.z]\n"+
				"m44 vt3, "+$va0+",vc[va3.w]\n"+
				
				"mul vt0,vt0,va2.x\n"+
				"mul vt1,vt1,va2.y\n"+
				"mul vt2,vt2,va2.z\n"+
				"mul vt3,vt3,va2.w\n"+
				
				"add vt0,vt0,vt1\n"+
				"add vt0,vt0,vt2\n"+
				"add vt0,vt0,vt3\n"+
				"mov "+$vt0+",vt0 \n"
			
			return str;
		}
		private function getMatrixOrQuat($vt6:String,$va0:String,$isNrm:Boolean=false):String
		{
			
			var str:String = 
				
				getQtStr("vt0","x",$va0,$isNrm)+
				getQtStr("vt1","y",$va0,$isNrm)+
				getQtStr("vt2","z",$va0,$isNrm)+
				getQtStr("vt3","w",$va0,$isNrm)+
				
				
				"mul vt0,vt0,va2.x\n"+
				"mul vt1,vt1,va2.y\n"+
				"mul vt2,vt2,va2.z\n"+
				"mul vt3,vt3,va2.w\n"+
				
				"add vt0,vt0,vt1\n"+
				"add vt0,vt0,vt2\n"+
				"add vt0,vt0,vt3\n"+
				
				"neg vt0.x,vt0.x \n"+

				"mov "+$vt6+",vt0 \n"
			
			
			return str;
		}
		private function getQtStr(vt3:String,xyzw:String,va:String,$isNrm:Boolean):String
		{
			var str:String = 
				"mov "+vt3+".xyz,"+va+".xyz \n"+
				"mov "+vt3+".w,vc15.w \n"+
			//	"mov vt7,vc15  \n"+  //先得到  -》1,1,1,1]
			//	"mov vt5,vc15  \n"+  //先得到  -》1,1,1,1]
			//	"mov vt4,vc15  \n"+  //先得到  -》1,1,1,1]
				"add vt7,va3,vc15  \n"+  //gpos 的位置
				"mov vt6,vc[va3."+xyzw+"]  \n"+  //quat
				"mov vt7,vc[vt7."+xyzw+"]  \n"+  //gpos
				
				"crs vt5.xyz,vt6.xyz,"+va+".xyz \n"+ //cross(m[0].xyz, v)
				"add vt5.xyz,vt5.xyz,vt5.xyz \n"+   //*2 ==t
				"mul vt4.xyz,vt5.xyz,vt6.w \n"+   //m[0].w * t
				"crs vt5.xyz,vt6.xyz,vt5.xyz \n"+ //cross(m[0].xyz, t)
				"add "+vt3+".xyz,"+vt3+".xyz,vt4.xyz \n"+  //v + m[0].w * t
				"add "+vt3+".xyz,"+vt3+".xyz,vt5.xyz \n";  //f
			
			if($isNrm){
				str+="nrm "+vt3+".xyz,"+vt3+".xyz \n";   //法线nrm  不需要加位移
			}else{
				str+="add "+vt3+".xyz,"+vt3+".xyz,vt7.xyz \n";   //正常需要加上移移
			
			}
			return str
			
		}

		private function getMd5Normal():String{
			return getMatrixOrQuat("vt0","va4",true)
		}

		
		private function getMd5NormalMap():String{
			var str:String =
				/*
				"m44 vt0, va5,vc[va3.x]\n"+
				"m44 vt1, va5,vc[va3.y]\n"+
				"m44 vt2, va5,vc[va3.z]\n"+
				"m44 vt3, va5,vc[va3.w]\n"+
				
				"mul vt0,vt0,va2.x\n"+
				"mul vt1,vt1,va2.y\n"+
				"mul vt2,vt2,va2.z\n"+
				"mul vt3,vt3,va2.w\n"+
				
				"add vt4,vt0,vt1\n"+
				"add vt4,vt4,vt2\n"+
				"add vt4,vt4,vt3\n"+
				"nrm vt4.xyz,vt4.xyz\n" +
				 */
	
				getMatrixOrQuat("vt4","va5",true)+
				
				/*
				"m44 vt0, va6,vc[va3.x]\n"+
				"m44 vt1, va6,vc[va3.y]\n"+
				"m44 vt2, va6,vc[va3.z]\n"+
				"m44 vt3, va6,vc[va3.w]\n"+
				
				"mul vt0,vt0,va2.x\n"+
				"mul vt1,vt1,va2.y\n"+
				"mul vt2,vt2,va2.z\n"+
				"mul vt3,vt3,va2.w\n"+
				
				"add vt5,vt0,vt1\n"+
				"add vt5,vt5,vt2\n"+
				"add vt5,vt5,vt3\n"+
				"nrm vt5.xyz,vt5.xyz\n" +
				*/
				getMatrixOrQuat("vt5","va6",true)+
				/*
				"m44 vt0, va4,vc[va3.x]\n"+
				"m44 vt1, va4,vc[va3.y]\n"+
				"m44 vt2, va4,vc[va3.z]\n"+
				"m44 vt3, va4,vc[va3.w]\n"+
				
				"mul vt0,vt0,va2.x\n"+
				"mul vt1,vt1,va2.y\n"+
				"mul vt2,vt2,va2.z\n"+
				"mul vt3,vt3,va2.w\n"+
				
				"add vt6,vt0,vt1\n"+
				"add vt6,vt6,vt2\n"+
				"add vt6,vt6,vt3\n"+
				"nrm vt6.xyz,vt6.xyz\n"
				*/
				getMatrixOrQuat("vt6","va4",true);
			
			
			return str;
		}
		
		override public function getDiffuseShader(lightProbe:Boolean,directLight:Boolean,noLight:Boolean):String{
			var str:String;
			if(lightProbe){
				str =	
					//"m44 vt0,vt0,vc16\n" +
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
					"m44 vt1,vt0,vc16\n" +
					"dp3 vt1.x,vt1.xyz,vc12.xyz\n" +
					"sat vt1.x,vt1.x\n" +
					"mov vt2.xyz,vc13.xyz\n" +
					"mul vt2.xyz,vt2.xyz,vt1.x\n" +
					"add vt2.xyz,vt2.xyz,vc14.xyz\n" +
					"mov v2, vt2";
			}else if(noLight){
				str = "";
			}else{
				str = "mov v2, va2";
			}
			return str;
			
		}
		
		
	}
}