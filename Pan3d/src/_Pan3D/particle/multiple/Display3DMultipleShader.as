package _Pan3D.particle.multiple
{
	import _Pan3D.program.Shader3D;
	
	public class Display3DMultipleShader extends Shader3D
	{
		public static var DISPLAY3DMULTIPLESHADER:String = "display3DMultipleShader";
		public function Display3DMultipleShader()
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
				
				//多重粒子独立有的算法   
				"mov vt4.xyz,vt2.xyz \n"+
				"mov vt4.w, vt0.w \n"+
				"m44 vt6, vt4, vc24 \n" +
				"mov vt5.x, vc24.w \n"+    //得到矩阵的x,
				"mov vt5.y, vc25.w \n"+    //得到矩阵的y
				"sub vt6.xy, vt6.xy,vt5.xy \n"+   //加上中心所在的位置为了是得到偏移 
				"mul vt7.x, vt6.x,vt6.x \n"+
				"mul vt7.y, vt6.y,vt6.y \n"+
				"add vt7.w, vt7.x,vt7.y \n"+
				"sqt vt7.w, vt7.w \n"+
				"div vt5.x,vt6.y,vt7.w \n"+
				"div vt5.y,vt6.x,vt7.w \n"+
				
				"mov vt5.z,vt0.x \n"+
				"mul vt7.x,vt5.y,vt5.z \n"+
				"mul vt7.y,vt5.x,vt0.y \n"+
				"sub vt0.x,vt7.x,vt7.y \n"+
				
				"mul vt7.x,vt5.x,vt5.z \n"+
				"mul vt7.y,vt5.y,vt0.y \n"+
				"add vt0.y,vt7.x,vt7.y \n"+
				
				
				//------面向视点-------//
				"m44 vt0, vt0, vc20 \n" +   //这里针对面向视角， 
				//将位置移动加到顶点坐标上去， 
				
				

				"add vt0.xyz, vt0.xyz ,vt2.xyz \n"+   
				
				//-------乘以镜头和 位置矩阵------//
				
				"m44 vt0, vt0, vc24 \n" +
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
	}
}