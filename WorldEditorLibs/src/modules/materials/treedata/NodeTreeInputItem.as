package modules.materials.treedata
{
	public class NodeTreeInputItem extends NodeTreeItem
	{
		private var _parentNodeItem:NodeTreeOutoutItem;
		public var hasCompiled:Boolean;
		public function NodeTreeInputItem()
		{
			super();
			inoutType = IN;
			hasCompiled = false;
		}
		
		public function get parentNodeItem():NodeTreeOutoutItem
		{
			return _parentNodeItem;
		}

		public function set parentNodeItem(value:NodeTreeOutoutItem):void
		{
			_parentNodeItem = value;
		}

		override public function getObj():Object{
			var obj:Object = super.getObj();
			obj.parentObj = parentNodeItem ? parentNodeItem.otherNeedObj() : null;
			return obj;
		}
		
		
		
	}
}