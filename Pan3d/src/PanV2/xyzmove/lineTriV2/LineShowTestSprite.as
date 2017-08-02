package PanV2.xyzmove.lineTriV2
{
	import flash.display3D.Context3D;
	
	import _me.Scene_data;
	
	public class LineShowTestSprite extends LineTri3DSprite
	{
		private static var instance:LineShowTestSprite;
		public function LineShowTestSprite($context3D:Context3D)
		{
			super($context3D);
			init()
		
		}
		protected function init():void
		{
			_thickness=5
			setLineData()
			clear()
		}
		public static function getInstance():LineShowTestSprite
		{
			
			if(!instance){
				instance=new LineShowTestSprite(Scene_data.context3D)
			}
			return instance;
		}
	}
}