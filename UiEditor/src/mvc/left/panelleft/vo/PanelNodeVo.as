package mvc.left.panelleft.vo
{
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	import common.utils.ui.file.FileNode;
	
	public class PanelNodeVo extends FileNode
	{
		public var item:ArrayCollection;
		public var canverRect:Rectangle;
		public var color:int;
		public function PanelNodeVo()
		{
			super();
		}
		
		public function readObject():Object
		{
			var obj:Object=new Object;
			obj.name=this.name;
			obj.canverRect=this.canverRect;
			obj.color=this.color;
			obj.item=getItemArr()
			return obj;
		}
		private function getItemArr():Array
		{  
			var arr:Array=new Array;
			for(var i:uint=0;i<item.length;i++){
				var $PanelRectInfoNode:PanelRectInfoNode=item[i]  as PanelRectInfoNode;
				arr.push($PanelRectInfoNode.readObject())
			}
			arr.sortOn("level",Array.NUMERIC);
			return arr;
		}
		
		public function readObjectToH5():Object
		{
			var obj:Object=new Object;
			obj.name=this.name;
			obj.canverRect=this.canverRect;
			obj.color=this.color;
			obj.item=getItemArrToH5()
			return obj;
		}
		private function getItemArrToH5():Array
		{  
			var arr:Array=new Array;
			for(var i:uint=0;i<item.length;i++){
				var $PanelRectInfoNode:PanelRectInfoNode=item[i]  as PanelRectInfoNode;
				arr.push($PanelRectInfoNode.readObjectToH5())
			}
			arr.sortOn("level",Array.NUMERIC);
			return arr;
		}
	
		
		
		public function setObject($obj:Object):void
		{
			this.item=new ArrayCollection;
			for(var i:uint=0;$obj.item&&i<$obj.item.length;i++){
				var $PanelRectInfoNode:PanelRectInfoNode=new PanelRectInfoNode;
				$PanelRectInfoNode.setObject($obj.item[i])
				$PanelRectInfoNode.sprite=new PanelRectInfoSprite()
				$PanelRectInfoNode.sprite.panelRectInfoNode=$PanelRectInfoNode
				this.item.addItem($PanelRectInfoNode)
			}
			
			this.name=$obj.name;
			this.color=$obj.color;
			this.canverRect=new Rectangle;
			this.canverRect.x=$obj.canverRect.x
			this.canverRect.y=$obj.canverRect.y
			this.canverRect.width=$obj.canverRect.width
			this.canverRect.height=$obj.canverRect.height
		
		}
	}
}