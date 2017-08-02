package mvc.left.panelleft.vo
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import vo.FileInfoType;
	import vo.H5UIFileNode;
	
	public class PanelRectInfoBmp extends Sprite
	{
		private var _bmp:Bitmap
		private var _mc:Sprite
		private var _scale9Grid:Scale9Grid;
		private var _srameSprite:FrameSprite
		public function PanelRectInfoBmp()
		{
			_bmp=new Bitmap
			this.addChild(_bmp)
				
			_mc=new Sprite;
			this.addChild(_mc)

		}
		
		public function updata():void
		{
			var _panelRectInfoSprite:PanelRectInfoSprite=PanelRectInfoSprite(this.parent)
			var _panelRectInfoNode:PanelRectInfoNode=_panelRectInfoSprite.panelRectInfoNode;
			if(_panelRectInfoNode.type==PanelRectInfoType.PICTURE||_panelRectInfoNode.type==PanelRectInfoType.BUTTON){
				var $H5UIFileNode:H5UIFileNode=UiData.getUiNodeByName(_panelRectInfoNode.dataItem[0])
				var bmp:BitmapData=UiData.getUIBitmapDataByName(_panelRectInfoNode.dataItem[0]);
	
				clearMc()
				_bmp.bitmapData=null
				if($H5UIFileNode&&bmp){
					if($H5UIFileNode.type==FileInfoType.baseUi){
						_bmp.bitmapData=bmp;
					}
					if($H5UIFileNode.type==FileInfoType.ui9){
						var $rect:Rectangle=new Rectangle();
						$rect.x=$H5UIFileNode.rect9.width
						$rect.y=$H5UIFileNode.rect9.height
						$rect.width=$H5UIFileNode.rect.width-$H5UIFileNode.rect9.width*2
						$rect.height=$H5UIFileNode.rect.height-$H5UIFileNode.rect9.height*2
						_scale9Grid=new Scale9Grid(bmp,$rect)
						_mc.addChild(_scale9Grid)

					}
					if($H5UIFileNode.type==FileInfoType.frame){
					

						_srameSprite=new FrameSprite(bmp,$H5UIFileNode.rowColumn,10)
						_mc.addChild(_srameSprite)
						
					}
				}
			}
			changeSize()
			
		}
		public function changeSize():void
		{
			var _panelRectInfoSprite:PanelRectInfoSprite=PanelRectInfoSprite(this.parent)
			var _panelRectInfoNode:PanelRectInfoNode=_panelRectInfoSprite.panelRectInfoNode;
			if(_scale9Grid){
				_scale9Grid.width=_panelRectInfoNode.rect.width
				_scale9Grid.height=_panelRectInfoNode.rect.height
				_scale9Grid.refresh()
			}
			if(_srameSprite){
				_srameSprite.width=_panelRectInfoNode.rect.width
				_srameSprite.height=_panelRectInfoNode.rect.height
			}
			if(_bmp.bitmapData){
				_bmp.width=_panelRectInfoNode.rect.width
				_bmp.height=_panelRectInfoNode.rect.height
			}
		    
		}
		private function clearMc():void
		{
			while(_mc.numChildren){
				_mc.removeChildAt(0)
			}
		
		}
	}
}