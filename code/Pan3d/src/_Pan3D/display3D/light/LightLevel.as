package _Pan3D.display3D.light
{
	
	

	public class LightLevel
	{
		public var modelItem:Vector.<Display3DLightSprite>=new Vector.<Display3DLightSprite>
		public function LightLevel()
		{
		}
		public function updata():void
		{
			for each(var $modelSprite:Display3DLightSprite in modelItem)
			{
				$modelSprite.update()
			}
			
			
			
		}
	}
}


