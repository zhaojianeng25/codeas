package  PanV2
{
	import _me.Scene_data;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Stage3dView
	{
		private static var instance:Stage3dView;
		public function Stage3dView()
		{
		}
		public static function getInstance():Stage3dView
		{
			return instance?instance:new Stage3dView();
		}
		/**
		 *设计渲染窗口位置 
		 * @param x
		 * @param y
		 * 
		 */
		public function setStage3DXY(x:int,y:int):void
		{
			Scene_data.stage3D.x=x
			Scene_data.stage3D.y=y
			Scene_data.stage3DVO.x=x
			Scene_data.stage3DVO.y=y
		}
		/**
		 *设计渲染窗口大小 
		 * @param w 宽度
		 * @param h 高度
		 * 
		 */
		public function setStage3DSize(w:int,h:int):void
		{
			Scene_data.sceneViewHW=500
			Scene_data.stage3DVO.width=w
			Scene_data.stage3DVO.height=h
			
			ConfigV2.getInstance().configAntiAlias(Scene_data.antiAlias,w,h)
		}
	
	}
}