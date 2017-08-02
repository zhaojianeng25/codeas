package _Pan3D.display3D.navMesh
{
	import _me.Scene_data;
	
	import xyz.draw.TooMultipleLineTri3DSprite;
	
	

	public class NavMeshLevel
	{
		public function NavMeshLevel()
		{
		}
		
		public var modelItem:Vector.<NavMeshDisplay3DSprite>=new Vector.<NavMeshDisplay3DSprite>

		public static var lineSprite:TooMultipleLineTri3DSprite
		public function updata():void
		{
			
			
			for each(var $modelSprite:NavMeshDisplay3DSprite in modelItem)
			{
				$modelSprite.update()
			}
			
			if(lineSprite){
				lineSprite.update()
			}else{
				lineSprite=new TooMultipleLineTri3DSprite(Scene_data.context3D)
				lineSprite.clear()
			}
			
		}
		
	}
}