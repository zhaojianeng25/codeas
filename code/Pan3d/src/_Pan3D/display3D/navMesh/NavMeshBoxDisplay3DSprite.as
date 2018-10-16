package _Pan3D.display3D.navMesh
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import xyz.draw.TooBoxDisplay3DSprite;
	import xyz.draw.TooMathMoveUint;
	
	public class NavMeshBoxDisplay3DSprite extends TooBoxDisplay3DSprite
	{
		public function NavMeshBoxDisplay3DSprite(context:Context3D)
		{
			super(context);
		}


		
		override  protected function setVc() : void {

			_context3D.setCulling(Context3DTriangleFace.NONE);
			var $distance:Number=Vector3D.distance(TooMathMoveUint.camPositon,new Vector3D(this.x,this.y,this.z));
			var _sizeNum:Number=$distance/350*0.5

			posMatrix=new Matrix3D;
			posMatrix.appendScale(_sizeNum,_sizeNum,_sizeNum)
			posMatrix.appendTranslation(this.x,this.y,this.z)
			
			
			super.setVc()
		}


	}
}