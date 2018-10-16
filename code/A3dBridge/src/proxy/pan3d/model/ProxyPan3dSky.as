package proxy.pan3d.model
{
	import _Pan3D.display3D.Display3dCubeMap;
	
	import proxy.top.model.ISky;
	
	public class ProxyPan3dSky implements ISky
	{
		public var display:Display3dCubeMap;
		public function ProxyPan3dSky()
		{
		}
		
		public function set scale(value:Number):void
		{
			display.scale = value;
		}
		
		
		public function set url(value:String):void
		{
			display.url = value;
		}
		
		public function set cubeMapUrl(value:String):void
		{
			display.cubeMapUrl = value;
		}
		
		public function set visible(value:Boolean):void
		{
			display.visible=value
			
		}
		
		public function get visible():Boolean
		{
			// TODO Auto Generated method stub
			return display.visible;
		}
		
	}
}