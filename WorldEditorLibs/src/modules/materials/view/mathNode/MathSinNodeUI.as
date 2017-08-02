package modules.materials.view.mathNode
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeSin;

	public class MathSinNodeUI extends MathStaticNodeUI
	{
		public function MathSinNodeUI()
		{
			super();
			nodeTree = new NodeTreeSin;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.SIN;
			_titleLabel.text = "正弦(sin)";
			initItem();
		}
	}
}