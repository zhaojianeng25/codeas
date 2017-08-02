package _Pan3D.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.Object3D;
	import _Pan3D.base.ObjectMath;
	
	import _me.Scene_data;

// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Calculation
	{

		public static function _DistPt2Panel(p:Object3D, E:ObjectMath):Number
		{
			return Math.abs(E.a * p.x + E.b * p.y + E.c * p.z + E.d) / Math.sqrt(E.a * E.a + E.b * E.b + E.c * E.c);
		}
		public static function _PanelEquationFromThreePt(p1:Object3D, p2:Object3D, p3:Object3D):ObjectMath
		{
			//得到平面方程 ax+by+cz+d=0(传入三个点,返回平面方程a,b,c,d);
			var a:Number=((p2.y - p1.y) * (p3.z - p1.z) - (p2.z - p1.z) * (p3.y - p1.y));
			var b:Number=((p2.z - p1.z) * (p3.x - p1.x) - (p2.x - p1.x) * (p3.z - p1.z));
			var c:Number=((p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x));
			var d:Number=(0 - (a * p1.x + b * p1.y + c * p1.z));
			var tempObjectMath:ObjectMath=new ObjectMath;
			tempObjectMath.a=a;
			tempObjectMath.b=b;
			tempObjectMath.c=c;
			tempObjectMath.d=d;
			return tempObjectMath;
		}
		public static function _PanelEquationFromThreePtVec(p1:Vector3D, p2:Vector3D, p3:Vector3D):ObjectMath
		{
			//得到平面方程 ax+by+cz+d=0(传入三个点,返回平面方程a,b,c,d);
			var a:Number=((p2.y - p1.y) * (p3.z - p1.z) - (p2.z - p1.z) * (p3.y - p1.y));
			var b:Number=((p2.z - p1.z) * (p3.x - p1.x) - (p2.x - p1.x) * (p3.z - p1.z));
			var c:Number=((p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x));
			var d:Number=(0 - (a * p1.x + b * p1.y + c * p1.z));
			var tempObjectMath:ObjectMath=new ObjectMath;
			tempObjectMath.a=a;
			tempObjectMath.b=b;
			tempObjectMath.c=c;
			tempObjectMath.d=d;
			return tempObjectMath;
		}
		private static function _anti_computing_point(_3dpoint:Object3D, _Cam:Camera3D):void
		{
			//这是一个相对于镜头坐标算出得到原来世界坐标。。在这个数里先不加上镜头的坐标系，只是算出他的相对镜头从头位移，
			//这个功能是为了方便移动场景。所要用到的，
	
			var rx:Number=_3dpoint.rx;
			var ry:Number=_3dpoint.ry;
			var rz:Number=_3dpoint.rz;
			
/*
			
			var tmp_rz : Number = rz;
			rz = _Cam.cos_x * tmp_rz - _Cam.sin_x * ry;
			ry = _Cam.sin_x * tmp_rz + _Cam.cos_x * ry;
			
			var tmp_rx : Number = rx;
			rx = _Cam.cos_y * tmp_rx - _Cam.sin_y * rz;
			rz = _Cam.sin_y * tmp_rx + _Cam.cos_y * rz;
			
			_3dpoint.x=rx 
			_3dpoint.y=ry
			_3dpoint.z=rz 
			*/
				
			var $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-_Cam.angle_x,Vector3D.X_AXIS);
			$m.appendRotation(-_Cam.angle_y,Vector3D.Y_AXIS);
			
			var $p:Vector3D=$m.transformVector(new Vector3D(rx,ry,rz))
			_3dpoint.x=$p.x 
			_3dpoint.y=$p.y 
			_3dpoint.z=$p.z 
		

		}
		public static function _anti_computing_point_copy(_3dpoint:Object3D, _Cam:Camera3D):void
		{
			
			var rx:Number=_3dpoint.rx;
			var ry:Number=_3dpoint.ry;
			var rz:Number=_3dpoint.rz;
/*
			var tmp_rz : Number = rz;
			rz = _Cam.cos_x * tmp_rz - _Cam.sin_x * ry;
			ry = _Cam.sin_x * tmp_rz + _Cam.cos_x * ry;
			
			var tmp_rx : Number = rx;
			rx = _Cam.cos_y * tmp_rx - _Cam.sin_y * rz;
			rz = _Cam.sin_y * tmp_rx + _Cam.cos_y * rz;
			
			_3dpoint.x=(rx + _Cam.x);
			_3dpoint.y=(ry + _Cam.y);
			_3dpoint.z=(rz + _Cam.z);
			
			*/
			

			var $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-_Cam.angle_x,Vector3D.X_AXIS);
			$m.appendRotation(-_Cam.angle_y,Vector3D.Y_AXIS);
			var $p:Vector3D=$m.transformVector(new Vector3D(rx,ry,rz))
			_3dpoint.x=($p.x + _Cam.x);
			_3dpoint.y=($p.y + _Cam.y);
			_3dpoint.z=($p.z + _Cam.z);
		
		}

		public static function _get_hit_rec(a:Object3D, b:Object3D, c:Object3D, _Cam:Camera3D, xx:Number, yy:Number):Object3D
		{
			var A:Object3D=new Object3D();
			var B:Object3D=new Object3D();
			var C:Object3D=new Object3D();
			A.x=a.rx;
			A.y=a.ry;
			A.z=a.rz;
			B.x=b.rx;
			B.y=b.ry;
			B.z=b.rz;
			C.x=c.rx;
			C.y=c.ry;
			C.z=c.rz;
			var _obj:ObjectMath=_PanelEquationFromThreePt(A, B, C);
			var _D:Object3D=_math_intersect(_obj, xx, yy);
			_anti_computing_point( _D,_Cam);
			return (_D);
		}

		public static function _math_intersect(_obj:ObjectMath, xx:Number, yy:Number):Object3D
		{
			//这里是用屏幕的射线，为算出在这个镜头坐标系中，与原来设定的三个定形成的平面，的焦点。
			var a:Number=_obj.a;
			var b:Number=_obj.b;
			var c:Number=_obj.c;
			var d:Number=_obj.d;
			var n:Number = 2/2; //在这里，因为镜头的投影不是1.1/一个很神奇的数字，为了只是和屏幕尺寸对应
			var D:Object3D=new Object3D();
			var x2:Number=xx==0?1:xx/n;
			var y2:Number=yy==0?1:yy/n;
			var z2:Number=Scene_data.sceneViewHW*2; //与屏幕焦点坐坐，方便对应鼠标的位置，用于算出射线与平面相交的点
			D.rx=-d / (a + (b * y2 / x2) + (c * z2 / x2));
			D.ry=D.rx / x2 * y2;
			D.rz=D.rx / x2 * z2;
			return D;
			//	(x-x1)/(x2-x1)=(y-y1)/(y2-y1)=(z-z1)/(z2-z1)  直线方程
			//   ax+by+cz+d=0;  平面方程;
		}
		
		public static function isLineCrossPlane(plane_a:Vector3D, plane_b:Vector3D, plane_c:Vector3D, line_a:Vector3D, line_b:Vector3D):Boolean
		{
			//3点确定平面
			var planeFun:ObjectMath = _PanelEquationFromThreePtVec(plane_a, plane_b, plane_c);
			//获得平面法线
			var normal:Vector3D = new Vector3D(planeFun.a, planeFun.b, planeFun.c);
			normal.normalize();
			//计算直线与平面交点
			var crossPoint:Vector3D = calPlaneLineIntersectPoint(normal, plane_a, line_a, line_b);
			if(crossPoint)
			{
				//有交点
//				var triXY:TestTriangle = new TestTriangle(new Point(plane_a.x, plane_a.y), new Point(plane_b.x, plane_b.y), new Point(plane_c.x, plane_c.y));
//				var triXZ:TestTriangle = new TestTriangle(new Point(plane_a.x, plane_a.z), new Point(plane_b.x, plane_b.z), new Point(plane_c.x, plane_c.z));
//				var triYZ:TestTriangle = new TestTriangle(new Point(plane_a.y, plane_a.z), new Point(plane_b.y, plane_b.z), new Point(plane_c.y, plane_c.z));
//				if(triXY.checkPointIn(new Point(crossPoint.x, crossPoint.y)) &&
//					triXZ.checkPointIn(new Point(crossPoint.x, crossPoint.z)) &&
//					triYZ.checkPointIn(new Point(crossPoint.y, crossPoint.z)))
				if(pointinTriangle(plane_a, plane_b, plane_c, crossPoint))
				{
					//交点在三角面内
					var a:Vector3D = crossPoint.subtract(line_a);
					var b:Vector3D = crossPoint.subtract(line_b);
					var c:Vector3D = line_a.subtract(line_b);
					var sub:Number = c.length - a.length - b.length;
					if(sub < 0.01 && sub > -0.01)
					{
						//交点在线段上
						return true;
					}
				}
			}
			return false;
		}
		
		private static function pointinTriangle(a:Vector3D, b:Vector3D, c:Vector3D, p:Vector3D):Boolean
		{
			var v0:Vector3D = c.subtract(a);
			var v1:Vector3D = b.subtract(a);
			var v2:Vector3D = p.subtract(a);
			
			var dot00:Number = v0.dotProduct(v0) ;
			var dot01:Number = v0.dotProduct(v1) ;
			var dot02:Number = v0.dotProduct(v2) ;
			var dot11:Number = v1.dotProduct(v1) ;
			var dot12:Number = v1.dotProduct(v2) ;
			
			var inverDeno:Number = 1 / (dot00 * dot11 - dot01 * dot01) ;
			
			var u:Number = (dot11 * dot02 - dot01 * dot12) * inverDeno ;
			if (u < 0 || u > 1) // if u out of range, return directly
			{
				return false ;
			}
			
			var v:Number = (dot00 * dot12 - dot01 * dot02) * inverDeno ;
			if (v < 0 || v > 1) // if v out of range, return directly
			{
				return false ;
			}
			
			return u + v <= 1 ;
		}
		
		public static function calPlaneLineIntersectPoint(planeVector:Vector3D, planePoint:Vector3D, linePointA:Vector3D, linePointB:Vector3D):Vector3D
		{
			var ret:Vector3D = new Vector3D();
			var vp1:Number = planeVector.x;
			var vp2:Number = planeVector.y;
			var vp3:Number = planeVector.z;
			var n1:Number = planePoint.x;
			var n2:Number = planePoint.y;
			var n3:Number = planePoint.z;
			var v1:Number = linePointA.x - linePointB.x;
			var v2:Number = linePointA.y - linePointB.y;
			var v3:Number = linePointA.z - linePointB.z;
			var m1:Number = linePointB.x;
			var m2:Number = linePointB.y;
			var m3:Number = linePointB.z;
			var vpt:Number = v1 * vp1 + v2 * vp2 + v3 * vp3;
			//首先判断直线是否与平面平行
			if (vpt == 0)
			{
				return null;
			}
			else
			{
				var t:Number = ((n1 - m1) * vp1 + (n2 - m2) * vp2 + (n3 - m3) * vp3) / vpt;
				ret.x = m1 + v1 * t;
				ret.y = m2 + v2 * t;
				ret.z = m3 + v3 * t;
			}
			return ret;
		}
		
	}
}
