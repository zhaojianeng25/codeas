package  xyz.draw
{
	import flash.geom.Vector3D;
	
	import xyz.base.TooObjectMath;
	
	//import _me.Scene_data;

	public class TooXyzRotationMath
	{
		public function TooXyzRotationMath()
		{
		}
		public static function mouseDown($centenPos:Vector3D):void
		{
			
		}
		
		/**
		 *计算出屏幕上与镜头，所成角
		 * @param a
		 * @param b
		 * @param c
		 * @param _xyzMoveData
		 * 
		 */
		public static function showYaix(a:Vector3D,b:Vector3D,c:Vector3D,_xyzMoveData:TooXyzMoveData):void
		{
			
			
			var camPos:Vector3D=TooMathMoveUint.camPositon.clone()
//			camPos.x=Scene_data.cam3D.x
//			camPos.y=Scene_data.cam3D.y
//			camPos.z=Scene_data.cam3D.z
			
			a=_xyzMoveData.modeMatrx3D.transformVector(a)
			b=_xyzMoveData.modeMatrx3D.transformVector(b)
			c=_xyzMoveData.modeMatrx3D.transformVector(c)
			
		
			var $triNrm:Vector3D=TooMathMoveUint.calTriNormal(a,b,c,true)
			var $chuiD:Vector3D=camPos.add($triNrm)
			var triItem:Vector.<Vector3D>=new Vector.<Vector3D>
			triItem.push(a)
			triItem.push(b)
			triItem.push(c)
			
			var $cenetPos:Vector3D=_xyzMoveData.modeMatrx3D.position
			var D:Vector3D=TooMathMoveUint.getLinePlaneInterectPointByTri(camPos,$chuiD,triItem);
			pingmiangfa(D,$cenetPos,TooMathMoveUint._PanelEquationFromThreePt(a,b,c))
			
			TooXyzSkipMath.mathLastChuiZhu();
		}
		/**
		 *得到映射轴的两个屏幕坐标点 
		 * @param D
		 * @param $cenetPos
		 * @param pmfc0
		 * 
		 */
		private static function pingmiangfa(D:Vector3D,$cenetPos:Vector3D,pmfc0:TooObjectMath):void
		{
			
			var ANrm:Vector3D=D.subtract($cenetPos)
			ANrm.normalize()
			var BNrm:Vector3D=new Vector3D(pmfc0.a,pmfc0.b,pmfc0.c)
			BNrm.normalize()
			
			var bNrm:Vector3D=ANrm.crossProduct(BNrm)
			var eNrm:Vector3D=bNrm.clone()
			bNrm.normalize()
			eNrm.normalize()
			eNrm.negate()
			
			bNrm.scaleBy(100)
			eNrm.scaleBy(100)
			bNrm=bNrm.add($cenetPos)
			eNrm=eNrm.add($cenetPos)
			
			TooXyzSkipMath._disA=TooMathMoveUint.mathWorld3DPosto2DView(TooMathMoveUint.stage3Drec,bNrm)
			TooXyzSkipMath._disB=TooMathMoveUint.mathWorld3DPosto2DView(TooMathMoveUint.stage3Drec,eNrm)
			
		}
		
		

		
		

		
	}
}