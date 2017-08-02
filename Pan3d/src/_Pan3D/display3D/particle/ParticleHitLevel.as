package _Pan3D.display3D.particle
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTriangleFace;
	
	import _me.Scene_data;

	public class ParticleHitLevel
	{
		public var particleHitItem:Vector.<ParticleHitBoxSprite>=new Vector.<ParticleHitBoxSprite>
		public function ParticleHitLevel()
		{
		}
		public function updata():void
		{
			var _context3D:Context3D=Scene_data.context3D
			_context3D.setCulling(Context3DTriangleFace.NONE);
			for each(var $modelSprite:ParticleHitBoxSprite in particleHitItem)
			{
				$modelSprite.update()
			}
			
		}
	}
}


