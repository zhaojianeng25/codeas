package mvc.centen.panelcenten
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.UIComponent;
	
	import mvc.left.panelleft.vo.PanelRectInfoNode;
	
	public class PanelCentenInfoLevel extends UIComponent
	{
		private var _setItem:ArrayCollection;
		public function PanelCentenInfoLevel()
		{
			super();
		}

		public function get setItem():ArrayCollection
		{
			return _setItem;
		}

		public function set setItem(value:ArrayCollection):void
		{
			_setItem = value;
			clearLevel();
			for(var i:uint=0;i<_setItem.length;i++)
			{
				var $PanelRectInfoNode:PanelRectInfoNode=_setItem[i]
				$PanelRectInfoNode.select=false
				this.addChild($PanelRectInfoNode.sprite)
				$PanelRectInfoNode.sprite.updata();
			
			}
		}
		public function addPanelRectInfoNode($PanelRectInfoNode:PanelRectInfoNode):void
		{
			this.addChild($PanelRectInfoNode.sprite)
			$PanelRectInfoNode.sprite.updata();
		}
		private var isshowhide:Boolean=true
		public function showHideLine():void
		{

			this.isshowhide=!this.isshowhide;
			for(var i:uint=0;_setItem&&i<_setItem.length;i++)
			{
				var $PanelRectInfoNode:PanelRectInfoNode=_setItem[i]
				$PanelRectInfoNode.sprite.showHideLine(this.isshowhide)
			}
		
		}
	
		private function clearLevel():void
		{
		
			while(this.numChildren){
			
				this.removeChildAt(0)
			}
		}

	}
}