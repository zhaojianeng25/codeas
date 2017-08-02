package  xyz.draw
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import xyz.base.TooObjData;
	import xyz.base.TooObject3D;
	import xyz.base.TooObjectMath;
	import xyz.base.TooTestTriangle;
	
	//import _me.Scene_data;


	public class TooMathMoveUint
	{
		public static var viewMatrx3D:Matrix3D
		public static var cameraMatrix:Matrix3D
		public static var stage3Drec:Rectangle
		public static var stage3Dmouse:Point
		public static var stage2Dmouse:Point
		public static var camPositon:Vector3D
		public static var context3D:Context3D
		public static var agalLevel:uint=1    //2为a3d 1为pan3d
			
		
		public static var MOVE_XYZ:uint=0	
		public static var MOVE_SCALE:uint=1	
		public static var MOVE_ROUTATION:uint=2	
		public  static var _line50:Number=50
			
		public function TooMathMoveUint()
		{
		}
		public static function mathHit3DPoint(v:Vector3D,_size:Number=10):Boolean
		{
			var p:Point=TooMathMoveUint.mathWorld3DPosto2DView(stage3Drec,v)
			//if(MathClass.math_distance(p.x,p.y,stage3Dmouse.x,stage3Dmouse.y)<_size){
			if(Point.distance(p,stage3Dmouse)<_size){
				return true
			}else{
				return false;
			}
		}
		public static function _PanelEquationFromThreePt(p1:Vector3D, p2:Vector3D, p3:Vector3D):TooObjectMath
		{
			//得到平面方程 ax+by+cz+d=0(传入三个点,返回平面方程a,b,c,d);
			var a:Number=((p2.y - p1.y) * (p3.z - p1.z) - (p2.z - p1.z) * (p3.y - p1.y));
			var b:Number=((p2.z - p1.z) * (p3.x - p1.x) - (p2.x - p1.x) * (p3.z - p1.z));
			var c:Number=((p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x));
			var d:Number=(0 - (a * p1.x + b * p1.y + c * p1.z));
			var tempObjectMath:TooObjectMath=new TooObjectMath;
			tempObjectMath.a=a;
			tempObjectMath.b=b;
			tempObjectMath.c=c;
			tempObjectMath.d=d;
			return tempObjectMath;
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
		public static function getLineAndPlaneIntersectPoint(linePoint_a:Vector3D,linePoint_b:Vector3D,planePoint:Vector3D,planeNormal:Vector3D):Vector3D
		{
			var lineVector:Vector3D=new Vector3D(linePoint_a.x-linePoint_b.x,linePoint_a.y-linePoint_b.y,linePoint_a.z-linePoint_b.z);
			lineVector.normalize();
			var pt:Number=lineVector.x*planeNormal.x+lineVector.y*planeNormal.y+lineVector.z*planeNormal.z;
			var t:Number=((planePoint.x-linePoint_a.x)*planeNormal.x+(planePoint.y-linePoint_a.y)*planeNormal.y+(planePoint.z-linePoint_a.z)*planeNormal.z)/pt;
			var aPro1:Vector3D=new Vector3D;
			aPro1.setTo(linePoint_a.x+lineVector.x*t,linePoint_a.y+lineVector.y*t,linePoint_a.z+lineVector.z*t);
			return aPro1;
		}
		/**
		 * 
		 * @param linePoint_a  线起点
		 * @param linePoint_b  线结点
		 * @param planePoint  构成面的三个点
		 * @return 交点坐标
		 * 
		 */		
		public static function getLinePlaneInterectPointByTri(linePoint_a:Vector3D,linePoint_b:Vector3D,planePoint:Vector.<Vector3D>):Vector3D
		{
			if(planePoint.length<3) return null;
			var nomal:Vector3D=calTriNormal(planePoint[0],planePoint[1],planePoint[2]);
			return getLineAndPlaneIntersectPoint(linePoint_a,linePoint_b,planePoint[0],nomal);
		}
		/**
		 * 根据三个点求法向量   这里不需要单位化
		 * @param v1
		 * @param v2
		 * @param v3
		 * @param isNormallize  是否单位化  默认不单位化
		 * @return 
		 * 
		 */		
		
		public static function calTriNormal(v0:Vector3D,v1:Vector3D,v2:Vector3D,isNormallize:Boolean=false):Vector3D
		{
			var p1:Vector3D=v1.subtract(v0)
			var p2:Vector3D=v2.subtract(v1)
			var nrmVec:Vector3D=p1.crossProduct(p2)
			if(isNormallize){
				nrmVec.normalize();
			}
			return  nrmVec;
		}
		
		
		public static function argbToHex16( r:uint, g:uint, b:uint):uint
		{
			// 转换颜色
			var color:uint= r << 16 | g << 8 | b;
			return color;
		}
		
		
		/**
		 * 
		 * @param $v3d 传入一个世界坐标，
		 * @return  返回一个屏幕顶点坐标
		 * 
		 */
		public static function mathWorld3DPosto2DView($stage3DVO:Rectangle,$v3d:Vector3D):Point{
			if(!viewMatrx3D){
				throw new Error("Scene_data.viewMatrx3D.还没设置")
			}
			var _posMatrix:Matrix3D=new Matrix3D
			_posMatrix.appendTranslation($v3d.x,$v3d.y,$v3d.z);
			_posMatrix.append(cameraMatrix);
			_posMatrix.append(viewMatrx3D);
			var v3d:Vector3D = _posMatrix.transformVector(new Vector3D);
			v3d.x = v3d.x/v3d.w;
			v3d.y = v3d.y/v3d.w;
			
			var sw:Number=$stage3DVO.width
			var sh:Number=$stage3DVO.height
			
			v3d.x = (1 + v3d.x) * sw / 2;
			v3d.y = (1 - v3d.y) * sh / 2;
			return new Point(v3d.x,v3d.y);
			
			
		}
		
		/**
		 * 2D坐标转换成3D坐标，当然要给一个相离镜头的深度
		 * @param $stage3DVO 为stage3d的坐标信息
		 * @param $point  2d位置是场景的坐标，
		 * @param $depht  默认深度为500,
		 * @return  3D的坐标
		 * 
		 */
		public static function mathDisplay2Dto3DWorldPos($stage3DVO:Rectangle,$point:Point,$depht:Number=500):Vector3D
		{
			if(agalLevel==2){
				return screenToWorld($stage3DVO,$point,$depht)
			}
			var cameraMatrixInvert:Matrix3D=cameraMatrix.clone()
			var viewMatrx3DInvert:Matrix3D=viewMatrx3D.clone()
			cameraMatrixInvert.invert();
			viewMatrx3DInvert.invert();
			var a:Vector3D=new Vector3D()	
			a.x=$point.x-$stage3DVO.x
			a.y=$point.y-$stage3DVO.y
			
			a.x=a.x*2/$stage3DVO.width-1
			a.y=1-a.y*2/$stage3DVO.height
			a.w=$depht
			a.x = a.x*a.w
			a.y = a.y*a.w
			a=viewMatrx3DInvert.transformVector(a)
			a.z=$depht
			a=cameraMatrixInvert.transformVector(a)
			
			return a;
			
		}
		public  static function screenToWorld($stage3DVO:Rectangle,$point:Point,$depht:Number=500):Vector3D {
			
			var _worldToGpuMatrix3D:Matrix3D=new Matrix3D;
			_worldToGpuMatrix3D=cameraMatrix.clone()
			_worldToGpuMatrix3D.append(viewMatrx3D);

			var gpuPos:Vector3D = new Vector3D(($point.x - stage3Drec.width * 0.5) / stage3Drec.width * 2, (stage3Drec.height * 0.5 - $point.y) / stage3Drec.height * 2, 1);
			var rayDir:Vector3D = getGpuToWorldRay(gpuPos.x, gpuPos.y, _worldToGpuMatrix3D);
			rayDir.scaleBy($depht / rayDir.length);
			var worldPos:Vector3D = camPositon.add(rayDir);
			return worldPos;
		}
		public static  function getGpuToWorldRay(_gpuX:Number, _gpuY:Number, _worldToGpuMatrix3D:Matrix3D ):Vector3D {
			var gpuPos:Vector3D             = new Vector3D(_gpuX, _gpuY, 1);
			var gpuToWorldMatrix3D:Matrix3D = _worldToGpuMatrix3D.clone();
			gpuToWorldMatrix3D.invert();
			var worldSpacePos:Vector3D = gpuToWorldMatrix3D.transformVector(gpuPos);
			return worldSpacePos;
		}
		public static function hexToArgb(expColor:uint,is32:Boolean=true,color:Vector3D = null):Vector3D
		{
			if(!color)
			{
				color = new Vector3D();
			}
			color.w =is32? (expColor>>24) & 0xFF:0;
			color.x= (expColor>>16) & 0xFF;
			color.y = (expColor>>8) & 0xFF;
			color.z = (expColor) & 0xFF;
			return color;
		}
		
		/**
		 * 计算出镜头的坐标，及矩阵
		 * @param _Cam
		 * @param _focus_3d
		 * @param shake
		 * 
		 */

		
		private function getDrawTri(a:Point,b:Point):Rectangle
		{
			var $rect:Rectangle=new Rectangle;
			$rect.x=Math.floor(Math.min(a.x,b.x))
			$rect.y=Math.floor(Math.min(a.y,b.y))
			$rect.width=Math.ceil(Math.abs(b.x-a.x))
			$rect.height=Math.ceil(Math.abs(b.y-a.y))
			return $rect
		}
		private static var _triangleClass:TooTestTriangle=new TooTestTriangle(); //引用一个测试类，
		/**
		 *计算模型是否被鼠标点到 
		 * @param objData
		 * @param posMatrix
		 * @param face
		 * @return 三角形id
		 * 
		 */
		private static function clikObjDataHit(objData:TooObjData,posMatrix:Matrix3D,face:Boolean=false):int
		{
			if(!objData||!posMatrix){
				return -1
			}
			
			var haveHit:Boolean=false;
			var A:Vector3D=new Vector3D;
			var B:Vector3D=new Vector3D;
			var C:Vector3D=new Vector3D;
			var a:Point=new Point
			var b:Point=new Point
			var c:Point=new Point
			
			
			var P:TooObject3D=new TooObject3D(stage3Dmouse.x,stage3Dmouse.y);
			var $camPos:Vector3D=new Vector3D(camPositon.x,camPositon.y,camPositon.z);
			for (var i:int=0;objData&&objData.indexs&& i < objData.indexs.length / 3; i++)
			{
				
				var i0:uint=objData.indexs[i*3+0]
				var i1:uint=objData.indexs[i*3+1]
				var i2:uint=objData.indexs[i*3+2]
				
				A=new Vector3D(objData.vertices[i0 * 3 + 0] , objData.vertices[i0 * 3 + 1] , objData.vertices[i0 * 3 + 2] )
				B=new Vector3D(objData.vertices[i1 * 3 + 0] , objData.vertices[i1 * 3 + 1] , objData.vertices[i1 * 3 + 2] )
				C=new Vector3D(objData.vertices[i2 * 3 + 0] , objData.vertices[i2 * 3 + 1] , objData.vertices[i2 * 3 + 2] )
				
				
				A=posMatrix.transformVector(A)
				B=posMatrix.transformVector(B)
				C=posMatrix.transformVector(C)
					
					
				if(face){
					var $centenPos:Vector3D=A.add(B).add(C)
					var $camNrm:Vector3D=$camPos.subtract($centenPos)
					$camNrm.normalize()
					var $triNrm:Vector3D=TooMathMoveUint.calTriNormal(A,B,C,true)
					if($camPos.dotProduct($triNrm)<0){
						continue;
					}
				}
	
				
				a=TooMathMoveUint.mathWorld3DPosto2DView(stage3Drec,A)
				b=TooMathMoveUint.mathWorld3DPosto2DView(stage3Drec,B)
				c=TooMathMoveUint.mathWorld3DPosto2DView(stage3Drec,C)
				
				
				if(a.x==b.x&&a.y==b.y||a.x==c.x&&a.y==c.y||c.x==b.x&&c.y==b.y)
				{
					//排除在一条线上
				}else{
					_triangleClass.setAllPoint(new Point(a.x, a.y), new Point(b.x, b.y), new Point(c.x, c.y))
					if (_triangleClass.checkPointIn(new Point(P.x, P.y)))
					{
						haveHit=true;
						return i
						break;
					}
				}
			}
			return -1
		}

		
		
	}
}