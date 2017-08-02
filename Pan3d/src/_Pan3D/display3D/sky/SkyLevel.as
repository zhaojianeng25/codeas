package _Pan3D.display3D.sky
{
	import _Pan3D.display3D.Display3dCubeMap;

	public class SkyLevel
	{
		public var display:Display3dCubeMap;
		public function SkyLevel()
		{
			
		}
		
		public function updata():void{
			if(display){
				display.update();
			}
		}
		
	}
}