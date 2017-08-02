package modules.materials.view.mathNode
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeMul;

	public class MathMulNodeUI extends MathDynamicNodeUI
	{
		public function MathMulNodeUI()
		{
			super();
			
			nodeTree = new NodeTreeMul;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.MUL;
			
			_titleLabel.text = "乘法(Mul*)";
			initItem();
			
		}
	}
}