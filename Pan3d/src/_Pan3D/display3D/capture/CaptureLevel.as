package _Pan3D.display3D.capture
{
	

	public class CaptureLevel
	{
		public var captureItem:Vector.<Display3DCaptureSprite>=new Vector.<Display3DCaptureSprite>
		public function CaptureLevel()
		{
		}
		public function updata():void
		{
			for each(var $modelSprite:Display3DCaptureSprite in captureItem)
			{
				$modelSprite.update()
			}

		}
	}
}




