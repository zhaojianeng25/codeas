package modules.materials.view.dynamicNode
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeAdd;
	import modules.materials.treedata.nodetype.NodeTreeDynamicInputVec3;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;
	
	public class DynamicVec3NodeUI extends BaseMaterialNodeUI
	{
		private var outItem:ItemMaterialUI;
		private var outRItem:ItemMaterialUI;
		private var outGItem:ItemMaterialUI;
		private var outBItem:ItemMaterialUI;
		public function DynamicVec3NodeUI()
		{
			super();
			
			titleBitmap = new phys_marterialCls;
			addTitleImg();
			this.gap = 20;
			this.width = 162;
			this.height = 120;
			_titleLabel.text = "参数(param)";
			
			nodeTree = new NodeTreeDynamicInputVec3;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.DYNVEC3;
			
			outItem = new ItemMaterialUI("out",MaterialItemType.VEC3,false);
			outRItem = new ItemMaterialUI("r",MaterialItemType.FLOAT,false);
			outGItem = new ItemMaterialUI("g",MaterialItemType.FLOAT,false);
			outBItem = new ItemMaterialUI("b",MaterialItemType.FLOAT,false);
			
			addItems(outItem);
			addItems(outRItem);
			addItems(outGItem);
			addItems(outBItem);
			
		}
	}
}