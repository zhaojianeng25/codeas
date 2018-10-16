package _Pan3D.particle.follow
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DFollowShader extends Shader3D
	{
		public static var DISPLAY3DFOLLOWSHADER:String = "Display3DFollowShader";
		// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
		public function Display3DFollowShader()
		{
			vertex = 
				//注：va2.w 为VC 的基础下标  现在设定为 8
				"mov vt0, va0 \n"+
				"mov vt3, va0 \n"+    //作为一直用的临时VT3
				"mov vt6, va0 \n"+    //作为一直用的临时VT6
				"mov vt7, va0 \n"+    //作为一直用的临时VT7
				
				"sub vt3.x, vc16.x,va3.w \n" +  //算出粒子出现之后的时间   vc16
				"div vt3.x, vt3.x,vc16.y \n" +  //时间除去生命 得到周期内
				"frc vt3.x, vt3.x \n"+         //取余是为了得到周内的时间 
				"mul vt3.x, vt3.x,vc16.y \n" +  //得到整的时间 放在 vt3.x
				
				//-----振幅-----//
				"mul vt7.w, vt3.x, vc19.z \n" +   //振幅变变化 ,从时间，得到SIN值，然后，再加上他的振幅。最小，到最大
				"sin vt7.w, vt7.w \n" +                //得到一个-1到+1的区间
				"mul vt7.w, vt7.w, vc19.w \n" +    //乘以强度 ，， 
				"mul vt7.xy, vt0.xy,vt7.w \n"+             
				"mul vt7.xy, vt7.xy,vc19.xy \n"+   //这个是约束高宽的
				"add vt0.xy, vt0.xy,vt7.xy \n"+
				
				
				//-------比例变化---// 
				"mul vt7.x, vt3.x, vc16.z \n"+    // x存放变化的大小
				"mul vt7.xyz,vt0.xyz,vt7.x \n"+   //得到变化比例的部分
				"mul vt7.xy,vt7.xy,vc19.xy \n"+
				"add vt0.xyz,vt0.xyz,vt7.xyz \n"+  //原来的加上变化的部分， 
				
				//-----作为基本的随机角度，就是启始给基一个角度--baseRandomAngle------//
				"sin vt5.x,va4.w \n"+
				"cos vt5.y,va4.w \n"+
				"mov vt5.z,vt0.x \n"+
				"mul vt7.x,vt5.y,vt5.z \n"+
				"mul vt7.y,vt5.x,vt0.y \n"+
				"sub vt0.x,vt7.x,vt7.y \n"+
				"mul vt7.x,vt5.x,vt5.z \n"+
				"mul vt7.y,vt5.y,vt0.y \n"+
				"add vt0.y,vt7.x,vt7.y \n"+
				
				//------计算离心力和离心加速度-----//
				"mov vt7 ,vc17 \n"+          //得到离心参数
				"mul vt7.w, vt7.w, vt3.x \n"+ 
				"mul vt7.xyzw,vt7.xyzw, vt3.x \n"+
				"add vt7.xyz, vt7.xyz,vt7.w \n"+
				"nrm vt6.xyz, va2.xyz \n"+
				"mul vt7.xyz, vt7.xyz, vt6.xyz \n"+
				"mov vt2.xyz, vt7.xyz \n"+
				
				
				//-------给一个方向。然后再给一个加速度addForce-----、、
				"mov vt4, vc18 \n"+  
				"mov vt7, vc18 \n"+  
				"abs vt7.xyz, vt7.xyz \n"+  //取到addForce 的绝对值
				"mul vt4.xyz, vt4.xyz,vt3.x \n"+
				"mul vt4.w, vt4.w,vt3.x \n"+     //时间平方所以就要乘与两次
				"mul vt4.w, vt4.w,vt3.x \n"+     
				"add vt4.xyz,vt4.xyz, vt4.w \n"+  
				"mul vt7.xyz,vt7.xyz,vt4.xyz \n"+
				"add vt2.xyz,vt2.xyz,vt7.xyz \n"+
				
				//----------沿着发射方向--------//
				"mul vt4.xyz, va4.xyz, vt3.x \n"   +  //发射方向*时间
				"add vt2.xyz, vt2.xyz, vt4.xyz \n"+
				"add vt2.xyz, vt2.xyz, va2.xyz \n"+       //加上基本坐标，
				"add vt2.xyz, vt2.xyz, va3.xyz \n"+       //加上根坐标
				
				//-------及数度及速度发射---//
				"nrm vt4.xyz, va4.xyz \n"+   //计算加速度
				"mul vt7.x, vt3.x,vt3.x \n"+  //算好时间
				"mul vt7.x, vt7.x,vc16.w \n"+
				"mul vt4.xyz,vt4.xyz,vt7.x \n"+
				"add vt2.xyz, vt2.xyz, vt4.xyz \n"+
				
				//------面向视点-------//
				"m44 vt0, vt0, vc20 \n" +   //这里针对面向视角， 
				//将位置移动加到顶点坐标上去， 
				"add vt0.xyz, vt0.xyz ,vt2.xyz \n"+   
				
				//-------乘以镜头和 位置矩阵------//
				"m44 vt0, vt0, vc24 \n" +
				"add vt0.xyz, vt0.xyz ,vc[va2.w].xyz \n"+ 
				"m44 vt0, vt0, vc12 \n" +
				"m44 op, vt0, vc0 \n" +
				
				"sub vt7.x, vc16.x,va3.w \n" +  //算出粒子出现之后的时间
				"mov v7, vt7 \n"+
				"mov vt3.y,vc16.y \n"+  //vt3.y粒子生命
				"mov vt3.w,va2.w \n"+  //存入VC id 
				"mov v3, vt3 \n"+      //vt3。x为时间
				
				"mul v5, va5, vc8 \n"+    //基础颜色再加上父级的颜色
				
				"mov v1, va1";
			fragment =
				
				"mov ft0, v1 \n"+
				"mov ft7, v7 \n"+
				"kil ft7.x \n"+    //小于应该开始的时间的粒子都KILL掉
				
				"mov ft3, v3 \n"+  //对时间取整
				"div ft3.x,ft3.x,fc3.w \n" +
				
				"frc ft5.x,ft3.x \n"+  //UV 分段。。4*4
				"sub ft5.x,ft3.x,ft5.x \n"+ //现在的ft4为整数
				"div ft6.x,ft5.x,fc3.x \n"+
				"add ft0.x,ft0.x,ft6.x \n"+
				"div ft6.x,ft5.x,fc3.x \n"+
				"frc ft6.w,ft6.x \n"+
				"sub ft6.y, ft6.x,ft6.w \n"+
				"div ft6.y,ft6.y,fc3.y \n"+
				"add ft0.y,ft0.y,ft6.y \n"+
				
				"tex ft0, ft0, fs1 <2d,linear,repeat>\n"+
				
				"mov ft3, v3 \n"+   //接收到时间
				"div ft3.x,ft3.x,ft3.y \n"+
				"sub ft3.y, ft3.w, fc1.x \n"+   //减去8
				"div ft3.y, ft3.y, fc1.y \n"+   //
				"add ft3.y, ft3.y, fc1.z \n"+
				"tex ft1, ft3, fs0 <2d,linear,2d>\n"+
				"mul ft0, ft0, ft1 \n"+
				
				"mul ft0, ft0, v5 \n"+
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
				"add vt4.xyz,vt4.xyz,vc[va1.w].xyz\n" +
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
				//"add vt0.xyz, vt0.xyz ,vc[va1.w].xyz\n";
			
			var mvpStr:String = 
				/************************/
				"m44 vt0, vt0, vc4 \n" +
				"add vt0.xyz, vt0.xyz,vc[va1.w].xyz\n"+
				"m44 vt0, vt0, vc24 \n" +
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