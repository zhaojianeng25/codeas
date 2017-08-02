package _Pan3D.utils.materialShow
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	import _Pan3D.display3D.Display3DMaterialSprite;
	
	public class ScanModelSprite extends Display3DMaterialSprite
	{
		public function ScanModelSprite(context:Context3D)
		{
			super(context);
		}
		override  protected function setVc() : void {
			super.setVc();
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([2,0.0001,99999,0])); 
			
		}
	}
}