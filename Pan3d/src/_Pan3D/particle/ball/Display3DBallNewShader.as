package _Pan3D.particle.ball
{
	import _Pan3D.program.Shader3D;
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Display3DBallNewShader extends Shader3D
	{
		public static var Display3DBallNewShader:String = "Display3DBallNewShader";

		public function Display3DBallNewShader()
		{
			fragment =
				"tex ft0, v0.xy, fs1 <2d,linear,repeat>\n"+
				
				"tex ft1, v1.xy, fs0 <2d,linear>\n"+
				
				"mul ft0,ft0,ft1\n" +
				
				//				"tex ft2, v1.zw, fs0 <2d,linear>\n"+
				//				
				//				"mul ft0,ft0,ft2\n" +
				
				"mov oc ft0 ";
		}
		
		
		
		
		
		
		
		
		override public function get vertex():String{
			
			var baseStr:String = 
				"mov vt0,va0\n" + 
				
				/**当前时间***********/
				"sub vt1.x,vc12.x,va2.w\n"+//vt1.x为当前帧数(时间)
				/**控制粒子按顺序发射*******/
				"sge vt1.y,vc13.y,vt1.x\n" +
				
				"mul vt1.y,vt1.y,vc13.x\n" +
				"add vt0.y,vt0.y,vt1.y\n"+
				
				"div vt1.y,vt1.x,vc12.y\n" +
				"frc vt1.y,vt1.y\n"+
				"mul vt1.y,vc12.y,vt1.y\n" +
				
				"mul vt2.x,vt1.y,vc8.x\n" +
				"mul vt2.y,vt1.x,vc8.y\n" +
				"add vt1.x,vt2.x,vt2.y\n" +
				
				"slt vt1.z,vc12.y,vt1.x\n" +
				"mul vt1.y,vt1.z,vc13.x\n" +
				"add vt0.y,vt0.y,vt1.y\n"+
				
				
				/**比例变化部分***********/
				"sub vt2.z,vt1.x,vc11.w\n" +
				"max vt2.z,vt2.z,vc13.y\n" +
				"mul vt2.x,vt2.z,vc12.z\n" + //时间*比例变化系数
				"mul vt2.y,vt2.z,vc9.x\n" +  //时间 * 振动频率
				"sin vt2.y,vt2.y\n" +		//sin 时间
				"mul vt2.y,vt2.y,vc9.y\n" +  //加入振幅
				"add vt2.x,vt2.x,vt2.y\n" +  //所有额外的比例加成
				
				//最大最小比例约束
				"min vt2.x,vt2.x,vc15.z\n" +
				"max vt2.x,vt2.x,vc15.w\n" +
				
				"mov vt2.y,vt2.x\n" +
				"mul vt2.xy,vt2.xy,vc15.xy\n" +
				"add vt2.xy,vt2.xy,vc13.w\n" +
				
				"mul vt0.xy,vt0.xy,vt2.xy";
//			var rotationStr:String = 
//				/**基础旋转部分***********/
//				"sin vt3.x,va3.w\n" +
//				"cos vt3.y,va3.w\n" +
//				"mul vt2.x,vt3.y,vt0.y\n" + //b.y = cos_z * a.y - sin_z * a.x;
//				"mul vt2.y,vt3.x,vt0.x\n" +
//				"sub vt2.z,vt2.x,vt2.y\n" +
//				"mul vt2.x,vt3.x,vt0.y\n" + //b.x = sin_z * a.y + cos_z * a.x;
//				"mul vt2.y,vt3.y,vt0.x\n" +
//				"add vt0.x,vt2.x,vt2.y\n" +
//				"mov vt0.y,vt2.z";
				
			var rotationStr:String = 
				"mul vt2.x vt1.x,va5.y\n" + 
				"add vt2.x,vt2.x,va5.x\n" + 
				"sin vt3.x,vt2.x\n" + 
				"cos vt3.y,vt2.x\n" + 
				"mul vt2.x,vt3.y,vt0.y\n" + 
				"mul vt2.y,vt3.x,vt0.x\n" + 
				"sub vt2.z,vt2.x,vt2.y\n" + 
				"mul vt2.x,vt3.x,vt0.y\n" + 
				"mul vt2.y,vt3.y,vt0.x\n" + 
				"add vt0.x,vt2.x,vt2.y\n" + 
				"mov vt0.y,vt2.z";
				
			var basePosStr:String = 
				"mov vt6.xyz,va2.xyz";
			var posStr:String = 
				/**匀速运动部分***********/
				"mul vt2.xyz,va3.xyz,vt1.x\n" +
				"add vt6.xyz,vt6.xyz,vt2.xyz\n" +
				
				/**加速度部分***********/
				"nrm vt2.xyz,va3.xyz\n" +
				"mul vt2.xyz,vt2.xyz,vc13.z\n" + // a
				"add vt2.xyz,vt2.xyz,vc14.xyz\n" + // a + a1
				"mul vt1.y,vt1.x,vt1.x\n"+ //a * t * t
				"mul vt2.xyz,vt2.xyz,vt1.y\n" +
				"add vt6.xyz,vt6.xyz,vt2.xyz";
				
			var speedStr:String = //当前速度方向
				"nrm vt2.xyz,va3.xyz\n" +
				"mul vt2.xyz,vt2.xyz,vc13.z\n" + 
				"add vt2.xyz,vt2.xyz,vc14.xyz\n" +
				"mul vt2.xyz,vt2.xyz,vt1.x\n" +
				"mul vt2.xyz,vt2.xyz,vc14.w\n" +
				"add vt2.xyz,vt2.xyz,va3.xyz\n"+
				//"mov vt2.w,va0.w\n" +
				"m33 vt2.xyz,vt2.xyz,vc20\n" +
				"nrm vt2.xyz,vt2.xyz"
			
			var mulStr:String = 
				"m33 vt4.xyz,vt6.xyz,vc20\n" +
				"add vt4.xyz,vt4.xyz,vc24.xyz\n" +
				"sub vt4.xyz,vc11.xyz,vt4.xyz\n" + //v(视点-位置)
				"nrm vt4.xyz,vt4.xyz\n" + 
				"crs vt3.xyz,vt2.xyz,vt4.xyz\n" +
				"nrm vt3.xyz,vt3.xyz\n" + 
				"mul vt5.xyz,vt2.xyz,vt0.x\n" +
				"mul vt4.xyz,vt3.xyz,vt0.y\n" +
				"add vt0.xyz,vt5.xyz,vt4.xyz";
				
			var watchEyeStr:String = 
				/**面向视点***********/
				"m44 vt0,vt0,vc16"
			var resultPos:String = 
				"add vt0.xyz,vt0.xyz,vt6.xyz";
				
			var mvpStr:String = 
				/************************/
				"m44 vt0, vt0, vc4 \n" +
				"m44 op, vt0, vc0";
			var uvStr:String = 
				/**uv部分**********************/
				"mov vt2,va1\n" +
				"mov vt4.x,vt1.x\n"+
				"div vt1.x,vt1.x,vc10.w \n" +
				"frc vt1.y,vt1.x \n"+
				"sub vt1.x,vt1.x,vt1.y \n"+//vt1为当前动画帧数
				"div vt3.x,vt1.x,vc10.x \n"+
				"add vt2.x,vt2.x,vt3.x \n"+
				"frc vt3.y,vt3.x \n"+
				"sub vt3.x,vt3.x,vt3.y \n"+
				"div vt3.x,vt3.x,vc10.y \n"+
				"add vt2.y,vt2.y,vt3.x \n"+
				
				"mul vt3.xy,vc9.zw,vt4.x\n" +
				"add vt2.xy,vt2.xy,vt3.xy\n" +
				"mov v0, vt2";
				
			var particleColor:String = 
				"div vt1.x,vt4.x,vc12.y\n" + 
				"mov vt1.y,vc8.z\n"+
				"mov vt1.z,va1.z\n" +
				"mov vt1.w,vc8.w\n"+
				"mov v1,vt1";
			var randomColor:String = 
				"mov v2,va4"
			
			var str:String = new String;
			
			//粒子颜色渐变，随机颜色，多重粒子
			if(paramAry){
//				if(paramAry[2] == 1){
//					str = baseStr + LN + basePosStr + LN + posStr + LN + speedStr + LN + mulStr + LN + resultPos + LN + mvpStr + LN + uvStr;
//				}else{
//					str = baseStr + LN + rotationStr + LN + watchEyeStr + LN + basePosStr + LN + posStr + LN + resultPos + LN + mvpStr + LN + uvStr;
//				}
				
				if (paramAry[2] == 1){
					str = baseStr + LN + basePosStr + LN + posStr + LN + speedStr + LN + mulStr + LN + watchEyeStr + LN + resultPos + LN + mvpStr + LN + uvStr;
				}else if (paramAry[3] == 1){
					str = baseStr + LN + rotationStr + LN + watchEyeStr + LN + basePosStr + LN + posStr + LN + resultPos + LN + mvpStr + LN + uvStr;
				}else{
					str = baseStr + LN + watchEyeStr + LN + basePosStr + LN + posStr + LN + resultPos + LN + mvpStr + LN + uvStr;
				}
				
				if(paramAry[0] == 1){
					 str +=  LN + particleColor;
				}
				if(paramAry[1] == 1){
					str += LN + randomColor;
				}
			}else{
				return baseStr;
			}
			
			
			
			return str;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}