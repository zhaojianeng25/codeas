package _Pan3D.role
{
	import _Pan3D.base.ObjectBone;
	import _Pan3D.core.Quaternion;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * 骨骼工具类
	 * 1. 骨骼插值
	 * 2. ……
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class BoneUtils
	{
		public function BoneUtils()
		{
		}
		/**
		 * 两帧之间的插值
		 * @param ary1 第一帧的骨骼
		 * @param ary2 第二帧的骨骼
		 * @param proportion 插值比例
		 * @return 插值帧
		 * */
		public static function interpolaFrame(ary1:Array,ary2:Array,proportion:Number):Array{
			var ary:Array = new Array;
			for(var i:int;i<ary1.length;i++){
				ary.push(interpolaBone(ary1[i],ary2[i],proportion));
			}
			return ary;
		}
		/**
		 * 骨骼之间的插值
		 * @param one 第一个骨骼
		 * @param two 第二个骨骼
		 * @param proportion 插值比例
		 * @return 插值后的骨骼
		 * */
		private static function interpolaBone(one:ObjectBone,two:ObjectBone,proportion:Number):ObjectBone{
			var q1:Quaternion = new Quaternion(one.qx,one.qy,one.qz);
			q1.w= getW(q1.x,q1.y,q1.z);
			var q2:Quaternion = new Quaternion(two.qx,two.qy,two.qz);
			q2.w= getW(q2.x,q2.y,q2.z);
			
			var resultQ:Quaternion = new Quaternion;
			resultQ.slerp(q1,q2,proportion);
			
			var newBone:ObjectBone = new ObjectBone();
			newBone.father = one.father;
			newBone.name = one.name;
			newBone.qx = resultQ.x;
			newBone.qy = resultQ.y;
			newBone.qz = resultQ.z;
			
			newBone.tx = one.tx * proportion + two.tx * (1-proportion);
			newBone.ty = one.ty * proportion + two.ty * (1-proportion);
			newBone.tz = one.tz * proportion + two.tz * (1-proportion);
			
			return newBone;
		}
		/**
		 * 骨骼对象转矩阵
		 * @param frameAry 骨骼序列
		 * */
		public static function setFrameToMatrix(frameAry:Array):void{
			AnimDataManager.getInstance().setFrameToMatrix(frameAry);
			return 
			for(var j:int=0;j<frameAry.length;j++){
				var boneAry:Array = frameAry[j];
				
				var Q0:Quaternion=new Quaternion();
				var Q1:Quaternion=new Quaternion();
				var OldQ:Quaternion=new Quaternion();
				var OldM:Matrix3D=new Matrix3D();
				var newM:Matrix3D=new Matrix3D();
				var tempM:Matrix3D=new Matrix3D;
				var tempObj:ObjectBone=new ObjectBone;
				
				for(var i:int=0;i<boneAry.length;i++){
					
					var _M1:Matrix3D=new Matrix3D;
					
					var xyzfarme0:ObjectBone= boneAry[i];
					Q0=new Quaternion(xyzfarme0.qx,xyzfarme0.qy,xyzfarme0.qz);
					Q0.w= getW(Q0.x,Q0.y,Q0.z);
					var sonBone:ObjectBone=xyzfarme0;
					
					if(xyzfarme0.father==-1){
						OldQ=new Quaternion(xyzfarme0.qx,xyzfarme0.qy,xyzfarme0.qz);
						OldQ.w= getW(OldQ.x,OldQ.y,OldQ.z);
						newM=OldQ.toMatrix3D();
						newM.appendTranslation(xyzfarme0.tx,xyzfarme0.ty,xyzfarme0.tz);
						newM.appendRotation(-90,Vector3D.X_AXIS);
						var fatherQ:Quaternion = new Quaternion();
						fatherQ.fromMatrix(newM);
						
						xyzfarme0.tx=newM.position.x;
						xyzfarme0.ty=newM.position.y;
						xyzfarme0.tz=newM.position.z;
						xyzfarme0.tw=newM.position.w;
						
						xyzfarme0.qx=fatherQ.x;
						xyzfarme0.qy=fatherQ.y;
						xyzfarme0.qz=fatherQ.z;
						xyzfarme0.qw=fatherQ.w;
						//newM.appendScale(-1,1,1);
						xyzfarme0.matrix = newM;
						
					}else {
						var fatherBone:ObjectBone=boneAry[xyzfarme0.father];
						OldQ=new Quaternion(fatherBone.qx,fatherBone.qy,fatherBone.qz,fatherBone.qw);
						OldM=OldQ.toMatrix3D();
						OldM.appendTranslation(fatherBone.tx,fatherBone.ty,fatherBone.tz);
						var  tempV:Vector3D=OldM.transformVector(new Vector3D(sonBone.tx,sonBone.ty,sonBone.tz));
						_M1.appendTranslation(tempV.x,tempV.y,tempV.z);
						
						Q1.multiply(OldQ,Q0);
						newM=Q1.toMatrix3D();
						newM.append(_M1);
						tempM=newM;
						
						xyzfarme0.qx=Q1.x;
						xyzfarme0.qy=Q1.y;
						xyzfarme0.qz=Q1.z;
						xyzfarme0.qw=Q1.w;
						
						xyzfarme0.tx=tempV.x;
						xyzfarme0.ty=tempV.y;
						xyzfarme0.tz=tempV.z;
						xyzfarme0.tw=tempV.w;
						
						//tempM.appendScale(-1,1,1);
						xyzfarme0.matrix = tempM;
						
					}
					//context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12+i*4,  tempM, true);
				}
			}
		}
		/**
		 * 四元数已知xyz 求w 
		 * @param x
		 * @param y
		 * @param z
		 * @return w
		 * 
		 */		
		private static function getW(x:Number,y:Number,z:Number):Number{
			var t:Number = 1-(x*x + y*y + z*z);
			if(t<0){
				t=0
			}else{
				t = -Math.sqrt(t);
			}
			return t;
		}
		/**
		 * 动作克隆
		 * */
		public static function cloneAction(sourceAry:Array):Array{
			var resultAry:Array = new Array;
			for(var i:int;i<sourceAry.length;i++){
				var sourceTwo:Array = sourceAry[i];
				resultAry.push(new Array);
				for(var j:int=0;j<sourceTwo.length;j++){
					resultAry[i].push(sourceTwo[j].clone());
				}
			}
			return resultAry;
		}
	}
}