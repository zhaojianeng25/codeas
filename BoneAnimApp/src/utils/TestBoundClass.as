package utils
{
	import _Pan3D.core.TestTriangle;
	
	import _me.Scene_data;
	
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * 包围盒判断类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class TestBoundClass
	{
		private var triangel:TestTriangle;
		private var indexAry:Array = [[0,1,2],[0,3,2],[4,6,7],[4,5,6],[0,3,4],[3,4,7],[3,7,6],[2,3,6],[6,1,2],[1,5,6],[0,4,5],[0,1,5]];

		private var changeMatrix:Matrix3D;
		
		private var _posMatrix:Matrix3D;
		public function TestBoundClass()
		{
			triangel = new TestTriangle;
			
			changeMatrix = new Matrix3D;
			changeMatrix.appendRotation(-Scene_data.cam3D.angle_x,Vector3D.X_AXIS);
			changeMatrix.appendRotation(-Scene_data.cam3D.angle_y,Vector3D.Y_AXIS);
			changeMatrix.invert();
			
			_posMatrix = new Matrix3D;
			
		}
		
		public function refreshCam():void{
			changeMatrix.identity()
			changeMatrix.appendRotation(-Scene_data.cam3D.angle_x,Vector3D.X_AXIS);
			changeMatrix.appendRotation(-Scene_data.cam3D.angle_y,Vector3D.Y_AXIS);
			changeMatrix.invert();
		}
		
		public function testPoint(ary:Vector.<Point>,mousePoint:Point):Boolean{
			for(var i:int;i<indexAry.length;i++){
				triangel.setAllPoint(ary[indexAry[i][0]],ary[indexAry[i][1]],ary[indexAry[i][2]]);
				if(triangel.checkPointIn(mousePoint)){
					return true;
				}
			}
			return false;
		}
		
		public function test3DPoint(v3dary:Vector.<Vector3D>,rotationY:Number,pos:Vector3D,mousePoint:Point):Boolean{
			_posMatrix.identity();
			_posMatrix.appendRotation(rotationY,Vector3D.Y_AXIS);
			_posMatrix.appendTranslation(pos.x,pos.y,pos.z);
			
			var ary:Vector.<Point> = new Vector.<Point>;
			for(var i:int;i<v3dary.length;i++){
				var p0:Point = math3Dto2Dwolrd(v3dary[i]);
				ary.push(p0);
			}
			
			for(i=0;i<indexAry.length;i++){
				triangel.setAllPoint(ary[indexAry[i][0]],ary[indexAry[i][1]],ary[indexAry[i][2]]);
				if(triangel.checkPointIn(mousePoint)){
					return true;
				}
			}
			return false;
		}
		
		public function get3DTo2DPoint(v3dary:Vector.<Vector3D>,rotationY:Number,pos:Vector3D):Vector.<Point>{
			_posMatrix.identity();
			_posMatrix.appendRotation(rotationY,Vector3D.Y_AXIS);
			_posMatrix.appendTranslation(pos.x,pos.y,pos.z);
			
			var ary:Vector.<Point> = new Vector.<Point>;
			for(var i:int;i<v3dary.length;i++){
				var p0:Point = math3Dto2Dwolrd(v3dary[i]);
				ary.push(p0);
			}
			return ary;
		}
		
		public function math3Dto2Dwolrd(v3d:Vector3D):Point{
			v3d = _posMatrix.transformVector(v3d);
			var p1:Vector3D = changeMatrix.transformVector(v3d);
			p1.x = p1.x + Scene_data.stageWidth/2;
			p1.y = -p1.y +  Scene_data.stageHeight/2;
			return new Point(p1.x,p1.y);
		}
		
		
		
	}
}