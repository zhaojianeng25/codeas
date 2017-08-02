package _Pan3D.display3D.reflection
{
	

	public class ReflectionLevel
	{
		public var reFlectionItem:Vector.<Display3DReflectionSprite>=new Vector.<Display3DReflectionSprite>
		public function ReflectionLevel()
		{
		}
		public function updata():void
		{
			for each(var $modelSprite:Display3DReflectionSprite in reFlectionItem)
			{
				$modelSprite.update()
			}
			
		}
		public function scanWaterReflectioinUpData():void
		{
			for each(var $modelSprite:Display3DReflectionSprite in reFlectionItem)
			{
				$modelSprite.scanReflection()
			}
			
		}
	}
}




