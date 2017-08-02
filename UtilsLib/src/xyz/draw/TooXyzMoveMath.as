package  xyz.draw
{
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import xyz.base.TooSelectRotationModel;
	
	//import _me.Scene_data;
	

	//import _me.Scene_data;

	public class TooXyzMoveMath
	{
		public static var _hitCenten:Boolean;
		public static var _hitX:Boolean;
		public static var _hitY:Boolean;
		public static var _hitZ:Boolean;
		public static var _hitXZtri:Boolean
		public static var _hitXYtri:Boolean
		public static var _hitYZtri:Boolean
	
		public function TooXyzMoveMath()
		{
		}
		public static function mouseDown(_moveDisplay3DSprite:TooMoveLevel,_xyzMoveData:TooXyzMoveData):void
		{
			var line50:Number=TooMathMoveUint._line50
			var $centenPos:Vector3D=_moveDisplay3DSprite.posMatrix.position
			var $po:Vector3D=_moveDisplay3DSprite.posMatrix.transformVector(new Vector3D(0,0,0))
			var $px:Vector3D=_moveDisplay3DSprite.posMatrix.transformVector(new Vector3D(line50,0,0))
			var $py:Vector3D=_moveDisplay3DSprite.posMatrix.transformVector(new Vector3D(0,line50,0))
			var $pz:Vector3D=_moveDisplay3DSprite.posMatrix.transformVector(new Vector3D(0,0,line50))
			
			
			_hitX=false
			_hitY=false
			_hitZ=false
			_hitXZtri=false
			_hitXYtri=false
			_hitYZtri=false
			_hitCenten=false
			var moveSelectId:uint=TooSelectRotationModel.scanHitModel(_moveDisplay3DSprite.spriteItem,TooMathMoveUint.stage2Dmouse,Context3DTriangleFace.NONE)
			
		
			if(moveSelectId==0){
				_hitCenten=true
			}
			if(moveSelectId==1){
				_hitX=true
			}
			if(moveSelectId==2){
				_hitY=true
			}
			if(moveSelectId==3){
				_hitZ=true
			}
			if(moveSelectId==4){
				_hitXZtri=true
			}
			if(moveSelectId==5){
				_hitXYtri=true
			}
			if(moveSelectId==6){
				_hitYZtri=true
			}

			
			var A:Vector3D=$po;
		    var B:Vector3D=$px;
			var C:Vector3D

			var camPos:Vector3D=TooMathMoveUint.camPositon.clone()
			if(_hitCenten){
				var $obj:Object=getPinMianVec(camPos,$po)
				A=$obj.A
				B=$obj.B
				C=$obj.C
			}else if(_hitX||_hitY||_hitZ){
				if(_hitX){
					 B=$px;
				}else if(_hitY){
					 B=$py;
				}else if(_hitZ){
					 B=$pz;
				}
				var $triNrm:Vector3D=TooMathMoveUint.calTriNormal(A,B,camPos,true)
				$triNrm.scaleBy(100)
				C=B.add($triNrm)
		
			}else if(_hitXZtri){
				var xzArr:Vector.<Vector3D>=getXZtriItem(_moveDisplay3DSprite.posMatrix);
				A=xzArr[0];
				B=xzArr[1];
				C=xzArr[2];
			}else if(_hitXYtri){
				var xyArr:Vector.<Vector3D>=getXYtriItem(_moveDisplay3DSprite.posMatrix);
				A=xyArr[0];
				B=xyArr[1];
				C=xyArr[2];
			}else if(_hitYZtri){
				var yzArr:Vector.<Vector3D>=getYZtriItem(_moveDisplay3DSprite.posMatrix);
				A=yzArr[0];
				B=yzArr[1];
				C=yzArr[2];
			}else{
				return ;
			}
			
			lastMatrx=_xyzMoveData.modeMatrx3D.clone()
			triVecItem=new Vector.<Vector3D>
			triVecItem.push(A)
			triVecItem.push(B)
			triVecItem.push(C)
				
		
				
		    var pos:Vector3D=TooMathMoveUint.mathDisplay2Dto3DWorldPos(TooMathMoveUint.stage3Drec,TooMathMoveUint.stage2Dmouse,500)
			var D:Vector3D=TooMathMoveUint.getLinePlaneInterectPointByTri(camPos,pos,triVecItem);
			
			var $m:Matrix3D=lastMatrx.clone()
			$m.invert()
			D=$m.transformVector(D)
			lastPos=D
		}
		
		private static function getXZtriItem($m:Matrix3D):Vector.<Vector3D>
		{
			var a:Vector3D=new Vector3D(0,0,0)
			var b:Vector3D=new Vector3D(100,0,0)
			var c:Vector3D=new Vector3D(0,0,100)
			var $arr:Vector.<Vector3D>=new Vector.<Vector3D>
			$arr.push($m.transformVector(a));
			$arr.push($m.transformVector(b));
			$arr.push($m.transformVector(c));
			return $arr
		}
		private static function getXYtriItem($m:Matrix3D):Vector.<Vector3D>
		{
			var a:Vector3D=new Vector3D(0,0,0)
			var b:Vector3D=new Vector3D(100,0,0)
			var c:Vector3D=new Vector3D(0,100,0)
			var $arr:Vector.<Vector3D>=new Vector.<Vector3D>
			$arr.push($m.transformVector(a));
			$arr.push($m.transformVector(b));
			$arr.push($m.transformVector(c));
			return $arr
		}
		private static function getYZtriItem($m:Matrix3D):Vector.<Vector3D>
		{
			var a:Vector3D=new Vector3D(0,0,0)
			var b:Vector3D=new Vector3D(0,0,100)
			var c:Vector3D=new Vector3D(0,100,0)
			var $arr:Vector.<Vector3D>=new Vector.<Vector3D>
			$arr.push($m.transformVector(a));
			$arr.push($m.transformVector(b));
			$arr.push($m.transformVector(c));
			return $arr
		}
		private static function getPinMianVec(camPos:Vector3D,$po:Vector3D):Object
		{
			var nrm1:Vector3D=camPos.subtract($po)
			nrm1.normalize()
			var m1:Matrix3D=new Matrix3D
			m1.pointAt(nrm1,Vector3D.X_AXIS,Vector3D.Y_AXIS)
				
			var a:Vector3D=new Vector3D(0,0,0)	
			var b:Vector3D=new Vector3D(0,100,0)	
			var c:Vector3D=new Vector3D(0,0,100)	
		
			a=m1.transformVector(a)
			b=m1.transformVector(b)
			c=m1.transformVector(c)

			a=a.add($po)
			b=b.add($po)
			c=c.add($po)

			return {A:a,B:b,C:c}
				
		}
		public static var lastPos:Vector3D
		public static function mouseMove():Vector3D
		{
			var $addPos:Vector3D=new Vector3D
			if(triVecItem){
				var camPos:Vector3D=TooMathMoveUint.camPositon.clone()
				var pos:Vector3D=TooMathMoveUint.mathDisplay2Dto3DWorldPos(TooMathMoveUint.stage3Drec,TooMathMoveUint.stage2Dmouse,500)
				var D:Vector3D=TooMathMoveUint.getLinePlaneInterectPointByTri(camPos,pos,triVecItem);
		
				var $m:Matrix3D=lastMatrx.clone()
				$m.invert()
				D=$m.transformVector(D)
					
				if(_hitCenten||_hitXZtri||_hitXYtri||_hitYZtri){
					$addPos.x=D.x-lastPos.x
					$addPos.y=D.y-lastPos.y
					$addPos.z=D.z-lastPos.z
					
				}else if(_hitX||_hitY||_hitZ){
					if(_hitX){
						$addPos.x=D.x-lastPos.x
					}else if(_hitY){
						$addPos.y=D.y-lastPos.y
					}else if(_hitZ){
						$addPos.z=D.z-lastPos.z
					}

				}
					
			}

			return $addPos
		}
		public static function mouseUp():void
		{
			triVecItem=null	
		}
		private static var triVecItem:Vector.<Vector3D>
		public static var lastMatrx:Matrix3D=new Matrix3D

	}
}