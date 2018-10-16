package _Pan3D.utils
{
	import _Pan3D.core.MathClass;
	import _Pan3D.core.MathCore;
	import _Pan3D.core.TestTriangle;
	
	import _me.Scene_data;
	
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * 包围盒判断类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Test3DBoundManager
	{
		/**
		 * 判断关系所用三角形 
		 */		
		private var triangel:TestTriangle;
		private var indexAry:Array = [[0,1,2],[0,3,2],[4,6,7],[4,5,6],[0,3,4],[3,4,7],[3,7,6],[2,3,6],[6,1,2],[1,5,6],[0,4,5],[0,1,5]];

		private var changeMatrix:PerspectiveMatrix3D;
		
		private var _posMatrix:Matrix3D;
		
		private static var _instance:Test3DBoundManager;
		
		//private var sp:Sprite;
		public function Test3DBoundManager()
		{
			init();
		}
		public static function getInstance():Test3DBoundManager{
			if(!_instance){
				_instance = new Test3DBoundManager;
			}
			return _instance;
		}
		/**
		 * 初始化测试类 
		 * 
		 */		
		public function init():void{
			triangel = new TestTriangle;
			
			changeMatrix = new PerspectiveMatrix3D();
			changeMatrix.perspectiveFieldOfViewLH(1, 1, 0.1, 9000);
			
			_posMatrix = new Matrix3D;
			
//			sp = new Sprite;
//			Scene_data.stage.addChild(sp);
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
			if(!v3dary || v3dary.length==0){
				return false;
			}
			
			_posMatrix.identity();
			_posMatrix.appendRotation(rotationY,Vector3D.Y_AXIS);
			_posMatrix.appendTranslation(posX,posY,posZ);
			_posMatrix.append(Scene_data.cam3D.cameraMatrix);
			_posMatrix.append(changeMatrix);
			
			var ary:Vector.<Point> = new Vector.<Point>;
			for(var i:int;i<v3dary.length;i++){
				var p0:Point = useMath3Dto2Dwolrd(v3dary[i]);
				ary.push(p0);
			}
			
//			sp.graphics.clear();
//			sp.graphics.beginFill(0xff0000,1);
//			
//			for(i=0;i<ary.length;i++){
//				sp.graphics.drawCircle(ary[i].x,ary[i].y,3);
//			}
//			sp.graphics.endFill();
			
			for(i=0;i<indexAry.length;i++){
				triangel.setAllPoint(ary[indexAry[i][0]],ary[indexAry[i][1]],ary[indexAry[i][2]]);
				if(triangel.checkPointIn(mousePoint)){
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 3d点转2d的转换关系 (投影关系)
		 * @param v3d 3d点
		 * @return 2d点
		 * 
		 */
		private function useMath3Dto2Dwolrd($v3d:Vector3D):Point{
			
			var v3d:Vector3D = _posMatrix.transformVector($v3d);
			
			v3d.x = v3d.x/v3d.w;
			v3d.y = v3d.y/v3d.w;
			
			v3d.x = (1 + v3d.x) * Scene_data.stageWidth / 2;
			v3d.y = (1 - v3d.y) * Scene_data.stageHeight / 2; 
			
			return new Point(v3d.x,v3d.y);
		}
		
		public function math3Dto2Dwolrd($v3d:Vector3D):Point{
			
			_posMatrix.identity();
			_posMatrix.appendTranslation($v3d.x,$v3d.y,$v3d.z);
			_posMatrix.append(Scene_data.cam3D.cameraMatrix);
			_posMatrix.append(changeMatrix);
			
			var v3d:Vector3D = _posMatrix.transformVector(new Vector3D);
			
			v3d.x = v3d.x/v3d.w;
			v3d.y = v3d.y/v3d.w;
			
			v3d.x = (1 + v3d.x) * Scene_data.stageWidth / 2;
			v3d.y = (1 - v3d.y) * Scene_data.stageHeight / 2; 
			
			return new Point(v3d.x,v3d.y);
		}
		
//		public function math3DLenght():Point{
//			
//		}
		
		
		
	}
}