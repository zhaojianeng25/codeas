package PanV2.xyzmove
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.Focus3D;
	import _Pan3D.base.ObjData;
	import _Pan3D.base.ObjectMath;
	import _Pan3D.core.TestTriangle;
	
	import _me.Scene_data;
	

	public class MathUint
	{
		
		public function MathUint()
		{
		}
		/**
		 * 计算出镜头的坐标，及矩阵
		 * @param _Cam
		 * @param _focus_3d
		 * @param shake
		 * 
		 */
		public static function catch_cam(_Cam:Camera3D, _focus_3d:Focus3D,shake:Vector3D=null):void
		{
			
			
			
			
			
			
			
			var  $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-_focus_3d.angle_x, Vector3D.X_AXIS);
			$m.appendRotation(-_focus_3d.angle_y, Vector3D.Y_AXIS);
			$m.appendTranslation( _focus_3d.x, _focus_3d.y, _focus_3d.z)
			var $p:Vector3D=$m.transformVector(new Vector3D(0,0,-_Cam.distance))
			_Cam.x=$p.x
			_Cam.y=$p.y
			_Cam.z=$p.z
			_Cam.rotationX=_focus_3d.angle_x;
			_Cam.rotationY=_focus_3d.angle_y;
			
			_Cam.cameraMatrix.identity();
			var fovw:Number=Scene_data.stage3DVO.width
			var fovh:Number=Scene_data.stage3DVO.height
			_Cam.cameraMatrix.prependScale(1*(Scene_data.sceneViewHW/fovw*2), fovw / fovh*(Scene_data.sceneViewHW/fovw*2), 1);
			_Cam.cameraMatrix.prependTranslation(0, 0, _Cam.distance);
			_Cam.cameraMatrix.prependRotation(_Cam.rotationX, Vector3D.X_AXIS);
			_Cam.cameraMatrix.prependRotation(_Cam.rotationY, Vector3D.Y_AXIS);
			_Cam.cameraMatrix.prependTranslation(-_focus_3d.x, -_focus_3d.y,-_focus_3d.z);
			
			//_Cam.cameraMatrix=lookAt(new Vector3D(_focus_3d.x,_focus_3d.y,_focus_3d.z),new Vector3D(_Cam.x,_Cam.y,_Cam.z))
			
			
		}
		public static function MathCam(_Cam:Camera3D):void
		{
			
			_Cam.camera3dMatrix.identity();


			_Cam.camera3dMatrix.prependRotation(_Cam.rotationX, Vector3D.X_AXIS);
			_Cam.camera3dMatrix.prependRotation(_Cam.rotationY, Vector3D.Y_AXIS);
			_Cam.camera3dMatrix.prependTranslation(-_Cam.x + _Cam.offset.x, -_Cam.y + _Cam.offset.y,-_Cam.z + _Cam.offset.z);
			
		
			
			var fovw:Number=Scene_data.stage3DVO.width
			var fovh:Number=Scene_data.stage3DVO.height
			_Cam.cameraMatrix.identity();
			_Cam.cameraMatrix.append(_Cam.camera3dMatrix)
			_Cam.cameraMatrix.appendScale(1*(Scene_data.sceneViewHW/fovw*2), fovw / fovh*(Scene_data.sceneViewHW/fovw*2), 1);
			
			
		}
		
		
		public static function catch_Rect_Cam(_Cam:Camera3D, _focus_3d:Focus3D):void
		{
			var  $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-_focus_3d.angle_x, Vector3D.X_AXIS);
			$m.appendRotation(-_focus_3d.angle_y, Vector3D.Y_AXIS);
			$m.appendTranslation( _focus_3d.x, _focus_3d.y, _focus_3d.z)
			var $p:Vector3D=$m.transformVector(new Vector3D(0,0,-_Cam.distance))
			_Cam.x=$p.x
			_Cam.y=$p.y
			_Cam.z=$p.z
			_Cam.rotationX=_focus_3d.angle_x;
			_Cam.rotationY=_focus_3d.angle_y;
			_Cam.cameraMatrix.identity();
			_Cam.cameraMatrix.prependScale(1,1,1);
			_Cam.cameraMatrix.prependTranslation(0, 0, _Cam.distance);
			_Cam.cameraMatrix.prependRotation(_Cam.rotationX, Vector3D.X_AXIS);
			_Cam.cameraMatrix.prependRotation(_Cam.rotationY, Vector3D.Y_AXIS);
			_Cam.cameraMatrix.prependTranslation(-_focus_3d.x, -_focus_3d.y,-_focus_3d.z);

		}
		public static function lookAt(a:Vector3D,b:Vector3D):Matrix3D
		{
			var m:Matrix3D=new Matrix3D;
			var ma:Matrix3D=new Matrix3D
			var mb:Matrix3D=new Matrix3D
			ma.pointAt(a.subtract(b),Vector3D.X_AXIS,Vector3D.Y_AXIS);
			mb.pointAt(new Vector3D(0,0,1),Vector3D.X_AXIS,Vector3D.Y_AXIS);
			ma.invert()
			ma.append(mb)
			ma.invert()
			m.append(ma)
			m.appendTranslation(b.x,b.y,b.z)
			m.invert()
			return m;
			
		}
		
		/**
		 * 
		 * @param $v3d 传入一个世界坐标，
		 * @return  返回一个屏幕顶点坐标
		 * 
		 */
		public static function mathWorld3DPosto2DView($stage3DVO:Rectangle,$v3d:Vector3D):Point{
			if(!Scene_data.viewMatrx3D){
				throw new Error("Scene_data.viewMatrx3D.还没设置")
			}
			var _posMatrix:Matrix3D=new Matrix3D
			_posMatrix.appendTranslation($v3d.x,$v3d.y,$v3d.z);
			_posMatrix.append(Scene_data.cam3D.cameraMatrix);
			_posMatrix.append(Scene_data.viewMatrx3D);
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
	
			var cameraMatrixInvert:Matrix3D=Scene_data.cam3D.cameraMatrix.clone()
			var viewMatrx3DInvert:Matrix3D=Scene_data.viewMatrx3D.clone()
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
		public static function mathPostionTransFormCam($v3d:Vector3D):Vector3D
		{
			return Scene_data.cam3D.cameraMatrix.transformVector($v3d);
			
		}

		public static function _PanelEquationFromThreePt(p1:Vector3D, p2:Vector3D, p3:Vector3D):ObjectMath
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
		 *计算空间中点到三角形最短距离 
		 * @param a
		 * @param b
		 * @param c
		 * @param d
		 * @return 
		 * 
		 */
		public static function vector3DToRectangleDis(a:Vector3D,b:Vector3D,c:Vector3D,d:Vector3D):Number
		{
		
			var $cuizhu:Vector3D=MathUint.getPointPedalInPlane(d,a,b,c);
			if(MathUint.checkPointInPlaneByTriMiddPoint(a,b,c,$cuizhu)){
				return Vector3D.distance(d,$cuizhu)
			}else{
				var Ald:Number=(MathUint.getPointToLineNearestdistance(a,b,d))
				var Bld:Number=(MathUint.getPointToLineNearestdistance(a,c,d))
				var Cld:Number=(MathUint.getPointToLineNearestdistance(b,c,d))
				return Math.min(Ald,Bld,Bld)
			}
		}
		/**
		 *  求空间中点到线短的最短距离
		 * @param a  线段端点
		 * @param b  线段端点
		 * @param c  待检测的点
		 * @return 
		 * 大体上应该分为四种情况  俩边的俩个钝角   上面的锐角 和共线的情况
		 */		
		public static function getPointToLineNearestdistance(a:Vector3D,b:Vector3D,c:Vector3D):Number
		{
			var _a:Number=getTwoPointDis(b,c);
			if(_a<=0.00001){
				return 0;
			}
			var _b:Number=getTwoPointDis(a,c);
			if(_b<0.00001){
				return 0;
			}
			var _c:Number=getTwoPointDis(a,b);
			if(_c<0.00001){
				return 0;
			}
			
			if(_a*_a>=_b*_b+_c*_c){
				return _b;
			}
			if(_b*_b>=_a*_a+_c*_c){
				return _a;
			}
			var l:Number=(_a+_b+_c)/2;
			var s:Number=Math.sqrt(l*(l-_a)*(l-_b)*(l-_c));
			return 2*s/_c;
		}
		
		/**
		 * 空间俩点的距离 
		 * @param vec
		 * @param vec1
		 * @return 
		 * 
		 */		
		public static function getTwoPointDis(vec:Vector3D,vec1:Vector3D):Number
		{
			return Vector3D.distance(vec,vec1);
		}
		/**
		 *  判断空间中点是否在空间三角形内    确定点在面内 
		 * @param a
		 * @param b
		 * @param c
		 * @param target
		 * @return 
		 * 
		 */		
		public static function checkPointInPlaneByTriMiddPoint(a:Vector3D,b:Vector3D,c:Vector3D,target:Vector3D):Boolean
		{
			var vac:Vector3D=getVectorByTwoPoint(a,c);
			var vab:Vector3D=getVectorByTwoPoint(a,b);
			var vat:Vector3D=getVectorByTwoPoint(a,target);
			var dotacac:Number=dotMulVector(vac,vac);
			var dotacab:Number=dotMulVector(vac,vab);
			var dotacat:Number=dotMulVector(vac,vat);
			var dotabab:Number=dotMulVector(vab,vab);
			var dotabat:Number=dotMulVector(vab,vat);
			var num:Number=1/(dotacac*dotabab-dotacab*dotacab);
			var u:Number=(dotabab*dotacat-dotacab*dotabat)*num;
			if(u<0||u>1){
				return false;
			}
			var v:Number=(dotacac*dotabat-dotacab*dotacat)*num;
			if(v<0||v>1){
				return false
			}
			return u+v<=1;
		}
		/**
		 * 得到a--->b方向的向量 
		 * @param a
		 * @param b
		 * 
		 */		
		public static function getVectorByTwoPoint(a:Vector3D,b:Vector3D):Vector3D
		{
			return new Vector3D(b.x-a.x,b.y-a.y,b.z-a.z);
		}
		/**
		 * 向量的点乘  几何意义就是俩个向量的夹角幅度 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		public static function dotMulVector(a:Vector3D,b:Vector3D):Number
		{
			return a.x*b.x+a.y*b.y+a.z*b.z;
		}
		
		
		public static function getPointToPlaneDistance(p:Vector3D,a:Vector3D,b:Vector3D,c:Vector3D):Number
		{
			var pedal:Vector3D=getPointPedalInPlane(p,a,b,c);
			return Vector3D.distance(p,pedal);
		}
		
		/**
		 *  根据三个点确定的平面球 另外一点在面的垂足 
		 * @param targetPoint
		 * @param a
		 * @param b
		 * @param c
		 * @return 
		 * 
		 */		
		public static function getPointPedalInPlane(targetPoint:Vector3D,a:Vector3D,b:Vector3D,c:Vector3D):Vector3D
		{
			var planeNomal:Vector3D=calTriNormal(a,b,c,true);
			var plane:Vector.<Vector3D>=new Vector.<Vector3D>();
			plane.push(a,b,c);
			return getProjPosition(planeNomal,targetPoint,plane);
		}
		/**
		 * p点在三角形b确定的平面内的投影坐标点 
		 * @param bNomal
		 * @param p
		 * @param b
		 * @return 
		 * 
		 */		
		public static function getProjPosition(bNomal:Vector3D, targetPoint:Vector3D, bTriPlane:Vector.<Vector3D>):Vector3D
		{
			var checkPoint:Vector3D=targetPoint;
			var pedal:Number=(bNomal.x*(bTriPlane[0].x-checkPoint.x)+bNomal.y*(bTriPlane[0].y-checkPoint.y)+bNomal.z*(bTriPlane[0].z-checkPoint.z))/(bNomal.x*bNomal.x+bNomal.y*bNomal.y+bNomal.z*bNomal.z);
			var pedalVector3d:Vector3D=new Vector3D(checkPoint.x+pedal*bNomal.x,checkPoint.y+pedal*bNomal.y,checkPoint.z+pedal*bNomal.z);
			return pedalVector3d;
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

		
		public static function catch_camByLook(_Cam:Camera3D, _focus_3d:Focus3D,shake:Vector3D=null):void{
			var  $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-_Cam.rotationX, Vector3D.X_AXIS);
			$m.appendRotation(-_Cam.rotationY, Vector3D.Y_AXIS);
			$m.appendTranslation( _focus_3d.x, _focus_3d.y, _focus_3d.z)
			var $p:Vector3D=$m.transformVector(new Vector3D(0,0,-_Cam.distance))
			_Cam.x=$p.x
			_Cam.y=$p.y
			_Cam.z=$p.z
			_Cam.rotationX=_focus_3d.angle_x;
			_Cam.rotationY=_focus_3d.angle_y;
			
			_Cam.cameraMatrix.identity();
//			var fovw:Number=Scene_data.stage3DVO.width
//			var fovh:Number=Scene_data.stage3DVO.height
//			_Cam.cameraMatrix.prependScale(1*(Scene_data.sceneViewHW/fovw*2), fovw / fovh*(Scene_data.sceneViewHW/fovw*2), 1);
			_Cam.cameraMatrix.prependTranslation(0, 0, _Cam.distance);
			_Cam.cameraMatrix.prependRotation(_Cam.rotationX, Vector3D.X_AXIS);
			_Cam.cameraMatrix.prependRotation(_Cam.rotationY, Vector3D.Y_AXIS);
			_Cam.cameraMatrix.prependTranslation(-_focus_3d.x, -_focus_3d.y,-_focus_3d.z);
		}
		
		private function getDrawTri(a:Point,b:Point):Rectangle
		{
			var $rect:Rectangle=new Rectangle;
			$rect.x=Math.floor(Math.min(a.x,b.x))
			$rect.y=Math.floor(Math.min(a.y,b.y))
			$rect.width=Math.ceil(Math.abs(b.x-a.x))
			$rect.height=Math.ceil(Math.abs(b.y-a.y))
			return $rect
		}
		public static function mathObjDataRound($objData:ObjData,ma:Matrix3D=null):Object
		{
			if(!ma){
				ma=new Matrix3D
			}
			
			var i0:uint;
			var i1:uint;
			var i2:uint;
			var a:Vector3D
			var b:Vector3D
			var c:Vector3D
			var $minPos:Vector3D
			var $maxPos:Vector3D
			
			for(var i:uint=0;i<$objData.indexs.length/3;i++){
				i0=$objData.indexs[i*3+0]
				i1=$objData.indexs[i*3+1]
				i2=$objData.indexs[i*3+2]
				
				a=new Vector3D($objData.vertices[i0*3+0],$objData.vertices[i0*3+1],$objData.vertices[i0*3+2])
				b=new Vector3D($objData.vertices[i1*3+0],$objData.vertices[i1*3+1],$objData.vertices[i1*3+2])
				c=new Vector3D($objData.vertices[i2*3+0],$objData.vertices[i2*3+1],$objData.vertices[i2*3+2])
				
				a = ma.transformVector(a);
				b = ma.transformVector(b);
				c = ma.transformVector(c);
				
				if(!$minPos){
					$minPos=a.clone()
					$maxPos=a.clone()
				}
				$minPos.x=Math.min($minPos.x,a.x,b.x,c.x)
				$minPos.y=Math.min($minPos.y,a.y,b.y,c.y)
				$minPos.z=Math.min($minPos.z,a.z,b.z,c.z)
				$maxPos.x=Math.max($maxPos.x,a.x,b.x,c.x)
				$maxPos.y=Math.max($maxPos.y,a.y,b.y,c.y)
				$maxPos.z=Math.max($maxPos.z,a.z,b.z,c.z)
				
			}
			
			var centerPos:Vector3D = $minPos.add($maxPos);
			centerPos.scaleBy(0.5);
			
		    return {min:$minPos,max:$maxPos,center:centerPos};
			
		}
		private static var _triangleClass:TestTriangle=new TestTriangle(); //引用一个测试类，
		

		public static function  makeTopView():void
		{
			if(Scene_data.topViewMatrx3D){
				var $scale:Number=1/Scene_data.cam3D.y
				Scene_data.topViewMatrx3D.identity()
				Scene_data.topViewMatrx3D.appendScale($scale,$scale,0.0002);
				Scene_data.cam3D.angle_y=0.00;
				Scene_data.cam3D.angle_x=-90;
			}

		}
		
		
	}
}