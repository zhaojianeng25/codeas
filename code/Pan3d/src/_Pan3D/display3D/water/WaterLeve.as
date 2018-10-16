package _Pan3D.display3D.water
{
	public class WaterLeve
	{
		public var modelItem:Vector.<Display3DWaterSprite>=new Vector.<Display3DWaterSprite>
		public function WaterLeve()
		{
		}
		public function updata():void
		{
			for each(var $modelSprite:Display3DWaterSprite in modelItem)
			{
				$modelSprite.update()
			}
			
			
			
		}
		public function upDataScanFa():void
		{
			for each(var $modelSprite:Display3DWaterSprite in modelItem)
			{
				$modelSprite.upDataScanFa()
			}
			
			
			
		}

	}
}



