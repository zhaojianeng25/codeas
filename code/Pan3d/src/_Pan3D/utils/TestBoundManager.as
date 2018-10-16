package _Pan3D.utils
{
	import _Pan3D.core.MathClass;
	import _Pan3D.core.MathCore;
	import _Pan3D.core.TestTriangle;
	
	import _me.Scene_data;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * 包围盒判断类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class TestBoundManager
	{
		/**
		 * 判断关系所用三角形 
		 */		
		private var triangel:TestTriangle;
		private var indexAry:Array = [[0,1,2],[0,3,2],[4,6,7],[4,5,6],[0,3,4],[3,4,7],[3,7,6],[2,3,6],[6,1,2],[1,5,6],[0,4,5],[0,1,5]];

		private var changeMatrix:Matrix3D;
		
		private var _posMatrix:Matrix3D;
		
		private var _offsetX:int;
		private var _offsetY:int;
		
		private static var _instance:TestBoundManager;
		public function TestBoundManager()
		{
			init();
		}
		public static function getInstance():TestBoundManager{
			if(!_instance){
				_instance = new TestBoundManager;
			}
			return _instance;
		}
		/**
		 * 初始化测试类 
		 * 
		 */		
		public function init():void{
			triangel = new TestTriangle;
			
			changeMatrix = new Matrix3D;
			changeMatrix.appendRotation(-Scene_data.cam3D.angle_x,Vector3D.X_AXIS);
			changeMatrix.appendRotation(-Scene_data.cam3D.angle_y,Vector3D.Y_AXIS);
			changeMatrix.invert();
			
			_posMatrix = new Matrix3D;
		}
		/**
		 * 刷新镜头 
		 */		
		public function refreshCam():void{
			changeMatrix.identity()
			changeMatrix.appendRotation(-Scene_data.cam3D.angle_x,Vector3D.X_AXIS);
			changeMatrix.appendRotation(-Scene_data.cam3D.angle_y,Vector3D.Y_AXIS);
			changeMatrix.invert();
		}
		/**
		 * 刷新场景坐标 
		 * @param sceneX
		 * @param sceneY
		 * 
		 */		
		public function refershScene(sceneX:int,sceneY:int):void{
			_offsetX = sceneX;
			_offsetY = sceneY;
		}
		/**
		 * 测试12面体 面和点的关系 
		 * @param v3dary 面的顶点坐标
		 * @param rotationY 面的旋转
		 * @param posX x坐标
		 * @param posY y坐标
		 * @param posZ z坐标
		 * @param offsetX 场景x
		 * @param offsetY 场景y
		 * @param mousePoint 鼠标坐标
		 * @return 
		 * 
		 */		
		public function test3DPoint(v3dary:Vector.<Vector3D>,rotationY:Number,
									posX:Number,posY:Number,posZ:Number,mousePoint:Point):Boolean{
			//_offsetX = offsetX;
			//_offsetY = offsetY;
			if(!v3dary || v3dary.length==0){
				return false;
			}
			
			_posMatrix.identity();
			_posMatrix.appendRotation(rotationY,Vector3D.Y_AXIS);
			_posMatrix.appendTranslation(posX,posY,posZ);
			
			var ary:Vector.<Point> = new Vector.<Point>;
			var v3d:Vector3D = new Vector3D;
			for(var i:int;i<v3dary.length;i++){
				v3d.x = v3dary[i].x * Scene_data.mainRelateScale;
				v3d.y = v3dary[i].y * Scene_data.mainRelateScale;
				v3d.z = v3dary[i].z * Scene_data.mainRelateScale;
				var p0:Point = math3Dto2Dwolrd(v3d);
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
		
		public function get3DTo2DPoint(v3dary:Vector.<Vector3D>,rotationY:Number,
									   posX:Number,posY:Number,posZ:Number,offsetX:int,offsetY:int,mousePoint:Point):Vector.<Point>{
			
			_offsetX = offsetX;
			_offsetY = offsetY;
			
			_posMatrix.identity();
			_posMatrix.appendRotation(rotationY,Vector3D.Y_AXIS);
			_posMatrix.appendTranslation(posX,posY,posZ);
			
			var ary:Vector.<Point> = new Vector.<Point>;
			for(var i:int;i<v3dary.length;i++){
				var p0:Point = math3Dto2Dwolrd(v3dary[i]);
				ary.push(p0);
			}
			return ary;
		}
		/**
		 * 3d点转2d的转换关系 (投影关系)
		 * @param v3d 3d点
		 * @return 2d点
		 * 
		 */
		public function math3Dto2Dwolrd(v3d:Vector3D):Point{			
			v3d = _posMatrix.transformVector(v3d);
			var p1:Vector3D = changeMatrix.transformVector(v3d);
			p1.x = p1.x + _offsetX;
			p1.y = -p1.y +  _offsetY;
			return new Point(p1.x,p1.y);
		}
		
		public function math3DLenght(l:Number):Number{
			//var v3d:Vector3D = _posMatrix.transformVector(new Vector3D(0,l,0));
			var v3d:Vector3D = new Vector3D(0,l,0);
			v3d = changeMatrix.transformVector(v3d);
			//v3d.y *= Scene_data.mainRelateScale;
			return v3d.y;
		}
		
		public function test2DPoint(bitmapdata:BitmapData,posX:Number,posY:Number,mousePoint:Point):Boolean{
			var xpos:int = -posX - _offsetX + mousePoint.x + bitmapdata.width/2;
			var ypos:int = -posY - _offsetY + mousePoint.y + bitmapdata.height;
			
			if(xpos > 0 && xpos < bitmapdata.width && ypos > 0 && ypos < bitmapdata.height){
//				trace("testBoundManager", Boolean(bitmapdata.getPixel32(xpos,ypos)))
				return Boolean(bitmapdata.getPixel32(xpos,ypos));
			}
			
			return false;
		}
		
	}
}