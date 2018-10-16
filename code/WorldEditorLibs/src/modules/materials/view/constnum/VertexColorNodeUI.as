package modules.materials.view.constnum
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeVertexColor;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;

	public class VertexColorNodeUI extends ConstVec3NodeUI
	{
		private var outRItem:ItemMaterialUI;
		private var outGItem:ItemMaterialUI;
		private var outBItem:ItemMaterialUI;
		public function VertexColorNodeUI()
		{
			super();
			_titleLabel.text = _bastTitleStr = "VertexColor";
			nodeTree.isDynamic = false;
			nodeTree.canDynamic = false;
			nodeTree.paramName = _bastTitleStr;
			
			outRItem = new ItemMaterialUI("r",MaterialItemType.FLOAT,false);
			addItems(outRItem);
			
			outGItem = new ItemMaterialUI("g",MaterialItemType.FLOAT,false);
			addItems(outGItem);
			
			outBItem = new ItemMaterialUI("b",MaterialItemType.FLOAT,false);
			addItems(outBItem);
			
			this.height = 150;
		}
		
		override public function initNodeTree():void{
			nodeTree = new NodeTreeVertexColor;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.VERCOLOR;
		}
		
	}
}