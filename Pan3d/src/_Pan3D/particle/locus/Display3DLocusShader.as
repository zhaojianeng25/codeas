package _Pan3D.particle.locus
{
	import _Pan3D.program.Shader3D;
	
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Display3DLocusShader extends Shader3D
	{
		public static var DISPLAY3DLOCUSSHADER:String = "display3DLocusShader";
		public function Display3DLocusShader()
		{
			vertex = 

				"m44 vt0, va0, vc4 \n" +     //这为vc24  对应该的矩阵
				"m44 op, vt0, vc0 \n" +
				
				"mov vt1, va1 \n"+
				"sub vt1.x,vt1.x,vc15.x \n"+ // -0.5 0.5
		        "mov v1, va1 \n"+ //颜色v
				
				"mov vt5, va1 \n"+ 
				"div vt5.w, vt1.x, vc15.z \n"+   //计算拖尾的渐变色 -0.5 0.5 
				"abs vt5.w, vt5.w \n"+ //0.5 0 0.5
				"sat vt5.w, vt5.w \n"+ //0.5 0 0.5
				"sub vt5.w, vc15.y, vt5.w \n"+ //0.5 1 0.5
				
				"neg vt5.x,vt1.x \n"+  //大于0的部份不显示
				"sub vt5.y,vt1.x,vc15.w \n"+  //小于最后周期
				
				"mul vt5.x, vt5.x,vt5.y \n"+
				"mov v2, vt5 \n"+
				
				"mov v0, vt1 ";
			
			fragment =
				
				"kil v2.x \n"+

				"tex ft0, v0, fs1 <2d,clamp,repeat>\n"+
				"mul ft0, ft0, v2.w \n"+
				
				"tex ft1, v1, fs0 <2d,clamp,repeat>\n"+    //得到渐变颜色
				"mul ft0, ft0, ft1 \n"+
				"mul ft0, ft0, fc6 \n"+     //外部颜色
				"mov oc, ft0";
		}
		
		override public function get vertex():String{
			var posStr:String  = 
				"m44 vt0, va0, vc4 \n" +  
				"m44 vt0, vt0, vc8 \n" +  
				"m44 op, vt0, vc0";
			var watchPosStr:String = 
				"m44 vt0, va0, vc4 \n" +  
				"sub vt1.xyz,vc12.xyz,vt0.xyz\n" +
				"nrm vt1.xyz,vt1.xyz\n" +
				"crs vt2.xyz,vt1.xyz,va2.xyz\n" +
				"nrm vt2.xyz,vt2.xyz\n" + 
				"mul vt2.xyz,vt2.xyz,va2.w \n" +
				"add vt0.xyz,vt2.xyz,va0.xyz \n" +
				"m44 vt0, vt0, vc4 \n" +  
				"m44 vt0, vt0, vc8 \n" + 
				"m44 op, vt0, vc0";
			
			var killStr:String = 
				
				"mov vt1, va1 \n"+
				"sub vt1.x,vt1.x,vc15.x \n"+ // -0.5 0.5
				"mov v1, va1 \n"+ //颜色v
				
				"mov vt5, va1 \n"+ 
				"div vt5.w, vt1.x, vc15.z \n"+   //计算拖尾的渐变色 -0.5 0.5 
				"abs vt5.w, vt5.w \n"+ //0.5 0 0.5
				"sat vt5.w, vt5.w \n"+ //0.5 0 0.5
				"sub vt5.w, vc15.y, vt5.w \n"+ //0.5 1 0.5
				
				"neg vt5.x,vt1.x \n"+  //大于0的部份不显示
				"sub vt5.y,vt1.x,vc15.w \n"+  //小于最后周期
				"mul vt5.x, vt5.x,vt5.y \n"+
				
				
				"mov v2, vt5";
				
           var uvStr:String=
				"mul vt1.xy, vt1.xy, vc16.xy \n"+//换一下UV,
				"mul vt4.xy, vt1.xy, vc16.z \n"+  //互换UV
				"mul vt5.xy, vt1.xy, vc16.w \n"+
				"add vt1.x, vt4.x,vt5.y \n"+
				"add vt1.y, vt4.y,vt5.x";
		   var outUv:String=
				"mov v0, vt1 ";
			
			var str:String;
			if(paramAry){
				if(paramAry[0]){
					str = watchPosStr + LN;
				}else{
					str = posStr + LN;
				}
				str += killStr+ LN;
				if(paramAry[1]){
					str +=uvStr+LN
				}
				str +=outUv
				

			}else{
				str = posStr + LN + killStr+ LN+outUv;
			}
			
			return str;
		}
		
	}
}