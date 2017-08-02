package _Pan3D.core {
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

	
// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //

	public class MathClass {
		
		
		/**
		 *通过矩阵反算三个角度 
		 * @param matrix
		 * 
		 */
		public static function getRollFromMatrix(matrix:Matrix3D):Vector3D
		{
			var vv:Vector.<Vector3D>=matrix.decompose();
			var q:Vector3D=vv[0];//  平移
			var w:Vector3D=vv[1];//  旋转
			var e:Vector3D=vv[2];//  缩放
			w.scaleBy(180/Math.PI);
			var p:Vector3D=new Vector3D
			p.setTo(w.x,w.y,w.z);
			return p;
		}
		
		
		public static function math_angle(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var d_x:Number = x1-x2;
			var d_y:Number = y1-y2;
			var z:Number = Math.atan(d_y/d_x)*180/3.1415926;
			if (d_x>=0 && d_y>=0) {
				z = z;
			}
			if (d_x<0 && d_y>0) {
				z = z+180;
			}
			if (d_x<0 && d_y<0) {
				z = z+180;
			}
			if (d_x>0 && d_y<0) {
				z = 360+z;
			}
			return z;
		}
		public static function math_in_box(a:Point,s:Point,e:Point):Boolean
		{
			if(a.x>s.x&&a.x<e.x&&a.y>s.y&&a.y<e.y){
				return true
			}
			return false;
		}
		public static function math_distance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var z :Number= Math.sqrt((y2-y1)*(y2-y1)+(x2-x1)*(x2-x1));
			return z;
		}
		public static function math_distance3D(x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number):Number {
			var z :Number= Math.sqrt((y2-y1)*(y2-y1)+(x2-x1)*(x2-x1) + (z2-z1)*(z2-z1));
			return z;
		}
		public static function getSourcePro(vSourceXml:XML):Array{
			var tempArray:Array=new Array;
			for (var i:int=0; i < vSourceXml.children().length(); i++) {
				var z:Object=new Object;
				for (var j:int=0; j < vSourceXml.child(i).children().length(); j++) {
					var vT:String=String(vSourceXml.child(i).child(j).name());
					z[vT]=vSourceXml.child(i).child(j);
				}
				tempArray[i]=z;
			}
			return tempArray;
		}
		/**
		 * 三点一面 求法线
		 * @param p1 第一点
		 * @param p2 第二点
		 * @param p3 第三点
		 * @param norm 返回的法线
		 */		
		public static function normal(p1:Vector3D,p2:Vector3D,p3:Vector3D,norm:Vector3D):void
		{
			var d1:Vector3D=subVector3D(p1,p2)
			var d2:Vector3D=subVector3D(p2,p3)
			normcrossprod(d1,d2,norm);
			
		}
		/**
		 *两线一面 求法线 
		 * @param v1 第一条线
		 * @param v2 第二条线
		 * @param out 返回的法线
		 * 
		 */		
		private static function normcrossprod(v1:Vector3D, v2:Vector3D, out:Vector3D):void
		{
			// TODO Auto Generated method stub
			out.x=v1.y*v2.z-v1.z*v2.y;
			out.y=v1.z*v2.x-v1.x*v2.z;
			out.z=v1.x*v2.y-v1.y*v2.x;
			normalize(out);
		}
		
		private static function normalize(v:Vector3D):void
		{
			var d:Number = Math.sqrt(v.x*v.x+v.y*v.y+v.z*v.z);
			if(d==0.0)return;
			v.x/=d;
			v.y/=d;
			v.z/=d;
		}
		public static function toNextAngly(a:Number,b:Number):Number{
			var c:Number=b-a;
			c=c%360
			if(c>180){
				c=c-360
			}else{
				c=c;
			}
			return c+a
		}
		public static function subVector3D(a:Vector3D,b:Vector3D):Vector3D
		{
			var baceVector3D:Vector3D=new Vector3D;
			baceVector3D.x=a.x-b.x
			baceVector3D.y=a.y-b.y
			baceVector3D.z=a.z-b.z
			baceVector3D.w=a.w-b.w
			return baceVector3D;
		}
		public static function math_change_point_Pi(_3dpoint:Vector3D, Pivector3D:Vector3D):Vector3D
		{
			/*
			var sin_x:Number = Math.sin(Pivector3D.x);
			var cos_x:Number = Math.cos(Pivector3D.x);
			var sin_y:Number = Math.sin(Pivector3D.y);
			var cos_y:Number = Math.cos(Pivector3D.y);
			var sin_z:Number = Math.sin(Pivector3D.z);
			var cos_z:Number = Math.cos(Pivector3D.z);
			
			var tmp_xyz : Number;
			
			tmp_xyz  = _3dpoint.y;
			_3dpoint.y = cos_z * tmp_xyz - sin_z * _3dpoint.x;
			_3dpoint.x = sin_z * tmp_xyz + cos_z * _3dpoint.x;
			
			tmp_xyz  = _3dpoint.x;
			_3dpoint.x = cos_y * tmp_xyz - sin_y * _3dpoint.z;
			_3dpoint.z = sin_y * tmp_xyz + cos_y * _3dpoint.z;

			 tmp_xyz  = _3dpoint.z;
			 _3dpoint.z = cos_x * tmp_xyz - sin_x * _3dpoint.y;
			 _3dpoint.y = sin_x * tmp_xyz + cos_x * _3dpoint.y;

			return _3dpoint
			
			*/
		
			var $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-Pivector3D.x*180/Math.PI,Vector3D.X_AXIS);
			$m.appendRotation(-Pivector3D.y*180/Math.PI,Vector3D.Y_AXIS);
			$m.appendRotation(-Pivector3D.z*180/Math.PI,Vector3D.Z_AXIS);
		    return $m.transformVector(_3dpoint)
			
			
		}
		public static function math_change_point(_3dpoint:Vector3D, angleX:Number=0,angleY:Number=0,angleZ:Number=0):Vector3D
		{
			var $m:Matrix3D=new Matrix3D;
			$m.appendRotation(angleX,Vector3D.X_AXIS);
			$m.appendRotation(angleY,Vector3D.Y_AXIS);
			$m.appendRotation(angleZ,Vector3D.Z_AXIS);
			return $m.transformVector(_3dpoint)
			

		
			var sin_x:Number = Math.sin(angleX * Math.PI / 180);
			var cos_x:Number = Math.cos(angleX * Math.PI / 180);
			var sin_y:Number = Math.sin(angleY * Math.PI / 180);
			var cos_y:Number = Math.cos(angleY * Math.PI / 180);
			var sin_z:Number = Math.sin(angleZ * Math.PI / 180);
			var cos_z:Number = Math.cos(angleZ * Math.PI / 180);
			
			var rx:Number=_3dpoint.x;
			var ry:Number=_3dpoint.y;
			var rz:Number=_3dpoint.z;
			
			
			var tmp_ry : Number = ry;
			ry = cos_z * tmp_ry - sin_z * rx;
			rx = sin_z * tmp_ry + cos_z * rx;
			
			var tmp_rx : Number = rx;
			rx = cos_y * tmp_rx - sin_y * rz;
			rz = sin_y * tmp_rx + cos_y * rz;
			
			var tmp_rz : Number = rz;
			rz = cos_x * tmp_rz - sin_x * ry;
			ry = sin_x * tmp_rz + cos_x * ry;

			return new Vector3D(rx,ry,rz);
			
//			var $m:Matrix3D=new Matrix3D;
//			$m.appendRotation(-angleX,Vector3D.X_AXIS);
//			$m.appendRotation(-angleY,Vector3D.Y_AXIS);
//			$m.appendRotation(-angleZ,Vector3D.Z_AXIS);
//			return $m.transformVector(_3dpoint)
		}
		//复制数组
		public static function depthCopy(source:Object):Object{
			var byte:ByteArray = new ByteArray();
			byte.writeObject(source);
			byte.position = 0;
			return byte.readObject();
		}
		
		public static function moveAngle(a:Number,b:Number,param:Number):Number
		{
			var _a:Number=changeAngle(a);
			var _b:Number=changeAngle(b);
			
			var max:Number=_a>_b?_a:_b;
			var min:Number=_a>_b?_b:_a;
			var plus:Number=_a>_b?(_a-_b):(_b-_a);
			var derection:int=plus>(360-plus)?1:-1;
			
			var dis:Number=plus>(360-plus)?(360-plus):plus;
			if(derection==1)
			{
				return dis*param+max;
			}
			else
			{
				return dis*param+min;
			}
		}
		
		private static function changeAngle(_a:Number):Number
		{
			if(_a>0){
				_a=_a%360;
			}
			while(_a<0)
			{
				_a=_a+360;
			}
			return _a;
		}
		/**
		 * 
		 * @param p0
		 * @param p1
		 * @param p2
		 * @param p3
		 * @param v0
		 * @param v1
		 * @param v2
		 * @return 映射到空间坐标中的位置
		 * 
		 */
		public static function transformUvPosIn3Dpos(p0:Point,p1:Point,p2:Point,p3:Point, v0:Vector3D,v1:Vector3D,v2:Vector3D):Vector3D
		{
			var dd:Number = p1.x * p2.y + p0.x * p1.y + p2.x * p0.y - p1.x * p0.y - p2.x * p1.y - p0.x * p2.y;
			if(dd == 0)
			{
				return null;
			}
			var ret:Vector3D = new Vector3D();
			var dx:Number = (p1.x * p2.y + p3.x * p1.y + p3.y * p2.x - p1.x * p3.y - p3.x * p2.y - p1.y * p2.x) / dd;
			var dy:Number = (p3.x * p2.y + p0.x * p3.y + p2.x * p0.y - p3.x * p0.y - p2.x * p3.y - p0.x * p2.y) / dd;
			var dz:Number = (p1.x * p3.y + p0.x * p1.y + p3.x * p0.y - p1.x * p0.y - p3.x * p1.y - p3.y * p0.x) / dd;
			ret.x = v0.x * dx + v1.x * dy + v2.x * dz;
			ret.y = v0.y * dx + v1.y * dy + v2.y * dz;
			ret.z = v0.z * dx + v1.z * dy + v2.z * dz;
			return ret;
		}
		
		public static function getArrByStr(str:String):Array
		{
			var boneNameAry:Array = str.split(/\s+/g);
			for(var i:Number=boneNameAry.length-1;i>=0;i--){
				if(String(boneNameAry[i]).length<1){
					boneNameAry.splice(i,1);
				}
			}
			return boneNameAry;
		}
		

	}
}
