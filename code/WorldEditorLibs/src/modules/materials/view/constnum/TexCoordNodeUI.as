package modules.materials.view.constnum
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeTexCoord;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;
	
	public class TexCoordNodeUI extends BaseMaterialNodeUI
	{
		private var outItem:ItemMaterialUI;
		
		public function TexCoordNodeUI()
		{
			super();
			titleBitmap = new phys_marterialCls;
			addTitleImg();
			this.gap = 20;
			this.width = 162;
			this.height = 65;
			
			
			nodeTree = new NodeTreeTexCoord;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.TEXCOORD;
			
			outItem = new ItemMaterialUI("out",MaterialItemType.VEC2,false);
			addItems(outItem);
			
			_titleLabel.text = "TexCoord";
		}
	}
}