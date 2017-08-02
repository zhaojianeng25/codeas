package _Pan3D.display3D.parallel
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTriangleFace;
	
	import _me.Scene_data;

	public class ParallelLightLevel
	{
		
		public var parallelLightItem:Vector.<Dispaly3DParallelLightSpreit>=new Vector.<Dispaly3DParallelLightSpreit>
		public function ParallelLightLevel()
		{
		}
		public function updata():void
		{
			var _context3D:Context3D=Scene_data.context3D
			_context3D.setCulling(Context3DTriangleFace.NONE);
			for each(var $modelSprite:Dispaly3DParallelLightSpreit in parallelLightItem)
			{
				$modelSprite.update()
			}
			
		}
	}
}