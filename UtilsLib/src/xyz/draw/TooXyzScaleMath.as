package  xyz.draw
{
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import xyz.base.TooObject3D;
	import xyz.base.TooSelectRotationModel;
	
//	import _me.Scene_data;

	public class TooXyzScaleMath
	{
		public static var _hitX:Boolean;
		public static var _hitY:Boolean;
		public static var _hitZ:Boolean;
		public static var _hitCenten:Boolean;
		public function TooXyzScaleMath()
		{
		}
		public static function mouseDown(_scaleDisplay3DSprite:TooScaleLevel,_xyzMoveData:TooXyzMoveData):void
		{
			var line50:Number=TooMathMoveUint._line50
			var $centenPos:Vector3D=_scaleDisplay3DSprite.posMatrix.position
			var $po:Vector3D=_scaleDisplay3DSprite.posMatrix.transformVector(new Vector3D(0,0,0))
			var $px:Vector3D=_scaleDisplay3DSprite.posMatrix.transformVector(new Vector3D(line50,0,0))
			var $py:Vector3D=_scaleDisplay3DSprite.posMatrix.transformVector(new Vector3D(0,line50,0))
			var $pz:Vector3D=_scaleDisplay3DSprite.posMatrix.transformVector(new Vector3D(0,0,line50))
				
				
			_hitX=false
			_hitY=false
			_hitZ=false
			_hitCenten=false
			var scaleSelectId:uint=TooSelectRotationModel.scanHitModel(_scaleDisplay3DSprite.spriteItem,TooMathMoveUint.stage2Dmouse,Context3DTriangleFace.NONE)
			if(scaleSelectId==0){
				_hitCenten=true
			}
			if(scaleSelectId==1){
				_hitX=true
			}
			if(scaleSelectId==2){
				_hitY=true
			}
			if(scaleSelectId==3){
				_hitZ=true
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

				lastMousePos=TooMathMoveUint.stage2Dmouse.clone()
			
				
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
				
			}else{
				return ;
			}
			
			lastMatrx=_xyzMoveData.modeMatrx3D.clone()
			
			triVecItem=new Vector.<Vector3D>
			triVecItem.push(A)
			triVecItem.push(B)
			triVecItem.push(C)
			
			//var pos:Vector3D=MathMoveUint.mathDisplay2Dto3DWorldPos(Scene_data.stage3DVO,new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY),500)
			var pos:Vector3D=TooMathMoveUint.mathDisplay2Dto3DWorldPos(TooMathMoveUint.stage3Drec,TooMathMoveUint.stage2Dmouse,500)
			var D:Vector3D=TooMathMoveUint.getLinePlaneInterectPointByTri(camPos,pos,triVecItem);
			
			var $m:Matrix3D=lastMatrx.clone()
			$m.invert()
			D=$m.transformVector(D)
			
			lastPos=D
				
			lastScale.scale_x=_xyzMoveData.scale_x
			lastScale.scale_y=_xyzMoveData.scale_y
			lastScale.scale_z=_xyzMoveData.scale_z
		}
		private static var lastMousePos:Point=new Point
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
		public static var lastScale:TooObject3D=new TooObject3D

		public static var lastPos:Vector3D
		public static function mouseMove():Vector3D
		{
			var $addPos:Vector3D=new Vector3D
			if(triVecItem){
				//var camPos:Vector3D=Scene_data.cam3D.clone()
				var camPos:Vector3D=TooMathMoveUint.camPositon
				//var pos:Vector3D=MathMoveUint.mathDisplay2Dto3DWorldPos(Scene_data.stage3DVO,new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY),500)
				var pos:Vector3D=TooMathMoveUint.mathDisplay2Dto3DWorldPos(TooMathMoveUint.stage3Drec,TooMathMoveUint.stage2Dmouse,500)
				var D:Vector3D=TooMathMoveUint.getLinePlaneInterectPointByTri(camPos,pos,triVecItem);
				
		
				var $m:Matrix3D=lastMatrx.clone()
				$m.invert()
				D=$m.transformVector(D)
				
				if(_hitCenten){
		
					//var $dis:Number=Scene_data.stage.mouseX-lastMousePos.x
					var $dis:Number=TooMathMoveUint.stage2Dmouse.x-lastMousePos.x
					$addPos.x=$dis
					$addPos.y=$dis
					$addPos.z=$dis
						
				}else
				if(_hitX||_hitY||_hitZ){
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
		private static var lastMatrx:Matrix3D=new Matrix3D
		
	}
}


