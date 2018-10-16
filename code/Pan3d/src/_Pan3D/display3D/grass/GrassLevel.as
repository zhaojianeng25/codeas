package _Pan3D.display3D.grass
{
	import _Pan3D.scene.SceneContext;
	

	public class GrassLevel
	{
		private var _grassItem:Vector.<GrassEditorDisplay3DSprite>
		public function GrassLevel()
		{
		}
		public function get grassItem():Vector.<GrassEditorDisplay3DSprite>
		{
			return _grassItem;
		}
		public function set grassItem(value:Vector.<GrassEditorDisplay3DSprite>):void
		{
			_grassItem = value;
		}
		public function updata():void
		{
			for each(var $grassEditorDisplay3DSprite:GrassEditorDisplay3DSprite in _grassItem)
			{
				$grassEditorDisplay3DSprite.update()
			}
		}
	
		public function clear():void
		{
			while(_grassItem&&_grassItem.length>0){
				var $GroundEditorSprite:GrassEditorDisplay3DSprite=_grassItem.pop()
				$GroundEditorSprite.dispose()
			}
			_grassItem=new Vector.<GrassEditorDisplay3DSprite>
		}
	}
}


