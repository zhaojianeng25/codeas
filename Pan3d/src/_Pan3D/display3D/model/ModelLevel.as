package _Pan3D.display3D.model
{
	

	public class ModelLevel
	{
		public var modelItem:Vector.<Display3DModelSprite>=new Vector.<Display3DModelSprite>
		public function ModelLevel()
		{
		}
		
		public function addMode($model:Display3DModelSprite):void{
			modelItem.push($model);
		}

		public function updata():void
		{
			for each(var $modelSprite:Display3DModelSprite in modelItem)
			{
				$modelSprite.update()
			}
			
		}
		public function upDataCollision():void
		{
			for each(var $modelSprite:Display3DModelSprite in modelItem)
			{
				if($modelSprite.display3DCollistionGrop)
				{
					$modelSprite.display3DCollistionGrop.update();
				}
				
			}
		}
	}
}