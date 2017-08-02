package render.atf
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	
	import _Pan3D.base.BaseLevel;
	
	import _me.Scene_data;
	
	import _Pan3D.display3D.grass.GrassEditorDisplay3DSprite;
	
	public class AtfLevel extends BaseLevel
	{
		private static var instance:AtfLevel;
		private var _atfItem:Vector.<AtfDisplay3DSprite>;;
		public function AtfLevel()
		{
			super();
			
		}
		override protected function initData():void
		{
			var $context3D:Context3D=Scene_data.context3D
			_atfItem=new Vector.<AtfDisplay3DSprite>
				
				var dd:AtfDisplay3DSprite=new AtfDisplay3DSprite($context3D)
				_atfItem.push(dd)
			
		}
		public static function getInstance():AtfLevel{
			if(!instance){
				instance = new AtfLevel();
			}
			return instance;
		}
		override public function upData():void
		{
			var $context3D:Context3D=Scene_data.context3D
			$context3D.setDepthTest(true,Context3DCompareMode.LESS);
			$context3D.setCulling(Context3DTriangleFace.NONE);
			for each(var $grassDisplay3DSprite:AtfDisplay3DSprite in _atfItem)
			{
				$grassDisplay3DSprite.update()
			}
		}
		
	}
}