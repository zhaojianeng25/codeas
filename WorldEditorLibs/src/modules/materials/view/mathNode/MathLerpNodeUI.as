package modules.materials.view.mathNode
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeLerp;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;

	public class MathLerpNodeUI extends MathDynamicNodeUI
	{
		private var intLerpItem:ItemMaterialUI;
		public function MathLerpNodeUI()
		{
			super();
			_titleLabel.text = "插值(Lerp)";
			
			nodeTree = new NodeTreeLerp;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.LERP;
			
			initItem();
			
			this.height = 100;
		}
		
		override protected function initItem():void{
			super.initItem();
			intLerpItem = new ItemMaterialUI("alpha",MaterialItemType.FLOAT);
			addItems(intLerpItem);
			
			addDisEvent(intLerpItem);
		}
		
	}
}