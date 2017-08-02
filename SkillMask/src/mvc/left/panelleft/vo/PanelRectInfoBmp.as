package mvc.left.panelleft.vo
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class PanelRectInfoBmp extends Sprite
	{
		private var _bmp:Bitmap
		private var _mc:Sprite

		private var _maskSprite:MaskSprite
		public function PanelRectInfoBmp()
		{
			_bmp=new Bitmap
		//	this.addChild(_bmp)
				
			_mc=new Sprite;
			this.addChild(_mc)
				
			_maskSprite=new MaskSprite;
			this.addChild(_maskSprite);

		}
		
		public function updata():void
		{
			var _panelRectInfoSprite:PanelRectInfoSprite=PanelRectInfoSprite(this.parent)
			var _panelRectInfoNode:PanelSkillMaskNode=_panelRectInfoSprite.panelRectInfoNode;
		
			clearMc()
			_bmp.bitmapData=new BitmapData(64,64,true,0xffff0000)
			_maskSprite.setPanelRectInfoNode(_panelRectInfoNode)

				
			changeSize()
			
			
			
		}
		public function changeSize():void
		{
			var _panelRectInfoSprite:PanelRectInfoSprite=PanelRectInfoSprite(this.parent)
			var _panelRectInfoNode:PanelSkillMaskNode=_panelRectInfoSprite.panelRectInfoNode;

			if(_bmp.bitmapData){
				_bmp.width=_panelRectInfoNode.rect.width
				_bmp.height=_panelRectInfoNode.rect.height
			}

			_maskSprite.changeSize()
			
		}
		private function clearMc():void
		{
			while(_mc.numChildren){
				_mc.removeChildAt(0)
			}
		
		}
	}
}