package _Pan3D.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.ObjData;
	import _Pan3D.base.Object3D;
	import _Pan3D.base.ObjectHitBox;
	import _Pan3D.display3D.Display3DSprite;
	
	import _me.Scene_data;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class MathHitModel
	{
		public function MathHitModel()
		{
		}
		private static function math_change_point(_thisCam:Camera3D, _3dpoint:Object3D):void
		{
			//对坐标系里的原始点，跟据镜头角度算出新的从坐标
			var rx:Number=_3dpoint.x - _thisCam.x;
			var ry:Number=_3dpoint.y - _thisCam.y;
			var rz:Number=_3dpoint.z - _thisCam.z;
			/*

			var tmp_rx:Number=rx;
			rx=_thisCam.cos_y * tmp_rx - _thisCam.sin_y * rz;
			rz=_thisCam.sin_y * tmp_rx + _thisCam.cos_y * rz;
			
			var tmp_rz:Number=rz;
			rz=_thisCam.cos_x * tmp_rz - _thisCam.sin_x * ry;
			ry=_thisCam.sin_x * tmp_rz + _thisCam.cos_x * ry;
			
			_3dpoint.rx=int(rx);
			_3dpoint.ry=int(ry);
			_3dpoint.rz=int(rz);
			*/
	
			var $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-_thisCam.angle_y,Vector3D.Y_AXIS);
			$m.appendRotation(-_thisCam.angle_x,Vector3D.X_AXIS);
			var $p:Vector3D=$m.transformVector(new Vector3D(rx, ry, rz))
			_3dpoint.rx=$p.x 
			_3dpoint.ry=$p.y
			_3dpoint.rz=$p.z
			
		}
		private static var _triangleClass:TestTriangle=new TestTriangle(); //引用一个测试类，
		private static function getHitModelVector3D(objData:ObjData, pos:Vector3D):Object3D
		{
			return null
			/*
			//得到最近碰到的三角形坐标
			var A:Object3D=new Object3D;
			var B:Object3D=new Object3D;
			var C:Object3D=new Object3D;
			//复制镜头，因为这个新的镜头有别于原来;
			var _sceneCam:Camera3D=Scene_data.cam3D;
			var _thisCam:Camera3D=_sceneCam.clone();
			var f:Number=Scene_data.stage.mouseX - _sceneCam.fovw / 2;
			var g:Number=_sceneCam.fovh / 2 - Scene_data.stage.mouseY;
			_thisCam.x=_sceneCam.x;
			_thisCam.y=_sceneCam.y;
			_thisCam.z=_sceneCam.z;
			//镜头角度，逆方向，这样才可得到新的旋转后的这些点的镜头坐标。（或说，镜头向左转30度，其实就可以说这些点向右转30度）
			_thisCam.angle_y=-_sceneCam.angle_y;
			_thisCam.angle_x=-_sceneCam.angle_x;
			_thisCam.sin_x=Math.sin(_thisCam.angle_x * Math.PI / 180);
			_thisCam.cos_x=Math.cos(_thisCam.angle_x * Math.PI / 180);
			_thisCam.sin_y=Math.sin(_thisCam.angle_y * Math.PI / 180);
			_thisCam.cos_y=Math.cos(_thisCam.angle_y * Math.PI / 180);
			
			var baceObject3D:Object3D;
			
			
			for (var i:int=0; i < objData.vertices.length / 9; i++)
			{
				A=new Object3D(objData.vertices[i * 9 + 0] + pos.x, objData.vertices[i * 9 + 1] + pos.y, objData.vertices[i * 9 + 2] + pos.z)
				B=new Object3D(objData.vertices[i * 9 + 3] + pos.x, objData.vertices[i * 9 + 4] + pos.y, objData.vertices[i * 9 + 5] + pos.z)
				C=new Object3D(objData.vertices[i * 9 + 6] + pos.x, objData.vertices[i * 9 + 7] + pos.y, objData.vertices[i * 9 + 8] + pos.z)
		    
				math_change_point(_thisCam, A);
				math_change_point(_thisCam, B);
				math_change_point(_thisCam, C);
				
				//分析是否三点在同一线上
				if ((A.rx == B.rx && B.rx == C.rx) || (A.ry == B.ry && B.ry == C.ry) || (A.rz == B.rz && B.rz == C.rz))
				{
					continue;
				}
				//假如在镜头后面也将不计算
				
				if(A.rx<0&&A.ry<0&&A.rz<0){
					continue;
				}
				//算出焦点f,g是屏幕坐标
				var P:Object3D=Calculation._get_hit_rec(A, B, C, Scene_data.cam3D, f, g);
				_triangleClass.setAllPoint(new Point(A.rx, A.ry), new Point(B.rx, B.ry), new Point(C.rx, C.ry))
				if (_triangleClass.checkPointIn(new Point(P.rx, P.ry)))
				{
					//有在三角形里胡就返回
					//return true;
					if(baceObject3D)
					{
						if(baceObject3D.rz>P.rz)//新的点比现在的近才换
						{
							baceObject3D.rx=P.rx;
							baceObject3D.ry=P.ry;
							baceObject3D.rz=P.rz;
						}
						
					}else{
						baceObject3D=new Object3D;
						baceObject3D.rx=P.rx;
						baceObject3D.ry=P.ry;
						baceObject3D.rz=P.rz;
					}
				}
				
			}
			if(baceObject3D){
				
				Calculation._anti_computing_point_copy( baceObject3D,_sceneCam);
				
				
			}
			return baceObject3D;
			*/
		}
		public static function mathHitModel(buildEditDisplay3DSprite:Display3DSprite):Boolean
		{
			var haveHit:Boolean=false;
			var objData:ObjData=buildEditDisplay3DSprite.objData;
			var A:Vector3D=new Vector3D;
			var B:Vector3D=new Vector3D;
			var C:Vector3D=new Vector3D;
			var a:Point=new Point
			var b:Point=new Point
			var c:Point=new Point
			var P:Object3D=new Object3D(Scene_data.stage.mouseX,Scene_data.stage.mouseY);

			for (var i:int=0;objData&&objData.vertices&& i < objData.vertices.length / 9; i++)
			{
				
				A=new Vector3D(objData.vertices[i * 9 + 0] , objData.vertices[i * 9 + 1] , objData.vertices[i * 9 + 2] )
				B=new Vector3D(objData.vertices[i * 9 + 3] , objData.vertices[i * 9 + 4] , objData.vertices[i * 9 + 5] )
				C=new Vector3D(objData.vertices[i * 9 + 6] , objData.vertices[i * 9 + 7] , objData.vertices[i * 9 + 8] )
				
				A=buildEditDisplay3DSprite.posMatrix.transformVector(A)
				B=buildEditDisplay3DSprite.posMatrix.transformVector(B)
				C=buildEditDisplay3DSprite.posMatrix.transformVector(C)
		        
				a=MathCore.mathWorld3DPosto2DView(A)
				b=MathCore.mathWorld3DPosto2DView(B)
				c=MathCore.mathWorld3DPosto2DView(C)
		
				if(a.x==b.x&&a.y==b.y||a.x==c.x&&a.y==c.y||c.x==b.x&&c.y==b.y)
				{
					//排除在一条线上
				}else{
					_triangleClass.setAllPoint(new Point(a.x, a.y), new Point(b.x, b.y), new Point(c.x, c.y))
					if (_triangleClass.checkPointIn(new Point(P.x, P.y)))
					{
						haveHit=true;
						break;
					}
				}
			}
			return haveHit;
		}

		public static function mathHit3DPoint(v:Vector3D,_size:Number=20):Boolean
		{
			var p:Point=MathCore.mathWorld3DPosto2DView(v)
			var d:Number=MathClass.math_distance(p.x,p.y,Scene_data.stage.mouseX,Scene_data.stage.mouseY)
			if(d<_size){
				return true
			}else{
				return false;
			}
		}
		public static function mathBuildHitBox(objectHitBox:ObjectHitBox,_modeMatrix3D:Matrix3D):Boolean
		{
			if(!objectHitBox){
				return false
			}
			var $indexArr:Array=new Array
			$indexArr.push(0,1,2)
			$indexArr.push(0,2,3)
				
			$indexArr.push(4,6,5)
			$indexArr.push(4,7,6)
				
			$indexArr.push(1,5,6)
			$indexArr.push(1,6,2)
				
			$indexArr.push(0,7,4)
			$indexArr.push(0,3,7)
				
			$indexArr.push(0,4,5)
			$indexArr.push(0,5,1)
				
			$indexArr.push(3,6,7)
			$indexArr.push(3,2,6)
				
			objectHitBox.initPointList();
			for(var i:uint=0;i<objectHitBox.pointVec.length;i++){
				objectHitBox.pointVec[i]=_modeMatrix3D.transformVector(objectHitBox.pointVec[i])
				var $p:Vector3D=Scene_data.cam3D.cameraMatrix.transformVector(objectHitBox.pointVec[i])
			    if($p.z<100){   //如果有一个点的深度小于了。那就返回不可选
					return false
				}
					
			}
			var haveHit:Boolean=false;
			var a:Point=new Point
			var b:Point=new Point
			var c:Point=new Point
			var P:Object3D=new Object3D(Scene_data.stage.mouseX,Scene_data.stage.mouseY);
			for(var j:uint=0;j<$indexArr.length/3;j++){

				a=MathCore.mathWorld3DPosto2DView(objectHitBox.pointVec[$indexArr[j*3+0]])
				b=MathCore.mathWorld3DPosto2DView(objectHitBox.pointVec[$indexArr[j*3+1]])
				c=MathCore.mathWorld3DPosto2DView(objectHitBox.pointVec[$indexArr[j*3+2]])

				if(a.x==b.x&&a.y==b.y||a.x==c.x&&a.y==c.y||c.x==b.x&&c.y==b.y)
				{
				}else{
					_triangleClass.setAllPoint(new Point(a.x, a.y), new Point(b.x, b.y), new Point(c.x, c.y))
					if (_triangleClass.checkPointIn(new Point(P.x, P.y)))
					{
						return true   
					}
				}
				
			}
			return false;
		}

	}
}