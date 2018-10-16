package _Pan3D.display3D.ground
{
	

	public class GroundLevel
	{
		private var _groundItem:Vector.<GroundEditorSprite>
		public static var showTerrain:Boolean=true
		public function GroundLevel()
		{
		}
		public function get groundItem():Vector.<GroundEditorSprite>
		{
			return _groundItem;
		}
		public function set groundItem(value:Vector.<GroundEditorSprite>):void
		{
			_groundItem = value;
		}
		public function updata():void
		{
		
			if(showTerrain){
				for each(var $groundEditorSprite:GroundEditorSprite in _groundItem)
				{
					$groundEditorSprite.update()
				}
			}
			
			
		}
		public function clear():void
		{
			while(_groundItem&&_groundItem.length>0){
				var $GroundEditorSprite:GroundEditorSprite=_groundItem.pop()
				$GroundEditorSprite.dispose()
			}
			_groundItem=new Vector.<GroundEditorSprite>
		}
	}
}