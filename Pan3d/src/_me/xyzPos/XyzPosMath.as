package _me.xyzPos
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Object3D;
	import _Pan3D.base.ObjectMath;
	import _Pan3D.core.Groundposition;
	
	import _me.Scene_data;

	public class XyzPosMath
	{
		public function XyzPosMath()
		{
		}
		public static var  lastPosVec:Vector3D;
		public static var  planeMath:ObjectMath;
		public static var _plantItem:Vector.<Vector3D>;
		public static function makeViewTri(ve:Vector3D):Boolean
		{
			lastPosVec=ve
			var a:Vector3D=new Vector3D(0,0,0)
			var b:Vector3D=new Vector3D(10,0,0)
			var c:Vector3D=new Vector3D(10,10,0)
			var m:Matrix3D=new Matrix3D;
			//转到这个点所在的平面上的三个顶点，
			m.appendRotation(-Scene_data.cam3D.angle_x,Vector3D.X_AXIS);
			m.appendRotation(-Scene_data.cam3D.angle_y,Vector3D.Y_AXIS);
			m.appendTranslation(lastPosVec.x,lastPosVec.y,lastPosVec.z)
			a=m.transformVector(a)
			b=m.transformVector(b)
			c=m.transformVector(c)
			_plantItem=new Vector.<Vector3D>
			_plantItem.push(a)
			_plantItem.push(b)
			_plantItem.push(c)
			return true;
		}

		public static function getHitViewPos():Vector3D
		{
			var _E:Object3D=Groundposition.getScene3DPoint()
			var hitV:Vector3D=new Vector3D(_E.x,_E.y,_E.z)
			var camV:Vector3D=new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z);
			var hitP:Vector3D=getLinePlaneInterectPointByTri(camV,hitV,_plantItem);
			var _v:Vector3D=new Vector3D;
			_v.x=hitP.x-lastPosVec.x
			_v.y=hitP.y-lastPosVec.y
			_v.z=hitP.z-lastPosVec.z
			return _v
		}
		/**
		 * 空间一条射线和平面的交点 
		 * @param linePoint_a  过直线的一点
		 * @param linePoint_b  过直线另一点
		 * @param planePoint   过平面一点
		 * @param planeNormal  平面的法线
		 * @return 
		 * 
		 */		
		private static  function getLineAndPlaneIntersectPoint(linePoint_a:Vector3D,linePoint_b:Vector3D,planePoint:Vector3D,planeNormal:Vector3D):Vector3D
		{
			var lineVector:Vector3D=new Vector3D(linePoint_a.x-linePoint_b.x,linePoint_a.y-linePoint_b.y,linePoint_a.z-linePoint_b.z);
			lineVector.normalize();
			var pt:Number=lineVector.x*planeNormal.x+lineVector.y*planeNormal.y+lineVector.z*planeNormal.z;
			var t:Number=((planePoint.x-linePoint_a.x)*planeNormal.x+(planePoint.y-linePoint_a.y)*planeNormal.y+(planePoint.z-linePoint_a.z)*planeNormal.z)/pt;
			var aPro1:Vector3D=new Vector3D;
			aPro1.setTo(linePoint_a.x+lineVector.x*t,linePoint_a.y+lineVector.y*t,linePoint_a.z+lineVector.z*t);
			return aPro1;
		}
		public static function getLinePlaneInterectPointByTri(linePoint_a:Vector3D,linePoint_b:Vector3D,planePoint:Vector.<Vector3D>):Vector3D
		{
			if(planePoint.length<3) return null;
			var nomal:Vector3D=calTriNormal(planePoint[0],planePoint[1],planePoint[2]);
			return getLineAndPlaneIntersectPoint(linePoint_a,linePoint_b,planePoint[0],nomal);
		}
		private static function calTriNormal(v1:Vector3D,v2:Vector3D,v3:Vector3D):Vector3D
		{
			var p1:Vector3D=new Vector3D;
			var p2:Vector3D=new Vector3D;
			var nrmVec:Vector3D=new Vector3D;
			p1.x=v2.x-v1.x;
			p1.y=v2.y-v1.y;
			p1.z=v2.z-v1.z;
			p2.x=v3.x-v2.x;
			p2.y=v3.y-v2.y;
			p2.z=v3.z-v2.z;
			
			nrmVec.x=p1.y*p2.z-p1.z*p2.y;
			nrmVec.y=p1.z*p2.x-p1.x*p2.z;
			nrmVec.z=p1.x*p2.y-p1.y*p2.x
			nrmVec.normalize();
			return  nrmVec;
		}
		
	}
}