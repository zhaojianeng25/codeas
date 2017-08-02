package  PanV2
{
	import _me.Scene_data;
	
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Stage3DVO
	{
		public function Stage3DVO()
		{	
		}
		private var _width:uint=600
		public var height:uint=600
		public var x:Number=0
		public var y:Number=0
		
		public function get width():uint
		{
			return _width;
		}

		public function set width(value:uint):void
		{
			_width = value;
		}

		public  function get mouseX():Number
		{
			return Scene_data.stage.mouseX-x
		}
		public  function get mouseY():Number
		{
			return Scene_data.stage.mouseY-y
		}
		
	
	}
}