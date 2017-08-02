package _Pan3D.display3D.lightProbe
{
	import _Pan3D.program.Program3DManager;
	import flash.display3D.Context3DTriangleFace;
	
	import _me.Scene_data;
	import flash.display3D.Context3D;
	

	public class LightProbeLevel
	{
		public var lightProbeItem:Vector.<Display3DLightProbeSprite>=new Vector.<Display3DLightProbeSprite>
		public function LightProbeLevel()
		{
			Program3DManager.getInstance().registe(Display3DLightProbeItemShader.DISPLAY3D_LIGHT_PROBE_ITEM_SHADER,Display3DLightProbeItemShader)
		}
		public function updata():void
		{
			var _context3D:Context3D=Scene_data.context3D
			_context3D.setCulling(Context3DTriangleFace.NONE);
			for each(var $modelSprite:Display3DLightProbeSprite in lightProbeItem)
			{
				$modelSprite.update()
			}

		}
	}
}



